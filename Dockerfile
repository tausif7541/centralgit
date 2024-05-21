From openjdk:21
VOLUME /tmp
EXPOSE 8081
ARG JAR_FILE=*.jar
COPY ${JAR_FILE} SpringDocker-0.0.1.jar
ENTRYPOINT ["java", "-jar", "/SpringDocker-0.0.1.jar"]
