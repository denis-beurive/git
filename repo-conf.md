# Repository Configuration

## Configuring a local repository

```shell
$ git remote add origin git@personal.github.com:your-login-1/your-repository.git
$ git config user.email "your-login-1@domain.com"
```

or:

```shell
$ git remote add origin git@profesional.github.com:your-login-2/your-repository.git
$ git config user.email "your-login-2@domain.com"
```

To see the configuration:

```shell
$ git config --list
$ git config --get-all user.email
$ git config --get-all remote.origin.url
```

Il you need to unset/remove a configuration paramter:

```shell
$ git config --unset user.email your-login-1@domain.com
$ git remote rm origin
```

If you need to change the origin URL:

```shell
$ git remote set-url origin git@personal.github.com:your-login-1/your-repository.git
```

> This command may be useful depending on your GitHub account settings.

Print the remote related configuration:

```shell
git remote -v
```


