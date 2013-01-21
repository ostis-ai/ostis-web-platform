# -*- coding: utf-8 -*-

"""
-----------------------------------------------------------------------------
This source file is part of OSTIS (Open Semantic Technology for Intelligent Systems)
For the latest info, see http://www.ostis.net

Copyright (c) 2012 OSTIS

OSTIS is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

OSTIS is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with OSTIS. If not, see <http://www.gnu.org/licenses/>.
-----------------------------------------------------------------------------
"""

import re, sys, traceback
from pyparsing import Word, Literal, Forward, Regex, Group, ZeroOrMore, SkipTo, ParserElement
from pyparsing import OneOrMore, srange, Keyword, QuotedString, ParseResults, Optional, cStyleComment

ParserElement.enablePackrat()

reKeyword = r'/!\*\s*keyword:\s*([a-zA-Z0-9_]+)\s*\*/'

# parse results cache
maxCachedResults = 10
cacheMap = {}
cacheQueue = []

connectors = [u'<>',
              u'>',
              u'<',
              u'..>',
              u'<..',
              u'->',
              u'<-',
              u'<=>',
              u'=>',
              u'<=',
              u'-|>',
              u'<|-',
              u'-/>',
              u'</-',
              u'~>',
              u'<~',
              u'~|>',
              u'<|~',
              u'~/>',
              u'</~',
              u'=']

# ---------------------- Helpers -----------------
class BaseGroup:
       
    def renderField(self, marker, value, level):
        """Render scn field into html
        """
        pass
    
    def __repr__(self):
        return self.__str__()
    
    def __eq__(self, other):
        return self.__class__ == other.__class__
    
class KeywordGroup(BaseGroup):
    
    def __init__(self, tokens):
        self.value = tokens[0]
        
        r = re.compile(reKeyword)
        self.value = r.match(self.value).group(1)
        
    def __call__(self, tokens):
        return KeywordGroup(tokens)
    
    def __str__(self):
        return str(self.value)       
    
    def __eq__(self, other):
        if isinstance(other, Keyword) and other.value == self.value:
            return True
        
        if isinstance(other, SimpleIdentifierGroup) and other.value == self.value:
            return True
        
        return False
    
class IdentifierGroup(BaseGroup):
    """Class that represent identifier information.
    It also contains information about internal sentences
    """
    def __init__(self, tokens):
        self.identifier = tokens[0][0]
        self.internal = None
        if len(tokens[0]) > 1:
            self.internal = tokens[0][1]
        
    def __call__(self, tokens):
        return IdentifierGroup(tokens)
    
    def __str__(self):
        if self.internal is not None:
            return str(self.identifier) + str(self.internal)
        
        return str(self.identifier)
    
    def __eq__(self, other):
        if not isinstance(other, IdentifierGroup):
            return False
        
        if self.identifier != other.identifier:
            return False
        
        return self.internal == other.internal
    
class SimpleIdentifierGroup(BaseGroup):
    """Class that represents simple identifier
    """
    def __init__(self, tokens):
        self.value = tokens[0]
        
    def __call__(self, tokens):
        return SimpleIdentifierGroup(tokens)
    
    def __str__(self):
        return str(self.value)  
    
    def __eq__(self, other):
        if not isinstance(other, SimpleIdentifierGroup):
            return False
        
        return self.value == other.value
    
class UrlGroup(BaseGroup):
    
    def __init__(self, tokens):
        self.value = tokens[0]
        
    def __call__(self, tokens):
        return UrlGroup(tokens)
    
    def __str__(self):
        return str(self.value)  
    
    def __eq__(self, other):
        if not isinstance(other, SimpleIdentifierGroup):
            return False
        
        return self.value == other.value
    
class AliasGroup(BaseGroup):
    """Class that represent identifiers, that hasn't name (names doesn't translate into memory)
    """
    def __init__(self, tokens):
        pass
    
    def __call__(self, tokens):
        return AliasGroup(tokens)
    
    def __str__(self):
        return 'ooo'
    
    def __eq__(self, other):
        return False # they always doesn't equivalent

class ContentGroup(BaseGroup):
    """Class that represent content information
    """
    def __init__(self, tokens):
        self.value = tokens[0]
        
    def __call__(self, tokens):
        return ContentGroup(tokens)
    
    def __str__(self):
        return str(self.value)        
    
    def __eq__(self, other):
        if not isinstance(other, ContentGroup):
            return False
        
        return self.value == other.value
    
