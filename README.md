# ~/bin/binwarden/🚀

This is an *experimental* project aimed at building and maintaining an easy to use installer for a full Bitwarden development environment. The officially support operating systems are the Mac, Ubuntu, and Arch Linux. That said everything may work fine on any UNIX OS as long as you are using homebrew, apt, or pacman as a package manager.

This tool installs the bare minimum software for building and working with Bitwarden repositories, but can be supplemented with additional scripts for installing common but not required tools.

Currently this project only works for Bitwarden employees, but open-source contributor compatibility is planned once the project is stable.

## Features

* ⏱️ Stand up a Bitwarden development environment from scratch in minutes
* 🐙Run entire project dependency groups with a single command
* 👷Extend these scripts to customize your builds, install additional tools, or anything else bash can do.

## Installation

1. To prepare: ensure `$HOME/bin/binwarden` is somewhere in your `$PATH`.
1. Be ready to login in to your Bitwarden company account.
1. To install: from a terminal run the following command to clone and set up the project in `$HOME/bin/binwarden`.
    ```bash
    curl -s https://raw.githubusercontent.com/addisonbeck/binwarden/main/cloners/clone-binwarden \
    --output clone-binwarden.sh && \
    bash clone-binwarden.sh
    ```
1. To use: run some scripts!

## Usage

You can do a lot with these scripts. Here are some general highlights:

### Cloning and Scaffolding Bitwarden Projects

`bw-clone-server` pulls `bitwarden/server` into `$HOME/bitwarden` and gets it ready to be built. This involves downloading software like docker and dotnet (if they are not already installed), first time database setup, etc. You will be prompted to log in to your company Bitwarden account to access secrets used to build the cloud environment locally. 

At this time `bw-clone-clients` (for web only right now) and `bw-clone-directory-connector` are also supported for scaffolding these projects.

### Starting Bitwarden Projects

`bw-start-api` ensures the api server project is cloned, starts the docker containers for cloud, and starts the api. From a fresh boot this one command should start a fully functioning api. `bw-start-identity`, `bw-start-web`, `bw-start-directory-connector`, and varioud `bw-start-docker-{container}` scripts operate the same for those projects and their build dependencies. All of these processes provide logs from the last run in `$HOME/bitwarden/logs` along with the usual output to stdout.

### Managing Complex Multi-Project Debugging

If tmux is installed (`bw-install-tmux` will do this for you) you can run `bw-run-api` to create a tmux session dedicated to running the matching `bw-start` script. Dependencies are automatically managed in that `bw-run-web` will create sessions for `web`, `api`, and `identity` unless they are already running. This can be used to, for example, start a full `web` build locally from a cold machine with one command that will start all the needed containers, api projects, and web with logging and individual tmux sessions. 

If you want to use these scripts but are unfamiliar with tmux: there are plenty of resources online, but a quick way to just see the processes in action would look something like this:

1. From a terminal run `bw-run-web`.
1. Type `<Ctrl-b>` followed by `s` to open a list of your active tmux sessions. Select any that you want.
1. Type `<Ctrl-b>` followed by `d` to detach from tmux. This will not exit any of the running processes, and the vault will continue to build in the background, you will just be "detached" from the tmux server.
1. Run `tmux kill-server` from a terminal when you're done to completely quit any running tmux sessions, thus also stopping your builds.

There are more elegant and quick ways to move around then this, but this is a simple way to do it.

### Generating an SSH Key For Github & Commit Signing

`bw-generate-commit-signing-key` sets up an ssh key for managing remotes with Github and signing commits. You don't need to do this if you brought your own key and already have it configured, or prefer to do this manually. You will have to have an SSH key set up in some way to manage the project clones, as they all use SSH and not https. A few things to note:

1. This script requires the `$GH_TOKEN` be set as an environment variable prior to use. $GH_TOKEN should be a valid Github Personal Access Token with rights to manage ssh keys on your account.
1. This script builds an `ed25519-sk` SSH key - which is a hardware backed key. You will need a yubikey plugged in to create the key, and will need that yubikey plugged in to perform git operations. To use another key type please create, configure, and upload your key to Github manually, but understand it will not be as secure.
1. If you've already get a dev environment set up there are still a lot of helper scripts here for building and maintaining Bitwarden projects. For example: `bw-run-web` will start `web`, `api`, and `identity` in dedicated tmux sessions.
