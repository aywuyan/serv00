#!/bin/bash
# 启用调试模式，显示每个命令及其参数
set -x
# 设置时区为东八区
export TZ='Asia/Shanghai'
# 设置时间为24小时制
export DATE_FORMAT="%Y-%m-%d %H:%M:%S"

# 定义日志文件路径和 Telegram 机器人信息
LOGFILE=~/auto_ssh.log
TEMPLOG=~/auto_ssh_temp.log
SSH_LOGIN1="user1@vps-address" # 输入user1@vps-address
SSH_LOGIN2="user2@vps-address" # 输入user2@vps-address
BOT_TOKEN="YOUR_BOT_TOKEN" # 输入TG bot的token
CHAT_ID="YOUR_CHAT_ID" # 输入chat id
TELEGRAM_API_URL="https://api.telegram.org/bot$BOT_TOKEN/sendMessage"

# 清空临时日志文件
> "$TEMPLOG"

# 记录脚本开始执行的时间
echo "=== SSH连接脚本开始执行：$(date +"$DATE_FORMAT") ===" | tee -a "$LOGFILE" "$TEMPLOG"

# 定义发送 Telegram 消息的函数
send_telegram_message() {
    local MESSAGE=$1
    curl -s -X POST "$TELEGRAM_API_URL" -d chat_id="$CHAT_ID" -d text="$MESSAGE"
}

# 登录第一台服务器
echo "正在连接到 $SSH_LOGIN1..." | tee -a "$LOGFILE" "$TEMPLOG"
ssh -o ConnectTimeout=10 "$SSH_LOGIN1" "sleep 30" 2>&1 | tee -a "$LOGFILE" "$TEMPLOG"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "成功连接到 $SSH_LOGIN1 并保持半分钟。" | tee -a "$LOGFILE" "$TEMPLOG"
else
    echo "连接 $SSH_LOGIN1 失败。" | tee -a "$LOGFILE" "$TEMPLOG"
fi

# 登录第二台服务器
echo "正在连接到 $SSH_LOGIN2..." | tee -a "$LOGFILE" "$TEMPLOG"
ssh -o ConnectTimeout=10 "$SSH_LOGIN2" "sleep 30" 2>&1 | tee -a "$LOGFILE" "$TEMPLOG"
if [ ${PIPESTATUS[0]} -eq 0 ]; then
    echo "成功连接到 $SSH_LOGIN2 并保持半分钟。" | tee -a "$LOGFILE" "$TEMPLOG"
else
    echo "连接 $SSH_LOGIN2 失败。" | tee -a "$LOGFILE" "$TEMPLOG"
fi

# 记录脚本结束执行的时间
END_TIME="=== SSH连接脚本结束执行：$(date +"$DATE_FORMAT") ==="
echo "$END_TIME" | tee -a "$LOGFILE" "$TEMPLOG"

# 发送本次执行结果到 Telegram
MESSAGE="$(cat $TEMPLOG)"
send_telegram_message "$MESSAGE"

# 清除临时日志文件
rm "$TEMPLOG"
