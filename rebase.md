# Git rebase

## Préparation

Create an empty GIT repository:

	$ git init

Create a branche maned (by default) `master`:

	$ git commit --allow-empty -m "initial commit"
	[master (commit racine) 0fb48d6] initial commit

	$ git branch
	* master

> Please note:
>
> Git represents branches as pointers to the latest commit in that branch. If you haven't created a commit yet, there's nothing for that branch to point to. So you can't really create branches until you have at least one commit [source](https://stackoverflow.com/questions/5678699/creating-branches-on-an-empty-project-in-git/5678812).

On branch `master`, start working on a file `bin/calculator.py`:

	from typing import List

	def init_matix() -> List[List[int]]:
		res: List[List[int]] = []
		for n_line in range(5):
			line: List[int] = []
			for n_column in range(10):
				line.append(n_line + n_column)
			res.append(line)
		return res

	def calc(matrix: List[List[int]], nb_lines: int, nb_columns: int) -> int:
		res: int = 0
		for line in range(nb_lines):
			for column in range(nb_columns):
				res += line + column
		return res

	print("Run the calculator")

	matrix = init_matix()
	print("result = {}".format(calc(matrix, 5, 10)))

Add and commit `bin/calculator.py`:

	$ git add bin/calculator.py && git commit -m "First import"
	[master c09c95b] First import
	 1 file changed, 22 insertions(+)
	 create mode 100644 bin/calculator.py

Then, we create another commit (to create a commit history or more than just 1 commit...). To do that we add docstrings to the code, and then we commit.

	$ git add bin/calculator.py && git commit -m "Document init_matrix()"
	[master 6c99621] Document init_matrix()
	 1 file changed, 5 insertions(+)

	$ git add bin/calculator.py && git commit -m "Document calc()"
	[master 8bc7df3] Document calc()
	 1 file changed, 9 insertions(+), 1 deletion(-)

The resulting Python file is:

	from typing import List

	def init_matix() -> List[List[int]]:
		"""
		Initialize the matrix.

		:return: the matrix.
		"""
		res: List[List[int]] = []
		for n_line in range(5):
			line: List[int] = []
			for n_column in range(10):
				line.append(n_line + n_column)
			res.append(line)
		return res

	def calc(matrix: List[List[int]], nb_lines: int, nb_columns: int) -> int:
		"""
		Process a matrix.

		:param matrix: the matrix to calculate.
		:param nb_lines: the number of lines of the matrix.
		:param nb_columns: the number of columns of the matrix.
		:return: the result.
		"""
		res: int = 0
		for line in range(nb_lines):
			for column in range(nb_columns):
				res += line + column
		return res

	print("Run the calculator")

	matrix = init_matix()
	print("result = {}".format(calc(matrix, 5, 10)))

OK, we have a pretty decent history on branch `master`:

	$ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

Now, let's create a new branch called `feature`:

	$ git checkout -b feature
	Basculement sur la nouvelle branche 'feature'
	denis@labo:~/Documents/github/git-rebase$ git branch
	* feature
	  master

At this point, the histories of branches `master` and `feature` are identical:

	$ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

We will make sure that these histories diverge.

On the branch master, we continue to add modifications and commit them.

	$ git checkout master
	Basculement sur la branche 'master'
	$ git branch
  	feature
	* master

We add a function `print_result()`:

	$ git add ./bin/calculator.py && git commit -m "Add the function print_result()"
	[master 7b7855a] Add the function print_result()
	 1 file changed, 5 insertions(+), 1 deletion(-)

Then we document it:

	$ git add ./bin/calculator.py && git commit -m "Document print_result()"
	[master 3995d9a] Document print_result()
	 1 file changed, 5 insertions(+)

Now, on `master`, the commit history is:

	$ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	3995d9a Document print_result()
	7b7855a Add the function print_result()
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

Let's go back to the branch `feature` and make dome modification.

$ git checkout feature
Basculement sur la branche 'feature'

