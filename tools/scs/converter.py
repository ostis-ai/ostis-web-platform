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

import os, sys, shutil
import codecs
import re, sys, traceback
from pyparsing import Word, Literal, Forward, Regex, Group, ZeroOrMore, SkipTo, ParserElement
from pyparsing import OneOrMore, srange, Keyword, QuotedString, ParseResults, Optional, cStyleComment, ParseException
import scs_parser
from sre_parse import parse_template

#ParserElement.enablePackrat()

encoding = "utf-8" 
reload(sys)
sys.setdefaultencoding(encoding)
sys.stdout = codecs.getwriter(encoding)(sys.stdout, errors = "replace")
sys.stderr = codecs.getwriter(encoding)(sys.stderr, errors = "replace")

reKeyword = r'/!\*\s*keyword:\s*([a-zA-Z0-9_]+)\s*\*/'

arc_id = 0

mirror_connectors = [
                u'<',
                u'<..',
                u'<-',
                u'<=',
                u'<|-',
                u'</-',
                u'<~',
                u'<|~',
                u'</~',
                
                u'_<-',
                u'_<=',
                u'_<|-',
                u'_</-',
                u'_<~',
                u'_<|~',
                u'_</~'
                ]
                
arc_types = {
            u">" : u"sc_arc_common",
            u"<" : u"sc_arc_common",
            u"->": u"sc_arc_main",
            u"<-": u"sc_arc_main",
            u"<>": u"sc_edge",
            u"..>": u"sc_arc_access",
            u"<..": u"sc_arc_access",
            u'<=>': u"sc_edge",
            u'_<=>': u"sc_edge",
            u'=>': u"sc_arc_common",
            u'<=': u"sc_arc_common",
            u'=>': u"sc_arc_common",
            u'<=': u"sc_arc_common",
            u'_->': u"sc_arc_access",
            u'_<-': u"sc_arc_access",
            u'-|>': u"sc_arc_access",
            u'_-|>': u"sc_arc_access",
            u'<|-': u"sc_arc_access",
            u'_<|-': u"sc_arc_access",
            u'-/>': u"sc_arc_access",
            u'_-/>': u"sc_arc_access",
            u'</-': u"sc_arc_access",
            u'_</-': u"sc_arc_access",
            u'~>': u"sc_arc_access",
            u'_~>': u"sc_arc_access",
            u'<~': u"sc_arc_access",
            u'_<~': u"sc_arc_access",
            u'~|>': u"sc_arc_access",
            u'_~|>': u"sc_arc_access",
            u'<|~': u"sc_arc_access",
            u'_<|~': u"sc_arc_access",
            u'~/>': u"sc_arc_access",
            u'_~/>': u"sc_arc_access",
            u'</~': u"sc_arc_access",
            u'_</~': u"sc_arc_access",
            }

arc_keynodes = {
                u'<=>': u"sc_edge_const",
                u'_<=>': u"sc_edge_var",
                u'=>': u"sc_arc_common_const",
                u'<=': u"sc_arc_common_const",
                u'_=>': u"sc_arc_common_var",
                u'_<=': u"sc_arc_common_var",
                u'_->': u"sc_arc_access_var_pos_perm",
                u'_<-': u"sc_arc_access_var_pos_perm",
                u'-|>': u"sc_arc_access_const_neg_perm",
                u'_-|>': u"sc_arc_access_var_neg_perm",
                u'<|-': u"sc_arc_access_const_neg_perm",
                u'_<|-': u"sc_arc_access_var_neg_perm",
                u'-/>': u"sc_arc_access_const_fuz_perm",
                u'_-/>': u"sc_arc_access_var_fuz_perm",
                u'</-': u"sc_arc_access_const_fuz_perm",
                u'_</-': u"sc_arc_access_var_fuz_perm",
                u'~>': u"sc_arc_access_const_pos_temp",
                u'_~>': u"sc_arc_access_var_pos_temp",
                u'<~': u"sc_arc_access_const_pos_temp",
                u'_<~': u"sc_arc_access_var_pos_temp",
                u'~|>': u"sc_arc_access_const_neg_temp",
                u'_~|>': u"sc_arc_access_var_neg_temp",
                u'<|~': u"sc_arc_access_const_neg_temp",
                u'_<|~': u"sc_arc_access_var_neg_temp",
                u'~/>': u"sc_arc_access_const_fuz_temp",
                u'_~/>': u"sc_arc_access_var_fuz_temp",
                u'</~': u"sc_arc_access_const_fuz_temp",
                u'_</~': u"sc_arc_access_var_fuz_temp",
            }



