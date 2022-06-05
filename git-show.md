# git show

## Print details about a specific commit

    git show <commit SHA>

Example:

```shell
$ git log --pretty=format:"%C(green)%h%C(Reset) %s"
8699120 Edit file2 for the first time
faf7388 Create file2. This message has been modified.
50659dc Create file1. This message has been modified.
9fb518b first commit

$ git show faf7388
commit faf7388eec0e94f601a2af506dfea81ca60c31e4
Author: Denis BEURIVE <dbeurive@protonmail.com>
Date:   Thu May 6 11:46:00 2021 +0200

    Create file2. This message has been modified.

diff --git a/file2 b/file2
new file mode 100644
index 0000000..e69de29
```

If you are just interested by the files associated with a commit:

    git show --pretty="" --name-only <commit SHA>
 
If you need to show the last commit:

```shell
git show HEAD
```
