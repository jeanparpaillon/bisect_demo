bisect_demo
===========

Illustrate git bisect command

# Usage

```
$ ./bisect_demo dir N
```

dir: directory where to create git repository
N: number of commits

# Description

A git repository is created and N commits are made into it. Between
commit 0 and N (randomly), an error is introduced (file `test` contains 0 instead
of 1). Then git bisect is used for retrieving the commit introducing the
error.

`test.sh` is used by git bisect to test if the repository is valid or
not, ie if `test` file contains 0 (bad) or 1 (good).
