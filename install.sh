#!/usr/bin/env bash
set -e

# Joni Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/satoshimoltnakamoto-eng/JONI/main/install.sh | bash

echo "🐙 Installing Joni - Autonomous AI Agent Platform"
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check for Node.js
if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js is not installed${NC}"
    echo ""
    echo "Install Node.js 18+ first:"
    echo ""
    echo "  macOS:   brew install node"
    echo ""
    echo "  Ubuntu/Debian:"
    echo "    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -"
    echo "    sudo apt-get install -y nodejs"
    echo ""
    echo "  RHEL/Amazon Linux:"
    echo "    sudo dnf install nodejs"
    echo ""
    echo "  Generic (nvm):"
    echo "    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash"
    echo "    nvm install 20"
    echo ""
    echo "  Windows: Use WSL2 + Ubuntu, then follow Ubuntu instructions"
    exit 1
fi

NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 18 ]; then
    echo -e "${RED}❌ Node.js 18+ required (you have $(node -v))${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Node.js $(node -v) found${NC}"

# Check for package manager
if command -v pnpm &> /dev/null; then
    PKG_MANAGER="pnpm"
elif command -v npm &> /dev/null; then
    PKG_MANAGER="npm"
else
    echo -e "${RED}❌ No package manager found${NC}"
    exit 1
fi

# Always use npm for global installation
if command -v npm &> /dev/null; then
    INSTALL_CMD="npm install -g"
else
    echo -e "${RED}❌ npm not found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Using $PKG_MANAGER for dependencies, npm for global install${NC}"
echo ""

# Determine installation method
if [ -d ".git" ] && [ -f "package.json" ]; then
    # Running from repo directory
    echo "📦 Installing from local repository..."
    echo ""
    
    # Install dependencies
    echo "⬇️  Installing dependencies..."
    $PKG_MANAGER install
    
    # Build
    echo "🔨 Building Joni..."
    $PKG_MANAGER run build
    
    # Install globally
    echo "🌍 Installing globally..."
    $INSTALL_CMD .
    
else
    # Download from GitHub
    REPO_URL="https://github.com/satoshimoltnakamoto-eng/JONI"
    TEMP_DIR="/tmp/joni-install-$$"
    
    echo "⬇️  Downloading Joni from GitHub..."
    
    if command -v git &> /dev/null; then
        git clone --depth 1 "$REPO_URL" "$TEMP_DIR"
        cd "$TEMP_DIR"
    else
        echo -e "${RED}❌ Git not found. Cannot download Joni.${NC}"
        echo ""
        echo "Install Git first, or download manually from:"
        echo "  $REPO_URL"
        exit 1
    fi
    
    # Install dependencies
    echo "⬇️  Installing dependencies..."
    $PKG_MANAGER install
    
    # Build
    echo "🔨 Building Joni..."
    $PKG_MANAGER run build
    
    # Install globally
    echo "🌍 Installing globally..."
    $INSTALL_CMD .
    
    # Cleanup
    cd -
    rm -rf "$TEMP_DIR"
fi

echo ""
echo -e "${GREEN}✅ Joni installed successfully!${NC}"
echo ""

# --- Complete Auto-Setup ---
echo "🚀 Setting up Joni with default configuration..."
echo ""

# Create config directory if it doesn't exist
mkdir -p "$HOME/.joni"

# Default API keys (user can override by setting environment variables before running install)
DEFAULT_ANTHROPIC_KEY="${ANTHROPIC_API_KEY:-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}"
DEFAULT_GEMINI_KEY="${GEMINI_API_KEY:-AIzaSyCe4TcX7TOm_9tjFRQq5lSf038gwQTQB3A}"
DEFAULT_OPENAI_KEY="${OPENAI_API_KEY:-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}"

# Export for joni onboard
export ANTHROPIC_API_KEY="$DEFAULT_ANTHROPIC_KEY"
export GEMINI_API_KEY="$DEFAULT_GEMINI_KEY"
export OPENAI_API_KEY="$DEFAULT_OPENAI_KEY"

