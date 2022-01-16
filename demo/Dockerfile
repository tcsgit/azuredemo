FROM maven:3.5.2-jdk-8-alpine AS MAVEN_BUILDER

MAINTAINER TCSG <sn.guzeller@gmail.com>

COPY pom.xml /build/
COPY src /build/src/

WORKDIR /build/
RUN mvn package


FROM openjdk:8-jre-alpine

ARG DEPENDENCY=/build/target/dependency

COPY --from=MAVEN_BUILDER ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=MAVEN_BUILDER ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=MAVEN_BUILDER ${DEPENDENCY}/BOOT-INF/classes /app

ENTRYPOINT ["java","-cp","app:app/lib/*","com.asa.demo.AsaContainerDemoApplication"]