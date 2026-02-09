#!/usr/bin/env bash
set -e

# Joni Installer
# Usage: curl -fsSL https://joni.ai/install.sh | bash

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
    echo "Install Node.js first:"
    echo "  macOS:   brew install node"
    echo "  Linux:   https://nodejs.org"
    echo "  Windows: https://nodejs.org (use WSL2)"
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
    INSTALL_CMD="pnpm add -g"
elif command -v npm &> /dev/null; then
    PKG_MANAGER="npm"
    INSTALL_CMD="npm install -g"
else
    echo -e "${RED}❌ No package manager found${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Using $PKG_MANAGER${NC}"
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
    REPO_URL="https://github.com/yourusername/joni"
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

# --- Auto-onboard with preset defaults ---
# Skip interactive steps: risk acknowledgment, quickstart config, model/auth provider
# Jump straight to channel configuration

echo "🔧 Running auto-onboard with preset defaults..."
echo ""

# Prompt for Anthropic API key if not set
if [ -z "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Enter your Anthropic API key:${NC}"
    read -s ANTHROPIC_API_KEY_INPUT
    echo ""
    if [ -z "$ANTHROPIC_API_KEY_INPUT" ]; then
        echo -e "${RED}❌ API key required. Run 'joni onboard' manually to configure.${NC}"
        exit 1
    fi
    ANTHROPIC_API_KEY="$ANTHROPIC_API_KEY_INPUT"
fi

# Run non-interactive onboard with preset values, then launch interactive channel config
joni onboard \
    --non-interactive \
    --flow quickstart \
    --mode local \
    --auth-choice anthropic \
    --anthropic-api-key "$ANTHROPIC_API_KEY" \
    --gateway-port 18890 \
    --gateway-bind loopback \
    --gateway-auth token \
    --install-daemon \
    --skip-health

# Set default model in config
JONI_CONFIG="$HOME/.joni/joni.json"
if command -v node &> /dev/null && [ -f "$JONI_CONFIG" ]; then
    node -e "
const fs = require('fs');
const cfg = JSON.parse(fs.readFileSync('$JONI_CONFIG', 'utf8'));
cfg.agents = cfg.agents || {};
cfg.agents.defaults = cfg.agents.defaults || {};
cfg.agents.defaults.model = cfg.agents.defaults.model || {};
cfg.agents.defaults.model.primary = 'anthropic/claude-sonnet-4-5';
fs.writeFileSync('$JONI_CONFIG', JSON.stringify(cfg, null, 2) + '\n');
"
fi

echo ""
echo -e "${GREEN}✅ Base config ready!${NC}"
echo ""
echo "📋 Next step — configure your chat channel:"
echo "     ${YELLOW}joni configure --section channels${NC}"
echo ""
echo "🔗 Documentation: https://github.com/yourusername/joni"
echo "💬 Support: https://github.com/yourusername/joni/issues"
echo ""
echo "Happy deploying! 🚀"
