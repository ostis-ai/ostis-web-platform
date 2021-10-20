import argparse
import os
import shutil
import sys

from termcolor import colored
from tqdm import tqdm

from support_scripts.gwf_parser import GWFParser
from support_scripts.scs_writer import SCsWriter

class Gwf2SCs:

  def __init__(self):
    self.errors = []

  def collect_files(self, directory):
    result = []

    for root, _, files in os.walk(directory, topdown=False):
      for f in files:
        result.append(os.path.relpath(os.path.join(root, f), directory))
      
    return result

  def run(self, params):
    input = params.kb_path
    output = params.output

    if os.path.isdir(output):
      shutil.rmtree(output)
    os.makedirs(output)

    files = self.collect_files(input)
    print(colored("Collected ", "white") + colored(len(files), "green") + colored(" files"))

    for f in tqdm(files):
      _, ext = os.path.splitext(f)
      if ext.lower() == '.gwf':
        self.convert_file(os.path.join(input, f), os.path.splitext(os.path.join(output, f))[0] + ".scs")

  def convert_file(self, input_path, output_path):
    parser = GWFParser(self.add_error)
    elements = parser.parse(input_path)

    dir_name = os.path.dirname(output_path)
    if not os.path.isdir(dir_name):
      os.makedirs(dir_name)

    if elements is not None:
      writer = SCsWriter(output_path, self.add_error)
      writer.write(elements)

  def add_error(self, file_name, msg):
    self.errors.append((file_name, msg))

  def check_status(self):
    if len(self.errors) > 0:
      print (colored("There are some errors during conversion:", "red"))
      for e in self.errors:
        f, msg = e
        print (colored(f, "green") + ": " + colored(msg, "white"))
      return False
    else:
      return True

if __name__ == "__main__":
  parser = argparse.ArgumentParser(description='Converts directory with GWF files into SCs files')
  parser.add_argument('kb_path', action='store',
                      help='Path to input directory, that contains gwf files')
  parser.add_argument('repo_path', action='store',
                      help='Repo path file')
  args = parser.parse_args()
  args.output =os.path.join(args.kb_path, 'converted_gwf_to_scs')

  with open(args.repo_path, mode='a') as repo_path_file:
    repo_path_file.write(args.output)
  
  converter = Gwf2SCs()
  converter.run(args)
  if converter.check_status():
    sys.exit(0)
  else:
    sys.exit(1)
