#!/bin/bash

# Function to display usage
usage() {
    echo "Usage: $0 -w WEBHOOK_URL -n SERVER_NAME [-h]"
    echo "  -w    Webhook URL (required)"
    echo "  -n    Server name (required)"
    echo "  -h    Display this help message"
    exit 1
}

# Parse command line options
while getopts "w:n:h" opt; do
    case $opt in
        w) WEBHOOK_URL="$OPTARG" ;;
        n) SERVER_NAME="$OPTARG" ;;
        h) usage ;;
        ?) usage ;;
    esac
done

# Check if required parameters are provided
if [ -z "$WEBHOOK_URL" ] || [ -z "$SERVER_NAME" ]; then
    echo "Error: Both webhook URL and server name are required"
    usage
fi

# Get hostname for reference
HOSTNAME=$(hostname)

# Get current timestamp
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Get disk usage data, excluding Docker overlay filesystems
df_data=$(df -h | grep -v "overlay" | awk 'NR>1 {
    if ($6 != "/dev/shm" && $6 != "/run/lock") {
        printf "{\"mount\":\"%s\",\"size\":\"%s\",\"used\":\"%s\",\"available\":\"%s\",\"use_percent\":\"%s\"},", 
            $6, $2, $3, $4, $5
    }
}' | sed 's/,$//')

# Construct JSON payload
json_payload=$(cat <<EOF
{
    "server_name": "$SERVER_NAME",
    "hostname": "$HOSTNAME",
    "timestamp": "$TIMESTAMP",
    "disk_usage": [${df_data}]
}
EOF
)

# Send data to webhook
curl -X POST \
     -H "Content-Type: application/json" \
     -d "$json_payload" \
     "$WEBHOOK_URL"

# Optional: Log the payload for debugging
# echo "$json_payload" >> /var/log/disk-check.log
