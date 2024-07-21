FROM openjdk:11-jre

MAINTAINER mindse

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN mkdir -p /app

ARG JAR_FILE
COPY ${JAR_FILE} /app/app.jar


ENTRYPOINT ["java","-jar","/app/app.jar"]


