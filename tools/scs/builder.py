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
import converter
import ctypes
from pysc import *
from pysc import _sc_addr

# keynode identifires
keynode_hypermedia_format_txt_str = u"hypermedia_format_txt"
keynode_hypermedia_nrel_format_str = u"hypermedia_nrel_format"


encoding = "utf-8" 
reload(sys)
sys.setdefaultencoding(encoding)
sys.stdout = codecs.getwriter(encoding)(sys.stdout, errors = "replace")
sys.stderr = codecs.getwriter(encoding)(sys.stderr, errors = "replace")

# mapping of identifier prefix into sc-type
arcPrefixToType = {
			u"sc_arc_common" : sc_type_arc_common,
			u"sc_arc_main": sc_type_arc_pos_const_perm,
			u"sc_edge" : sc_type_edge_common,
			u"sc_arc_access": sc_type_arc_access,
			}

# mapping of set identifiers into sc-types
idtfToType = {
			u"sc_edge_const": sc_type_edge_common | sc_type_const,
			u"sc_edge_var": sc_type_edge_common | sc_type_var,
			u"sc_arc_common_const": sc_type_arc_common | sc_type_const,
			u"sc_arc_common_var": sc_type_arc_common | sc_type_var,
			
			u"sc_arc_access_var_pos_perm": sc_type_arc_access | sc_type_var | sc_type_arc_pos | sc_type_arc_perm,
			u"sc_arc_access_const_neg_perm": sc_type_arc_access | sc_type_const | sc_type_arc_neg | sc_type_arc_perm,
			u"sc_arc_access_var_neg_perm": sc_type_arc_access | sc_type_var | sc_type_arc_neg | sc_type_arc_perm,
			u"sc_arc_access_const_fuz_perm": sc_type_arc_access | sc_type_const | sc_type_arc_fuz | sc_type_arc_perm,
			u"sc_arc_access_var_fuz_perm": sc_type_arc_access | sc_type_var | sc_type_arc_fuz | sc_type_arc_perm,
			
			u"sc_arc_access_const_pos_temp": sc_type_arc_access | sc_type_const | sc_type_arc_pos | sc_type_arc_temp,
			u"sc_arc_access_var_pos_temp": sc_type_arc_access | sc_type_var | sc_type_arc_pos | sc_type_arc_temp,
			u"sc_arc_access_const_neg_temp": sc_type_arc_access | sc_type_const | sc_type_arc_neg | sc_type_arc_temp,
			u"sc_arc_access_var_neg_temp": sc_type_arc_access | sc_type_var | sc_type_arc_neg | sc_type_arc_temp,
			u"sc_arc_access_const_fuz_temp": sc_type_arc_access | sc_type_const | sc_type_arc_fuz | sc_type_arc_temp,
			u"sc_arc_access_var_fuz_temp": sc_type_arc_access | sc_type_var | sc_type_arc_fuz | sc_type_arc_temp,
			
			# nodes
			u"sc_const": sc_type_const,
			u"sc_var": sc_type_var,
			u"sc_node_not_binary_tuple": sc_type_node_tuple,
			u"sc_node_struct": sc_type_node_struct,
			u"sc_node_role_relation": sc_type_node_role,
			u"sc_node_norole_relation": sc_type_node_norole,
			u"sc_node_not_relation": sc_type_node_class, 
			u"sc_node_abstract": sc_type_node_abstract,
			u"sc_node_material": sc_type_node_material, 
			}


# --------------------------------------------------

class ScElement:
	def __init__(self):
		self.type = sc_type_node
		self.idtf = 0

class ScNode(ScElement):
	def __init__(self):
		ScElement.__init__(self)
		
class ScArc(ScElement):
	def __init__(self):
		ScElement.__init__(self)
		self.sc_addr = None
		self.begin = None
		self.end = None
		
class ScLink(ScElement):
	def __init__(self):
		ScElement.__init__(self)
		
# --------------------------------------------------

