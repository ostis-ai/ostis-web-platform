import os
from enum import Enum
from copy_kb import copy_kb
import sys
import shutil


class CopyKbPaths(Enum):
    KB_SCRIPTS = os.path.dirname(os.path.abspath(__file__))
    SCRIPTS = os.path.split(KB_SCRIPTS)[0]
    OSTIS = os.path.split(SCRIPTS)[0]
    REPO_PATH = os.path.join(OSTIS, 'repo.path')


class Scripts(Enum):
    REMOVE_SCSI = os.path.join(CopyKbPaths.KB_SCRIPTS.value, 'remove_scsi.py')
    GWF_TO_SCS = os.path.join(CopyKbPaths.KB_SCRIPTS.value, 'gwf_to_scs.py')


def main(copy_kb_path: str):
    copy_kb_path = os.path.join(CopyKbPaths.OSTIS.value, os.path.split(copy_kb_path)[1])
    if os.path.isdir(copy_kb_path):
        shutil.rmtree(copy_kb_path)
    os.mkdir(copy_kb_path)
    with open(CopyKbPaths.REPO_PATH.value) as repo_path_file:
        with open(os.path.join(copy_kb_path, 'repo.path'), mode='w') as prepared_repo_path:
            for path in repo_path_file:
                if '#' not in path and '\n' != path:
                    path = path.replace('\n', '')
                    copy_kb(
                        os.path.join(CopyKbPaths.OSTIS.value, path),
                        os.path.join(copy_kb_path, path.replace('../', ''))
                    )
                    prepared_repo_path.write(
                        os.path.join(os.path.split(copy_kb_path)[1], path.replace('../', '')) + '\n'
                    )
            prepared_repo_path.write(os.path.join(os.path.split(copy_kb_path)[1], 'converted_gwf_to_scs'))
    for script in Scripts:
        os.system("python3 " + script.value + ' ' + copy_kb_path)


if __name__ == '__main__':
    if len(sys.argv) == 2:
        main(sys.argv[1])
    else:
        main("prepared_kb")
