# Set the base image to elasticsearch alpine
FROM elasticsearch:8.4.0

user root

# base ES image sets default data dir to volume which means it won't persist
# if we ingest.  We make a new directory for data here and update the config
# file to point to it.
WORKDIR /usr/share/elasticsearch
RUN mkdir /data && \
    chown -R elasticsearch:elasticsearch /data && \
    echo 'path.data: /data' >> config/elasticsearch.yml && \
    echo 'http.compression: true' >> config/elasticsearch.yml
# also flag ES to run in single instance mode (for dev/test configs)
ENV xpack.security.enabled=false
ENV discovery.type=single-node


# Copy in support scripts
ADD https://raw.githubusercontent.com/vishnubob/wait-for-it/e1f115e4ca285c3c24e847c4dd4be955e0ed51c2/wait-for-it.sh /build/wait-for-it.sh
RUN chmod 777 /build/wait-for-it.sh


# Update
RUN apt-get update
RUN apt install -y python3 python3-pip

ADD requirements.txt requirements.txt
ADD create_mappings.py create_mappings.py
ADD mappings mappings
RUN pip install -r requirements.txt


# RUN elasticsearch & \
#     /bin/bash /build/wait-for-it.sh -t 90 localhost:9200 -- /build/distil-ingest/ingest.sh; \
#     exit 0;

ENV ES=localhost:9200

USER elasticsearch
RUN elasticsearch & \
    /bin/bash /build/wait-for-it.sh -t 80 localhost:9200 -- python3 ./create_mappings.py; \
    exit 0;
