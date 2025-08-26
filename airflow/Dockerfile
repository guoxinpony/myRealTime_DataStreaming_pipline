# FROM apache/airflow:2.10.5-python3.10

# # 可选：如果你需要国内源，可在构建时切换 pip index（这里示例默认不改）
# USER root
# COPY requirements.txt /requirements.txt
# RUN pip install --no-cache-dir -r /requirements.txt

# COPY entrypoint.sh /bootstrap.sh
# RUN chmod +x /bootstrap.sh

# # 切回 airflow 用户，保持与官方镜像一致的权限模型
# USER airflow

# # 用我们的 bootstrap 作为入口；它最终会 exec 回官方 /entrypoint
# ENTRYPOINT ["/bootstrap.sh"]


# ===========================================

FROM apache/airflow:2.10.5-python3.10

# 仍用 root 来放文件/改权限
USER root
COPY --chown=airflow:0 requirements.txt /opt/airflow/requirements.txt
COPY entrypoint.sh /bootstrap.sh
RUN chmod +x /bootstrap.sh

# 切回 airflow 用户，以用户空间安装 Python 包
USER airflow
# Debian/Bookworm 的 pip 需要允许“非虚拟环境安装”
RUN python -m pip install --no-cache-dir -r /opt/airflow/requirements.txt

# （通常镜像已把 ~/.local/bin 加进 PATH；稳妥起见可加这两行）
# ENV PATH="/home/airflow/.local/bin:${PATH}"
# ENV PYTHONPATH="/home/airflow/.local/lib/python3.10/site-packages:${PYTHONPATH}"

ENTRYPOINT ["/bootstrap.sh"]
