# Notations

## HEAD

* `HEAD` refers to the current state of the repository. It is a **symbolic pointer**.
* After `git checkout branch_A`: `HEAD` is the tip of branch `A`.

   > Keep in mind that: `git checkout <commit>`

* `branch_A~2`: is the commit located 2 commits before the tip of `branch_A`. Example:

   **branch `A`**: `...--C1--C2--C3--C4`. `A~2` points to `C2`. Thus, after `git checkout A~2`, `HEAD` is `C2`.





