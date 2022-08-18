# babelwhale 1.1.0

* NEW FUNCTIONALITY `run_auto_mount()`: Added helper function for letting `babelwhale` figure out which directories to mount automatically (#26, thanks @joelnitta!).

# babelwhale 1.0.3

* BUG FIX `detect_backend()`: Print helpful message when neither docker or singularity are installed (Thanks @KforKuma).

# babelwhale 1.0.2

* BUG FIX `test_docker_installation()`: Use `docker info` to check whether docker is available.

* BUG FIX: Redirect stdout and stderr to files to avoid processx hangs (#24, thanks @joelnitta!).

* MINOR CHANGE: Change maintainer from Wouter to Robrecht.

* MINOR CHANGE: Added an `environment_variables` to the singularity and docker config.

# babelwhale 1.0.1 (03-10-2019)

* BUG FIX `set_config_default()`: Fixed refactoring error; use `saveRDS` instead of `save`.

# babelwhale 1.0.0 (28-06-2019)

* Release of babelwhale, a package to run docker and singularity containers from R.
