import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

# Relative path to automation/source_data
PATH = Path("../..")
EXCLUDED_PATHS = ['triggers', 'pipelines']


class TestProjectStructure(unittest.TestCase):
    """Test class for project structure."""

    @classmethod
    def setUpClass(cls):
        folders_in_dir = [PATH / Path(f.name) for f in os.scandir(PATH) if f.is_dir()]
        cls.source_folders = [f for f in folders_in_dir if f.name not in EXCLUDED_PATHS]

    def test_source_folder_include_python_script(self):
        """Checks if all source folder contains a .py file."""
        for source_dir in self.source_folders:
            assert len([f for f in os.listdir(source_dir) if '.py' in str(f)]) > 0

    def test_sources_in_tfvars(self):
        """Checks if all source folder names are listed in tfvars."""
        with open(PATH / Path('../../terraform.tfvars'), encoding='utf-8') as tfvars:
            data = tfvars.read()

        # Find all trigger definitions in tfvars
        trigger_definitions = re.findall(r'({[a-zA-Z0-9_=\s,"/]*})', data)
        assert len(trigger_definitions) == len(self.source_folders)

        source_folders_copy = self.source_folders.copy()

        for trigger_definition in trigger_definitions:
            # Extract source_folder name value from trigger_definition
            trigger_name = re.findall(r'name\s*=\s*"([a-z/A-Z0-9_-]*)"', trigger_definition)[0]
            for source_folder in source_folders_copy:
                # source_folder name should match trigger name
                if source_folder.name in trigger_name:
                    source_folders_copy.remove(source_folder)
                    break

        assert len(source_folders_copy) == 0

    def test_source_script_main_accepts_args(self):
        """Checks that every source folder plugin has main function and accepts required number of arguments.

        The function tests whether all plugins can accept arguments by running the pytest command in a temporary
        directory containing the source script and its dependencies, and checking that the command returns a success
        code (0).
        """
        for source_dir in self.source_folders:
            files = os.listdir(source_dir)
            with tempfile.TemporaryDirectory() as tmp_dir:
                shutil.copytree('test-plugins', tmp_dir / Path('test-plugins/'))
                for file in files:
                    shutil.copy2(source_dir / Path(file), tmp_dir / Path('test-plugins/plugins'))
                path_to_file = tmp_dir + '/' + 'test-plugins/'
                result = subprocess.run(['pytest'], cwd=path_to_file, check=True)
