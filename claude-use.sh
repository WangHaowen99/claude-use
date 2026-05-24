#!/usr/bin/env bash
# claude-use — Claude Code provider switcher
# Usage: source claude-use.sh   (add to your ~/.bashrc)
#        claude-use <provider>
#        claude-which
#        claude-providers

# Guard: prevent double-sourcing
if [[ "${__CLAUDE_USE_LOADED:-}" = "1" ]]; then
    return 0
fi
__CLAUDE_USE_LOADED=1

# ── Config ──────────────────────────────────────────────────
# Credentials file path (override with CLAUDE_CODE_PROVIDER_ENV)
__claude_code_provider_env="${CLAUDE_CODE_PROVIDER_ENV:-$HOME/.claude-code-providers.env}"

# ── Helpers ─────────────────────────────────────────────────

__claude_code_load_provider_env() {
    if [ -f "$__claude_code_provider_env" ]; then
        . "$__claude_code_provider_env"
    fi
}

__claude_code_optional_export() {
    local name="$1" value="${2-}"
    if [ -n "$value" ]; then
        export "$name=$value"
    else
        unset "$name"
    fi
}

# ── Provider registry ───────────────────────────────────────

claude-providers() {
    printf '%s\n' zhipu deepseek aliyun dashscope aliyun-intl aliyun-coding anthropic
}

__claude_code_apply_provider() {
    local provider="$1"
    local base_url="" auth_token="" api_key="" credential_kind="auth_token"
    local model="" small_fast_model="" haiku_model="" sonnet_model="" opus_model="" subagent_model=""

    case "$provider" in
        zhipu|bigmodel)
            provider="zhipu"
            base_url="${CLAUDE_CODE_ZHIPU_BASE_URL:-}"
            auth_token="${CLAUDE_CODE_ZHIPU_AUTH_TOKEN:-}"
            model="${CLAUDE_CODE_ZHIPU_MODEL:-}"
            ;;
        deepseek)
            provider="deepseek"
            base_url="${CLAUDE_CODE_DEEPSEEK_BASE_URL:-}"
            auth_token="${CLAUDE_CODE_DEEPSEEK_AUTH_TOKEN:-}"
            model="${CLAUDE_CODE_DEEPSEEK_MODEL:-}"
            sonnet_model="${CLAUDE_CODE_DEEPSEEK_DEFAULT_SONNET_MODEL:-}"
            haiku_model="${CLAUDE_CODE_DEEPSEEK_DEFAULT_HAIKU_MODEL:-}"
            ;;
        aliyun|dashscope)
            provider="aliyun"
            base_url="${CLAUDE_CODE_ALIYUN_BASE_URL:-${CLAUDE_CODE_DASHSCOPE_BASE_URL:-}}"
            api_key="${CLAUDE_CODE_ALIYUN_API_KEY:-${CLAUDE_CODE_DASHSCOPE_API_KEY:-}}"
            auth_token="${CLAUDE_CODE_ALIYUN_AUTH_TOKEN:-${CLAUDE_CODE_DASHSCOPE_AUTH_TOKEN:-}}"
            credential_kind="api_key"
            model="${CLAUDE_CODE_ALIYUN_MODEL:-${CLAUDE_CODE_DASHSCOPE_MODEL:-}}"
            small_fast_model="${CLAUDE_CODE_ALIYUN_SMALL_FAST_MODEL:-}"
            haiku_model="${CLAUDE_CODE_ALIYUN_DEFAULT_HAIKU_MODEL:-}"
            sonnet_model="${CLAUDE_CODE_ALIYUN_DEFAULT_SONNET_MODEL:-}"
            opus_model="${CLAUDE_CODE_ALIYUN_DEFAULT_OPUS_MODEL:-}"
            subagent_model="${CLAUDE_CODE_ALIYUN_SUBAGENT_MODEL:-}"
            ;;
        aliyun-intl)
            provider="aliyun-intl"
            base_url="${CLAUDE_CODE_ALIYUN_INTL_BASE_URL:-}"
            api_key="${CLAUDE_CODE_ALIYUN_INTL_API_KEY:-}"
            auth_token="${CLAUDE_CODE_ALIYUN_INTL_AUTH_TOKEN:-}"
            credential_kind="api_key"
            model="${CLAUDE_CODE_ALIYUN_INTL_MODEL:-}"
            ;;
        aliyun-coding)
            provider="aliyun-coding"
            base_url="${CLAUDE_CODE_ALIYUN_CODING_BASE_URL:-}"
            auth_token="${CLAUDE_CODE_ALIYUN_CODING_AUTH_TOKEN:-}"
            model="${CLAUDE_CODE_ALIYUN_CODING_MODEL:-}"
            small_fast_model="${CLAUDE_CODE_ALIYUN_CODING_SMALL_FAST_MODEL:-}"
            haiku_model="${CLAUDE_CODE_ALIYUN_CODING_DEFAULT_HAIKU_MODEL:-}"
            sonnet_model="${CLAUDE_CODE_ALIYUN_CODING_DEFAULT_SONNET_MODEL:-}"
            opus_model="${CLAUDE_CODE_ALIYUN_CODING_DEFAULT_OPUS_MODEL:-}"
            subagent_model="${CLAUDE_CODE_ALIYUN_CODING_SUBAGENT_MODEL:-}"
            ;;
        anthropic|claude)
            provider="anthropic"
            api_key="${CLAUDE_CODE_ANTHROPIC_API_KEY:-}"
            auth_token="${CLAUDE_CODE_ANTHROPIC_AUTH_TOKEN:-}"
            model="${CLAUDE_CODE_ANTHROPIC_MODEL:-}"
            credential_kind="api_key"
            ;;
        *)
            printf 'claude-use: unknown provider: %s\n' "$provider" >&2
            printf 'Available providers:\n' >&2
            claude-providers >&2
            return 2
            ;;
    esac

    if [ "$provider" != "anthropic" ] && [ -z "$api_key" ] && [ -z "$auth_token" ]; then
        printf 'claude-use: credential for %s is missing. Edit %s first.\n' "$provider" "$__claude_code_provider_env" >&2
        return 1
    fi

    export CLAUDE_CODE_PROVIDER="$provider"

    if [ "$provider" = "anthropic" ]; then
        unset ANTHROPIC_BASE_URL
    else
        export ANTHROPIC_BASE_URL="$base_url"
    fi

    if [ "$credential_kind" = "api_key" ] && [ -n "$api_key" ]; then
        export ANTHROPIC_API_KEY="$api_key"
        unset ANTHROPIC_AUTH_TOKEN
    elif [ -n "$auth_token" ]; then
        export ANTHROPIC_AUTH_TOKEN="$auth_token"
        unset ANTHROPIC_API_KEY
    else
        unset ANTHROPIC_API_KEY
        unset ANTHROPIC_AUTH_TOKEN
    fi

    __claude_code_optional_export ANTHROPIC_MODEL "$model"
    __claude_code_optional_export ANTHROPIC_SMALL_FAST_MODEL "$small_fast_model"
    __claude_code_optional_export ANTHROPIC_DEFAULT_HAIKU_MODEL "$haiku_model"
    __claude_code_optional_export ANTHROPIC_DEFAULT_SONNET_MODEL "$sonnet_model"
    __claude_code_optional_export ANTHROPIC_DEFAULT_OPUS_MODEL "$opus_model"
    __claude_code_optional_export CLAUDE_CODE_SUBAGENT_MODEL "$subagent_model"
}

