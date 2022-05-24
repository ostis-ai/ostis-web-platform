import re
from os import path

NodeTypeSets = {

    "node/-/-/not_define": ["sc_node"],
    "node/-/not_define": ["sc_node"],

    "node/const/general_node": ["sc_node"],
    "node/const/terminal": ["sc_node_abstract"],
    "node/const/struct": ["sc_node_struct"],
    "node/const/tuple": ["sc_node_tuple"],
    "node/const/role": ["sc_node_role_relation"],
    "node/const/attribute": ["sc_node_role_relation"],
    "node/const/relation": ["sc_node_norole_relation"],
    "node/const/group": ["sc_node_class"],

    "node/const/perm/general": ["sc_node"],
    "node/const/perm/general_node": ["sc_node"],
    "node/const/perm/terminal": ["sc_node_abstract"],
    "node/const/perm/struct": ["sc_node_struct"],
    "node/const/perm/tuple": ["sc_node_tuple"],
    "node/const/perm/role": ["sc_node_role_relation"],
    "node/const/perm/attribute": ["sc_node_role_relation"],
    "node/const/perm/relation": ["sc_node_norole_relation"],
    "node/const/perm/group": ["sc_node_class"],

    "node/var/general_node": ["sc_node"],
    "node/var/terminal": ["sc_node_abstract"],
    "node/var/struct": ["sc_node_struct"],
    "node/var/tuple": ["sc_node_tuple"],
    "node/var/role": ["sc_node_role_relation"],
    "node/var/attribute": ["sc_node_role_relation"],
    "node/var/relation": ["sc_node_norole_relation"],
    "node/var/group": ["sc_node_class"],

    "node/var/perm/general": ["sc_node"],
    "node/var/perm/general_node": ["sc_node"],
    "node/var/perm/terminal": ["sc_node_abstract"],
    "node/var/perm/struct": ["sc_node_struct"],
    "node/var/perm/tuple": ["sc_node_tuple"],
    "node/var/perm/role": ["sc_node_role_relation"],
    "node/var/perm/attribute": ["sc_node_role_relation"],
    "node/var/perm/relation": ["sc_node_norole_relation"],
    "node/var/perm/group": ["sc_node_class"]
}

UnsupportedNodeTypeSets = {
    "node/const/perm/super_group": ["sc_node_super_group"],

    "node/const/temp/general": ["sc_node_temp"],
    "node/const/temp/general_node": ["sc_node_temp"],
    "node/const/temp/terminal": ["sc_node_abstract_temp"],
    "node/const/temp/struct": ["sc_node_struct_temp"],
    "node/const/temp/tuple": ["sc_node_tuple_temp"],
    "node/const/temp/role": ["sc_node_role_relation_temp"],
    "node/const/temp/attribute": ["sc_node_role_relation_temp"],
    "node/const/temp/relation": ["sc_node_norole_relation_temp"],
    "node/const/temp/group": ["sc_node_class_temp"],
    "node/const/temp/super_group": ["sc_node_super_group_temp"],

    "node/var/perm/super_group": ["sc_node_super_group"],

    "node/var/temp/general": ["sc_node_temp"],
    "node/var/temp/general_node": ["sc_node_temp"],
    "node/var/temp/terminal": ["sc_node_abstract_temp"],
    "node/var/temp/struct": ["sc_node_struct_temp"],
    "node/var/temp/tuple": ["sc_node_tuple_temp"],
    "node/var/temp/role": ["sc_node_role_relation_temp"],
    "node/var/temp/attribute": ["sc_node_role_relation_temp"],
    "node/var/temp/relation": ["sc_node_norole_relation_temp"],
    "node/var/temp/group": ["sc_node_class_temp"],
    "node/var/temp/super_group": ["sc_node_super_group_temp"],

    "node/meta/perm/general": ["sc_node_meta"],
    "node/meta/perm/general_node": ["sc_node_meta"],
    "node/meta/perm/terminal": ["sc_node_abstract_meta"],
    "node/meta/perm/struct": ["sc_node_struct_meta"],
    "node/meta/perm/tuple": ["sc_node_tuple_meta"],
    "node/meta/perm/role": ["sc_node_role_relation_meta"],
    "node/meta/perm/attribute": ["sc_node_role_relation_meta"],
    "node/meta/perm/relation": ["sc_node_norole_relation_meta"],
    "node/meta/perm/group": ["sc_node_class_meta"],
    "node/meta/perm/super_group": ["sc_node_super_group_meta"],

    "node/meta/temp/general": ["sc_node_meta_temp"],
    "node/meta/temp/general_node": ["sc_node_meta_temp"],
    "node/meta/temp/terminal": ["sc_node_abstract_meta_temp"],
    "node/meta/temp/struct": ["sc_node_struct_meta_temp"],
    "node/meta/temp/tuple": ["sc_node_tuple_meta_temp"],
    "node/meta/temp/role": ["sc_node_role_relation_meta_temp"],
    "node/meta/temp/attribute": ["sc_node_role_relation_meta_temp"],
    "node/meta/temp/relation": ["sc_node_norole_relation_meta_temp"],
    "node/meta/temp/group": ["sc_node_class_meta_temp"],
    "node/meta/temp/super_group": ["sc_node_super_group_meta_temp"],
}

