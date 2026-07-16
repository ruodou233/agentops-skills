#!/bin/bash
# agentops-skills 安装器：逐仓拉取 submodule（单仓失败不中断），symlink 到 Agent skill 目录。
# 用法：./install.sh [install_name ...]   不带参数=全量；--force 覆盖已存在的 symlink（不覆盖真实目录）。
set -u
cd "$(dirname "$0")" || exit 1
FORCE=0; WANT=()
for a in "$@"; do [ "$a" = "--force" ] && FORCE=1 || WANT+=("$a"); done

# name:path:platforms（与 catalog.yml 保持一致；改 catalog 时同步改这里）
ENTRIES=(
  "de-ai-taste:skills/de-ai-taste:claude codex"
  "wisdom-roundtable:skills/wisdom-roundtable:claude codex"
  "domain-explorer:skills/domain-explorer:claude codex"
  "improve-product-plan:skills/improve-product-plan:claude codex"
  "free-token-eggs:skills/free-token-eggs:claude codex"
  "cache-keepalive:skills/claude-cache-keepalive:claude"
  "connect-computers:skills/connect-computers:claude codex"
  "cross-review:skills/cross-review:claude codex"
  "agent-orchestration:skills/agent-orchestration:claude codex"
  "upgrade-audit:skills/upgrade-audit:claude codex"
)
dir_for() { case "$1" in claude) echo "$HOME/.claude/skills";; codex) echo "$HOME/.codex/skills";; esac; }

OK=(); SKIP=(); FAIL=()
for e in "${ENTRIES[@]}"; do
  name="${e%%:*}"; rest="${e#*:}"; path="${rest%%:*}"; plats="${rest#*:}"
  if [ ${#WANT[@]} -gt 0 ]; then
    hit=0; for w in "${WANT[@]}"; do [ "$w" = "$name" ] && hit=1; done
    [ $hit -eq 0 ] && continue
  fi
  echo "== $name"
  if ! git submodule update --init "$path"; then
    echo "   拉取失败，跳过（不影响其他 skill）"; FAIL+=("$name"); continue
  fi
  for p in $plats; do
    d="$(dir_for "$p")"; mkdir -p "$d"; target="$d/$name"
    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ -L "$target" ] && [ $FORCE -eq 1 ]; then rm "$target"
      else echo "   $target 已存在，拒绝覆盖（symlink 可用 --force）"; SKIP+=("$name→$p"); continue; fi
    fi
    ln -s "$(pwd)/$path" "$target" && echo "   已链接 $target"
  done
  OK+=("$name")
done
echo; echo "完成：成功 ${#OK[@]}，已存在跳过 ${#SKIP[@]}，失败 ${#FAIL[@]}"
[ ${#FAIL[@]} -gt 0 ] && { echo "失败项：${FAIL[*]}（可稍后重跑本脚本重试）"; exit 1; }
exit 0
