# Security: Credential Migration Guide

## ⚠️ Security Alert: Hardcoded Credentials Deprecated

Starting with this version, PicoClaw is migrating away from hardcoded OAuth credentials to environment variables for enhanced security.

## 🔐 What Changed

### Previously (Insecure)
```go
// ❌ DEPRECATED: Hardcoded credentials in source code
ClientID: "app_EMoamEEZ73f0CkXaXp7hrann"
```

### Now (Secure) 
```bash
# ✅ RECOMMENDED: Environment variables
export PICOCLAW_OAUTH_OPENAI_CLIENT_ID="your_client_id" 
export PICOCLAW_OAUTH_GOOGLE_CLIENT_ID="your_google_client_id"
export PICOCLAW_OAUTH_GOOGLE_CLIENT_SECRET="your_google_client_secret"
```

## 🚀 Migration Steps

### 1. Copy Environment Template
```bash
cp .env.example .env
```

### 2. Configure OAuth Credentials

Edit `.env` file and uncomment/update the OAuth section:

```bash
# ── OAuth Credentials ─────────────────────
# OpenAI OAuth (Codex CLI credentials)
PICOCLAW_OAUTH_OPENAI_CLIENT_ID=your_openai_client_id
PICOCLAW_OAUTH_OPENAI_CLIENT_SECRET=your_openai_client_secret
PICOCLAW_OAUTH_OPENAI_ENABLED=true

# Google OAuth (Antigravity/Cloud Code Assist) 
PICOCLAW_OAUTH_GOOGLE_CLIENT_ID=your_google_client_id
PICOCLAW_OAUTH_GOOGLE_CLIENT_SECRET=your_google_client_secret
PICOCLAW_OAUTH_GOOGLE_ENABLED=true
```

### 3. Obtain Your OAuth Credentials

#### For Google Cloud (Antigravity)
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create or select a project
3. Navigate to "APIs & Services" > "Credentials" 
4. Click "Create Credentials" > "OAuth 2.0 Client ID"
5. Choose "Desktop application"
6. Copy the Client ID and Client Secret

#### For OpenAI 
1. Visit [OpenAI Developer Dashboard](https://platform.openai.com/)
2. Create a new OAuth application
3. Note the Client ID and Client Secret

### 4. Test Configuration
```bash
# Test Google Antigravity authentication
picoclaw auth login --provider antigravity

# Test OpenAI authentication  
picoclaw auth login --provider openai
```

## 🔒 Security Best Practices

### Environment Variables
- ✅ Store credentials in environment variables or `.env` files
- ✅ Add `.env` to `.gitignore` (already configured)
- ✅ Use different credentials for development and production

### Git Security
- ❌ Never commit API keys or secrets to version control
- ✅ Use `.env.example` for sharing structure without credentials
- ✅ Set up pre-commit hooks to scan for secrets

### Production Deployments
- ✅ Use container secrets or environment injection
- ✅ Rotate credentials regularly
- ✅ Monitor for unauthorized access

## 🗓️ Deprecation Timeline

| Version | Status | Action |
|---------|---------|--------|
| **Current** | Hybrid | Environment variables preferred, hardcoded fallback |
| **Next Major** | Migration warning | Deprecation warnings for hardcoded values |
| **Future** | Environment only | Hardcoded values removed |

## ❓ Troubleshooting

### Common Issues

**Issue**: `Error: invalid client_id`
**Solution**: Verify your environment variables are set correctly:
```bash
echo $PICOCLAW_OAUTH_GOOGLE_CLIENT_ID
```

**Issue**: Authentication fails with environment variables
**Solution**: Check if credentials are properly formatted (no extra spaces/quotes)

**Issue**: Still using hardcoded credentials  
**Solution**: Ensure environment variables are exported/loaded before running PicoClaw

### Verification Commands
```bash
# Check if environment variables are loaded
env | grep PICOCLAW_OAUTH

# Test configuration
picoclaw auth status

# Debug authentication flow
picoclaw auth login --provider google --debug
```

## 🔗 Related Documentation

- [OAuth Implementation Details](./ANTIGRAVITY_AUTH.md)
- [Configuration Guide](../config/config.example.json)
- [Security Best Practices](./troubleshooting.md)

---

**Need Help?** 
- Check [troubleshooting guide](./troubleshooting.md)
- Submit an issue on [GitHub](https://github.com/sipeed/picoclaw/issues)
- Join our community discussions