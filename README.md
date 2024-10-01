# 🪄 binwarden 
> A Bitwarden development automation tool 💫

This is an *experimental* cli for building, maintaining, and working in a
Bitwarden development environment. 

Currently this project only works for Bitwarden employees, but open-source
contributor compatibility is planned once the project is stable.

## Features

* ⏱️ Stand up a Bitwarden development environment from scratch in minutes
* 🐙Run entire project dependency groups with a single command
* 👷Extend these scripts to customize your builds, install additional tools,
  or anything else bash can do.

## Installation

`binwarden` can currently be installed easily with nix pointing to `main`.
Traditional releases are planned.

## Usage

You can do a lot with this tool. Here are some examples:

### Cloning, Scaffolding, and Building Bitwarden Projects

`binwarden web -b` will take you all the way from a new computer with no dev
tools installed to a running local web vault and server. It pulls
`bitwarden/server` and `bitwarden/clients` into `$HOME/bitwarden` and gets
them ready to be built. This involves downloading software like docker,
dotnet, and node (if they are not already installed), first time database
setup, and more. You will be prompted to log in to your company Bitwarden
account to access secrets used to build the cloud environment locally. When
the process is complete you will have a web vault running on port `8080` all
ready for development work. When you're done run `b -s all` to stop your
containers, server, and web vault.

> 💡 **NOTE:** This project defaults to SSH communication with Github. You'll
> need an SSH key configuring locally and on Github for authentication and
> commit signing. 

### Managing Complex Multi-Project Debugging

After running a start command like `binwarden web -b` you can check in on
your running builds with tmux. To check on them you can do the following:

1. From a terminal after starting a build series (like with `binwarden web
   -b`) run `tmux a`. This attaches you to the tmux session for one of your
   builds.
1. Type `<Ctrl-b>` followed by `w` to open a list of your active tmux
   sessions. Select any that you want to view.
1. Type `<Ctrl-b>` followed by `d` to detach from tmux. This will not exit
   any of the running processes, and the vault will continue to build in the
   background, you will just be "detached" from the tmux server.
1. Run `tmux kill-server` from a terminal when you're done to completely quit
   any running tmux sessions, also stopping your builds.

There are more elegant and quick ways to move around then this, but this is a
simple way to do it.

Logs for the most recent builds are also written to `$HOME/bitwarden/logs`.
