FROM maven:3.8-openjdk-11 as build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM openjdk:11-jre-slim
WORKDIR /app
COPY --from=build /app/target/dependency/webapp-runner.jar webapp-runner.jar
COPY --from=build /app/target/*.war app.war
ENV PORT=8080
EXPOSE 8080
CMD java -jar webapp-runner.jar --port $PORT app.war 