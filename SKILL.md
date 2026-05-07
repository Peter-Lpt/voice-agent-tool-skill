---
name: voice-agent-tool-skill
description: "多风格语音生成：信息搜集 → 风格化处理 → TTS 语音生成。支持 Mimo/OpenAI/edge-tts 后端，5 种文本风格（严肃/幽默/故事/比喻/对话）。"
category: media
triggers:
  - 用户要求将文本/Markdown/搜索内容转为语音
  - 用户指定了语音风格（严肃/幽默/故事/比喻/对话）
  - 用户要求定时生成语音内容
  - 用户提到 voice-agent-tool-skill
---

# voice-agent-tool-skill

多风格语音生成 Skill —— 通过 Agent 完成 信息搜集 → 风格化处理 → TTS语音生成 的完整流程。

## 服务依赖

本 Skill 依赖 voice-agent-tool 服务提供 TTS 生成能力。

- 服务路径：/opt/voice-agent-tool/
- API 端点：http://localhost:8002/tts（待服务启动后配置）
- 项目文档：/opt/voice-agent-tool/README.md

## 配置文件

- `config/styles.yaml` — 5 种风格预设（严肃/幽默/故事/比喻/对话）
- 服务端 `config/tts.yaml` — TTS 后端配置（Mimo/OpenAI/edge-tts）

## 执行步骤

### Step 1：确认输入

确认内容来源（用户提供文本 / MD 文件路径 / 搜索关键词）、风格。

### Step 2：搜集内容

- **用户提供文本**：直接使用
- **MD 文件**：读取文件内容，忽略 `---` frontmatter 块
- **搜索关键词**：用 web_search / tavily 搜索，提取标题和摘要组合成播报脚本

### Step 3：风格化处理

读取 `config/styles.yaml`，获取对应风格的 `prompt_template`，填入 `{content}`。
调用 LLM 改写内容，风格化后文本需适合朗读：去除 markdown 格式、长句适当拆分。

### Step 4：调用 TTS 服务

```bash
curl -X POST http://localhost:8002/tts \
  -H "Content-Type: application/json" \
  -d '{
    "text": "风格化后的文本",
    "style": "serious",
    "provider": "mimo"
  }'
```

服务返回音频文件路径。

### Step 5：返回结果

返回音频文件路径、使用的风格和音色信息。

## 风格预设

| 风格 key | 名称 | TTS profile | 适用场景 |
|----------|------|-------------|----------|
| serious | 严肃教学 | clear-slow | 教学、技术文档 |
| humor | 幽默风趣 | casual | 轻松内容 |
| story | 故事叙述 | warm | 故事化叙述 |
| analogy | 比喻类比 | clear-slow | 概念解释 |
| conversational | 对话互动 | casual | 聊天风格 |

## 定时任务

用户可通过 Hermes cronjob 设置定时语音生成任务。

创建定时任务时使用 Hermes cronjob 工具，prompt 中引用本 skill。
任务会自动调用 voice-agent-tool 服务完成 TTS 生成。
