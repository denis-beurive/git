# Quick "do / undo"

| Do                                                       | Undo                                          | Note                                             | Examples                         |
|----------------------------------------------------------|-----------------------------------------------|--------------------------------------------------|----------------------------------|
| `git add <file>`                                         | `git reset <file>`                            | Unstage a single file                            |                                  |
| `git add --all`                                          | `git reset`                                   | Unstage all staged files                         |                                  |
| `git commit`                                             | `git commit --amend`                          | Change message for the last commit only          |                                  |
| `git commit`                                             | `git reset --soft HEAD~1`                     | Undo last commit, but preserve changes           |                                  |
| `git commit`                                             | `git reset --hard HEAD~1`                     | Undo last commit, but **discard changes**!       |                                  |
| multiple `git commit`                                    | `git reset --soft <commit sha>`               | Undo multiple commits, but preserve changes      | [ex](examples/git-reset-soft.md) |
| multiple `git commit`                                    | `git reset --hard <commit sha>`               | Undo multiple commits, but **discard changes**!  | [ex](examples/git-reset-hard.md) |
| `git reset --soft <commit sha>`                          | `git reset 'HEAD@{1}'`                        |                                                  | [ex](examples/git-reset-head.md) |
| `git stash`                                              | `git stash pop`                               |                                                  |                                  |
| `git merge`                                              | `git merge --abort`                           | If you cannot merge...                           |                                  |
| You modify a file... but you want to discard all changes | `git restore -s origin/<branch> -- <file>`    | Get the file from a remote branch                |                                  |
