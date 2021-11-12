import argparse
import os
import sys
from xml.etree.ElementTree import ParseError

from termcolor import colored

from support_scripts.gwf_parser import GWFParser
from support_scripts.scs_writer import SCsWriter


class Gwf2SCs:

    GWF_FORMAT = '.gwf'
    SCS_FORMAT = '.scs'

    def __init__(self):
        self.errors = []

    @staticmethod
    def collect_files(directory):
        result = []

        for root, _, files in os.walk(directory, topdown=False):
            for f in files:
                result.append(os.path.relpath(os.path.join(root, f), directory))

        return result

    def run(self, params):
        print('Convert GWF to SCs...')
        input = params.input
        files = Gwf2SCs.collect_files(input)

        file_id = 1
        files = [file for file in files if os.path.splitext(file)[1] == Gwf2SCs.GWF_FORMAT]

        for f in files:
            file = os.path.join(input, f)
            file_info = colored(f'[{file_id}/{len(files)}]: {f} - ', color='white')

            elements = {}
            error = Gwf2SCs.parse_gwf(file, elements)
            if error is None:
                errors = self.convert_to_scs(os.path.splitext(file)[0] + Gwf2SCs.SCS_FORMAT, elements)
                if len(errors) == 0:
                    self.print_parse_state(file_info, True)
                else:
                    self.print_parse_state(file_info, False)
                    for error in errors:
                        self.log_error(f, error)
                    return

            else:
                self.print_parse_state(file_info, False)
                self.log_error(f, error)
                return

            file_id += 1

    @staticmethod
    def parse_gwf(input_path, elements):
        try:
            gwf_parser = GWFParser(elements)
            return gwf_parser.parse(input_path)
        except (TypeError, ParseError) as e:
            return e

    @staticmethod
    def convert_to_scs(output_path, elements):
        dir_name = os.path.dirname(output_path)
        if not os.path.isdir(dir_name):
            os.makedirs(dir_name)

        if elements is not None:
            writer = SCsWriter(output_path)
            return writer.write(elements)

        return None

    def print_parse_state(self, file_info, parsed):
        if parsed:
            print(file_info + colored('ok', color='green'))
        else:
            print(file_info + colored('failed', color='red'))

    def log_error(self, file, error):
        self.errors.append((file, error))
        print(colored(f'Error: {error}', color='red'))

    def check_status(self, errors_file_path: str) -> bool:
        if len(self.errors) > 0:
            print(colored('There are errors during conversion. Stop...', 'red'))

            with open(errors_file_path, mode='w+') as errors_file:
                for error in self.errors:
                    file, msg = error
                    errors_file.write(f'{error}: {msg}\n')

            return False
        else:
            print('Conversion finished...')
            return True


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Converts directory with GWF files into SCs files')
    parser.add_argument(
        'input', action='store',
        help='Path to input directory that contains gwf files'
    )
    parser.add_argument(
        'errors_file', action='store',
        help='Path to log file that contains errors')
    args = parser.parse_args()

    converter = Gwf2SCs()
    converter.run(args)
    if converter.check_status(args.errors_file):
        sys.exit(0)
    else:
        sys.exit(1)
