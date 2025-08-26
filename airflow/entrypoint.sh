#!/usr/bin/env bash
set -euo pipefail

# 默认变量（可被 docker-compose 的 environment 覆盖）
: "${_AIRFLOW_WWW_USER_USERNAME:=admin}"
: "${_AIRFLOW_WWW_USER_PASSWORD:=admin}"
: "${_AIRFLOW_WWW_USER_FIRSTNAME:=Air}"
: "${_AIRFLOW_WWW_USER_LASTNAME:=Flow}"
: "${_AIRFLOW_WWW_USER_EMAIL:=admin@example.com}"
: "${AIRFLOW_HOME:=/opt/airflow}"

# 幂等初始化：用一个文件标记，建议把 AIRFLOW_HOME 挂卷，这样多次重启不会重复初始化
if [ ! -f "${AIRFLOW_HOME}/.initialized" ]; then
  echo "[bootstrap] Initializing Airflow DB..."
  airflow db init || true

  echo "[bootstrap] Ensuring admin user exists..."
  # users list 的输出不稳定，这里用 grep -w 精确匹配用户名
  if ! airflow users list | grep -wq "${_AIRFLOW_WWW_USER_USERNAME}"; then
    airflow users create \
      --username "${_AIRFLOW_WWW_USER_USERNAME}" \
      --password "${_AIRFLOW_WWW_USER_PASSWORD}" \
      --firstname "${_AIRFLOW_WWW_USER_FIRSTNAME}" \
      --lastname "${_AIRFLOW_WWW_USER_LASTNAME}" \
      --role Admin \
      --email "${_AIRFLOW_WWW_USER_EMAIL}"
  fi

  touch "${AIRFLOW_HOME}/.initialized"
fi

# 交还给镜像自带的官方 entrypoint（会正确处理 webserver/scheduler/celery 等命令）
exec /entrypoint "$@"
