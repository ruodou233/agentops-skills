# agentops-skills — AI Agent skill 全家桶

> **这是作者电脑上的实际实现方案。** 所有 skill 都在作者的日常工作流中真实运行；你的 AI（Claude Code、Codex 或其他 Agent）可以根据自身环境和配置对它们做轻度调整——每个 skill 的正文都写明了哪些部分是"作者实现参考"、哪些是通用方法。

这套 skill 是我平时拿来干活的：查资料、做选择、写东西、做产品，再把长任务和多台电脑安排起来。原来给一个具体问题写的招数，也可以拿去解决别的同类问题，各仓 README 里都有具体用法。

本仓库用 git submodule 把下表这些 skill 装到一起。想一次装一套的，用这个仓库；只想要某一个的，直接去对应单仓。

## 从你要干的事开始

- **调研和选型**：`domain-explorer` 先把领域摸清，`smart-buyer` 比商品、软件、服务和技术方案，`community-buzz` 看真实体验和争议。
- **把想法做出来**：`improve-product-plan` 把工具、应用和自动化想法整理成能交给 AI 开发的说明，再用 `cross-review` 看看哪里漏了、哪里复杂了。
- **处理资料和写作**：`audio-transcribe` 把会议、访谈、课程、播客转成文字，`de-ai-taste` 帮文章、讲稿和口播去掉机器感。
- **把大活交给 AI**：`agent-orchestration` 分工跑长任务，`connect-computers` 连起设备，`upgrade-audit` 把干活的经验留下来。
- **额度花在值得的地方**：`free-token-eggs` 看看有什么鸡蛋可领，`codex-reset-watch` 看今天能怎么蹬，`cache-keepalive` 算算长会话保温值不值。

## 设计原理

- **聚合层只引用、不复制**：本仓不复制任何 skill 正文，只用 git submodule 指向各单仓的具体 commit——同一份内容不在聚合层第二处维护（双写必然漂移），submodule 指针同时充当版本锁。
- **核心流程单仓可用**：每个单仓包含运行核心流程所需的正文与资产，`SKILL.md` 是唯一入口约定（install.sh 也以 SKILL.md 存在与否判定合法 skill）。正文区分"通用方法"与"作者实现参考"，后者描述作者环境、均已标注并给出跳过或替代路径，不是运行前提。
- **规则先讲理由**：正文规则尽量先交代为什么、再给要求，方便你的 AI 在规则没覆盖的场景下正确变通，也方便你按需删改。

## Skill 清单与关联

| Skill | 用途 | 关联（缺失时的影响） |
|---|---|---|
| [de-ai-taste](https://github.com/ruodou233/de-ai-taste) | AI 写的中文一眼就能看出来？逐条找出 AI 味、给出具体修改建议，让文章、讲稿和文案读起来像你写的。 | 独立可用 |
| [domain-explorer](https://github.com/ruodou233/domain-explorer) | 速通新领域：入门、转行、选课题，先把来龙去脉和各路说法弄明白 | 独立可用；与 improve-product-plan 互为路由邻居 |
| [improve-product-plan](https://github.com/ruodou233/improve-product-plan) | 想做成一个作品？把应用、工具、自动化和游戏想法打磨成能开工的方案 | 独立可用；与 domain-explorer 互为路由邻居 |
| [smart-buyer](https://github.com/ruodou233/smart-buyer) | AI 推荐了一堆，到底该选哪个还是没弄明白？聪明买手帮你把商品、软件、服务和技术方案研究明白再选。 | 独立可用 |
| [free-token-eggs](https://github.com/ruodou233/free-token-eggs) | 免费额度找半天、领一圈，模型还不好用？帮你挑值得领的免费 AI token——太蠢的大模型不收录，吃点好的。 | 独立可用 |
| [claude-cache-keepalive](https://github.com/ruodou233/claude-cache-keepalive) | 缓存保温：实测命中、算清收益，让长会话少花冤枉 token | 独立可用；本套餐当前安装到 Claude，其他链路按单仓说明实测 |
| [connect-computers](https://github.com/ruodou233/connect-computers) | 把电脑连起来：轻薄本调家中工作机，闲置电脑跑任务，出门也能接着干 | 独立可用 |
| [cross-review](https://github.com/ruodou233/cross-review) | AI 的活总差一点，总要你擦屁股，总打丑补丁？让另一家 AI 挑刺复查，自己把活干完整，不用你一直兜底。 | 独立可用；与 agent-orchestration 搭配收益更大 |
| [agent-orchestration](https://github.com/ruodou233/agent-orchestration) | 复杂任务跑到半夜，你不可能一直盯着。让 Agent 分工跑长任务和批量工作，你只管第二天早上收结果。 | 独立可用；与 cross-review 搭配收益更大 |
| [upgrade-audit](https://github.com/ruodou233/upgrade-audit) | 把你教过 AI 的东西留下来：沉淀偏好、复盘踩坑、更新 skill 和工作流程 | 独立可用；产出可喂给 cross-review 审查 |
| [audio-transcribe](https://github.com/ruodou233/audio-transcribe) | 把会议、访谈、课程和播客变成文字稿，需要说话人、时间戳和字幕也能安排 | 独立可用 |
| [community-buzz](https://github.com/ruodou233/community-buzz) | 想听真实口碑？从社区里挖使用体验、竞品痛点和技术争议 | 独立可用；可单独调研口碑，也可补充 smart-buyer 的实践反馈 |
| [codex-reset-watch](https://github.com/ruodou233/codex-reset-watch) | Codex 额度哨兵：看看还能蹬多久，重任务该现在上还是缓一缓 | 独立可用；自动读取需本机 Codex CLI，也支持手动输入 |
| [polymarket-anomaly-watch](https://github.com/ruodou233/polymarket-anomaly-watch) | 每天醒来就有一份科技情报——市场异动、GitHub 热榜、App Store 榜单，AI 替你盯着。 | 独立可用；不含通知推送层，需自行接入 |

以下不是常规 skill（没有 SKILL.md，install.sh 不会自动安装），按各自 README 手动接入：

| 项目 | 用途 | 备注 |
|---|---|---|
| [turn-guard](https://github.com/ruodou233/turn-guard) | Claude Code 老忘流程？把该做的检查变成每回合提醒 | 轻量发布，未做教程化包装；L2 默认关闭，作者本机仍是 A/B 实验状态 |

各 skill 缺少"路由邻居"时的行为：正文中的跨 skill 转介绍语句失效，Agent 应忽略该转介、继续用当前 skill 完成任务（每个 skill 都自包含）。

另有 [craft-frontend-ppt](https://github.com/ruodou233/craft-frontend-ppt) 做网页演讲、作品集与交互文章，[web-access](https://github.com/ruodou233/web-access) 处理网页资料与交互；可到单仓安装。更多项目见 [作者主页](https://github.com/ruodou233)。

## 安装

```bash
git clone https://github.com/ruodou233/agentops-skills.git
cd agentops-skills
./install.sh            # 全量安装
./install.sh de-ai-taste   # 只装指定的
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