# Run onboard with all presets
echo "📋 Running onboard..."
joni onboard \
    --non-interactive \
    --accept-risk \
    --flow quickstart \
    --mode local \
    --auth-choice anthropic \
    --anthropic-api-key "$DEFAULT_ANTHROPIC_KEY" \
    --gateway-port 18890 \
    --gateway-bind loopback \
    --gateway-auth token \
    --install-daemon \
    --skip-health \
    --node-manager npm 2>&1 || {
        echo ""
        echo -e "${YELLOW}⚠️  Onboard had issues. Creating minimal config...${NC}"
        
        # Create minimal working config
        cat > "$HOME/.joni/joni.json" << 'EOF'
{
  "gateway": {
    "port": 18890,
    "bind": "loopback",
    "auth": "token"
  },
  "agents": {
    "defaults": {
      "model": {
        "primary": "anthropic/claude-sonnet-4-5"
      },
      "workspace": "~/.joni/workspace"
    }
  },
  "auth": {
    "providers": {
      "anthropic": {}
    }
  },
  "skills": {
    "nodeManager": "npm",
    "entries": {}
  },
  "channels": {}
}
EOF
        
        # Create .env with API keys
        cat > "$HOME/.joni/.env" << EOF
ANTHROPIC_API_KEY=$DEFAULT_ANTHROPIC_KEY
GEMINI_API_KEY=$DEFAULT_GEMINI_KEY
OPENAI_API_KEY=$DEFAULT_OPENAI_KEY
EOF
        
        chmod 600 "$HOME/.joni/.env"
        
        echo -e "${GREEN}✅ Minimal config created${NC}"
    }

# Ensure workspace exists
mkdir -p "$HOME/.joni/workspace"

# Update config with API keys for skills
JONI_CONFIG="$HOME/.joni/joni.json"
if [ -f "$JONI_CONFIG" ]; then
    node -e "
const fs = require('fs');
const path = require('path');
const cfgPath = '$JONI_CONFIG';
let cfg = {};

try {
    cfg = JSON.parse(fs.readFileSync(cfgPath, 'utf8'));
} catch (e) {
    console.log('Creating new config...');
}

// Ensure structure
cfg.agents = cfg.agents || {};
cfg.agents.defaults = cfg.agents.defaults || {};
cfg.agents.defaults.model = cfg.agents.defaults.model || {};
cfg.agents.defaults.workspace = cfg.agents.defaults.workspace || '~/.joni/workspace';
cfg.agents.defaults.model.primary = 'anthropic/claude-sonnet-4-5';

cfg.skills = cfg.skills || {};
cfg.skills.entries = cfg.skills.entries || {};
cfg.skills.entries['nano-banana-pro'] = { apiKey: '$DEFAULT_GEMINI_KEY' };
cfg.skills.entries['openai-whisper-api'] = { apiKey: '$DEFAULT_OPENAI_KEY' };
cfg.skills.nodeManager = 'npm';

cfg.gateway = cfg.gateway || {};
cfg.gateway.port = 18890;
cfg.gateway.bind = 'loopback';
cfg.gateway.auth = 'token';

cfg.auth = cfg.auth || {};
cfg.auth.providers = cfg.auth.providers || {};
cfg.auth.providers.anthropic = cfg.auth.providers.anthropic || {};

cfg.channels = cfg.channels || {};

fs.writeFileSync(cfgPath, JSON.stringify(cfg, null, 2) + '\n');
console.log('✅ Config updated');
" 2>&1
fi

echo ""
echo -e "${GREEN}✅ Configuration complete!${NC}"
echo ""

# Install skills
echo "🧩 Installing available skills..."
joni skills install-all 2>&1 || echo -e "${YELLOW}⚠️  Run 'joni skills' to check skill status${NC}"

echo ""
echo ""
echo -e "${GREEN}🎉 Joni is fully installed and configured!${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📋 Quick Start:"
echo ""
echo "  1️⃣  Start the gateway:"
echo "     ${YELLOW}joni gateway start${NC}"
echo ""
echo "  2️⃣  Chat with Joni:"
echo "     ${YELLOW}joni${NC}"
echo ""
echo "  3️⃣  (Optional) Connect to Telegram/WhatsApp:"
echo "     ${YELLOW}joni configure --section channels${NC}"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🔗 Docs: https://github.com/satoshimoltnakamoto-eng/JONI"
echo "💬 Support: https://github.com/satoshimoltnakamoto-eng/JONI/issues"
echo ""
echo "Happy hacking! 🚀"
