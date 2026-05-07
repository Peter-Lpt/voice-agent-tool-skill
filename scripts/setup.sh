#!/bin/bash
# voice-agent-tool-skill 初始化脚本

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "初始化 voice-agent-tool-skill..."

# 创建本地配置文件（如果不存在）
if [ ! -f "$PROJECT_DIR/config/tts.local.yaml" ]; then
    echo "创建 tts.local.yaml..."
    cat > "$PROJECT_DIR/config/tts.local.yaml" << 'EOF'
# 本地 TTS 配置覆盖
# 取消注释并填入你的 API Key

# providers:
#   mimo:
#     api_key_env: "MIMO_API_KEY"
#   openai:
#     api_key_env: "OPENAI_API_KEY"
EOF
fi

# 创建输出目录
mkdir -p "$PROJECT_DIR/output"

# 安装 edge-tts（可选）
if ! command -v edge-tts &> /dev/null; then
    echo "安装 edge-tts..."
    pip install edge-tts -q
fi

echo "初始化完成！"
echo ""
echo "下一步："
echo "1. 设置环境变量: export MIMO_API_KEY=your_key"
echo "2. 或编辑 config/tts.local.yaml 配置 API Key"
