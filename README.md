# 🐙 Joni — Autonomous AI Agent Platform

**Deploy AI Agents with Crypto-Powered Infrastructure**

---

## What is Joni?

**Joni** is an autonomous AI agent deployment platform that enables agents to create and manage their own infrastructure using cryptocurrency payments.

Unlike traditional deployment platforms, Joni agents can:

- 💰 **Create crypto wallets** — Generate and manage Ethereum wallets
- 🌐 **Purchase domains** — Buy domains autonomously via Njalla (crypto-friendly registrar)
- ☁️ **Setup hosting** — Configure Cloudflare DNS and Pages hosting
- 🚀 **Deploy websites** — Autonomous deployment of static sites and web apps
- 🔐 **Manage credentials** — Secure storage of all keys, tokens, and credentials

## Key Features

### 🎯 Agent Presets

Create specialized agents with pre-configured capabilities:

- **DevOps Agent** — Infrastructure management and deployment
- **Developer Agent** — Code deployment and hosting
- **Content Agent** — Website creation and publishing

### 🔑 Crypto-Native

- Full Ethereum wallet support
- Automated domain purchases with ETH/BTC/XMR
- No credit cards or traditional payment methods required
- Complete autonomy from traditional financial infrastructure

### 🌍 Web-Based Onboarding

Simple, browser-based agent creation:

- No terminal required for basic setup
- Visual workflow builder
- Agent preset selection
- Guided deployment process

## Installation

### One-Liner Install (Recommended)

```bash
curl -fsSL https://cdn.jsdelivr.net/gh/satoshimoltnakamoto-eng/JONI@main/install.sh | bash
```

### Or via npm

```bash
npm install -g joni
```

Or with pnpm:

```bash
pnpm add -g joni
```

### First Run

```bash
joni onboard
```

This launches the interactive wizard that will guide you through:

1. Setting up the gateway
2. Configuring workspace
3. Installing agent skills
4. Setting up deployment capabilities

## Usage

### Create Deployment Agent

```bash
joni agent create --preset devops
```

This creates an agent with:

- Crypto wallet management
- Domain purchasing capabilities
- Cloudflare integration
- Autonomous deployment skills

### Deploy a Project

Once your agent is configured:

```bash
# Agent autonomously:
# 1. Suggests available domain names
# 2. Purchases domain with crypto
# 3. Configures DNS
# 4. Deploys your site
joni deploy --project my-app
```

Or interact conversationally:

```
You: "Deploy my website with a cool domain name"
Agent: "I'll help you deploy. Let me suggest some available domains..."
```

## Agent Skills

Joni comes with powerful built-in skills:

### Crypto-Deploy Skill

Complete autonomous deployment workflow:

```bash
# Create wallet
joni skill run crypto-deploy wallet:create

# Get domain suggestions
joni skill run crypto-deploy domain:suggest --project my-app

# Purchase domain
joni skill run crypto-deploy domain:purchase --domain example.com

# Deploy site
joni skill run crypto-deploy site:deploy --path ./dist
```

### Smart Domain Suggestions

AI-powered domain name generation:

- Based on project name and keywords
- Checks real-time availability at Njalla
- Shows pricing in USD
- Only suggests domains purchasable with crypto

### Automated Infrastructure

- Cloudflare Pages hosting
- SSL/TLS certificates
- DNS configuration
- CDN distribution

## Architecture

Joni is built on top of a powerful multi-channel AI gateway with:

- **Multi-channel support** — Telegram, WhatsApp, Discord, Slack, Signal, iMessage, etc.
- **Extensible skills** — Plugin-based architecture for new capabilities
- **Local-first** — Runs on your own devices
- **Privacy-focused** — Your data stays with you

## Configuration

### Workspace Structure

```
~/.joni/
├── workspace/          # Agent workspace
│   ├── skills/        # Installed skills
│   ├── credentials/   # Secure credential storage
│   └── memory/        # Agent memory and context
├── config.json        # Main configuration
└── agents/            # Configured agents
```

### Environment Setup

Create `.env` file:

```bash
# Crypto
ETH_RPC_URL=https://mainnet.infura.io/v3/YOUR_KEY

# Optional: Pre-configure API tokens
NJALLA_API_TOKEN=your_token
CLOUDFLARE_API_TOKEN=your_token
```

## Security

⚠️ **Important Security Notes:**

- All private keys are encrypted with password
- Credentials stored with 600 permissions
- Never commit `credentials/` to git
- Backup seed phrases offline (paper wallet)
- Test with small amounts first

See [Security Guide](docs/security.md) for details.

## Roadmap

- [ ] Web-based agent builder (no CLI required)
- [ ] More agent presets (Marketing, Analytics, etc.)
- [ ] Multi-chain support (Solana, Polygon, etc.)
- [ ] Advanced deployment options (Docker, Kubernetes)
- [ ] Agent marketplace
- [ ] DAO governance for platform

## Contributing

Joni is open source! Contributions welcome.

```bash
# Clone the repo
git clone https://github.com/yourusername/joni.git
cd joni

# Install dependencies
npm install

# Build
npm run build

# Run in development
npm run dev
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/yourusername/joni/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/joni/discussions)

## Credits

Built with ❤️ by the Joni community.

Based on powerful AI assistant framework technology.

---

**Start deploying autonomously today!**

```bash
npm install -g joni
joni onboard
```
