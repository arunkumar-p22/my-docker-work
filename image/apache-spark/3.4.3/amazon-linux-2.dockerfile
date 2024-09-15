# Docker image to use.
FROM sloopstash/base:v1.1.1

# Install Oracle JDK.
WORKDIR /tmp
COPY jdk-22_linux-x64_bin.rpm /tmp/
RUN set -x \
    && yum clean all \
    && yum update -y \
    && yum install -y /tmp/jdk-22_linux-x64_bin.rpm

# Install Apache Spark.
RUN set -x \
    && wget https://downloads.apache.org/spark/spark-3.4.3/spark-3.4.3-bin-hadoop3.tgz --quiet \
    && tar -xvf spark-3.4.3-bin-hadoop3.tgz > /dev/null \
    && ls -l \
    && mkdir -p /usr/local/lib/spark \
    && cp -r spark-3.4.3-bin-hadoop3/* /usr/local/lib/spark/ \
    && rm -rf spark-3.4.3*

# Create Spark directories.
RUN set -x \
  && mkdir /opt/spark \
  && mkdir /opt/spark/data \
  && mkdir /opt/spark/log \
  && mkdir /opt/spark/conf \
  && mkdir /opt/spark/script \
  && mkdir /opt/spark/system \
  && touch /opt/spark/system/server.pid \
  && touch /opt/spark/system/supervisor.ini \
  && ln -s /opt/spark/system/supervisor.ini /etc/supervisord.d/spark.ini \
  && history -c

# Set default work directory.
WORKDIR /opt/spark