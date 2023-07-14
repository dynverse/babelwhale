# babelwhale 1.2.0

Resubmission of babelwhale to CRAN, after it was removed for failing to fix the Singularity to Apptainer update on the host system.


* BUG FIX `test_singularity_installation()`: No longer fails when Apptainer is used instead of Singularity.

* MINOR CHANGES `run()`: Use different environment variables when Singularity is actually Apptainer.

* NEW FUNCTIONALITY `run_auto_mount()`: Added helper function for letting `babelwhale` figure out which directories to mount automatically (#26, thanks @joelnitta!).


## Test environments
* local installation, R release
* ubuntu (on github actions), R release
* ubuntu (on github actions), R devel
* win-builder (via devtools), R release
* win-builder (via devtools), R devel
