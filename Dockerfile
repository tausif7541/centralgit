From openjdk:17
VOLUME /tmp
EXPOSE 8080
ARG JAR_FILE=*SpringDocker-0.0.1.jar
COPY ${JAR_FILE} Demo.jar
ENTRYPOINT ["java", "-jar", "/Demo.jar"]
