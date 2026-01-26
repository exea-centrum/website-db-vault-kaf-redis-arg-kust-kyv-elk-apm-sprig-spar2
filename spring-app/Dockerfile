FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy jar file
COPY target/spring-survey-api.jar app.jar

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]
