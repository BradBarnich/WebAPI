FROM maven:3-amazoncorretto-8-al2023 AS builder

WORKDIR /code

ARG MAVEN_PROFILE=webapi-docker
ARG MAVEN_PARAMS="" # can use maven options, e.g. -DskipTests=true -DskipUnitTests=true

ARG OPENTELEMETRY_JAVA_AGENT_VERSION=1.33.5
RUN curl -LSsO https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/download/v${OPENTELEMETRY_JAVA_AGENT_VERSION}/opentelemetry-javaagent.jar

# Download dependencies
COPY pom.xml /code/
RUN mkdir .git \
    && mvn package \
     -P${MAVEN_PROFILE}

ARG GIT_BRANCH=unknown
ARG GIT_COMMIT_ID_ABBREV=unknown

# Compile code and repackage it
COPY src /code/src
RUN mvn package ${MAVEN_PARAMS} \
    -Dgit.branch=${GIT_BRANCH} \
    -Dgit.commit.id.abbrev=${GIT_COMMIT_ID_ABBREV} \
    -P${MAVEN_PROFILE}

# OHDSI WebAPI and ATLAS web application running as a Spring Boot application with Java 8
FROM amazoncorretto:8-al2023

MAINTAINER Lee Evans - www.ltscomputingllc.com

# Any Java options to pass along, e.g. memory, garbage collection, etc.
# ENV JAVA_OPTS=""
# Additional classpath parameters to pass along. If provided, start with colon ":"
# ENV CLASSPATH=""
# Default Java options. 
# ENV DEFAULT_JAVA_OPTS=""
# Otel agent options
# ENV JAVA_TOOL_OPTIONS="-javaagent:opentelemetry-javaagent.jar"
# ENV OTEL_SERVICE_NAME="webapi"

# set working directory to a fixed WebAPI directory
WORKDIR /var/lib/ohdsi/webapi

COPY --from=builder /code/opentelemetry-javaagent.jar .

# deploy the just built OHDSI WebAPI war file
# copy resources in order of fewest changes to most changes.
# This way, the libraries step is not duplicated if the dependencies
# do not change.
COPY --from=builder /code/target/WebAPI-2.15.0-SNAPSHOT.jar .

EXPOSE 8080

USER 101

# Directly run the code as a WAR.
CMD exec java ${DEFAULT_JAVA_OPTS} ${JAVA_OPTS} \
    -jar WebAPI-2.15.0-SNAPSHOT.jar
