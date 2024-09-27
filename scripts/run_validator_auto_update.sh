#!/bin/bash

VERSION_FILE="version.txt"
PID_FILE="/tmp/check_for_updates.pid"

get_current_version() {
    # Read the version from the version.txt file
    if [[ -f $VERSION_FILE ]]; then
        cat $VERSION_FILE
    else
        echo "0"
    fi
}

check_for_updates() {
    while true; do
        git fetch origin
        git reset --hard origin/main

        new_version=$(get_current_version)

        if [ "$current_version" != "$new_version" ]; then
            echo "Version has changed from $current_version to $new_version. Restarting script."
            pkill -f "python3 subnet/cli.py"
            deactivate
            pm2 restart "$PM2_PROCESS_NAME"
            exit 0
        fi
        sleep 300
    done
}

clean_up() {
    echo "Cleaning up before exiting..."
    if [[ -f $PID_FILE ]]; then
        kill "$(cat $PID_FILE)"
        rm -f $PID_FILE
    fi
    deactivate
    exit 0
}

trap clean_up SIGINT SIGTERM

if [ "$#" -lt 2 ]; then
    echo "Usage: $0 <network_type> <pm2_process_name>"
    exit 1
fi

NETWORK_TYPE=${1:-mainnet}
PM2_PROCESS_NAME=${2:-validator}

python3 -m venv venv_validator
source venv_validator/bin/activate
pip install -r requirements.txt

cp -r env venv_validator/

export PYTHONPATH=$(pwd)
echo "PYTHONPATH is set to $PYTHONPATH"

current_version=$(get_current_version)

# Run check_for_updates in background and save its PID
check_for_updates &
echo $! > $PID_FILE

cd src
python3 subnet/cli.py $NETWORK_TYPE

# Clean up when main process exits
clean_up
