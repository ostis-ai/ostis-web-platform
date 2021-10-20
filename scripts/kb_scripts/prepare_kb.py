import os
from enum import Enum
from copy_kb import copy_kb
import sys
import shutil


class CopyKbPaths(Enum):
    KB_SCRIPTS = os.path.dirname(os.path.abspath(__file__))
    SCRIPTS = os.path.split(KB_SCRIPTS)[0]
    OSTIS = os.path.split(SCRIPTS)[0]


class Tokens(Enum):
    VERIFY = '#verify'
    NOT_VERIFY = '#not verify'
    COMMENT = '#'
    PREPARED = 'prepared'


scripts = [
    os.path.join(CopyKbPaths.KB_SCRIPTS.value, 'remove_scsi.py'),
    os.path.join(CopyKbPaths.KB_SCRIPTS.value, 'gwf_to_scs.py')
]


def copy_path(src_path: str, dest_path: str, path: str):
    copy_kb(
        os.path.join(src_path, path),
        os.path.join(dest_path, path.replace('../', ''))
    )


def create_path(ext_path: str, int_path: str) -> str:
    return os.path.join(ext_path, os.path.split(int_path)[1])


def main(ostis_path: str, copy_kb_name: str, repo_path_name: str):
    path_to_copy_kb = create_path(ostis_path, copy_kb_name)
    if os.path.isdir(path_to_copy_kb ):
        shutil.rmtree(path_to_copy_kb )
    os.mkdir(path_to_copy_kb )
    path_to_root_repo_path = create_path(ostis_path, repo_path_name)
    path_to_repo_path = create_path(path_to_copy_kb, repo_path_name)
    path_to_prepared_repo_path = create_path(path_to_copy_kb, Tokens.PREPARED.value + repo_path_name)

    is_need_to_verify = True
    with open(path_to_root_repo_path) as root_repo_path_file:
        with open(path_to_repo_path, mode='w') as repo_path_file:
            with open(path_to_prepared_repo_path, mode='w') as prepared_repo_path_file:
                for line in root_repo_path_file:
                    if Tokens.NOT_VERIFY.value in line:
                        is_need_to_verify = False
                    if Tokens.VERIFY.value in line:
                        is_need_to_verify = True
                    if Tokens.COMMENT.value not in line and line != '\n':
                        line = line.replace('\n', '').replace('../', '')
                        if not is_need_to_verify:
                            prepared_repo_path_file.write(line + '\n')
                        elif is_need_to_verify:
                            copy_path(ostis_path, path_to_copy_kb, line)
                            repo_path_file.write(
                                os.path.join(path_to_copy_kb, line) + '\n'
                            )
    for script in scripts:
        os.system('python3 ' + script + ' ' + path_to_copy_kb + ' ' + path_to_repo_path)

    with open(path_to_repo_path) as repo_path_file:
        lines = repo_path_file.readlines()
    with open(path_to_prepared_repo_path) as prepared_repo_path_file:
        with open(path_to_repo_path, mode='w') as repo_path_file:
            for line in prepared_repo_path_file:
                line = line.replace('\n', '')
                copy_path(ostis_path, path_to_copy_kb, line)
                repo_path_file.write(
                    os.path.join(path_to_copy_kb, line) + '\n'
                )
            for line in lines:
                repo_path_file.write(line)
    os.remove(path_to_prepared_repo_path)


if __name__ == '__main__':
    if len(sys.argv) < 2:
        main(CopyKbPaths.OSTIS.value, 'prepared_kb', 'repo.path')
    else:
        main(sys.argv[1], sys.argv[2], sys.argv[3])
