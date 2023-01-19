from inspect import signature

from plugins import load_plugins


def test_main_accepts_expected_number_of_args():
    """Loads the plugin and checks that it has a main function that accepts the expected number of arguments."""
    plugins = load_plugins()
    for plugin in plugins:
        assert hasattr(plugin, "main")
        assert len(['file_path']) == len(
            signature(plugin.main).parameters.values())
