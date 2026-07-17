# agentops-skills — AI Agent skill 全家桶

> **这是作者电脑上的实际实现方案。** 所有 skill 都在作者的日常工作流中真实运行；你的 AI（Claude Code、Codex 或其他 Agent）可以根据自身环境和配置对它们做轻度调整——每个 skill 的正文都写明了哪些部分是"作者实现参考"、哪些是通用方法。

本仓库用 git submodule 聚合作者开源的全部 skill。想要全套的，装这一个仓库；只想要某一个的，直接去对应的单独仓库（见下表链接）。

## Skill 清单与关联

| Skill | 用途 | 关联（缺失时的影响） |
|---|---|---|
| [de-ai-taste](https://github.com/ruodou233/de-ai-taste) | 中文去AI味审阅：双层报告 + 质量净收益三档 + 改写幅度档位 | 独立可用 |
| [wisdom-roundtable](https://github.com/ruodou233/wisdom-roundtable) | 11 位思想家并行分析重大决策 | 独立可用 |
| [domain-explorer](https://github.com/ruodou233/domain-explorer) | 速通新领域，产出交互知识地图 | 独立可用；与 wisdom-roundtable / improve-product-plan 互为路由邻居 |
| [improve-product-plan](https://github.com/ruodou233/improve-product-plan) | 把模糊产品想法打磨成可开发的 SPEC.md | 独立可用；同上互为路由邻居 |
| [free-token-eggs](https://github.com/ruodou233/free-token-eggs) | 中国 AI 平台免费额度领取指南 | 独立可用 |
| [claude-cache-keepalive](https://github.com/ruodou233/claude-cache-keepalive) | Claude 侧缓存保温节拍策略 | 独立可用；仅适用 Claude 系环境 |
| [connect-computers](https://github.com/ruodou233/connect-computers) | 多电脑互联：VPN/SSH/远程屏幕/远端 Agent | 独立可用 |
| [cross-review](https://github.com/ruodou233/cross-review) | 跨公司模型独立审查协议 + 参考实现 | 独立可用；与 agent-orchestration 搭配收益更大 |
| [agent-orchestration](https://github.com/ruodou233/agent-orchestration) | 长任务/过夜任务多代理编排方法论 | 独立可用；与 cross-review 搭配收益更大 |
| [upgrade-audit](https://github.com/ruodou233/upgrade-audit) | 每日自主升级审计：知识沉淀进长期文档体系 | 独立可用；产出可喂给 cross-review 审查 |
| [audio-transcribe](https://github.com/ruodou233/audio-transcribe) | 音频转文字全流程：找稿判断 + 按价格/质量分档选型 + 双ASR交叉验证 | 独立可用 |

各 skill 缺少"路由邻居"时的行为：正文中的跨 skill 转介绍语句失效，Agent 应忽略该转介、继续用当前 skill 完成任务（每个 skill 都自包含）。

## 安装

```bash
git clone https://github.com/ruodou233/agentops-skills.git
cd agentops-skills
./install.sh            # 全量安装
./install.sh de-ai-taste wisdom-roundtable   # 只装指定的
```

install.sh 会逐仓拉取（单仓失败不影响其他仓）并把各 skill 链接到 `~/.claude/skills/` 与 `~/.codex/skills/`（已存在同名目录时拒绝并提示，不覆盖）。没有 git 或脚本不适用时，把仓库内容交给你的 AI，它会懂得怎么装。

## 版本

- 本仓库的 tag（`vYYYY.MM.DD`）= 作者本机实测配套的稳定组合，submodule 指针即版本锁定；
- A 类单仓（表中前 7 个）每次发布打日期 tag，独立使用时锁定单仓 tag（更新：`git fetch && git checkout <新tag>`）；复制安装建议记下安装时的 tag/commit 作为基线；
- 更新：A 类 skill 内置更新检查协议（cross-review / agent-orchestration / upgrade-audit 三仓暂沿用旧的 7 天核验，随下次脱敏发布统一）（每次会话首次调用时轻量检查，由你的 AI 根据 diff 总结"改了什么、对你有什么好处"，经你同意才更新；可用 `~/.config/agentops-skills/no-update-check` 关闭）。

## 更新套餐

进入本仓库 clone 执行：

```bash
git fetch --tags origin
git checkout <新套餐tag>          # 例如 v2026.07.16.2
git submodule update --init --recursive
```

套餐安装的更新以本仓库 tag 为准，不要单独 `git pull` 某个子模块（会脱离作者实测的版本组合）。父仓有本地改动时先备份再切换。

## 反馈与作者

各 skill 的问题去对应单仓提 issue/PR；全家桶层面的问题（安装、组合、catalog）提到本仓库。也可以通过小红书「错误乱码」、微信公众号「能工智人错误乱码」、B站「若逗道人」找到作者。

## License

MIT（各 submodule 仓库以其自带 LICENSE 为准）
