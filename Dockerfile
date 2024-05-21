From openjdk:21
VOLUME /tmp
EXPOSE 8081
ARG JAR_FILE=*.jar
COPY ${JAR_FILE} Demo.jar
ENTRYPOINT ["java", "-jar", "/Demo.jar"]
