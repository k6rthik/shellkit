# Docker Testing for shellkit

This directory contains Docker configuration for testing the shellkit project in isolated environments.

## Quick Start

### Build and test with bash:
```bash
cd docker
docker compose run --rm shellkit-bash
```

### Build and test with zsh:
```bash
cd docker
docker compose run --rm shellkit-zsh
```

### Run automated tests:
```bash
# In bash
cd docker
docker compose run --rm --entrypoint bash shellkit-bash -l -c "source ~/shellkit/init.sh && ~/shellkit/tests/test.sh"

# In zsh
cd docker
docker compose run --rm --entrypoint zsh shellkit-zsh -l -c "source ~/shellkit/init.sh && ~/shellkit/tests/test.sh"
```

## What's Included

The Docker container includes:
- **Shells**: bash, zsh
- **Modern tools**: fd, ripgrep, bat, exa, fzf, starship
- **Utilities**: git, vim, curl, wget
- **Test user**: `testuser` with sudo access
- **Sample workspace**: `~/ws/sample-project`

## Testing Features

Once inside the container, you can test:

### Aliases
```bash
ll              # List files
gs              # Git status
..              # Go up directory
ws              # Go to workspace
```

### FZF Commands
```bash
f               # File picker
fcd             # Directory picker
fh              # History search
checkout        # Interactive git branch
```

### Functions
```bash
mkcd test       # Create and cd
showpath        # View PATH
extract file.tar.gz
```

### Git Integration
```bash
fzf_git_files   # Pick git files
fzgd            # Git diff picker (unstaged)
fzgdc           # Git diff picker (staged)
fzga            # Interactive git add
```

## Development Workflow

1. Make changes to shellkit files
2. Rebuild: `cd docker && docker compose build`
3. Test: `docker compose run --rm shellkit-bash`
4. Run tests: `~/shellkit/tests/test.sh`

## Clean Up

```bash
# Remove containers
cd docker && docker compose down

# Remove image
docker rmi shellkit:test

# Full cleanup
cd docker && docker compose down --rmi all --volumes
```

## Notes

- The shellkit directory is mounted read-only to prevent accidental modifications
- SHELLKIT_VERBOSE=1 is set to see loading messages
- Both bash and zsh are configured and ready to test
