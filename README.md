# agentops-skills — AI Agent skill 全家桶

> **这是作者电脑上的实际实现方案。** 所有 skill 都在作者的日常工作流中真实运行；你的 AI（Claude Code、Codex 或其他 Agent）可以根据自身环境和配置对它们做轻度调整——每个 skill 的正文都写明了哪些部分是"作者实现参考"、哪些是通用方法。

本仓库用 git submodule 聚合作者开源的全部 skill。想要全套的，装这一个仓库；只想要某一个的，直接去对应的单独仓库（见下表链接）。

## 设计原理

- **聚合层只引用、不复制**：本仓不复制任何 skill 正文，只用 git submodule 指向各单仓的具体 commit——同一份内容不在聚合层第二处维护（双写必然漂移），submodule 指针同时充当版本锁。
- **核心流程单仓可用**：每个单仓包含运行核心流程所需的正文与资产，`SKILL.md` 是唯一入口约定（install.sh 也以 SKILL.md 存在与否判定合法 skill）。正文区分"通用方法"与"作者实现参考"，后者描述作者环境、均已标注并给出跳过或替代路径，不是运行前提。
- **规则先讲理由**：正文规则尽量先交代为什么、再给要求，方便你的 AI 在规则没覆盖的场景下正确变通，也方便你按需删改。

## Skill 清单与关联

| Skill | 用途 | 关联（缺失时的影响） |
|---|---|---|
| [de-ai-taste](https://github.com/ruodou233/de-ai-taste) | 中文去AI味审阅：双层报告 + 质量净收益三档 + 改写幅度档位 | 独立可用 |
| [wisdom-roundtable](https://github.com/ruodou233/wisdom-roundtable) | 11 位思想家并行分析重大决策 | 独立可用 |
| [domain-explorer](https://github.com/ruodou233/domain-explorer) | 速通新领域，产出交互知识地图 | 独立可用；与 wisdom-roundtable / improve-product-plan 互为路由邻居 |
| [improve-product-plan](https://github.com/ruodou233/improve-product-plan) | 把模糊产品想法打磨成可开发的 SPEC.md | 独立可用；同上互为路由邻居 |
| [smart-buyer](https://github.com/ruodou233/smart-buyer) | 正反双轨设标，核实 SKU、价格、风险与社区口碑后给出购物推荐 | 独立可用 |
| [free-token-eggs](https://github.com/ruodou233/free-token-eggs) | 中国 AI 平台免费额度领取指南 | 独立可用 |
| [claude-cache-keepalive](https://github.com/ruodou233/claude-cache-keepalive) | Claude 侧缓存保温节拍策略 | 独立可用；仅适用 Claude 系环境 |
| [connect-computers](https://github.com/ruodou233/connect-computers) | 多电脑互联：VPN/SSH/远程屏幕/远端 Agent | 独立可用 |
| [cross-review](https://github.com/ruodou233/cross-review) | 跨公司模型独立审查协议 + 参考实现 | 独立可用；与 agent-orchestration 搭配收益更大 |
| [agent-orchestration](https://github.com/ruodou233/agent-orchestration) | 长任务/过夜任务多代理编排方法论 | 独立可用；与 cross-review 搭配收益更大 |
| [upgrade-audit](https://github.com/ruodou233/upgrade-audit) | 每日自主升级审计：知识沉淀进长期文档体系 | 独立可用；产出可喂给 cross-review 审查 |
| [audio-transcribe](https://github.com/ruodou233/audio-transcribe) | 音频转文字全流程：找稿判断 + 按价格/质量分档选型 + 双ASR交叉验证 | 独立可用 |
| [community-buzz](https://github.com/ruodou233/community-buzz) | 社区口碑挖掘：只保留爱好者社区评论区讨论度高的真实讨论 | 独立可用；与 smart-buyer 搭配做购物决策的社区验证 |
| [codex-reset-watch](https://github.com/ruodou233/codex-reset-watch) | Codex 额度哨兵：结合本机周额度与临时重置信号，给出保守的使用建议 | 独立可用；自动读取需本机 Codex CLI，也支持手动输入 |
| [polymarket-anomaly-watch](https://github.com/ruodou233/polymarket-anomaly-watch) | 每日扫描 Polymarket 异动 + GitHub 热榜 + App Store 中美榜单 | 独立可用；不含通知推送层，需自行接入 |

以下不是常规 skill（没有 SKILL.md，install.sh 不会自动安装），按各自 README 手动接入：

| 项目 | 用途 | 备注 |
|---|---|---|
| [turn-guard](https://github.com/ruodou233/turn-guard) | Claude Code 回合级流程守护 hook（L1确定性提醒+可选L2语义分类器） | 轻量发布，未做教程化包装；L2 默认关闭，作者本机仍是 A/B 实验状态 |

各 skill 缺少"路由邻居"时的行为：正文中的跨 skill 转介绍语句失效，Agent 应忽略该转介、继续用当前 skill 完成任务（每个 skill 都自包含）。

## 安装

```bash
git clone https://github.com/ruodou233/agentops-skills.git
cd agentops-skills
./install.sh            # 全量安装
./install.sh de-ai-taste wisdom-roundtable   # 只装指定的
```

install.sh 会逐仓拉取（单仓失败不影响其他仓）并把各 skill 链接到 `~/.claude/skills/` 与 `~/.codex/skills/`——Claude Code 和 Codex 分别从这两个目录自动发现 skill（已存在同名目录时拒绝并提示，不覆盖）。脚本需要 bash 和 `python3`（解析 catalog.yml）；安装是 symlink 指向本 clone，装完后不要移动或删除本目录，否则链接全部失效。

其他安装路径：
- **没有 git**：聚合仓压缩包里 `skills/` 各子目录是空的（submodule 不随压缩包），不要用它；按上表或 `catalog.yml` 的仓库地址逐个下载单仓压缩包，确认目录内有 `SKILL.md` 后复制进平台 skill 目录。
- **Windows**：原生 Claude/Codex 客户端请把 skill 复制到 Windows 用户目录下的对应 skill 目录；WSL 里跑 install.sh 建的链接只对运行在同一 WSL 内的 Agent 可见。

## 版本

- 本仓库的 tag（`vYYYY.MM.DD`）= 作者本机实测配套的稳定组合，submodule 指针即版本锁定；
- A 类单仓每次发布打日期 tag，独立使用时锁定单仓 tag（更新：`git fetch && git checkout <新tag>`）；复制安装建议记下安装时的 tag/commit 作为基线；
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
