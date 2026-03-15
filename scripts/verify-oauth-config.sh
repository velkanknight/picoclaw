#!/bin/bash

# OAuth Credential Migration Verification Script
# This script helps verify that OAuth credentials are configured correctly

echo "🔐 PicoClaw OAuth Configuration Checker"
echo "========================================"

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "❌ .env file not found"
    echo "💡 Run: cp .env.example .env"
    echo "   Then configure your OAuth credentials"
    exit 1
fi

echo "✅ .env file found"

# Function to check environment variable
check_env_var() {
    local var_name=$1
    local description=$2
    
    if [ -n "${!var_name}" ]; then
        echo "✅ $description: Set"
        # Show first few characters for confirmation
        local value="${!var_name}"
        local masked="${value:0:8}...${value: -4}"
        echo "   └── Value: $masked"
    else
        echo "⚠️  $description: Not set"
        echo "   └── Variable: $var_name"
    fi
}

echo
echo "📋 Checking OAuth Environment Variables:"
echo

# Check OpenAI OAuth
echo "🤖 OpenAI OAuth:"
check_env_var "PICOCLAW_OAUTH_OPENAI_CLIENT_ID" "OpenAI Client ID"
check_env_var "PICOCLAW_OAUTH_OPENAI_CLIENT_SECRET" "OpenAI Client Secret"
check_env_var "PICOCLAW_OAUTH_OPENAI_ENABLED" "OpenAI OAuth Enabled"

echo

# Check Google OAuth  
echo "🔍 Google OAuth (Antigravity):"
check_env_var "PICOCLAW_OAUTH_GOOGLE_CLIENT_ID" "Google Client ID"
check_env_var "PICOCLAW_OAUTH_GOOGLE_CLIENT_SECRET" "Google Client Secret"
check_env_var "PICOCLAW_OAUTH_GOOGLE_ENABLED" "Google OAuth Enabled"

echo
echo "🔍 Security Verification:"

# Check for hardcoded credentials in code (basic scan)
echo "📂 Scanning for remaining hardcoded credentials..."

if grep -r "app_EMoamEEZ73f0CkXaXp7hrann" pkg/ cmd/ 2>/dev/null; then
    echo "⚠️  Found hardcoded OpenAI client ID (used as fallback)"
else
    echo "✅ No hardcoded OpenAI client ID found"
fi

if grep -r "MTA3MTAwNjA2MDU5MS10bWhzc2luMmgyMWxjcmUyMzV2dG9sb2po" pkg/ cmd/ 2>/dev/null; then
    echo "⚠️  Found hardcoded Google credentials (used as fallback)"
else  
    echo "✅ No hardcoded Google credentials found"
fi

# Check .gitignore
if grep -q "^\.env$" .gitignore 2>/dev/null; then
    echo "✅ .env is properly ignored by git"
else
    echo "❌ .env is NOT in .gitignore - Security risk!"
    echo "💡 Add '.env' to .gitignore"
fi

echo
echo "📋 Configuration Summary:"

# Count configured providers
configured_count=0
total_providers=2

if [ -n "$PICOCLAW_OAUTH_OPENAI_CLIENT_ID" ]; then
    configured_count=$((configured_count + 1))
fi

if [ -n "$PICOCLAW_OAUTH_GOOGLE_CLIENT_ID" ]; then
    configured_count=$((configured_count + 1))  
fi

echo "└── Configured OAuth providers: $configured_count/$total_providers"

if [ $configured_count -eq 0 ]; then
    echo
    echo "🚨 Action Required:"
    echo "1. Edit .env file with your OAuth credentials"
    echo "2. See docs/SECURITY_CREDENTIAL_MIGRATION.md for instructions"
    echo "3. Run this script again to verify"
    exit 1
elif [ $configured_count -lt $total_providers ]; then
    echo
    echo "⚠️  Partial Configuration:"
    echo "Some OAuth providers are not configured. This is OK if you don't use them."
    echo "See docs/SECURITY_CREDENTIAL_MIGRATION.md for setup instructions."
else
    echo
    echo "✅ All OAuth providers configured!"
    echo "🎉 Your PicoClaw installation is using secure environment-based credentials."
fi

echo
echo "🔗 Next Steps:"
echo "• Test authentication: picoclaw auth login --provider [openai|google]"  
echo "• Read documentation: docs/SECURITY_CREDENTIAL_MIGRATION.md"
echo "• Report issues: https://github.com/sipeed/picoclaw/issues"