EdgeTypes = {
    "pair/const/-/perm/noorien": "<=>",
    "pair/const/-/perm/orient": "=>",
    "pair/const/fuz/perm/orient/membership": "-/>",
    "pair/const/neg/perm/orient/membership": "-|>",
    "pair/const/pos/perm/orient/membership": "->",
    "pair/const/fuz/temp/orient/membership": "~/>",
    "pair/const/neg/temp/orient/membership": "~|>",
    "pair/const/pos/temp/orient/membership": "~>",
    "pair/const/-/temp/noorien": "<=>",
    "pair/const/-/temp/orient": "=>",

    "pair/var/-/perm/noorien": "_<=>",
    "pair/var/-/perm/orient": "_=>",
    "pair/var/fuz/perm/orient/membership": "_-/>",
    "pair/var/neg/perm/orient/membership": "_-|>",
    "pair/var/pos/perm/orient/membership": "_->",
    "pair/var/fuz/temp/orient/membership": "_~/>",
    "pair/var/neg/temp/orient/membership": "_~|>",
    "pair/var/pos/temp/orient/membership": "_~>",

    "pair/-/-/-/orient": ">",
    "pair/-/-/-/noorient": "<>",

    "arc/-/-": "..>",

    "arc/const/pos": "->",
    "arc/const/fuz": "-/>",
    "arc/const/neg": "-|>",
    "arc/const/pos/temp": "~>",
    "arc/const/fuz/temp": "~/>",
    "arc/const/neg/temp": "~|>",

    "arc/var/pos": "_->",
    "arc/var/fuz": "_-/>",
    "arc/var/neg": "_-|>",
    "arc/var/pos/temp": "_~>",
    "arc/var/fuz/temp": "_~/>",
    "arc/var/neg/temp": "_~|>",

    "pair/orient": ">",
    "pair/noorient": "<>",

    "pair/const/orient": "=>",
    "pair/const/noorient": "<=>",
    "pair/const/synonym": "<=>",

    "pair/var/orient": "_=>",
    "pair/var/noorient": "_<=>"

}

UnsupportedEdgeTypes = {
    "pair/var/-/temp/noorien": "sc_pair_var_temp_noorient",
    "pair/var/-/temp/orient": "sc_pair_var_temp_orient",

    "pair/meta/-/perm/noorien": "sc_pair_meta_perm_noorient",
    "pair/meta/-/perm/orient": "sc_pair_meta_perm_orient",
    "pair/meta/-/temp/noorien": "sc_pair_meta_temp_noorient",
    "pair/meta/-/temp/orient": "sc_pair_meta_temp_orient",

    "pair/meta/fuz/perm/orient/membership": "sc_pair_meta_fuz_perm_orient_membership",
    "pair/meta/fuz/temp/orient/membership": "sc_pair_meta_fuz_temp_orient_membership",
    "pair/meta/neg/perm/orient/membership": "sc_pair_meta_neg_perm_orient_membership",
    "pair/meta/neg/temp/orient/membership": "sc_pair_meta_neg_temp_orient_membership",
    "pair/meta/pos/perm/orient/membership": "sc_pair_meta_pos_perm_orient_membership",
    "pair/meta/pos/temp/orient/membership": "sc_pair_meta_pos_temp_orient_membership",
}

ImageFormats = {'png': 'format_png'}


class Buffer:

    def __init__(self):
        self.value = ""

    def write(self, s):
        self.value += s

    def add_tabs(self, tabs_value):
        lines = self.value.splitlines(True)
        self.value = ""

        for line in lines:
            self.value += tabs_value + line