# ── Public commands ─────────────────────────────────────────

claude-which() {
    local credential="missing"
    if [ -n "${ANTHROPIC_AUTH_TOKEN:-}" ]; then
        credential="ANTHROPIC_AUTH_TOKEN=set"
    elif [ -n "${ANTHROPIC_API_KEY:-}" ]; then
        credential="ANTHROPIC_API_KEY=set"
    fi

    printf 'provider:         %s\n' "${CLAUDE_CODE_PROVIDER:-unknown}"
    printf 'base_url:         %s\n' "${ANTHROPIC_BASE_URL:-<anthropic default>}"
    printf 'model:            %s\n' "${ANTHROPIC_MODEL:-<claude code default>}"
    printf 'small_fast_model: %s\n' "${ANTHROPIC_SMALL_FAST_MODEL:-<unset>}"
    printf 'haiku_default:    %s\n' "${ANTHROPIC_DEFAULT_HAIKU_MODEL:-<unset>}"
    printf 'sonnet_default:   %s\n' "${ANTHROPIC_DEFAULT_SONNET_MODEL:-<unset>}"
    printf 'opus_default:     %s\n' "${ANTHROPIC_DEFAULT_OPUS_MODEL:-<unset>}"
    printf 'subagent_model:   %s\n' "${CLAUDE_CODE_SUBAGENT_MODEL:-<unset>}"
    printf 'credential:       %s\n' "$credential"
}

claude-use() {
    local persist=0 provider="${1-}"

    case "$provider" in
        -p|--persist)
            persist=1
            provider="${2-}"
            ;;
        ''|-h|--help)
            printf 'Usage: claude-use [-p|--persist] <%s>\n' "$(claude-providers | paste -sd '|' -)"
            printf '\nCurrent provider:\n'
            claude-which
            return 0
            ;;
    esac

    __claude_code_load_provider_env
    __claude_code_apply_provider "$provider" || return $?

    if [ "$persist" -eq 1 ]; then
        if grep -q '^CLAUDE_CODE_PROVIDER=' "$__claude_code_provider_env" 2>/dev/null; then
            sed -i "s/^CLAUDE_CODE_PROVIDER=.*/CLAUDE_CODE_PROVIDER='$CLAUDE_CODE_PROVIDER'/" "$__claude_code_provider_env"
        else
            printf "\nCLAUDE_CODE_PROVIDER='%s'\n" "$CLAUDE_CODE_PROVIDER" >> "$__claude_code_provider_env"
        fi
        printf 'Default provider saved to %s\n' "$__claude_code_provider_env"
    fi

    printf 'Claude Code provider switched to %s\n' "$CLAUDE_CODE_PROVIDER"
    claude-which
}

claude-default() {
    claude-use --persist "$1"
}

# ── Auto-load on source ─────────────────────────────────────
__claude_code_load_provider_env
__claude_code_apply_provider "${CLAUDE_CODE_PROVIDER:-zhipu}" >/dev/null 2>&1 || true