class Converter:
    
    def __init__(self):
        self.group_processors = {
                        scs_parser.AliasGroup: self.processAliasGroup,
                        scs_parser.KeywordGroup: self.processKeywordGroup,
                        scs_parser.SimpleIdentifierGroup: self.processSimpleIdentifierGroup,
                        scs_parser.UrlGroup: self.processUrlGroup,
                        scs_parser.ContentGroup: self.processContentGroup,
                        scs_parser.SetGroup: self.processSetGroup,
                        scs_parser.OSetGroup: self.processOSetGroup,
                        scs_parser.TripleGroup: self.processTripleGroup,
                        scs_parser.SimpleSentenceGroup: self.processSimpleSentenceGroup,
                        #scs_parser.SynonymGroup: self.processSynonymGroup,
                        scs_parser.SentenceGroup: self.processSentenceGroup,
                        scs_parser.IdtfWithIntGroup: self.processIdtfWithIntGroup,
                        scs_parser.InternalGroup: self.processInternalGroup,
                        scs_parser.InternalListGroup: self.processInternalListGroup
                        }
        
        self.comments = {}
        self.triples = []
    
        # map of contents, that need to be written
        self.link_contents = {}
        # map of contents, that need to be copied
        self.link_copy_contents = {}
        self.contents_copy_link = {}
    
        # synonyms map. For each key in this map we contains list of all synonym elements
        self.synonyms = {}
        # aliases map
        self.aliases = {}
    
        self.set_count = 0
        self.contour_count = 0
        self.oset_count = 0
        self.arc_count = 0
        self.link_count = 0
        
        self.process_file = None
        self.process_dir = None
    
    def generate_set_idtf(self):
        self.set_count += 1
        return ".set_%d" % self.set_count
    
    def generate_contour_idtf(self):
        self.contour_count += 1
        return ".contour_%d" % self.contour_count
    
    def generate_oset_idtf(self):
        self.oset_count += 1
        return ".oset_%d" % self.oset_count
    
    def generate_link_idtf(self):
        self.link_count += 1
        return 'data/link_%d' % self.link_count
    
    def generate_arc_idtf(self, type = None, include_into_set = True):
        self.arc_count += 1
        
        res = None
        if type is not None:
            if arc_types.has_key(type):
                res = arc_types[type] + "#." + str(self.arc_count)
        
        if res is None:
            res = "sc_arc_common#.arc_%d" % self.arc_count
            
        if include_into_set and arc_keynodes.has_key(type):
            self.append_sentence(arc_keynodes[type], self.generate_arc_idtf('->', False), res, False)
            
        return res
    
    def resolve_identifier(self, group):
        """Resolves identifiers for different groups
        """
        
        key = str(group)
        if self.aliases.has_key(key):
            return self.aliases[key]
        
        alias = str(group)
        if isinstance(group, scs_parser.OSetGroup):
            alias = self.generate_oset_idtf()
        elif isinstance(group, scs_parser.SetGroup):
            alias = self.generate_set_idtf()
            
        self.aliases[key] = alias
        
        return alias
    
    def append_synonyms(self, idtf1, idtf2):
        """Appends two identifiers as synonyms into map
        """
        if self.synonyms.has_key(idtf1):
            return
        
        self.synonyms[idtf1] = idtf2
        
    def buildFormatRelation(self, linkIdtf, ext):
        """Build relation between sc-link and it's format
        @param linkIdtf: Identifier of sc-link
        @param ext: File extension 
        """
        fmt_idtf = u'hypermedia_format_' + ext
        arc_idtf = self.generate_arc_idtf(u'=>', True)
        self.append_sentence(linkIdtf, arc_idtf, fmt_idtf, False)
        self.append_sentence(u'hypermedia_nrel_format', self.generate_arc_idtf(u'->', True), arc_idtf, False)
        
    def resolve_synonym(self, idtf):
        if self.synonyms.has_key(idtf):
            return self.resolve_synonym(self.synonyms[idtf])
        
        return idtf
    
    def check_predicate_mirror(self, predicate):
        
        return (predicate in mirror_connectors)
    
    def append_sentence(self, subject, predicate, object, isMirrored):
        """Appends new scs-level 1 sentence into list
        """
        assert isinstance(subject, str) or isinstance(subject, unicode)
        assert isinstance(object, str) or isinstance(object, unicode)
        assert isinstance(predicate, str) or isinstance(predicate, unicode)
        
        if not isMirrored:
            self.triples.append((subject, predicate, object))
        else:
            self.triples.append((object, predicate, subject))
    
    # ---------------------------------------
    def processSimpleIdentifierGroup(self, group):
        self.resolve_identifier(group)
        
    def processUrlGroup(self, group):
        """Process url to link content data
        """
        data_path = group.value[1:-1]
        if data_path.startswith(u"file://"):
            data_path = data_path.replace(u"file://", u"")
        
        path, tail = os.path.split(self.process_file)
        abs_path = os.path.abspath(os.path.join(path, data_path))    
        if self.contents_copy_link.has_key(abs_path):
            group.value = '"file://%s"' % self.contents_copy_link[abs_path]
        else:
            link_idtf = self.generate_link_idtf()
            self.link_copy_contents[link_idtf] = abs_path
            self.contents_copy_link[abs_path] = link_idtf
            group.value = '"file://%s"' % link_idtf
            
            path, ext = os.path.splitext(abs_path)
            self.buildFormatRelation(group.value, ext[1:])
        
    def processKeywordGroup(self, group):
        return group
        
    def processSimpleSentenceGroup(self, group):
        """Process scs-level 1 sentences
        """
        subject_idtf = self.resolve_identifier(group.subject)
        object_idtf = self.resolve_identifier(group.object)
        arc_idtf = group.predicate.value
        
        self.append_sentence(subject_idtf, arc_idtf, object_idtf, False);
    
    def processIdtfWithIntGroup(self, group):
        """Process identifier with internal sentence group
        """
        self.parse_tree(group.idtf)
        subject_idtf = self.resolve_identifier(group.idtf)
        
        internal_list = group.internal
        if internal_list is not None:
            for sentence in internal_list.sentences:
                
                for obj in sentence.object:
                    self.parse_tree(obj)
                    object_idtf = self.resolve_identifier(obj)
                    attributes = sentence.attrs
                    arc_idtf = self.generate_arc_idtf(sentence.predicate)
                    
                    self.append_sentence(subject_idtf, arc_idtf, object_idtf, self.check_predicate_mirror(sentence.predicate))
                    
                    # write attributes
                    for attr in attributes:
                        attr_idtf = self.resolve_identifier(attr)
                        self.append_sentence(attr_idtf, self.generate_arc_idtf('->'), arc_idtf, False)
                
                
    def processInternalGroup(self, group):
        return group
        
    def processInternalListGroup(self, group):
        return group
        
    def processTripleGroup(self, group):
        return group
        
    def processAliasGroup(self, group):
        """Just resolve identifier for alias
        """
        return self.resolve_identifier(group)
        
    def processContentGroup(self, group):
        """Store link content for saving
        """
        result = None
        if len(group.value) > 1 and group.value[0] == u'*' and group.value[-1] == u'*':
            data = group.value[1:-1]
            data_str = data
            process_file = self.process_file
            process_dir = self.process_dir
            
            if data.startswith(u'^'):
                data = data[2:-1]
                if data.startswith(u"file://"):
                    data = data.replace(u"file://", u"")
                    
            
                process_dir, tail = os.path.split(self.process_file)
                process_file = os.path.join(process_dir, data)
                f = open(process_file, "r")
                data_str = f.read()
                f.close()
            
            
            
            # create new converter and build data
            converter = Converter()
            converter.link_copy_contents = self.link_copy_contents
            converter.link_contents = self.link_contents
            converter.synonyms = self.synonyms
            #converter.triples = self.triples
            converter.aliases = self.aliases
            converter.set_count = self.set_count
            converter.oset_count = self.oset_count
            converter.arc_count = self.arc_count
            converter.link_count = self.link_count
            converter.process_file = process_file
            converter.process_dir = process_dir
            
            converter.parse_string(data_str)
            
            self.link_copy_contents = converter.link_copy_contents
            self.link_contents = converter.link_contents
            self.synonyms = converter.synonyms
            self.triples.extend(converter.triples)
            self.aliases = converter.aliases
            self.set_count = converter.set_count
            self.oset_count = converter.oset_count
            self.arc_count = converter.arc_count
            self.link_count = converter.link_count
                        
            # collect all created sc-elements to append them into contour
            objects = []
            for triple in converter.triples:
                if triple[0] in arc_types.values() or triple[0] in arc_keynodes.values():
                    continue
                for idx in xrange(len(triple)):
                    if not triple[idx] in objects:
                        objects.append(triple[idx])
            
            contour = self.generate_contour_idtf()
            self.append_sentence(u'sc_node_struct', self.generate_arc_idtf('->', False), contour, False)
            for obj in objects:
                self.append_sentence(contour, self.generate_arc_idtf('->', False), obj, False)
            
            group.value = contour
            result = contour
        else:
            link_idtf = self.generate_link_idtf()
            self.link_contents[link_idtf] = group.value
            group.value = '"file://%s"' % link_idtf
            result = link_idtf
            
            self.buildFormatRelation(group.value, u'txt')
        
        return result
        
    def processSetGroup(self, group):
        """Process set
        """
        idtf = self.resolve_identifier(group)
        for item in group.items:
            attributes = item[0]
            object = item[1]
            
            self.parse_tree(object)
            arc_idtf = self.generate_arc_idtf('->')
            self.append_sentence(idtf, arc_idtf, self.resolve_identifier(object), False)
            
            for attr in attributes:
                attr_idtf = self.resolve_identifier(attr)
                self.append_sentence(attr_idtf, self.generate_arc_idtf('->'), arc_idtf, False)
        
        
    def processOSetGroup(self, group):
        """Process ordered tree
        """
        idtf = self.resolve_identifier(group)
        item_count = 0
        for item in group.items:
            attributes = item[0]
            object = item[1]
            item_count += 1
            
            object_idtf = self.resolve_identifier(object)
            self.parse_tree(object)
            arc_idtf = self.generate_arc_idtf('->')
            self.append_sentence(idtf, arc_idtf, object_idtf, False)
            # add order attribute
            self.append_sentence("%d_" % item_count, self.generate_arc_idtf('->'), arc_idtf, False)
            
            for attr in attributes:
                attr_idtf = self.resolve_identifier(attr)
                self.append_sentence(attr_idtf, self.generate_arc_idtf('->'), object_idtf, False)
        
    def processSentenceGroup(self, group):
        """Process sentence for scs-levels 2-6
        """
        subject = group.subject
        predicate = group.predicate
        attributes = group.attrs
        objects = group.object
        
        self.parse_tree(subject)
        subject_idtf = self.resolve_identifier(subject)
        for obj in objects:
            # process object
            self.parse_tree(obj)
            # resolve object identifier
            obj_idtf = self.resolve_identifier(obj)
    
    
            if predicate == u'=':
                self.append_synonyms(obj_idtf, subject_idtf)
            else:
                # connect subject with object
                arc_idtf = self.generate_arc_idtf(predicate)
                self.append_sentence(subject_idtf, arc_idtf, obj_idtf, self.check_predicate_mirror(predicate))
                
                # connect attributes
                for attr in attributes:
                    self.parse_tree(attr)
                    attr_idtf = self.resolve_identifier(attr)
                    self.append_sentence(attr_idtf, self.generate_arc_idtf('->'), arc_idtf, False)
    
    def processSynonymGroup(self, group):
        pass
    
             
    def get_string_value(self, element):
        """Returns string representation of specified element
        from parser results
        """
        pass
    
    def parse_skip(self, group):
        pass
    
    def parse_simple_sentence(self, group):
        pass
        
        
    # ----------------------------------------- 
    def parse_tree(self, tree):
        """Parse results tree
        """
        
        if isinstance(tree, ParseResults):
            for item in tree:
                self.parse_tree(item)
        else:
            self.group_processors[tree.__class__](tree)
        
    
    def parse_string(self, data):
        """Parse specified string
        """
        try:
            result = scs_parser.syntax().parseString(data.decode('utf-8'), parseAll = True)
            self.parse_tree(result)
            
            # process synonyms
            new_triples = []
            for subj, predicate, obj in self.triples:
                new_triples.append((self.resolve_synonym(subj), predicate, self.resolve_synonym(obj)))
                self.triples = new_triples
                
            
        except ParseException, err:
            print err.line
            print " "*(err.column-1) + "^"
            print err
    
    def parse_directory(self, path):
        """Parse specified directory
        """
        self.process_dir = path
        for root, dirs, files in os.walk(path):
            #print root
            for f in files:
                
                # skip none scs files
                base, ext = os.path.splitext(f)
                if ext != '.scs':
                    continue
                
                file_path = os.path.join(root, f)
                self.process_file = file_path
                
                self.comments[len(self.triples)] = file_path
                
                # parse file
                print "Parse %s" % file_path
                input = open(file_path, "r")
                self.parse_string(input.read().decode("utf-8"))
                input.close()
                
    def write_to_fs(self, path):
        """Writes converted data into specified directory
        """
        if os.path.exists(path):
            shutil.rmtree(path)
            
        os.makedirs(path)
        
        count = 0
        with codecs.open(os.path.join(path, "data.scs"), "w", "utf-8") as output:
            for t in self.triples:
                
                if self.comments.has_key(count):
                    output.write('\n/* --- %s --- */\n' % self.comments[count])
                
                output.write("%s | %s | %s;;\n" % t)
                count += 1
            output.close()
                
        # write contents
        os.makedirs(os.path.join(path, "data"))
        for num, data in self.link_contents.items():
            f = open(os.path.join(path, str(num)), "w")
            f.write(data)
            f.close()
            
        # copy contents
        for num, src_path in self.link_copy_contents.items():
            shutil.copyfile(src_path, os.path.join(path, str(num)))

if __name__ == "__main__":

    print "Default encoding: %s" % sys.getdefaultencoding()

    if len(sys.argv) < 3:
        print "Usage: python converter.py <input dir> <output dir>"
        sys.exit(0)
    
    converter = Converter()
    converter.parse_directory(sys.argv[1])
    print "Write output..."
    converter.write_to_fs(sys.argv[2])
