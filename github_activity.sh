#!/bin/bash

# Set your GitHub username and personal access token
GITHUB_USERNAME="Jay-Nehra"
ACCESS_TOKEN="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"

# Set the date for which you want to generate the summary
DATE=$(date +'%Y-%m-%d')

# Define a function to fetch GitHub activity using GraphQL API
get_github_activity() {
    local query='
    {
        user(login: "'$GITHUB_USERNAME'") {
            contributionsCollection(from: "'$DATE'", to: "'$DATE'") {
                pullRequestContributionsByRepository {
                    repository {
                        name
                    }
                    contributions(first: 10) {
                        nodes {
                            pullRequest {
                                title
                                url
                            }
                        }
                    }
                }
                issueContributionsByRepository {
                    repository {
                        name
                    }
                    contributions(first: 10) {
                        nodes {
                            issue {
                                title
                                url
                            }
                        }
                    }
                }
                commitContributionsByRepository {
                    repository {
                        name
                    }
                    contributions(first: 10) {
                        nodes {
                            commit {
                                message
                                url
                            }
                        }
                    }
                }
            }
        }
    }
    '

    curl -s -H "Authorization: Bearer $ACCESS_TOKEN" -X POST -d "{'query': '$query'}" https://api.github.com/graphql
}

# Call the function to fetch GitHub activity
activity_response=$(get_github_activity)

# Parse the JSON response to extract relevant information
pull_requests=$(echo "$activity_response" | jq -r '.data.user.contributionsCollection.pullRequestContributionsByRepository')
issues=$(echo "$activity_response" | jq -r '.data.user.contributionsCollection.issueContributionsByRepository')
commits=$(echo "$activity_response" | jq -r '.data.user.contributionsCollection.commitContributionsByRepository')

# Print the summary
echo "GitHub Activity Summary for $DATE"
echo "==================================="

echo "Pull Requests:"
echo "$pull_requests" | jq -r '.[] | "- " + .repository.name + ": " + .contributions.nodes[].pullRequest.title + " (" + .contributions.nodes[].pullRequest.url + ")"'

echo "Issues:"
echo "$issues" | jq -r '.[] | "- " + .repository.name + ": " + .contributions.nodes[].issue.title + " (" + .contributions.nodes[].issue.url + ")"'

echo "Commits:"
echo "$commits" | jq -r '.[] | "- " + .repository.name + ": " + .contributions.nodes[].commit.message + " (" + .contributions.nodes[].commit.url + ")"'
