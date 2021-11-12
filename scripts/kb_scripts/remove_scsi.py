import sys
import os
import re


def main(work_directory):
    list_of_files = list()
    for (dir_path, dir_names, file_names) in os.walk(work_directory):
        list_of_files += [os.path.join(dir_path, file) for file in file_names]
    for file in list_of_files:
        if file.endswith(".scs"):
            is_file_processed = False
            buffer_file_list = []
            with open(file, 'r', encoding='utf-8') as scs_file:
                dir_path = os.path.split(file)[0]
                for scs_file_line in scs_file:
                    scsi_file_paths = re.findall(r"((\w*\s*=\s*)?\[\*\^\"file:\/\/.*\.scsi\"\*];;)", scs_file_line)
                    if len(scsi_file_paths) > 0:
                        for scsi_file_path in scsi_file_paths:
                            edit_line_list = scsi_file_path[0].split('^"file://')
                            tabulation_string = " " * len(edit_line_list[0])

                            buffer_file_list.append(edit_line_list[0] + '\n')
                            scsi_path = edit_line_list[1].split('"*];;')[0]

                            relative_path = ""
                            if scsi_path.rfind('/') >= 0:
                                relative_path = scsi_path[:scsi_path.rfind('/') + 1]

                            with open(os.path.join(dir_path, scsi_path), 'r', encoding='utf-8') as scsi_file:
                                for scsi_file_line in scsi_file:
                                    if scsi_file_line.find(r'"file://') >= 0 and len(relative_path) > 0:
                                        scsi_file_line = scsi_file_line[:scsi_file_line.find('//')+2] + \
                                                     relative_path + scsi_file_line[scsi_file_line.find('//')+2:]
                                    buffer_file_list.append(tabulation_string + scsi_file_line)

                            buffer_file_list.append("\n*];;\n")
                            os.remove(os.path.join(dir_path, scsi_path))
                            is_file_processed = True
                    else:
                        buffer_file_list.append(scs_file_line)
            if is_file_processed:
                with open(file, "w", encoding="utf_8") as scs_file:
                    for scs_file_line in buffer_file_list:
                        scs_file.write(scs_file_line)


if __name__ == '__main__':
    if len(sys.argv) == 3:
        main(sys.argv[1])
    else:
        print("invalid number of arguments, Please specify only the work directory")
