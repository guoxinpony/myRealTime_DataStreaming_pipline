#!/usr/bin/env bash


set -euo pipefail

install_requirements() {
  if [[ -f "/opt/airflow/requirements.txt" ]]; then
    python -m pip install --upgrade pip
    python -m pip install --no-cache-dir -r /opt/airflow/requirements.txt
  fi
}

init_airflow() {
  # 升级到最新迁移；若还没初始化则 init
  airflow db upgrade || airflow db init
  # 创建 admin（已存在则忽略错误）
  airflow users create \
    --username "${AIRFLOW_ADMIN_USERNAME:-admin}" \
    --firstname "${AIRFLOW_ADMIN_FIRSTNAME:-admin}" \
    --lastname  "${AIRFLOW_ADMIN_LASTNAME:-admin}" \
    --role Admin \
    --email "${AIRFLOW_ADMIN_EMAIL:-admin@example.com}" \
    --password "${AIRFLOW_ADMIN_PASSWORD:-admin}" || true
}

case "${1:-webserver}" in
  init)
    install_requirements
    init_airflow
    echo "Airflow init done."
    ;;
  webserver|scheduler|triggerer|celery|flower)
    install_requirements
    airflow db upgrade || true
    exec airflow "$@"
    ;;
  *)
    
    exec "$@"
    ;;
esac
