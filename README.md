# voice-agent-tool-skill

Hermes Agent 语音生成 Skill —— 多风格 TTS 语音生成。

## 定位

作为 Hermes Agent Skill 使用，由 Agent 在对话中完成全流程：
1. 信息搜集（用户输入 / MD 文件 / 网络搜索）
2. 风格化处理（5 种风格可选）
3. 调用 voice-agent-tool 服务生成音频

## 依赖

- Hermes Agent
- voice-agent-tool 服务（/opt/voice-agent-tool/）

## 风格

| 风格 | 名称 | 适用场景 |
|------|------|----------|
| serious | 严肃教学 | 教学、技术文档 |
| humor | 幽默风趣 | 轻松内容 |
| story | 故事叙述 | 故事化叙述 |
| analogy | 比喻类比 | 概念解释 |
| conversational | 对话互动 | 聊天风格 |

## 使用方式

在 Hermes Agent 对话中：
- "把这段文字转成语音"
- "用幽默风格生成一段关于 Python 的音频"
- "搜索最新的 AI 新闻，生成语音播报"

## 文件结构

```
voice-agent-tool-skill/
├── SKILL.md              # Skill 定义
├── config/
│   └── styles.yaml       # 风格预设
└── README.md
```
