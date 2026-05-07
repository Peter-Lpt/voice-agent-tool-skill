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

## 前置条件

- Python 3.10+
- 已运行 `bash /opt/voice-agent-tool-skill/scripts/setup.sh` 初始化本地配置
- 已在 `/opt/voice-agent-tool-skill/config/tts.local.yaml` 中填入 TTS API 配置
- TTS API Key 设置为环境变量（如 `MIMO_API_KEY`）

## 配置加载规则

1. 读取 `config/tts.yaml`（基础配置）
2. 如果 `config/tts.local.yaml` 存在，合并覆盖对应 provider 字段
3. 输出目录默认 `output/`，文件名格式 `{style}_{YYYYMMDD_HHmmss}.mp3`

## 风格预设

| 风格 key | 名称 | TTS profile | 适用场景 |
|----------|------|-------------|----------|
| serious | 严肃教学 | clear-slow | 教学、技术文档 |
| humor | 幽默风趣 | casual | 轻松内容 |
| story | 故事叙述 | warm | 故事化叙述 |
| analogy | 比喻类比 | clear-slow | 概念解释 |
| conversational | 对话互动 | casual | 聊天风格 |

## 执行步骤

### Step 1：确认输入

确认内容来源（用户提供文本 / MD 文件路径 / 搜索关键词）、风格、TTS provider。

### Step 2：搜集内容

- **用户提供文本**：直接使用
- **MD 文件**：`cat` 读取，忽略 `---` frontmatter 块
- **搜索关键词**：用 web_search / tavily 搜索，提取标题和摘要组合成播报脚本

### Step 3：风格化处理

读取 `config/styles.yaml`，获取对应风格的 `prompt_template`，填入 `{content}`。
风格化后文本需适合朗读：去除 markdown 格式、长句适当拆分。

### Step 4：TTS 生成

1. 确定 provider（默认 `default_provider`）
2. 根据风格的 `tts_profile` 获取 voice/speed 参数
3. 参考 `reference/tts-{provider}.md` 调用 TTS API
4. 保存到 `output.dir`，文件名 `{style}_{YYYYMMDD_HHmmss}.mp3`

### Step 5：返回结果

返回音频文件路径、使用的风格和音色信息。

## TTS 调用要点

### Mimo TTS
- 端点：`https://api.xiaomimimo.com/v1/chat/completions`
- 模型：`mimo-v2.5-tts`
- messages 必须包含 `assistant` 角色，content 为待朗读文本
- 返回音频在 `choices[0].message.audio.data`，base64 编码需解码

### OpenAI TTS
- 端点：`https://api.openai.com/v1/audio/speech`
- 模型：`tts-1` 或 `tts-1-hd`
- 返回原始二进制音频，无需 base64 解码

### edge-tts（本地免费方案）
- `pip install edge-tts`，100+ 音色可用
- 适合无 API Key 的本地场景

## 定时任务

用户可通过 Hermes cronjob 设置定时语音生成任务。

创建定时任务时使用 Hermes cronjob 工具，prompt 中引用本 skill。

## 参考文档

- `config/styles.yaml` — 风格预设详情
- `config/tts.yaml` — TTS 配置详情
