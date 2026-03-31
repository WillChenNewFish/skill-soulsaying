#!/bin/bash
# speak.sh — Generate TTS and send as Feishu voice message (one-step)
# Usage: bash speak.sh "text to speak" [open_id] [chat_id]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Load config
if [ -f "$SKILL_DIR/config.env" ]; then
  source "$SKILL_DIR/config.env"
fi

TEXT="$1"
OPEN_ID="${2:-$FEISHU_OPEN_ID}"
CHAT_ID="$3"

if [ -z "$TEXT" ]; then
  echo "Usage: bash speak.sh \"text to speak\" [open_id] [chat_id]"
  exit 1
fi

TMP_MP3="/tmp/soulsaying_speak_$(date +%s).mp3"

# 1. Generate TTS
bash "${SCRIPT_DIR}/tts.sh" "$TEXT" "$TMP_MP3"

# 2. Send to Feishu
bash "${SCRIPT_DIR}/send_feishu_voice.sh" "$TMP_MP3" "$OPEN_ID" "$CHAT_ID"

# 3. Cleanup
rm -f "$TMP_MP3"
