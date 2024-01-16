#!/bin/bash

# Check if the message is provided as a command-line argument
if [ -z "$1" ]; then
  echo "Usage: $0 <message>"
  exit 1
fi

# Set your Google Chat webhook URL
WEBHOOK_URL="https://chat.googleapis.com/v#########################################"

# Get the message from the command-line argument
MESSAGE="$1"

# Create JSON payload for the message
PAYLOAD=$(cat <<EOF
{
  "text": "$MESSAGE"
}
EOF
)

# Make the API request using curl
curl -X POST -H "Content-Type: application/json" -d "$PAYLOAD" "$WEBHOOK_URL"
