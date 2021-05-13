# git-reset --soft

    $ git log  --pretty=format:"%C(green)%h%C(Reset) %s"
    d6b4131 tests: add messages used for testing.
    aa6f165 host_id: generalize the detection of roles.
    31cdd7c postproc: introduce the role scanner.
    a8e139f postproc: instroduce the service tracker.
    3e0ac36 postproc: add new types.
    8b45e62 host_id: introduce the concept of "role".
    e95e094 host_id: add docstrings and type hints.

    $ git reset --soft 3e0ac36
    3e0ac36 postproc: add new types.
    8b45e62 host_id: introduce the concept of "role".
    e95e094 host_id: add docstrings and type hints.

    $ git status --porcelain
    M  postproc/host_id.py
    A  postproc/role_scanner.py
    A  postproc/service_tracker.py
    M  tests/eve.json
