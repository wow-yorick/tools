FROM dockerhub.verystar.net/library/openjdk:15

WORKDIR /app

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} ./app.jar

#COPY ./config/ /app/config

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

EXPOSE 80
ENTRYPOINT ["java", "-Xms256m", "-Xmx512m", "-jar", "-Dfile.encoding=UTF-8", "-Djava.net.preferIPv4Stack=true","-Dspring.profiles.active=prod", "app.jar"]

