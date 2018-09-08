## -*- docker-image-name: "mcreations/elasticsearch" -*-

FROM mcreations/openwrt-java:8

LABEL maintainer="Reza Rahimi <rahimi@m-creations.net> \
                  and Ioanna M. Dimitriou <dimitriou@m-creations.net>"
LABEL vendor="mcreations"

ENV ELASTIC_HOME="/opt/elastic"
ENV INTERNAL_CONFIG_DIR="/config"
ENV INTERNAL_TEMPLATES_DIR="/etc/elastic/templates"
ENV EXTERNAL_TEMPLATES_DIR="/data/templates"
ENV DIST_DIR="/mnt/packs"

VOLUME /data

RUN mkdir -p /mnt/packs

ADD image/root /
ADD dist/ /mnt

ENV ELASTIC_VERSION="6.3.2"
ENV ELASTIC_REPO_BASE="https://artifacts.elastic.co/downloads/elasticsearch"
ENV ELASTIC_ARTIFACT_NAME="elasticsearch-${ELASTIC_VERSION}"
ENV ELASTIC_FILE="${ELASTIC_ARTIFACT_NAME}.tar.gz"
ENV ELASTIC_DOWNLOAD_URL="${ELASTIC_REPO_BASE}/${ELASTIC_FILE}"

ENV ELASTIC_USER="elasticsearch"
ENV ELASTIC_GROUP="$ELASTIC_USER"


# More info: https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html#create-index-settings
# Default for number_of_shards is 5
ENV ELASTIC_NUMBER_OF_SHARDS=5
# Default for number_of_replicas is 1 (ie one replica for each primary shard)
ENV ELASTIC_NUMBER_OF_REPLICAS=1

ENV CLUSTER_NAME="elasticsearch"
ENV NODE_NAME="node-1"

ENV PATH="${ELASTIC_HOME}/bin:$PATH"

EXPOSE 9200 9300

RUN sh /mnt/install-elastic.sh

CMD ["/start-elastic.sh"]

