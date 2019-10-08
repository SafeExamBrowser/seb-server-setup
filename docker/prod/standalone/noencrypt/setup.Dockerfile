FROM openjdk:11-jre-stretch

WORKDIR /certs

CMD cp -a /host/config/. /config/ \
    && secret=$(cat /config/secret) \
    && rm /host/config/secret