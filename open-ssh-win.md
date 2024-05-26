# Note about OpenSSH and Windows (10/11)

* OpenSSH for Windows: see [this link](http://sshwindows.sourceforge.net/)
* Default installation directory: `"%PROGRAMFILES(X86)%\OpenSSH"`
* Path to the SSH configuration files: `"%HOMEPATH%\.ssh"`

> Useful [link](https://www.thewindowsclub.com/system-user-environment-variables-windows) for Windows environment variables.

# Starting SSH agent

See: [Starting ssh-agent on Windows 10 fails: "unable to start ssh-agent service, error :1058"](https://stackoverflow.com/questions/52113738/starting-ssh-agent-on-windows-10-fails-unable-to-start-ssh-agent-service-erro)

Run PowerShell has administrator.

```
Get-Service -Name ssh-agent | Set-Service -StartupType Manual
```

Then, to start the SSH agent:

```
Start-Service ssh-agent
```

