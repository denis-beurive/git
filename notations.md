# Notations

## HEAD

* `HEAD` refers to the current state of the repository. It is a **symbolic pointer**.
* `git checkout A`: `HEAD` is the tip of `A`.
* `git checkout A~2`: `HEAD` is the commit located 2 commits before the tip of `A`. Example:

   **branch `A`**: `...--C1--C2--C3--C4`. `A~2` points to `C2`. Thus, after `git checkout A~2`, `HEAD` is `C2`.





