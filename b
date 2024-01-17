#!/usr/bin/env bash

function help () {
  echo "Usage: b [options] <project>"
}

function usage () {
    cat <<__EOF__
🪄 Binwarden - A Bitwarden development automation tool 💫

  usage: b [OPTIONS] COMMAND

  COMMANDS:
      b [OPTIONS] [PROJECT]
        Automate cloning, building, testing, and editing Bitwarden projects.

        OPTIONS
          --build | -b: Start one or more tmux windows to build the project and its dependencies, cloining repos and install tooling if needed.
          --edit  | -e: Open the project in the editor set in your \$SHELL environment variable
          --test  | -t: Start a tmux window running project tests
          --git   | -g: Start a tmux window with lazygit open for the project
          --shell | -s: Start a tmux window with an empty shell in the project root

        EXAMPLE
          Running the command 'b -b -e -t -g -s web' will do everything needed to get Web up and ready for local testing.
          This involves any of the following steps, skipping any that are not needed:
            01. Installing nvm, node, and npm
            02. Cloning 'clients' to '\$HOME/bitwarden/clients'
            03. Generating a local ssl certificate for https connections to the local web vault
            04. Running 'npm ci' in 'clients'
            05. Cloning 'server' to '\$HOME/bitwarden/server'
            06. Installing dotnet, powershell, and docker
            07. Installing the Bitwarden CLI and prompting for a login to access any secrets needed for the server project
            08. Running docker compose to start any necassary containers for the server to run
            09. Running migration scripts on the attached database container
            l0. Starting 'Api' and 'Identity' builds
            11. Starting a 'Web' build
            12. Starting 'Clients' tests
            13. Starting lazygit in the 'Clients' directory
            14. Starting a shell in the 'Clients' directory

      b generate-github-key
        Generate a new SSH key for GitHub authentication and commit signing and uploads it to GitHub. 
        Requires a GitHub Personal Access Token with the "write:public_key" scope.

      b install [PACKAGE]
        Install additional tools that are useful for working on Bitwarden projects.
__EOF__

exit 0
}


function process_command () {
  if [ -z "$PROJECT" ]
  then
    echo "No project specified"
    help
  fi

  if [ $OPEN_EDITOR ] 
  then
    $HOME/bin/binwarden/commands/command-edit "$PROJECT"
  fi

  if [ $RUN_TESTS ]
  then
    $HOME/bin/binwarden/commands/command-test "$PROJECT"
  fi

  if [ $RUN_BUILD ]
  then
    $HOME/bin/binwarden/commands/command-build "$PROJECT"
  fi

  if [ $OPEN_GIT ]
  then
    $HOME/bin/binwarden/commands/command-git "$PROJECT"
  fi

  if [ $OPEN_TERMINAL ]
  then
    $HOME/bin/binwarden/commands/command-terminal "$PROJECT"
  fi
}

while [[ $# -gt 0 ]] 
do
  case $1 in
    -b|--build)
      RUN_BUILD=true
      shift
      ;;
      
    -t|--test)
      RUN_TESTS=true
      shift
      ;;
      
    -e|--edit)
      OPEN_EDITOR=true
      shift
      ;;

    -g|--git)
      OPEN_GIT=true
      shift
      ;;

    -s|--shell)
      OPEN_TERMINAL=true
      shift
      ;;

    -h|--help)
      usage
      ;;
      
    generate-github-key)
      $HOME/bin/binwarden/commands/command-generate-github-key
      exit 0
      ;;

    install)
      $HOME/bin/binwarden/installers/install-${2}
      exit 0
      ;;

    *)
      PROJECT=$1
      shift
      ;;
  esac
done

process_command
