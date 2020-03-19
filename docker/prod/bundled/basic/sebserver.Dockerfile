# Clone git repository form specified tag
FROM alpine/git

ARG GIT_TAG

WORKDIR /sebserver
RUN if [ "x${GIT_TAG}" = "x" ] ; \
    then git clone --depth 1 https://github.com/SafeExamBrowser/seb-server.git ; \
    else git clone -b "$GIT_TAG" --depth 1 https://github.com/SafeExamBrowser/seb-server.git ; fi

# Build with maven (skip tests)
FROM maven:latest

ARG SEBSERVER_VERSION

WORKDIR /sebserver
COPY --from=0 /sebserver/seb-server /sebserver
RUN mvn clean install -DskipTests

FROM openjdk:11-jre-stretch

ARG SEBSERVER_VERSION
ARG SEBSERVER_BUILD=
ENV SEBSERVER_JAR=${SEBSERVER_VERSION}${SEBSERVER_BUILD}
ENV DEBUG_MODE=false

WORKDIR /sebserver
COPY --from=1 /sebserver/target/seb-server-"$SEBSERVER_JAR".jar /sebserver

CMD if [ "${DEBUG_MODE}" = "true" ] ; \
        then secret=$(cat /sebserver/config/secret) && exec java \
            -Xms64M \
            -Xmx2G \
            -Dcom.sun.management.jmxremote \
            -Dcom.sun.management.jmxremote.port=9090 \
            -Dcom.sun.management.jmxremote.rmi.port=9090 \
            -Djava.rmi.server.hostname=localhost \
            -Dcom.sun.management.jmxremote.ssl=false \
            -Dcom.sun.management.jmxremote.local.only=false \
            -Dcom.sun.management.jmxremote.authenticate=true \
            -Dcom.sun.management.jmxremote.password.file=/sebserver/config/jmxremote.password \
            -Dcom.sun.management.jmxremote.access.file=/sebserver/config/jmxremote.access \
            -jar seb-server-"${SEBSERVER_JAR}".jar \
            --spring.profiles.active=prod,prod-gui,prod-ws \
            --spring.config.location=file:/sebserver/config/spring/,classpath:/config/ \
            --sebserver.certs.password="${secret}" \ 
            --sebserver.mariadb.password="${secret}" \
            --sebserver.password="${secret}" ; \
        else secret=$(cat /sebserver/config/secret) && exec java \
            -Xms64M \
            -Xmx2G \
            -jar seb-server-"${SEBSERVER_JAR}".jar \
            --spring.profiles.active=prod,prod-gui,prod-ws \
            --spring.config.location=file:/sebserver/config/spring/,classpath:/config/ \
            --sebserver.certs.password="${secret}" \ 
            --sebserver.mariadb.password="${secret}" \
            --sebserver.password="${secret}" ; \
        fi

EXPOSE 8080 9090