class ScBuilder:
	
	def __init__(self):
		# mapping identifiers into sc-addrs
		self.sc_addrs = {}
		# map of sc-element types
		self.sc_types = {}
		# map of sc-arc, that need to be created
		self.sc_arcs = {}
		self.conv = None
		
		# statistics
		self.created_nodes = 0
		self.created_links = 0
		self.created_arcs = 0
		
		self.nrel_idtf_addr = None
		
		self.input_path = None
		self.output_path = None

	def checkIdtfWithPrefix(self, idtf):
		"""Check if specified identifier contains type
		"""
		return idtf.count(u'#') > 0
	
	def checkIdtfIsLink(self, idtf):
		"""Checks if specified idtf is and sc-link
		"""
		return len(idtf) > 1 and idtf[0] == u'"' and idtf[-1] == u'"'
	
	def checkIdtfIsArc(self, idtf):
		"""Check if specified identifier is an arc identifier.
		This function analyze just identifier
		"""
		if self.checkIdtfWithPrefix(idtf):
			preffix, el_idtf = self.splitIdtf(idtf)
			if arcPrefixToType.has_key(preffix):
				return True
			
		return False
	
	def splitIdtf(self, idtf):
		"""Split identifier with prefix to type and identifier
		"""
		assert self.checkIdtfWithPrefix(idtf)
		
		res = idtf.split('#')
		return (res[0], res[1])
	
	
	def determineArcType(self, arc_idtf):
		"""Determine type of predicate 
		"""
		if self.checkIdtfWithPrefix(arc_idtf):
			prefix, idtf = self.splitIdtf(arc_idtf)
			return arcPrefixToType[prefix]
		
		return sc_type_arc_common
	
	def determineElementType(self, idtf, isPredicate):
		"""Determines element type and store it in types map 
		"""		
		oldType = None
		try:
			oldType = self.sc_types[idtf]
		except:
			pass
		
		isVariable = idtf.startswith(u"_")
		
		newType = None
		if self.checkIdtfIsLink(idtf):
			newType = sc_type_link
		else:
			if self.checkIdtfIsArc(idtf):
				newType = self.determineArcType(idtf)
		
		if newType is None:
			if isPredicate:
				newType = sc_type_arc_common
			else:
				newType = sc_type_node
		
		if isVariable:
			newType = newType | sc_type_var
		else:
			newType = newType | sc_type_const
		
		if oldType is not None:
			# determine if new element type more common then old type
			if oldType == (newType & oldType):
				self.sc_types[idtf] = newType
		else:
			self.sc_types[idtf] = newType
			
	def resolveLinkPath(self, idtf):
		"""Resolve sc-link file path
		"""
		path = idtf[1:-1]
		path = path.replace("file://", "")
		
		return os.path.join(input_path, path)	
		
		
	def createNodeOrLink(self, elIdtf, elType):
		"""Create sc-node or sc-link in memory
		"""
		if elType & sc_type_link:
			addr = sc_memory_link_new()
			self.created_links += 1
			
			
			# setup link data
			path = elIdtf[1:-1]
			path = unicode(path.replace("file://", ""))
			
			#print path, addr.seg, addr.offset
			stream = None
			if self.conv.link_copy_contents.has_key(path):
				cont_path = str(self.conv.link_copy_contents[path])
				if os.path.exists(cont_path):
					stream = sc_stream_file_new(cont_path, SC_STREAM_READ)
				else:
					print "File doesn't exist '%s'" % cont_path
			elif self.conv.link_contents.has_key(path):
				data = str(self.conv.link_contents[path])
				stream = sc_stream_memory_new(data, len(data), SC_STREAM_READ, False) 
			
			if stream is None:
				print "Can't setup content from path %s" % path
			else:
				res = sc_memory_set_link_content(addr, stream)
				if res != SC_RESULT_OK:
					print "Can't setup link data for %s" % (str(elIdtf))
				sc_stream_free(stream)
			
	
		elif elType & sc_type_node:
			
			addr = sc_memory_node_new(elType)
			self.created_nodes += 1
			
		else:
			raise "Unknown type"
	
		self.sc_addrs[elIdtf] = addr
		
	def resolveScAddr(self, idtf):
		"""Resolve sc-addr of element if it possible
		"""
		if self.sc_addrs.has_key(idtf):
			return
		
		obj_type = self.sc_types[idtf]
		# create subject and object if them aren't an arcs
		if not (obj_type & sc_type_arc_mask):
			self.createNodeOrLink(idtf, obj_type)
	
	def generateSystemIdentifier(self, el_addr, idtf):
		"""Generate system identifier construction for specified node
		"""
		format_txt = self.sc_addrs[keynode_hypermedia_format_txt_str]
		nrel_format = self.sc_addrs[keynode_hypermedia_nrel_format_str]
		
		idtf_data = str(idtf)
		stream = sc_stream_memory_new(idtf_data, len(idtf_data), SC_STREAM_READ, False)
		
		assert stream is not None
		
		results_list = None
		results_count = None
		idtf_link = None
		
		idtf_link = sc_memory_link_new()
		sc_memory_set_link_content(idtf_link, stream)
		sc_stream_free(stream)
		
		# link nodes
		arc_addr = sc_memory_arc_new(sc_type_arc_common | sc_type_const, el_addr, idtf_link)
		sc_memory_arc_new(sc_type_arc_pos_const_perm, nrel_idtf_addr, arc_addr)
		
		# setup format
		arc_addr = sc_memory_arc_new(sc_type_arc_common | sc_type_const, idtf_link, format_txt)
		sc_memory_arc_new(sc_type_arc_pos_const_perm, nrel_format, arc_addr)
		
		self.created_links += 1
		self.created_arcs += 2
	
	def generateIdentifiers(self):
		
		global nrel_idtf_addr
		
		# create 'nrel_system_identifier' keynode if it doesn't exist
		nrel_idtf_str = u'hypermedia_nrel_system_identifier'
		nrel_idtf_data = str(nrel_idtf_str)
		
		#sc_helper_init()
		
		try:
			nrel_idtf_addr = self.sc_addrs[nrel_idtf_str]
		except:
			raise "You need to define system identifier keynode in scs"
		
		assert nrel_idtf_addr is not None
		
		for idtf, addr in self.sc_addrs.items():
				
			# extract object identifier
			system_idtf = idtf
			if self.checkIdtfWithPrefix(system_idtf):
				system_idtf = self.splitIdtf(system_idtf)[1]
				
			if system_idtf.startswith('.') or (system_idtf.startswith('"') and system_idtf.endswith('"')) or system_idtf.startswith('_.'):
				continue
			
			# temporary hack
			if system_idtf == nrel_idtf_str:
				continue
			
			#print "\tSetup for %s, %d: %d" % (idtf, addr.seg, addr.offset)
			#print system_idtf
			
			assert addr is not None
			# generate identifier relation
			self.generateSystemIdentifier(addr, system_idtf)
		
		#sc_helper_shutdown()
		
	# ------------------------------------------------
	
	def process(self, input_path, output_path):
		
		self.input_path = input_path
		self.output_path = output_path
		
		if os.path.exists(self.output_path):
			shutil.rmtree(self.output_path)
		
		sc_memory_initialize(self.output_path, "")
		
		self.conv = converter.Converter()
		self.conv.parse_directory(input_path)
		
		# determine types of all objects
		print "Determine list of all objects and their types..."
		for triple in self.conv.triples:
			subject = triple[0]
			object = triple[2]
			predicate = triple[1]
			
			self.determineElementType(subject, False)
			self.determineElementType(predicate, True)
			self.determineElementType(object, False)
			
			# if first element in triple is an element type set, then change type of sc-element
			if idtfToType.has_key(subject):
				
				idtf_type = idtfToType[subject]
				new_type = self.sc_types[object] | idtf_type
				# todo add types conflict checking
				if (idtf_type & sc_type_constancy_mask != 0):
					new_type = (idtf_type & sc_type_constancy_mask) | (new_type & ~sc_type_constancy_mask)
				
				self.sc_types[object] = new_type
				
		print "\tFound %d elements" % len(self.sc_types)
		
		#print self.sc_types
		
		# process triples
		print "Resolve sc-addrs..."
		for triple in self.conv.triples:
			subject = triple[0]
			object = triple[2]
			predicate = triple[1]
			
			# if first element in triple is an element type set, then change type of sc-element
			if idtfToType.has_key(subject):
				self.resolveScAddr(object)
				continue
			
			self.resolveScAddr(subject)
			self.resolveScAddr(object)
			
			# store arc
			arc = ScArc()
			arc.begin = subject
			arc.end = object
			arc.type = self.sc_types[predicate]
			 
			self.sc_arcs[predicate] = arc
			
		# now create arcs, while there are any arcs not created, 
		# or any of them couldn't be created anymore
		print "Create arcs..."
		created = True
		while len(self.sc_arcs) > 0 and created:
			created = False
			
			created_list = []
			
			# iterate all arcs that wasn't created and try to create them
			for item in self.sc_arcs.iteritems():
				idtf, arc = item
				
				# determine if begin and end arc elements created
				begin_addr = None
				end_addr = None
				
				try:
					begin_addr = self.sc_addrs[arc.begin]
					end_addr = self.sc_addrs[arc.end]
				except:
					continue
				
				if (arc.type & sc_type_const and arc.type & sc_type_var):
					print "Invalid type %s" % idtf
				# create new arc
				addr = sc_memory_arc_new(arc.type, begin_addr, end_addr)
				self.sc_addrs[idtf] = addr
				created_list.append(idtf)
							
				self.created_arcs += 1
				
			created = (len(created_list) > 0)
			# remove created arcs from map
			for arc in created_list:
				self.sc_arcs.pop(arc)
				
				
		# generate system identifiers
		print "Setup system identifiers..."
		self.generateIdentifiers()
		
		sc_memory_shutdown()
		
		# write list of arcs, that wasn't created
		for idtf, arc in self.sc_arcs.items():
			print "Arc %s wasn't created" % idtf
			try:
				print "Begin: %s" % str(self.sc_addrs[arc.begin])
				print "End: %s" % str(self.sc_addrs[arc.end])
			except:
				continue
				
		all_count = self.created_links + self.created_nodes + self.created_arcs
		print "Statistics:"
		print "\tCreated nodes: %d (%.03f%%)" % (self.created_nodes, float(self.created_nodes) / all_count * 100)
		print "\tCreated links: %d (%.03f%%)" % (self.created_links, float(self.created_links) / all_count * 100)
		print "\tCreated arcs: %d (%.03f%%)" % (self.created_arcs, float(self.created_arcs) / all_count * 100)
		print "\tTotal: %d" % all_count
		

if __name__ == "__main__":
	
	print "Default encoding: %s" % sys.getdefaultencoding()

	if len(sys.argv) < 3:
		print "Usage: python builder.py <input dir> <output dir>"
		sys.exit(0)
		
	builder = ScBuilder()
	builder.process(sys.argv[1], sys.argv[2])
