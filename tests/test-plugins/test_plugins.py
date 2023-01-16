from inspect import signature

from plugins import load_plugins


def test_main_accepts_expected_number_of_args():
    """Checks that plugins in a source_folder contains a main function and accepts the expected number of arguments."""
    plugins = load_plugins()
    for plugin in plugins:
        assert hasattr(plugin, "main")
        assert len(['file_path', 'file_name', '_source_bucket', 'destination_bucket']) == len(
            signature(plugin.main).parameters.values())
