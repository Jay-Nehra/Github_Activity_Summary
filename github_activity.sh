#!/bin/bash

# Set your GitHub username and Personal Access Token
GITHUB_USERNAME="Jay-Nehra"
GITHUB_TOKEN="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"

# Initialize the date one week ago
ONE_WEEK_AGO=$(date -d '7 days ago' +%Y-%m-%dT%H:%M:%SZ)

# Initialize an empty string to store the activity summary
ACTIVITY_SUMMARY="# GitHub Activity Summary\n"

# Initialize repository count
REPO_COUNT=1

# Fetch list of repositories for the user
REPO_LIST=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/user/repos | jq -r '.[].name')

# Loop through each repository to get activities
for repo in $REPO_LIST; do
    # Initialize strings for each activity type
    RECENT_COMMITS=""
    RECENT_COMMENTS=""
    RECENT_PULLS=""
    RECENT_ISSUES=""

    # Fetch list of branches for the repository
    BRANCH_LIST=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/repos/$GITHUB_USERNAME/$repo/branches | jq -r '.[].name')

    for branch in $BRANCH_LIST; do
        # Fetch recent commits for the repository from the last week
        COMMITS_RESPONSE=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN "https://api.github.com/repos/$GITHUB_USERNAME/$repo/commits?since=$ONE_WEEK_AGO&sha=$branch")
        COMMIT_MESSAGES=$(echo "$COMMITS_RESPONSE" | jq -r '.[].commit.message')

        if [ -z "$COMMIT_MESSAGES" ]; then
            RECENT_COMMITS="1. No activity in the last 7 days."
        else
            RECENT_COMMITS=$(echo "$COMMIT_MESSAGES" | nl -s '. ' -w 1)
        fi

        # Fetch open pull requests
        PULLS=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/repos/$GITHUB_USERNAME/$repo/pulls | jq -r '.[].title')
        if [ -z "$PULLS" ]; then
            RECENT_PULLS="1. No activity in the last 7 days."
        else
            RECENT_PULLS=$(echo "$PULLS" | nl -s '. ' -w 1)
        fi

        # Fetch open issues
        ISSUES=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/repos/$GITHUB_USERNAME/$repo/issues | jq -r '.[].title')
        if [ -z "$ISSUES" ]; then
            RECENT_ISSUES="1. No activity in the last 7 days."
        else
            RECENT_ISSUES=$(echo "$ISSUES" | nl -s '. ' -w 1)
        fi

        # Fetch code comments
        COMMENTS=$(curl -s -u $GITHUB_USERNAME:$GITHUB_TOKEN https://api.github.com/repos/$GITHUB_USERNAME/$repo/commits/$branch/comments | jq -r '.[].body')
        if [ -z "$COMMENTS" ]; then
            RECENT_COMMENTS="1. No activity in the last 7 days."
        else
            RECENT_COMMENTS=$(echo "$COMMENTS" | nl -s '. ' -w 1)
        fi

        # Add the activities to the activity summary in the specified format
        ACTIVITY_SUMMARY+="\n\n## $REPO_COUNT. Repository: $repo\n### Branch: $branch\n#### Recent Commits\n$RECENT_COMMITS\n#### Recent Comments\n$RECENT_COMMENTS\n#### Recent Pull Requests\n$RECENT_PULLS\n#### Recent Issues\n$RECENT_ISSUES"
    done

    # Increment repository count
    REPO_COUNT=$((REPO_COUNT + 1))
done

# Print the activity summary or save it to a file
echo -e $ACTIVITY_SUMMARY > GitHub_Activity_Summary.md
