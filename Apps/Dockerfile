FROM openjdk:11

COPY ./app/build/libs/*.jar ./app.jar

ARG PORT=8080

EXPOSE ${PORT}

ENTRYPOINT [ "java", "-jar", "app.jar" ]
