FROM eclipse-temurin:17-jre-alpine

# Install APM agent
RUN wget -O /elastic-apm-agent.jar \
    https://search.maven.org/remotecontent?filepath=co/elastic/apm/elastic-apm-agent/1.36.0/elastic-apm-agent-1.36.0.jar

WORKDIR /app

# Copy jar file
COPY target/spring-survey-api.jar app.jar

# Create non-root user
RUN addgroup -S spring && adduser -S spring -G spring
USER spring:spring

EXPOSE 8080


ENTRYPOINT ["java", \
    "-javaagent:/elastic-apm-agent.jar", \
    "-Delastic.apm.service_name=spring-survey-service", \
    "-Delastic.apm.server_url=http://apm-server:8200", \
    "-Delastic.apm.environment=${ENVIRONMENT:-production}", \
    "-Delastic.apm.application_packages=com.dawidtrojanowski", \
    "-jar", "app.jar"]