class SetGroup(BaseGroup):
    """Class that represents set identifier
    """
    def __init__(self, tokens):
        self.items = tokens[0]
        self.par = ('{', '}')
        
    def __call__(self, tokens):
        return SetGroup(tokens)
    
    def __str__(self):
        
        res = self.par[0]
        first = True
        # TODO: sort items by alphabet
        for item in self.items:
            if not first:
                res += ', '
            else:
                first = False
            res += str(item)
            
        res += self.par[1]
        return res
    
    def __eq__(self, other):
        # TODO: implement comparsion
        return False
        
    
class OSetGroup(SetGroup):
    
    def __init__(self, tokens):
        SetGroup.__init__(self, tokens)
        self.par = ('<', '>')
        
    def __call__(self, tokens):
        return OSetGroup(tokens)
    
    def __eq__(self, other):
        
        if len(self.items) != len(other.items):
            return False
        
        for idx in xrange(len(self.items)):
            if self.items[idx] != other.items[idx]:
                return False
            
        return True
    
    def __str__(self):
        
        res = self.par[0]
        first = True
        # TODO: sort items by alphabet
        for item in self.items:
            if not first:
                res += ', '
            else:
                first = False
            res += str(item)
            
        res += self.par[1]
        return res

class TripleGroup(BaseGroup):
    """Class that represent triple
    """
    def __init__(self, tokens):
        self.subject = tokens[0][0]
        self.predicate = tokens[0][1]
        self.object = tokens[0][2]
        
    def __call__(self, tokens):
        return TripleGroup(tokens)
        
    def __str__(self):
        return "( " + str(self.subject) + " | " + str(self.predicate) + " | " + str(self.object) + " )"
    
    def __eq__(self, other):
        return self.subject == other.subkect and self.predicate == other.predicate and self.object == other.object
    
    
class SimpleSentenceGroup(TripleGroup):
    """Class that represents sentence of scs-code level 1
    """
    def __str__(self):
        return TripleGroup.__str__(self)[2 : -2]
        
    def __eq__(self, other):
        # TODO: implement comparsion
        return False
        
class SynonymGroup(BaseGroup):
    
    def __init__(self, tokens):
        self.first = tokens[0][0]
        self.second = tokens[0][1]
        
    def __call__(self, tokens):
        return SynonymGroup(tokens)
        
    def __str__(self):
        return "%s = %s" % (str(self.first), str(self.second))       
    
    def __eq__(self, other):
        # TODO: implement comparsion
        return False
    
class SentenceGroup(BaseGroup):
    """Class that represents sentence
    """
    def __init__(self, tokens):
        self.subject = tokens[0][0]
        self.predicate = tokens[0][1]
        self.attrs = tokens[0][2]
        self.object = tokens[0][3]
      
    def __call__(self, tokens):
        return SentenceGroup(tokens)
    
    def __str__(self):
        return "sentence: " + str(self.subject) + " " + str(self.predicate) + " " + str(self.attrs) + " " + str(self.object)
        
    def __eq__(self, other):
        # TODO: implement comparsion
        return False

class IdtfWithIntGroup(BaseGroup):
    
    def __init__(self, tokens):
        self.idtf = tokens[0][0]
        self.internal = None
        if len(tokens[0]) > 1:
            self.internal = tokens[0][1]
        
    def __call__(self, tokens):
        return IdtfWithIntGroup(tokens)
    
    def __str__(self):
        return "%s" % str(self.idtf)

    def __eq__(self, other):
        # TODO: implement comparsion
        return False

class InternalGroup(BaseGroup):
    
    def __init__(self, tokens):
        self.predicate = tokens[0][0]
        self.attrs = tokens[0][1]
        self.object = tokens[0][2]
        
    def __call__(self, tokens):
        return InternalGroup(tokens)
    
    def __str__(self):
        return '(* ' + str(self.predicate) + str(self.attrs) + str(self.object) + ' *)'
    
class InternalListGroup(BaseGroup):
    
    def __init__(self, tokens):
        self.sentences = tokens[0]
        
    def __call__(self, tokens):
        return InternalListGroup(tokens)
    
    def __str__(self):
        return str(self.sentences)

