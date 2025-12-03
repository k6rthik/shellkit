#!/usr/bin/env bash
# WSL-specific initialization
# This file contains WSL startup tasks that should run once per boot

# Only run on WSL
if ! grep -qEi "(Microsoft|WSL)" /proc/version &> /dev/null; then
    return 0
fi

# Run startup tasks only once per WSL session
if [ ! -f /tmp/wsl-start-flag ]; then
    # Start crontab service
    sudo service cron start > /dev/null 2>&1
    
    # Start docker service
    sudo service docker start > /dev/null 2>&1
    
    # Create flag file to prevent re-running
    touch /tmp/wsl-start-flag
fi
