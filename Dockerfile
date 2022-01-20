FROM python:3.9.7-buster

RUN apt-get -y update && \
    apt-get install -y tzdata && \
    curl -sL https://deb.nodesource.com/setup_12.x |bash - && \
    apt-get install -y --no-install-recommends nodejs yarn

RUN apt install -y locales && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8
ENV TZ Asia/Tokyo


# Pythonライブラリのインストール
COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt && \
    rm -rf ~/.cache/pip


# JupyterLab関連
RUN jupyter labextension install @kiteco/jupyterlab-kite && \
    jupyter labextension install @jupyterlab/toc

RUN cd && \
    wget https://linux.kite.com/dls/linux/current && \
    chmod 777 current && \
    sed -i 's/"--no-launch"//g' current > /dev/null && \
    ./current --install ./kite-installer
