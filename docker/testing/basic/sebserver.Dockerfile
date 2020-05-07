FROM alpine/git

ARG SEBSERVER_VERSION
ARG GIT_TAG="v${SEBSERVER_VERSION}"

WORKDIR /sebserver
RUN if [ "x${GIT_TAG}" = "x" ] ; \
    then git clone --depth 1 https://github.com/SafeExamBrowser/seb-server.git ; \
    else git clone -b "$GIT_TAG" --depth 1 https://github.com/SafeExamBrowser/seb-server.git ; fi

FROM maven:latest

ARG SEBSERVER_VERSION

WORKDIR /sebserver
COPY --from=0 /sebserver/seb-server /sebserver
RUN mvn clean install -DskipTests -Dbuild-version="${SEBSERVER_VERSION}"

FROM openjdk:11-jre-stretch

ARG SEBSERVER_VERSION
ENV SEBSERVER_JAR="seb-server-${SEBSERVER_VERSION}.jar"
ENV SERVER_PORT="8080"
ENV JMX_PORT="9090"

WORKDIR /sebserver
COPY --from=1 /sebserver/target/"${SEBSERVER_JAR}" /sebserver

CMD if [ "x${JMX_PORT}" = "x" ] ; \
        then secret=$(cat /sebserver/config/secret) && exec java \
            -Xms64M \
            -Xmx1G \
            -jar seb-server-"${SEBSERVER_JAR}".jar \
            --spring.profiles.active=prod,prod-gui,prod-ws \
            --spring.config.location=file:/sebserver/config/spring/,classpath:/config/ \
            --sebserver.certs.password="${secret}" \ 
            --sebserver.mariadb.password="${secret}" \
            --sebserver.password="${secret}" ; \
        else secret=$(cat /sebserver/config/secret) && exec java \
            -Xms64M \
            -Xmx1G \
            -Dcom.sun.management.jmxremote \
            -Dcom.sun.management.jmxremote.port="${JMX_PORT}" \
            -Dcom.sun.management.jmxremote.rmi.port="${JMX_PORT}" \
            -Djava.rmi.server.hostname=localhost \
            -Dcom.sun.management.jmxremote.ssl=false \
            -Dcom.sun.management.jmxremote.local.only=false \
            -Dcom.sun.management.jmxremote.authenticate=false \
            -jar seb-server-"${SEBSERVER_JAR}".jar \
            --spring.profiles.active=prod,prod-gui,prod-ws \
            --spring.config.location=file:/sebserver/config/spring/,classpath:/config/ \
            --sebserver.certs.password="${secret}" \ 
            --sebserver.mariadb.password="${secret}" \
            --sebserver.password="${secret}" ; \
        fi

EXPOSE $SERVER_PORT $JMX_PORT