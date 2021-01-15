FROM cluster-base

# -- Layer: Apache Spark

ARG spark_version=3.0.0
ARG hadoop_version=2.7

RUN apt-get update -y && \
    apt-get install -y curl wget && \
    curl https://archive.apache.org/dist/spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz -o spark.tgz && \
    tar -xf spark.tgz && \
    mv spark-${spark_version}-bin-hadoop${hadoop_version} /usr/bin/ && \
    mkdir /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/logs && \
    rm spark.tgz

RUN wget -nc https://repo1.maven.org/maven2/org/mongodb/spark/mongo-spark-connector_2.12/3.0.0/mongo-spark-connector_2.12-3.0.0.jar -P /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/jars/

RUN wget -nc https://repo1.maven.org/maven2/org/mongodb/mongo-java-driver/3.12.7/mongo-java-driver-3.12.7.jar -P /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/jars/

RUN wget -nc https://repo1.maven.org/maven2/org/postgresql/postgresql/42.2.18/postgresql-42.2.18.jar -P /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}/jars/

ENV SPARK_HOME /usr/bin/spark-${spark_version}-bin-hadoop${hadoop_version}
ENV SPARK_MASTER_HOST spark-master
ENV SPARK_MASTER_PORT 7077
ENV PYSPARK_PYTHON python3

# -- Runtime

WORKDIR ${SPARK_HOME}
