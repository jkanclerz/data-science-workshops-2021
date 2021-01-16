FROM cluster-base

ARG spark_version=3.0.0
ARG jupyterlab_version=2.2.6

RUN apt-get update -y && \
    apt-get install -y python3-pip && \
    pip3 install pyspark==${spark_version} jupyterlab==${jupyterlab_version} && \
    pip3 install wget && \
    pip3 install -U scikit-learn && \
    apt-get install -y python3-pandas && \
    pip3 install numpy && \
    pip3 install -U matplotlib && \ 
    pip3 install seaborn

RUN pip3 install jupyter
RUN apt-get install -y wget tree unzip 

RUN apt-get update -y && \
    apt-get install -y python3-geopandas

# -- Runtime

EXPOSE 8888
WORKDIR ${SHARED_WORKSPACE}
CMD jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=