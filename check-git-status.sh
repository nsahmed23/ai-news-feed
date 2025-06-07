#!/bin/bash
# Quick git status check before pushing

echo "📊 AI Updates Tracker - Git Repository Status"
echo "============================================="
echo ""

# Show all files that will be included
echo "📁 Files to be committed:"
echo ""

# Infrastructure files
echo "🏗️ Infrastructure Files:"
find infrastructure/ -type f -name "*.tf" -o -name "*.md" -o -name "*.py" -o -name "*.sh" 2>/dev/null | head -20
echo ""

# Documentation files
echo "📚 Documentation Files:"
find . -maxdepth 2 -name "*.md" -type f 2>/dev/null
echo ""

# Configuration files
echo "⚙️ Configuration Files:"
ls -la .gitignore .gitattributes 2>/dev/null
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "⚠️ Git not initialized. Run: git init"
else
    echo "✅ Git repository found"
    
    # Check for remote
    if git remote -v | grep -q "origin"; then
        echo "✅ Remote 'origin' configured:"
        git remote -v
    else
        echo "⚠️ No remote configured. You'll need to add your GitHub repository."
    fi
fi

echo ""
echo "📝 Next Steps:"
echo "1. Run: chmod +x git-push.sh"
echo "2. Run: ./git-push.sh"
echo "3. Follow the prompts to add your GitHub repository URL"
echo "4. Push with: git push -u origin main"
echo ""
echo "💡 Remember: Use a Personal Access Token for GitHub authentication"
echo "   Create one at: https://github.com/settings/tokens"
