import ast
import os
import re
import shutil
import subprocess
import tempfile
import unittest
from pathlib import Path

import jedi
import yaml


class TestProjectStructure(unittest.TestCase):
    """Test class for project structure."""

    @classmethod
    def setUpClass(cls):
        source_folder = os.environ.get("FOLDER_NAME")
        env_name = os.environ.get("ENV_NAME")
        cls.source_folder_path = Path(
            f"/workspace/automation/source-data/{env_name}/{source_folder}"
        )

    def test_source_folder_include_python_script(self):
        """Checks if source folder contains a .py file."""
        assert (
            len([f for f in os.listdir(self.source_folder_path) if ".py" in str(f)]) > 0
        )

    def test_yaml_config_in_source_folder(self):
        """Check that source folder has a config.yaml file defining triggers."""
        yaml_files = [
            f for f in os.listdir(self.source_folder_path) if "config.yaml" in str(f)
        ]
        # Check that config.yaml is in source directory
        assert len(yaml_files) == 1
        with open(self.source_folder_path / Path(yaml_files[0]), "r") as f:
            data = yaml.safe_load(f)
        # Check that folder_prefix exclusively contains allowed chars
        matches = re.findall(r"^[A-Za-z0-9-_./]*$", data["folder_prefix"])
        assert len(matches) == 1

    def test_source_script_main_accepts_args(self):
        """Checks that a source folder plugin has main function and accepts required number of arguments.

        The function tests whether a plugin can accept arguments by running the pytest command in a temporary
        directory containing the source script and its dependencies, and checking that the command returns a success
        code (0).
        """
        files = os.listdir(self.source_folder_path)
        with tempfile.TemporaryDirectory() as tmp_dir:
            shutil.copytree(
                "/workspace/dapla-source-data-processor-build-scripts/tests/test-plugins/",
                tmp_dir / Path("test-plugins/"),
            )
            for file in files:
                shutil.copy2(
                    self.source_folder_path / Path(file),
                    tmp_dir / Path("test-plugins/plugins"),
                )
            path_to_python_test = tmp_dir / Path("test-plugins/")
            subprocess.run(["pytest"], cwd=path_to_python_test, check=True)

    def test_source_script_does_not_reference_sys_exit(self):
        pyfiles = [f for f in os.listdir(self.source_folder_path) if ".py" in str(f)]
        for file in pyfiles:
            with open(self.source_folder_path / Path(file), "r") as f:
                contents = f.read()
                # Add an import of sys.exit at start to enable reference finding
                script = jedi.Script(f"from sys import exit as _\n{contents}")
                refs = script.get_references(
                    line=1, column=17, include_builtins=False, scope="file"
                )
                # Keep only references that actually reference sys.exit (get_references returns also locally defined exit functions, etc.)
                valid_refs = [ref for ref in refs if ref.goto()[0].module_name == "sys"]
                # If the user has not used sys.exit, our import statement should be the only reference
                assert len(valid_refs) == 1

    def test_source_script_does_not_reference_dapla_toolbelt(self):
      """Since the dapla_toolbelt library has been deprecated ensure no scripts use it."""
            pyfiles = [f for f in os.listdir(self.source_folder_path) if ".py" in str(f)]
            for file in pyfiles:
                with open(self.source_folder_path / Path(file), "r") as f:
                    contents = f.read()

                    # Parse the code into an AST
                    tree = ast.parse(contents)

                    # Check for dapla_toolbelt imports
                    dapla_toolbelt_usage = []
                    module_name = 'dapla_toolbelt'

                    for node in ast.walk(tree):
                        # Check regular imports: import dapla_toolbelt
                        if isinstance(node, ast.Import):
                            for alias in node.names:
                                if alias.name.startswith(module_name):
                                    dapla_toolbelt_usage.append(f"import {alias.name}")
                        # Check from imports: from dapla_toolbelt import ...
                        elif isinstance(node, ast.ImportFrom):
                            if node.module and node.module.startswith(module_name):
                                imports = ', '.join(alias.name for alias in node.names)
                                dapla_toolbelt_usage.append(f"from {node.module} import {imports}")

                    # Assert that no dapla_toolbelt usage was found
                    assert len(dapla_toolbelt_usage) == 0, (
                        f"Found usage of deprecated library dapla_toolbelt: {dapla_toolbelt_usage}"
                    )
