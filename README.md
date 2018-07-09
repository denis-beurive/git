# git

## Add all modified files to the staging area

	git status --porcelain | egrep '^ M ' | sed --expression='s/^ M //' | xargs -n1 git add

## Commit all staged files

	git status --porcelain | egrep '^M  ' | sed --expression='s/^M  //' |  xargs -n1 git commit -m "Your message"




