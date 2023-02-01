import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path
import yaml
import os


class TestProjectStructure(unittest.TestCase):
    """Test class for project structure."""

    @classmethod
    def setUpClass(cls):
        source_folder = os.environ.get('FOLDER_NAME')
        cls.source_folder_path = Path(f"/workspace/automation/source_data/{source_folder}")

    def test_source_folder_include_python_script(self):
        """Checks if source folder contains a .py file."""
        assert len([f for f in os.listdir(self.source_folder_path) if '.py' in str(f)]) > 0

    def test_yaml_config_in_source_folder(self):
        """Check that source folder has a config.yaml file defining triggers."""
        yaml_files = [f for f in os.listdir(self.source_folder_path) if 'config.yaml' in str(f)]
        # Check that config.yaml is in source directory
        assert len(yaml_files) == 1
        with open(self.source_folder_path / Path(yaml_files[0]), 'r') as f:
            data = yaml.safe_load(f)
        # Check that folder_prefix exclusively contains allowed chars
        matches = re.findall(r"^[A-Za-z0-9-_./]+$", data['folder_prefix'])
        assert len(matches) == 1

    def test_source_script_main_accepts_args(self):
        """Checks that a source folder plugin has main function and accepts required number of arguments.

        The function tests whether a plugin can accept arguments by running the pytest command in a temporary
        directory containing the source script and its dependencies, and checking that the command returns a success
        code (0).
        """
        files = os.listdir(self.source_folder_path)
        with tempfile.TemporaryDirectory() as tmp_dir:
            shutil.copytree('/workspace/dapla-source-data-processor-build-scripts/tests/test-plugins/',
                            tmp_dir / Path('test-plugins/'))
            for file in files:
                shutil.copy2(self.source_folder_path / Path(file), tmp_dir / Path('test-plugins/plugins'))
            path_to_python_test = tmp_dir / Path('test-plugins/')
            subprocess.run(['pytest'], cwd=path_to_python_test, check=True)
