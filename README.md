# claude-use — Claude Code Provider Switcher

Quickly switch Claude Code between different API providers (DeepSeek, Zhipu, Aliyun, Anthropic, etc.).

## Supported Providers

| Provider | Description |
|----------|-------------|
| `zhipu` | Zhipu BigModel (智谱 GLM) |
| `deepseek` | DeepSeek API |
| `aliyun` / `dashscope` | Aliyun DashScope (阿里云百炼) |
| `aliyun-intl` | Aliyun DashScope International |
| `aliyun-coding` | Aliyun Coding DashScope |
| `anthropic` / `claude` | Official Anthropic API |

## Quick Install

```bash
git clone https://github.com/whw/claude-use.git ~/claude-use
cd ~/claude-use
bash install.sh
```

Or manually:

```bash
# 1. Clone anywhere
git clone https://github.com/whw/claude-use.git ~/claude-use

# 2. Add to ~/.bashrc
echo 'source ~/claude-use/claude-use.sh' >> ~/.bashrc

# 3. Copy and edit credentials
cp ~/claude-use/claude-code-providers.example.env ~/.claude-code-providers.env
# Edit ~/.claude-code-providers.env and fill in your API keys

# 4. Reload
source ~/.bashrc
```

## Usage

```bash
# List available providers
claude-providers

# Switch provider (this session only)
claude-use deepseek

# Switch and save as default
claude-use --persist deepseek
claude-default deepseek    # shortcut

# Show current provider info
claude-which
```

## Environment Variables

Configure each provider in `~/.claude-code-providers.env`:

```bash
# Zhipu
CLAUDE_CODE_ZHIPU_AUTH_TOKEN='your-token'
CLAUDE_CODE_ZHIPU_BASE_URL='https://open.bigmodel.cn/api/anthropic'
CLAUDE_CODE_ZHIPU_MODEL='glm-5.1'

# DeepSeek
CLAUDE_CODE_DEEPSEEK_AUTH_TOKEN='your-key'
CLAUDE_CODE_DEEPSEEK_BASE_URL='https://api.deepseek.com/anthropic'
CLAUDE_CODE_DEEPSEEK_MODEL='deepseek-v4-pro[1m]'

# Aliyun DashScope
CLAUDE_CODE_ALIYUN_API_KEY='your-key'
CLAUDE_CODE_ALIYUN_BASE_URL='https://dashscope.aliyuncs.com/apps/anthropic'
CLAUDE_CODE_ALIYUN_MODEL='qwen3.6-plus'

# Anthropic Official
CLAUDE_CODE_ANTHROPIC_API_KEY='sk-ant-...'
```

## How It Works

Claude Code reads `ANTHROPIC_BASE_URL` and `ANTHROPIC_API_KEY` / `ANTHROPIC_AUTH_TOKEN` from the environment. `claude-use` sets these variables to point Claude Code at different API providers that implement the Anthropic-compatible API.

## License

MIT
