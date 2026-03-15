# OAuth Credential Migration Verification Script for Windows
# This script helps verify that OAuth credentials are configured correctly

Write-Host "🔐 PicoClaw OAuth Configuration Checker" -ForegroundColor Blue
Write-Host "========================================" -ForegroundColor Blue

# Check if .env file exists
if (-not (Test-Path ".env")) {
    Write-Host "❌ .env file not found" -ForegroundColor Red
    Write-Host "💡 Run: Copy-Item .env.example .env" -ForegroundColor Yellow
    Write-Host "   Then configure your OAuth credentials" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ .env file found" -ForegroundColor Green

# Function to check environment variable
function Check-EnvVar {
    param($VarName, $Description)
    
    $value = [Environment]::GetEnvironmentVariable($VarName)
    if ($value) {
        Write-Host "✅ $Description`: Set" -ForegroundColor Green
        # Show first few characters for confirmation
        $masked = $value.Substring(0, [Math]::Min(8, $value.Length)) + "..." + $value.Substring([Math]::Max(0, $value.Length - 4))
        Write-Host "   └── Value: $masked" -ForegroundColor Gray
    } else {
        Write-Host "⚠️  $Description`: Not set" -ForegroundColor Yellow
        Write-Host "   └── Variable: $VarName" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "📋 Checking OAuth Environment Variables:" -ForegroundColor Cyan
Write-Host ""

# Check OpenAI OAuth
Write-Host "🤖 OpenAI OAuth:" -ForegroundColor Blue
Check-EnvVar "PICOCLAW_OAUTH_OPENAI_CLIENT_ID" "OpenAI Client ID"
Check-EnvVar "PICOCLAW_OAUTH_OPENAI_CLIENT_SECRET" "OpenAI Client Secret"
Check-EnvVar "PICOCLAW_OAUTH_OPENAI_ENABLED" "OpenAI OAuth Enabled"

Write-Host ""

# Check Google OAuth  
Write-Host "🔍 Google OAuth (Antigravity):" -ForegroundColor Blue
Check-EnvVar "PICOCLAW_OAUTH_GOOGLE_CLIENT_ID" "Google Client ID"
Check-EnvVar "PICOCLAW_OAUTH_GOOGLE_CLIENT_SECRET" "Google Client Secret"
Check-EnvVar "PICOCLAW_OAUTH_GOOGLE_ENABLED" "Google OAuth Enabled"

Write-Host ""
Write-Host "🔍 Security Verification:" -ForegroundColor Cyan

# Check for hardcoded credentials in code (basic scan)
Write-Host "📂 Scanning for remaining hardcoded credentials..." -ForegroundColor Yellow

$foundHardcoded = $false

if (Get-ChildItem -Path "pkg", "cmd" -Recurse -ErrorAction SilentlyContinue | Select-String "app_EMoamEEZ73f0CkXaXp7hrann" -Quiet) {
    Write-Host "⚠️  Found hardcoded OpenAI client ID (used as fallback)" -ForegroundColor Yellow
    $foundHardcoded = $true
} else {
    Write-Host "✅ No hardcoded OpenAI client ID found" -ForegroundColor Green
}

if (Get-ChildItem -Path "pkg", "cmd" -Recurse -ErrorAction SilentlyContinue | Select-String "MTA3MTAwNjA2MDU5MS10bWhzc2luMmgyMWxjcmUyMzV2dG9sb2po" -Quiet) {
    Write-Host "⚠️  Found hardcoded Google credentials (used as fallback)" -ForegroundColor Yellow
    $foundHardcoded = $true
} else {
    Write-Host "✅ No hardcoded Google credentials found" -ForegroundColor Green
}

# Check .gitignore
if ((Test-Path ".gitignore") -and (Get-Content ".gitignore" | Select-String "^\.env$")) {
    Write-Host "✅ .env is properly ignored by git" -ForegroundColor Green
} else {
    Write-Host "❌ .env is NOT in .gitignore - Security risk!" -ForegroundColor Red
    Write-Host "💡 Add '.env' to .gitignore" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📋 Configuration Summary:" -ForegroundColor Cyan

# Count configured providers
$configuredCount = 0
$totalProviders = 2

if ([Environment]::GetEnvironmentVariable("PICOCLAW_OAUTH_OPENAI_CLIENT_ID")) {
    $configuredCount++
}

if ([Environment]::GetEnvironmentVariable("PICOCLAW_OAUTH_GOOGLE_CLIENT_ID")) {
    $configuredCount++
}

Write-Host "└── Configured OAuth providers: $configuredCount/$totalProviders" -ForegroundColor Gray

if ($configuredCount -eq 0) {
    Write-Host ""
    Write-Host "🚨 Action Required:" -ForegroundColor Red
    Write-Host "1. Edit .env file with your OAuth credentials" -ForegroundColor Yellow
    Write-Host "2. See docs/SECURITY_CREDENTIAL_MIGRATION.md for instructions" -ForegroundColor Yellow
    Write-Host "3. Run this script again to verify" -ForegroundColor Yellow
    exit 1
} elseif ($configuredCount -lt $totalProviders) {
    Write-Host ""
    Write-Host "⚠️  Partial Configuration:" -ForegroundColor Yellow
    Write-Host "Some OAuth providers are not configured. This is OK if you don't use them." -ForegroundColor Gray
    Write-Host "See docs/SECURITY_CREDENTIAL_MIGRATION.md for setup instructions." -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "✅ All OAuth providers configured!" -ForegroundColor Green
    Write-Host "🎉 Your PicoClaw installation is using secure environment-based credentials." -ForegroundColor Green
}

Write-Host ""
Write-Host "🔗 Next Steps:" -ForegroundColor Cyan
Write-Host "• Test authentication: picoclaw auth login --provider [openai|google]" -ForegroundColor Gray
Write-Host "• Read documentation: docs/SECURITY_CREDENTIAL_MIGRATION.md" -ForegroundColor Gray
Write-Host "• Report issues: https://github.com/sipeed/picoclaw/issues" -ForegroundColor Gray