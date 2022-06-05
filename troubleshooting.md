# Troubleshooting

## Activate the debug output

If you have a problem while performing a GIT command, you can try this commands:

```shell
$ GIT_TRACE=2 git push --verbose -u origin master
```

Or, even better:

```shell
$ GIT_CURL_VERBOSE=1 GIT_TRACE=1 git push -u origin master
```

## Did you get this error ? "error: failed to push some refs to..."

You probably need to commit something.

## Wrong GIT user

If you have more than 1 GitHub account, then you may have trouble with GIT users. If so, the try this solution:

```shell
git init
git config user.name "<the user you want to use>"
git config user.email "<the user's email>"
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin <project GIT URI>
git config --local credential.helper ""
git push -u origin main
```

Please note that the important points are:

* `git config user.name...` and `git config user.email...`
* `git config --local credential.helper ""`