def syntax():
        
    syntax = None
    
    name = Word(srange(u"[\.a-zA-Z0-9_#]"), srange(u"[\.a-zA-Z0-9_#]")).setParseAction(SimpleIdentifierGroup).setName("Name")
    url = QuotedString(quoteChar='"', unquoteResults=False).setParseAction(UrlGroup).setName("Url")
    simpleIdtf = name ^ url
    
    tripleSep = Literal(u'|').suppress()
    attrSep = Literal(u':').suppress()
    objSep = Literal(u';').suppress()
    sentSep = Literal(u';;').suppress()
    synSep = Literal(u'=').suppress()
    lpar = Literal(u'(').suppress()
    rpar = Literal(u')').suppress()
    aliasNoName = Literal(u'***').suppress()
    lpar_set = Literal(u'{').suppress()
    rpar_set = Literal(u'}').suppress()
    lpar_oset = Literal(u'<').suppress()
    rpar_oset = Literal(u'>').suppress()
    lpar_trf = Literal(u'[').suppress()
    rpar_trf = Literal(u']').suppress()
    lpar_int = Literal(u'(*').suppress()
    rpar_int = Literal(u'*)').suppress()
    
    # comments
    comment_keyword = Regex(reKeyword).setParseAction(KeywordGroup)
    comment = comment_keyword
    
    # level 1 sentence
    sentence_lv1 = Group(simpleIdtf + tripleSep + simpleIdtf + tripleSep + simpleIdtf).setParseAction(SimpleSentenceGroup).setName("SimpleSentence")
    
    
    # other levels sentence
    connector = None 
    for c in connectors:
        if c == connectors[0]:
            connector = Literal(c) ^ Literal(u'_' + c)
        else:
            connector = connector ^ Literal(c) ^ Literal(u'_' + c)
    
    # identifiers
    idtf = Forward()
    internal = Forward()
    
    attrsList = Group(ZeroOrMore(simpleIdtf + attrSep))
    
    # internal sentence
    idtfWithInt = Group(idtf + Optional(internal)).setParseAction(IdtfWithIntGroup).setName("IdtfWithIntGroup")
    objectList = Group(idtfWithInt + ZeroOrMore(objSep + idtfWithInt))
    intSentence = Group(connector + Optional(attrsList) + objectList).setParseAction(InternalGroup).setName("InternalSentence")
    
    intSentenceList = Group(lpar_int + OneOrMore(intSentence + sentSep) + rpar_int).setParseAction(InternalListGroup).setName("InternalSentenceGroup")
    
    internal << intSentenceList
    
    content = QuotedString(quoteChar=u'[', endQuoteChar=u']', unquoteResults=True, multiline=True, escChar=u'\\').setParseAction(ContentGroup).setName("Content")
    triple = Group(lpar + idtf + connector + idtf + rpar).setParseAction(TripleGroup).setName("Triple")
    alias = Group(aliasNoName).setParseAction(AliasGroup).setName("Alias")
    
    setIdtf = Group(lpar_set + ZeroOrMore(Group(Optional(attrsList) + idtfWithInt) + objSep) + Group(Optional(attrsList) + idtfWithInt) + rpar_set).setParseAction(SetGroup).setName("Set")
    osetIdtf = Group(lpar_oset + ZeroOrMore(Group(Optional(attrsList) + idtfWithInt) + objSep) + Group(Optional(attrsList) + idtfWithInt) + rpar_oset).setParseAction(OSetGroup).setName("OSet")
    
    anyIdtf = simpleIdtf ^ content ^ triple ^ setIdtf ^ osetIdtf ^ alias
    idtf << anyIdtf
    
#    sentence_synonym = Group(idtf + synSep + idtf).setParseAction(SynonymGroup)
    sentence_lv23456 = Group(idtf + connector + Optional(attrsList) + objectList).setParseAction(SentenceGroup).setName("Sentence")
    
    sentence = (sentence_lv1 ^ sentence_lv23456)# ^ sentence_synonym)
    syntax = ZeroOrMore(Group(sentence + sentSep) ^ comment)
    
    syntax.ignore(cStyleComment)
    
    #syntax.setDebug()
    
    return syntax

def parse(path):
    """Parse scs file with specified \p path
    """ 
    data = None   
    try:
        f = open(path, 'r')
        data = f.read().decode("utf-8")
        f.close()
        
        fields = syntax().parseString(data)
        
    except:
        print 'Error to parse "%s" file"' % path
        print "Error:", sys.exc_info()[0]
        traceback.print_exc(file=sys.stdout)
        return None
    
    return fields
    
    
