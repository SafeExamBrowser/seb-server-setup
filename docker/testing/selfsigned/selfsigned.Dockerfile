FROM openjdk:11-jre-stretch

RUN  apt-get update && apt-get install -y openssl

ENV DOMAIN_NAME="localhost"
ENV OPENSSL_SUBJ="/C=CH/ST=Zurich/L=Zurich"
ENV OPENSSL_CA="${OPENSSL_SUBJ}/CN=${DOMAIN_NAME}"

WORKDIR /certs

CMD cp -a /host/config/. /config/ \
    && secret=$(cat /config/secret) \
    && openssl req -x509 -nodes -days 365 -subj "${OPENSSL_CA}" -newkey rsa:2048 -keyout /certs/nginx-key.pem -out /certs/nginx-cert.pem \
    && rm /host/config/secret