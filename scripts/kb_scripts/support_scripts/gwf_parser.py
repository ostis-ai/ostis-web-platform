import base64
import re

import xml.etree.ElementTree as ElementTree


class GWFParser:

    def __init__(self, add_error):
        self.add_error = add_error

    def parse(self, input_path) -> dict:
        elements = {}

        # parse gwf
        tree = ElementTree.parse(input_path)
        gwf_root = tree.getroot()

        static_sector = gwf_root.find("staticSector")
        if static_sector is None:
            self.add_error(input_path, "Can't find `staticSector` tag")
            return

        for el in static_sector:
            tag = el.tag.lower()

            el_id = el.attrib["id"]

            if el_id in elements:
                self.add_error(input_path, "Duplicate id {}".format(id))
                return None

            el_parent = el.attrib["parent"]
            el_type = el.attrib["type"]
            el_idtf = el.attrib["idtf"]

            result_el = {
                "id": el_id,
                "parent": el_parent,
                "idtf": el_idtf,
                "type": el_type,
                "tag": tag.lower(),
            }

            if tag == "node":
                content = None
                gwf_content = el.find("content")
                if gwf_content is not None:
                    content_type = int(gwf_content.attrib["type"])
                    mime_type = gwf_content.attrib["mime_type"]
                    file_name = gwf_content.attrib["file_name"]
                    data = None
                    text = gwf_content.text
                    if text is not None:
                        if content_type == 4:
                            data = base64.b64decode(text.encode('ascii'))
                        elif 1 <= content_type <= 3:
                            data = text
                        else:
                            self.add_error(input_path, "Content type `{}` is not supported".format(content_type))

                    content = {
                        "type": content_type,
                        "mime": mime_type,
                        "file_name": file_name,
                        "data": data,
                    }

                if not re.match(r"^[0-9a-zA-Z_]*$", el_idtf):
                    self.add_error(input_path,
                                   "Identifier `{}` should match expression `^[0-9a-zA-Z_]*$`".format(el_idtf))
                    return None

                result_el["content"] = content

            elif tag == "pair" or tag == "arc":
                result_el["source"] = el.attrib["id_b"]
                result_el["target"] = el.attrib["id_e"]
            elif tag == "bus":
                pass
            elif tag == "contour":
                pass

            elements[el_id] = result_el

        return elements
