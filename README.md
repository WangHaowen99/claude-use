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
git clone https://github.com/WangHaowen99/claude-use.git ~/claude-use
# or from Gitee (faster in China):
# git clone https://gitee.com/wanghaowen2/claude-use.git ~/claude-use
cd ~/claude-use
bash install.sh
```

**After install, edit your credentials file:**

```bash
vim ~/.claude-code-providers.env
# Fill in your API keys for the providers you use.
# Leave unused providers blank.
```

Then reload your shell:

```bash
source ~/.bashrc
claude-which
```

## Prerequisites

- Bash 4.0+
- `paste` (from GNU coreutils, pre-installed on Linux/macOS)
- Claude Code (`claude` command)

Tested on Ubuntu 24.04 LTS.

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

## Troubleshooting

**`claude-use deepseek` shows "credential is missing"**

Edit `~/.claude-code-providers.env` and set your API key:
```bash
CLAUDE_CODE_DEEPSEEK_AUTH_TOKEN='sk-your-actual-key'
```

**`claude-which` shows `provider: unknown`**

Your env file hasn't been sourced yet. Run `source ~/.bashrc` or open a new terminal.

**`claude-use: unknown provider: xxx`**

Run `claude-providers` to see all valid provider names.

**Commands not found after install**

Make sure you've reloaded your shell: `source ~/.bashrc`

**"Auth conflict: Both a token and an API key are set"**

This means your `~/.claude/settings.json` has an `apiKeyHelper` setting that conflicts with `claude-use`. You have two options:

Option A — remove `apiKeyHelper` from settings.json (let claude-use manage auth):
```bash
# Edit ~/.claude/settings.json and remove the "apiKeyHelper" line
```

Option B — don't use claude-use, keep your existing apiKeyHelper setup.

**"env" section in settings.json overrides claude-use**

If your `~/.claude/settings.json` has an `"env"` block with `ANTHROPIC_BASE_URL`, those values take precedence over `claude-use`. Remove the conflicting env entries:
```json
// Remove or comment out these from settings.json:
"env": {
    "ANTHROPIC_BASE_URL": "...",
    "ANTHROPIC_MODEL": "..."
}
```

## Repositories

- GitHub: [WangHaowen99/claude-use](https://github.com/WangHaowen99/claude-use)
- Gitee: [wanghaowen2/claude-use](https://gitee.com/wanghaowen2/claude-use)

## License

MIT
