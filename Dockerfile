FROM openjdk:11

COPY ./build/libs/*.jar ./app.jar

ARG PORT=8080

EXPOSE ${PORT}

ENTRYPOINT [ "java", "-jar", "app.jar" ]
