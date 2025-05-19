# Clone a GitHub repo as a worktree base
clone repo branch='main':
    #!/usr/bin/env bash
    set -e
    
    # Parse the owner and repo from the repo slug
    OWNER=$(echo {{repo}} | cut -d'/' -f1)
    REPO=$(echo {{repo}} | cut -d'/' -f2)
    DIR_NAME="${OWNER}-${REPO}"
    ENV_VAR_NAME="PRIMARY_$(echo ${OWNER} | tr '[:lower:]' '[:upper:]')_$(echo ${REPO} | tr '[:lower:]' '[:upper:]')_WORKTREE"
    
    if [ -d "$DIR_NAME" ]; then
      echo "Directory '$DIR_NAME' already exists. Remove it first if you want to clone again."
      exit 1
    fi
    
    # Create directories
    mkdir -p "$DIR_NAME/{{branch}}"
    
    # Clone into the branch subdirectory
    echo "Cloning {{repo}} branch '{{branch}}' into ./$DIR_NAME/{{branch}}..."
    git clone -b {{branch}} git@github.com:{{repo}}.git "$DIR_NAME/{{branch}}"
    
    # Save branch name to .env file
    if [ -f .env ]; then
      if grep -q "^$ENV_VAR_NAME=" .env; then
        sed -i "s/^$ENV_VAR_NAME=.*/$ENV_VAR_NAME={{branch}}/" .env
      else
        echo "$ENV_VAR_NAME={{branch}}" >> .env
      fi
    else
      echo "$ENV_VAR_NAME={{branch}}" > .env
    fi
    
    echo "Branch name saved to .env file as $ENV_VAR_NAME."
    echo "Done. Repository cloned to ./$DIR_NAME/{{branch}}"
    echo "To add worktrees: cd $DIR_NAME/{{branch}} && git worktree add ../<new-branch-dir> <branch-name>"

# Create a new worktree branch in an existing project
branch repo branch_name:
    #!/usr/bin/env bash
    set -e
    
    # Parse the owner and repo from the repo slug
    OWNER=$(echo {{repo}} | cut -d'-' -f1)
    REPO=$(echo {{repo}} | cut -d'-' -f2)
    DIR_NAME="${OWNER}-${REPO}"
    ENV_VAR_NAME="PRIMARY_$(echo ${OWNER} | tr '[:lower:]' '[:upper:]')_$(echo ${REPO} | tr '[:lower:]' '[:upper:]')_WORKTREE"
    
    if [ ! -d "$DIR_NAME" ]; then
      echo "Project directory '$DIR_NAME' doesn't exist. Clone it first with 'just clone {{repo}}'."
      exit 1
    fi
    
    # Read the primary branch name from .env file
    if [ ! -f .env ] || ! grep -q "^$ENV_VAR_NAME=" .env; then
      echo "No primary worktree found in .env file. Clone the project first with 'just clone'."
      exit 1
    fi
    
    PRIMARY_BRANCH=$(grep "^$ENV_VAR_NAME=" .env | cut -d'=' -f2)
    
    if [ ! -d "$DIR_NAME/$PRIMARY_BRANCH" ]; then
      echo "Primary worktree directory '$DIR_NAME/$PRIMARY_BRANCH' not found."
      exit 1
    fi
    
    # Create the new worktree
    echo "Creating worktree branch '{{branch_name}}' from primary branch '$PRIMARY_BRANCH'..."
    cd "$DIR_NAME/$PRIMARY_BRANCH" && git worktree add "../{{branch_name}}" -b "{{branch_name}}"
    
    echo "Done. New worktree branch created at ./$DIR_NAME/{{branch_name}}"

# List available commands
default:
    @just --list