Let's add a function and then document it (so we generate 2 commits...).

	$ git add bin/calculator.py && git commit -m "Add the function print_version()"
	[feature 628589b] Add the function print_version()
	 1 file changed, 3 insertions(+)

	$ git add bin/calculator.py && git commit -m "Document print_version()"
	[feature af1f3df] Document print_version()
	 1 file changed, 3 insertions(+)

On branch `feature`, the commit history is now:

	$ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	af1f3df Document print_version()
	628589b Add the function print_version()
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

Thus, if we compare the commit histories between `master` and `feature`:

| master                                    | feature                                  |
|-------------------------------------------|------------------------------------------|
| _3995d9a Document print_result()_         | _af1f3df Document print_version()_         |
| _7b7855a Add the function print_result()_ | _628589b Add the function print_version()_ |
| --                                        | --                                       |
| 8bc7df3 Document calc()                   | 8bc7df3 Document calc()                  |
| 6c99621 Document init_matrix()            | 6c99621 Document init_matrix()           |
| 9e31a77 First import                      | 9e31a77 First import                     |
| 87d762b initial commit                    | 87d762b initial commit                   |

## Using "rebase"

	rebase <=> re-base 
	       <=> change the base
	       <=> set a new "parent" (inherit from another branch)

### Git rebase

#### First form: git rebase <new parent>

We want to **re-base** the branch `feature`. Another way to say it:
we want to **change the base** of the commit history of `feature`.

	"re-base" == "change the base"

What we plan to do:

* we will change the commit history of the branch `feature`.
* we want to add the history of `master` to the history of `feature`.
  **<=> `master` becomes the new parent of `feature`**.

We want to have the following history (on `feature`):

	af1f3df Document print_version()
	628589b Add the function print_version()
	3995d9a Document print_result()           # <- from master
	7b7855a Add the function print_result()   # <- from master
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

Please note that we create a new branch `rebase` because we want to keep the branch `feature` intact for later experiments...

	$ git checkout -b rebase
	Basculement sur la nouvelle branche 'rebase'

	$ git branch
	  feature
	  master
	* rebase

	$ git rebase master
	...
	impossible d'appliquer 628589b... Add the function print_version()

We resolve the conflict. The we add the fixed file to the stage and we continue the rebase operation.

	$ git add bin/calculator.py 

	$ git rebase --continue
	[HEAD détachée e142988] Add the function print_version()
	 1 file changed, 3 insertions(+)
	Rebasage et mise à jour de refs/heads/rebase avec succès.

And, finally, the desired result is obtained:

	$ git branch
	  feature
	  master
	* rebase

	$ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	9bd55eb Document print_version()
	e142988 Add the function print_version()
	3995d9a Document print_result()
	7b7855a Add the function print_result()
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

#### Second form: git rebase <new parent> <branch>

This form is equivalent to the first one (`git rebase <new parent>`)
if you are on branch `branch`.

	$ git checkout feature
	Basculement sur la branche 'feature'

	$ git checkout -b rebase-bis
	Basculement sur la nouvelle branche 'rebase-bis'

	$ git checkout -b other-branch
	Basculement sur la nouvelle branche 'other-branch'

We are on the branch `other-branch`.

	$ git rebase master rebase-bis
	...
	impossible d'appliquer 628589b... Add the function print_version()git rebase master rebase-bis

There is a conflict. Fix it and continue the rebase:

	$ git add bin/calculator.py 

	$ git rebase --continue
	[HEAD détachée 21944e7] Add the function print_version()
	 1 file changed, 3 insertions(+)
	Rebasage et mise à jour de refs/heads/rebase-bis avec succès.

Now, let's look at the branch `rebase-bis` commit hictory:

	$ git branch && git log  --pretty=format:"%C(green)%h%C(Reset) %s"
	  feature
	  master
	  other-branch
	  rebase
	* rebase-bis
	2656d64 Document print_version()
	21944e7 Add the function print_version()
	3995d9a Document print_result()
	7b7855a Add the function print_result()
	8bc7df3 Document calc()
	6c99621 Document init_matrix()
	9e31a77 First import
	87d762b initial commit

### Git rebase --onto

To do.