class SCsWriter:
    kNrelSystemIdtf = "nrel_system_identifier"
    kNrelMainIdtf = "nrel_main_identifier"

    def __init__(self, output_path):
        self.output_path = output_path

        self.written_elements = []
        self.errors = []

    def add_error(self, error):
        self.errors.append(error)

    def write(self, elements):
        buff = Buffer()
        for _, el in elements.items():
            self.correct_idtf(buff, el)

        self.process_elements(elements, buff, 0)

        file = open(self.output_path, "w")
        file.write(buff.value)
        file.close()

        return self.errors

    def process_elements(self, elements, buffer, parent, nested_level=0):

        contours_queue = []
        edges_queue = []

        # generate nodes
        for _, el in elements.items():
            el_parent = int(el["parent"])

            el_tag = el["tag"]
            el_id = el["id"]

            if el_tag == "node" or el_tag == "bus":
                if parent == 0:
                    if el_tag == "node":
                        self.write_node(buffer, el)
                    self.written_elements.append(el_id)
                    buffer.write("\n")

            elif el_tag == "contour":
                if el_parent == parent:
                    contours_queue.append(el)

            elif el_tag == "arc" or el_tag == "pair":
                if el_parent == parent:
                    edges_queue.append(el)

        # write contours
        for c in contours_queue:
            self.write_contour(buffer, c, elements, nested_level)
            self.written_elements.append(c["id"])
            buffer.write("\n")

        # write edges
        self.write_edges(buffer, edges_queue, elements)

    def correct_idtf(self, buffer, el):
        idtf = el["idtf"]
        is_var = self.is_variable(el["type"])

        main_idtf = None
        if not re.match(r"^[0-9a-zA-Z_]*$", idtf):
            idtf = ""
            if re.match(r"^[0-9a-zA-Z_*'.. ]*$", idtf):
                main_idtf = el["idtf"]
            else:
                self.add_error("Identifier `{}` should match expression `^[0-9a-zA-Z_]*$`".format(idtf))

        if idtf is None or len(idtf) == 0:
            if is_var:
                el["idtf"] = ".._el_{}".format(el["id"].replace("-", "_"))
            else:
                el["idtf"] = "..el_{}".format(el["id"].replace("-", "_"))
        elif is_var:
            if not idtf.startswith("_"):
                el["idtf"] = "_{}".format(idtf.replace("-", "_"))
        elif not is_var:
            if idtf.startswith("_"):
                el["idtf"] = "{}".format(idtf[1:].replace("-", "_"))

        if main_idtf is not None:
            if main_idtf.startswith("["):
                buffer.write("\n{}\n => {}: {};;\n".format(el["idtf"], self.kNrelMainIdtf, main_idtf))
            else:
                buffer.write("\n{}\n => {}: [{}];;\n".format(el["idtf"], self.kNrelMainIdtf, main_idtf))

    @staticmethod
    def make_alias(prefix, element_id):
        return "@{}_{}".format(prefix, element_id.replace("-", "_"))

    @staticmethod
    def is_idtf_generated(idtf):
        return idtf.startswith("..el_") or idtf.startswith(".._el_")

    @staticmethod
    def is_variable(el_type):
        return "/var/" in el_type

    @staticmethod
    def write_system_idtf(buffer, alias, idtf):
        buffer.write("{} => {}: [{}];;\n".format(alias, SCsWriter.kNrelSystemIdtf, idtf))

    def write_edges(self, buffer, edges_queue, elements):
        processed_edge = True
        while len(edges_queue) > 0 and processed_edge:
            processed_edge = False
            process_queue = edges_queue

            edges_queue = []
            for e in process_queue:
                src_id = e["source"]
                trg_id = e["target"]

                if src_id not in self.written_elements or trg_id not in self.written_elements:
                    edges_queue.append(e)
                    continue

                try:
                    src_el = elements[src_id]
                    if src_el["tag"] == "bus":
                        src_el = elements[src_el["node_id"]]
                except KeyError:
                    self.add_error("Can't find source element with id {}".format(src_id))
                    continue

                try:
                    trg_el = elements[trg_id]
                except KeyError:
                    self.add_error("Can't find target element with id {}".format(trg_id))
                    continue

                edge_type = e["type"]
                is_unsupported = False
                try:
                    symbol = EdgeTypes[edge_type]
                except KeyError:
                    try:
                        scs_edge_type = UnsupportedEdgeTypes[edge_type]
                        is_unsupported = True
                    except KeyError:
                        msg = "Edge type `{}` is unknown. " \
                              "Please add it into EdgeTypes or into UnsupportedEdgeTypes"\
                            .format(edge_type)
                        self.add_error(msg)
                        buffer.write("// {}".format(msg))
                        continue

                alias = self.make_alias("edge", e["id"])
                if is_unsupported:
                    buffer.write("{} = ({} => {});;\n".format(alias, src_el["idtf"], trg_el["idtf"]))
                    buffer.write("{} -> {};;\n".format(scs_edge_type, alias))
                else:
                    buffer.write("{} = ({} {} {});;\n".format(alias, src_el["idtf"], symbol, trg_el["idtf"]))

                processed_edge = True
                self.written_elements.append(e["id"])
                e["idtf"] = alias

        if len(edges_queue) > 0:
            for e in edges_queue:
                try:
                    src_el = elements[e["source"]]
                except KeyError:
                    self.add_error("Can't find source element with id {}".format(e["source"]))
                    continue

                try:
                    trg_el = elements[e["target"]]
                except KeyError:
                    self.add_error("Can't find target element with id {}".format(e["target"]))
                    continue

                self.add_error("Wasn't able to create edge: {}->{}".format(src_el["idtf"], trg_el["idtf"]))

    def write_contour(self, buffer, el, elements, nested_level):
        el_id = el["id"]
        contour_buff = Buffer()
        self.process_elements(elements, contour_buff, int(el_id), nested_level + 1)
        contour_buff.add_tabs('    ' * (nested_level + 1))

        self.correct_idtf(buffer, el)
        buffer.write("{} = [*\n{}\n*];;\n".format(el["idtf"], contour_buff.value))

    def write_node(self, buffer, el):
        if el["content"]["type"] == 0:
            el_type = el["type"]
            idtf = el["idtf"]

            try:
                node_set = NodeTypeSets[el_type]
                buffer.write(idtf)

                for s in node_set:
                    buffer.write("\n  <- {}".format(s))
                buffer.write(";;\n")

            except KeyError:
                try:
                    node_set = UnsupportedNodeTypeSets[el_type]
                    buffer.write(idtf)

                    for s in node_set:
                        buffer.write("\n  <- {}".format(s))
                    buffer.write(";;\n")
                except KeyError:
                    msg = "Node type `{}` is not supported. Please add it into NodeTypeSets".format(el_type)
                    buffer.write("// {}".format(msg))
                    self.add_error(msg)
                    return

        else:
            self.write_link(buffer, el)

    def write_link(self, buffer, el):
        content = el["content"]
        content_type = content["type"]
        content_data = content["data"]

        is_url = False
        is_image = False
        image_format = ''

        if content_type == 1:
            write_content = content_data
        elif content_type == 2:
            write_content = '"int64:{}"'.format(content_data)
        elif content_type == 3:
            write_content = '"float:{}"'.format(content_data)
        elif content_type == 4:
            write_content = path.split(self.output_path)[0] + "/" + content["file_name"]
            f = open(write_content, "wb")
            f.write(content_data)
            f.close()
            write_content = "file://" + path.split(write_content)[1]
            is_url = True
            if path.splitext(write_content)[1][1:] in ImageFormats:
                image_format = ImageFormats.get(path.splitext(write_content)[1][1:])
                is_image = True

        else:
            msg = "Content type {} is not supported".format(content_type)
            buffer.write("// {}".format(msg))
            self.add_error(msg)
            return

        alias = self.make_alias("link", el["id"])

        if is_url:
            if is_image:
                buffer.write('{} = "{}";;\n'.format(alias, write_content))
                buffer.write('@format_edge = ({} => {});;\n'.format(alias, image_format))
                buffer.write('@nrel_format_edge = (nrel_format -> @format_edge);;\n')
            else:
                buffer.write('{} = "{}";;\n'.format(alias, write_content))
        else:
            is_var = "_" if self.is_variable(el["type"]) else ""
            buffer.write('{} = {}[{}];;\n'.format(alias, is_var, write_content))

        idtf = el["idtf"]
        if not self.is_idtf_generated(idtf):
            self.write_system_idtf(buffer, alias, idtf)

        el["idtf"] = alias
