# 🪄 binwarden 
> A Bitwarden development automation tool 💫

This is an *experimental* cli for building, maintaining, and working in a Bitwarden development environment. The officially supported operating systems are Mac, Ubuntu, and Arch Linux. That said: everything may work fine on any UNIX OS as long as you are using homebrew, apt, or pacman as a package manager. The build tools themselves should work on any operating system with bash installed, but initial setup of projects is OS specific.

Currently this project only works for Bitwarden employees, but open-source contributor compatibility is planned once the project is stable.

## Features

* ⏱️ Stand up a Bitwarden development environment from scratch in minutes
* 🐙Run entire project dependency groups with a single command
* 👷Extend these scripts to customize your builds, install additional tools, or anything else bash can do.

## Installation

1. To prepare: ensure `$HOME/bin/binwarden` is somewhere in your `$PATH`.
1. To install: from a terminal run the following command to clone and set up the project in `$HOME/bin/binwarden`.
    ```bash
    curl -s https://raw.githubusercontent.com/addisonbeck/binwarden/main/cloners/clone-binwarden \
    --output clone-binwarden.sh && \
    bash clone-binwarden.sh
    ```
1. To use run the following command: `b --help`

## Usage

You can do a lot with this tool. Here are some examples:

### Cloning, Scaffolding, and Building Bitwarden Projects

`b -b web` will take you all the way from a new computer with no dev tools installed to a running local web vault and server. It pulls `bitwarden/server` and `bitwarden/clients` into `$HOME/bitwarden` and gets them ready to be built. This involves downloading software like docker, dotnet, and node (if they are not already installed), first time database setup, any more. You will be prompted to log in to your company Bitwarden account to access secrets used to build the cloud environment locally. When the process is complete you will have a web vault running on port `8080` all ready for development work. When you're done run `b -s all` to stop your containers, server, and web vault.

_NOTE:_ This project defaults to SSH communication with Github. You'll need an SSH key configuring locally and on Github for authentication and commit signing. You can generate a key with `b generate-ssh-key` if you don't already have this set up. Doing this requires the `$GH_TOKEN` environment variable be set with a Github PAT with write access to ssh keys.

### Managing Complex Multi-Project Debugging

After running a start command like `b -b web` you can check in on your running builds with tmux. To check on them you can do the following:

1. From a terminal after starting a build series (like with `b -b web`) run `tmux a`. This attaches you to the tmux session for one of your builds.
1. Type `<Ctrl-b>` followed by `w` to open a list of your active tmux sessions. Select any that you want to view.
1. Type `<Ctrl-b>` followed by `d` to detach from tmux. This will not exit any of the running processes, and the vault will continue to build in the background, you will just be "detached" from the tmux server.
1. Run `tmux kill-server` from a terminal when you're done to completely quit any running tmux sessions, also stopping your builds.

There are more elegant and quick ways to move around then this, but this is a simple way to do it.

Logs for the most recent builds are also written to `$HOME/bitwarden/logs`.

### Generating an SSH Key For Github & Commit Signing

`b generate-ssh-key` sets up an ssh key for managing remotes with Github and signing commits. You don't need to do this if you brought your own key and already have it configured, or prefer to do this manually. You will have to have an SSH key set up in some way to manage the project clones, as they all use SSH and not https. A few things to note:

1. This script requires the `$GH_TOKEN` be set as an environment variable prior to use. $GH_TOKEN should be a valid Github Personal Access Token with rights to manage ssh keys on your account.
1. This script builds an `ed25519-sk` SSH key - which is a hardware backed key. You will need a yubikey plugged in to create the key, and will need that yubikey plugged in to perform git operations. To use another key type please create, configure, and upload your key to Github manually, but understand it will not be as secure.
1. If you've already get a dev environment set up there are still a lot of helper scripts here for building and maintaining Bitwarden projects. For example: `bw-run-web` will start `web`, `api`, and `identity` in dedicated tmux sessions.
