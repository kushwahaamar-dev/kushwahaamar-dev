#!/bin/bash

# Configuration
USERNAME="kushwahaamar-dev"
REPO_NAME="kushwahaamar-dev"
DIR="$(dirname "$0")"

cd "$DIR"

echo "🚀 Starting Profile Deployment..."

# Check if gh is authenticated
if ! gh auth status &>/dev/null; then
    echo "❌ GitHub CLI is not logged in."
    echo "👉 Please run 'gh auth login' first, then run this script again."
    exit 1
fi

# Initialize git if needed
if [ ! -d ".git" ]; then
    echo "📦 Initializing git repository..."
    git init
    git branch -M main
fi

# Add and commit changes
echo "💾 Committing changes..."
git add README.md
git commit -m "Update profile README" || echo "Nothing to commit"

# Check if repo exists
if gh repo view "$USERNAME/$REPO_NAME" &>/dev/null; then
    echo "✅ Repository $USERNAME/$REPO_NAME already exists."
    # Check if remote exists, if not add it
    if ! git remote | grep -q "origin"; then
        git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
    fi
    echo "⬆️  Pushing changes to GitHub..."
    git push -u origin main
else
    echo "✨ Creating new special profile repository..."
    gh repo create "$REPO_NAME" --public --source=. --remote=origin --push
fi

echo "🎉 Done! Your profile should be live at: https://github.com/$USERNAME"
