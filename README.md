# Disk Space Checker

A simple bash script that checks server disk space usage and sends the data to a webhook URL. Perfect for monitoring disk usage across multiple servers.

## Features

- Collects disk usage information using `df`
- Excludes Docker overlay filesystems to avoid redundancy
- Sends data in JSON format to a specified webhook URL
- Can be automated using cron
- Includes server name and timestamp in the payload

## Installation

1. Clone the repository:
```bash
git clone https://github.com/cemhurturk/disk-space-checker.git
cd disk-space-checker
```

2. Make the script executable:
```bash
chmod +x check_disk_space.sh
```

## Usage

Run the script with required parameters:

```bash
./check_disk_space.sh -w "YOUR_WEBHOOK_URL" -n "YOUR_SERVER_NAME"
```

Parameters:
- `-w`: Webhook URL (required)
- `-n`: Server name (required)
- `-h`: Display help message

## Sample Output

The script sends JSON data in this format:

```json
{
    "server_name": "production-server-1",
    "hostname": "server-hostname",
    "timestamp": "2025-02-04T12:34:56Z",
    "disk_usage": [
        {
            "mount": "/run",
            "size": "392M",
            "used": "103M",
            "available": "289M",
            "use_percent": "27%"
        },
        {
            "mount": "/",
            "size": "79G",
            "used": "25G",
            "available": "50G",
            "use_percent": "34%"
        }
    ]
}
```

## Setting up Cron Job

To run the script periodically:

1. Open crontab editor:
```bash
crontab -e
```

2. Add a line to run the script (for example, every hour):
```bash
0 * * * * /path/to/disk-space-checker/check_disk_space.sh -w "YOUR_WEBHOOK_URL" -n "YOUR_SERVER_NAME"
```

Common cron schedule examples:
- Every hour: `0 * * * *`
- Every 6 hours: `0 */6 * * *`
- Every day at midnight: `0 0 * * *`
- Every Monday at midnight: `0 0 * * 1`

## Requirements

- Bash
- curl
- df
- grep
- awk
- sed

These tools are typically pre-installed on most Linux distributions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/your-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/your-feature`)
5. Create a new Pull Request

## Support

For support, please open an issue on the [GitHub repository](https://github.com/cemhurturk/disk-space-checker/issues).
