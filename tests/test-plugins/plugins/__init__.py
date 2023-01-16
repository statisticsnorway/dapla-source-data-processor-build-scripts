import pkgutil
import importlib


def _iter_namespace():
    # Look up all files in the current package namespace
    return pkgutil.iter_modules(__path__, __name__ + ".")


def load_plugins():
    # Import all files in the current ('plugins') package namespace
    return [
        importlib.import_module(name)
        for _, name, _ in _iter_namespace()
    ]