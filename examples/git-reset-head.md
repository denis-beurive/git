# git reset 'HEAD@{1}'

    $ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
    3ab107b Add file5
    afa5a28 Add file4
    007ac0d Add file3
    b34a05c Edit file2 for the first time
    174f7f2 Create file2
    c4fb274 Create file1
    9fb518b first commit

Undo the commits `d6b4131`, `aa6f165` and `31cdd7c`.
    
    $ git reset --soft b34a05c
    $ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
    b34a05c Edit file2 for the first time
    174f7f2 Create file2
    c4fb274 Create file1
    9fb518b first commit

Check that the modifications associated with the undone commits are still here.
    
    $ git status --porcelain
    A  file3
    A  file4
    A  file5

Undo `git reset --soft b34a05c`:

	$ git reset 'HEAD@{1}'
	$ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	3ab107b Add file5
	afa5a28 Add file4
	007ac0d Add file3
	b34a05c Edit file2 for the first time
	174f7f2 Create file2
	c4fb274 Create file1
	9fb518b first commit


