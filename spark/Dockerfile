# FROM bitnami/spark:3.5.1

# USER root
# # Bitnami 镜像内已包含 Python3（一般路径 /opt/bitnami/python/bin/python3）
# # 为确保 pip 可用，这里直接用 python -m pip 安装
# COPY requirements.txt /tmp/requirements.txt
# RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt

# # 保证 PySpark 默认 Python 解释器正确
# ENV PYSPARK_PYTHON=python3
# ENV PYSPARK_DRIVER_PYTHON=python3

# # Bitnami 默认以非 root 运行，这里切回原有用户 (1001)
# USER 1001



FROM bitnami/spark:3.5.1

# 切到 root 以安装 Python 包（Bitnami 最终会以 1001 运行进程）
USER root

# 可选（如需国内加速）：取消下一行注释替换 pip 源
# RUN python3 -m pip config set global.index-url https://mirrors.aliyun.com/pypi/simple/

COPY requirements.txt /tmp/requirements.txt
RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt

# 为 PySpark 显式指定 Python 解释器（通常镜像已带 python3）
ENV PYSPARK_PYTHON=python3
ENV PYSPARK_DRIVER_PYTHON=python3

# 切回 Bitnami 预设的非 root 用户
USER 1001
