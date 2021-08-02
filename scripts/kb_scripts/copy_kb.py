import os
import shutil


def copy_kb(kb_path: str, copy_path: str) -> None:
    try:
        if os.path.isdir(copy_path):
            shutil.rmtree(copy_path)
        shutil.copytree(kb_path, copy_path)
        for i in os.listdir(copy_path):
            if os.path.isdir(os.path.join(copy_path, i)) and i == 'scripts':
                shutil.rmtree(os.path.join(copy_path, i))
    except (FileNotFoundError, OSError) as er:
        print(er)
