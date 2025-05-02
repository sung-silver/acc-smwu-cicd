#!/bin/bash

IDLE_PORT=$1

if [ -z "$IDLE_PORT" ]; then
  echo "❌ [switch.sh] 포트 인자가 필요합니다."
  exit 1
fi

# 현재 switch된 포트를 제외한 반대 포트를 계산
if [ "$IDLE_PORT" -eq 8080 ]; then
  OLD_PORT=8081
elif [ "$IDLE_PORT" -eq 8081 ]; then
  OLD_PORT=8080
else
  echo "❌ [switch.sh] 허용되지 않은 포트입니다: $IDLE_PORT"
  exit 1
fi

echo "🌐 Nginx 포트를 $IDLE_PORT 로 스위칭 중..."
echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc

echo "🔁 Nginx Reload 중..."
sudo service nginx reload
echo "✅ Nginx Reload 완료. 현재 포트: $IDLE_PORT"

# 이전 포트에서 실행 중인 프로세스 종료
echo "🛑 이전 포트($OLD_PORT)에서 실행 중인 애플리케이션 종료 시도 중..."
OLD_PID=$(lsof -t -i:$OLD_PORT)

if [ -z "$OLD_PID" ]; then
  echo "ℹ️ 이전 포트($OLD_PORT)에서 실행 중인 프로세스가 없습니다."
else
  echo "🔪 프로세스 종료: kill -15 $OLD_PID"
  kill -15 $OLD_PID
  sleep 5
fi