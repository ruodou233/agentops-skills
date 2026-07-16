#!/bin/bash
# agentops-skills 安装器：以 catalog.yml 为唯一清单来源，逐仓拉取（单仓失败不中断），symlink 到 Agent skill 目录。
# 用法：./install.sh [install_name ...]   不带参数=全量；--force 覆盖已存在的 symlink（不覆盖真实目录）。
set -u
cd "$(dirname "$0")" || exit 1
FORCE=0; WANT=()
for a in "$@"; do [ "$a" = "--force" ] && FORCE=1 || WANT+=("$a"); done

# 从 catalog.yml 解析 install_name / path / platforms（catalog 为唯一权威清单，本脚本不另存副本）
ENTRIES=()
while IFS= read -r line; do ENTRIES+=("$line"); done < <(python3 - <<'PYEOF'
import re
name=path=None; plats=[]
for raw in open("catalog.yml", encoding="utf-8"):
    line=raw.rstrip()
    if re.match(r"\s*- repo:", line):
        if name and path: print(f"{name}:{path}:{' '.join(plats)}")
        name=path=None; plats=[]
    m=re.match(r"\s*install_name:\s*(\S+)", line)
    if m: name=m.group(1)
    m=re.match(r"\s*path:\s*(\S+)", line)
    if m: path=m.group(1)
    m=re.match(r"\s*platforms:\s*\[(.*)\]", line)
    if m: plats=[p.strip() for p in m.group(1).split(",") if p.strip()]
if name and path: print(f"{name}:{path}:{' '.join(plats)}")
PYEOF
)
[ ${#ENTRIES[@]} -eq 0 ] && { echo "解析 catalog.yml 失败"; exit 1; }

# 未知名称校验
if [ ${#WANT[@]} -gt 0 ]; then
  for w in "${WANT[@]}"; do
    known=0; for e in "${ENTRIES[@]}"; do [ "${e%%:*}" = "$w" ] && known=1; done
    [ $known -eq 0 ] && { echo "未知 skill：$w（可用名称见 catalog.yml 的 install_name）"; exit 1; }
  done
fi

dir_for() { case "$1" in claude) echo "$HOME/.claude/skills";; codex) echo "$HOME/.codex/skills";; esac; }

OK=(); SKIP=(); FAIL=()
for e in "${ENTRIES[@]}"; do
  name="${e%%:*}"; rest="${e#*:}"; path="${rest%%:*}"; plats="${rest#*:}"
  if [ ${#WANT[@]} -gt 0 ]; then
    hit=0; for w in "${WANT[@]}"; do [ "$w" = "$name" ] && hit=1; done
    [ $hit -eq 0 ] && continue
  fi
  echo "== $name"
  if ! git submodule update --init "$path" || [ ! -f "$path/SKILL.md" ]; then
    echo "   拉取失败或缺 SKILL.md，跳过（不影响其他 skill）"; FAIL+=("$name"); continue
  fi
  entry_fail=0
  for p in $plats; do
    d="$(dir_for "$p")"; target="$d/$name"
    mkdir -p "$d" || { echo "   无法创建 $d"; entry_fail=1; continue; }
    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ -L "$target" ] && [ $FORCE -eq 1 ]; then
        rm "$target" || { echo "   无法移除旧链接 $target"; entry_fail=1; continue; }
      else
        echo "   $target 已存在，拒绝覆盖（symlink 可用 --force）"; SKIP+=("$name→$p"); continue
      fi
    fi
    if ln -s "$(pwd)/$path" "$target"; then echo "   已链接 $target"
    else echo "   链接失败 $target"; entry_fail=1; fi
  done
  [ $entry_fail -eq 1 ] && FAIL+=("$name") || OK+=("$name")
done
echo; echo "完成：成功 ${#OK[@]}，已存在跳过 ${#SKIP[@]}，失败 ${#FAIL[@]}"
[ ${#FAIL[@]} -gt 0 ] && { echo "失败项：${FAIL[*]}（处理后可重跑本脚本）"; exit 1; }
exit 0
