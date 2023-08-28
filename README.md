# GitHub Activity Digest Script

## Overview

This Bash script automates the process of generating a digest of GitHub activities for your repositories. It fetches recent commits, pull requests, issues, and code comments across all branches of each repository associated with your GitHub account. The digest is saved in a Markdown-formatted file.

## Prerequisites

- Bash
- `curl`
- `jq`
- GitHub Personal Access Token with the necessary permissions

## Usage

1. Clone this repository or download the script.
    ```bash
    git clone https://github.com/your-username/your-repo.git
    ```

2. Navigate to the directory containing the script.
    ```bash
    cd your-repo
    ```

3. Make the script executable.
    ```bash
    chmod +x github_activity.sh
    ```

4. Run the script.
    ```bash
    ./github_activity.sh
    ```

5. Check the generated `GitHub_Activity_Summary.md` file for your GitHub activity summary.

## Configuration

Edit the `github_activity.sh` script to set your GitHub username and Personal Access Token.

```bash
GITHUB_USERNAME="Your_Username"
GITHUB_TOKEN="Your_Token"
```

## Explanation

For a more detailed explanation of how this script works, please refer to [this Medium blog post](https://medium.com/@jayantnehra18/automating-github-activity-digest-with-a-bash-script-e07ac81ee1b2).

## Contributing

If you find any bugs or have suggestions for improvements, feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
