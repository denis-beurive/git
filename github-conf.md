# Configuring SSH for two GitHub users

Let's say that you have two GitHub accounts configured using the following parameters:

Your first GitHub account:

* Your login: `your-login-1`
* Your email address: `your-login-1@domain.com`
* Your private SSH key stored in the file `~/.ssh/ssh_github-1`.

Your second GitHub account:

* Your login: `your-login-2`
* Your email address: `your-login-2@domain.com`
* Your private SSH key stored in the file `~/.ssh/ssh_github-2`.

When accessing GitHub, you want the SSH client (launched behind the scenes by the GIT client) to perform the following actions:

* use the private key that is associated to the public key you downloaded to your GitHub account.
* use your GitHub login.

## Configuration

One way to do that is to associate a couple `(private key, login)` to an alias. This behaviour is configured in the SSH configuration file `~/.ssh`. For example:

    host personal.github.com
         HostName github.com
         User your-login-1
         PreferredAuthentications publickey
         IdentityFile ~/.ssh/ssh_github-1
         IdentitiesOnly yes

    host profesional.github.com
         HostName github.com
         User your-login-2
         PreferredAuthentications publickey
         IdentityFile ~/.ssh/ssh_github-2
         IdentitiesOnly yes


This way, when the SSH client opens a connexion to the host `github.com`, using the alias `personal.github.com`, it uses the login (`your-login-1`) and the SSH key (`~/.ssh/ssh_github-1`).

## Testing

Run the command below:

```shell
$ ssh -T git@personal.github.com
Hi your-login-1! You've successfully authenticated, but GitHub does not provide shell access.
```

```shell
$ ssh -T git@profesional.github.com
Hi your-login-2! You've successfully authenticated, but GitHub does not provide shell access.
```

> If you need to check the repository configuration: `git config -l`

## SSH troubleshouting

Here are some useful commands.

Check the fingerprint of an SSH key:

```shell
$ sh-keygen -l -E sha256 -f $SSH_KEY_FILE
```

> You can make sure that the private SSH you have matches to the public key you uploaded on GitHub.

Load the private keys into the SSH user agent:

    $ ssh-add
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    @         WARNING: UNPROTECTED PRIVATE KEY FILE!          @
    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    Permissions 0644 for '/home/denis/.ssh/id_rsa' are too open.
    It is required that your private key files are NOT accessible by others.
    This private key will be ignored.

> If you get this error message, then you know that the permissions for the directory `.ssh` are not valid. You must have `-rw-------` for all files within the `.ssh` directory. And, for the `.ssh` directory, the permissions must be `drwx------`.

Print the list of loaded private keys:

    $ ssh-add -l
