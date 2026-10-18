
# Use Java 17 runtime
FROM eclipse-temurin:17-jre

# Set the working directory inside the container
WORKDIR /app

# Copy the Spring Boot executable JAR into the image
COPY target/java-kubernetes-project-0.0.1-SNAPSHOT.jar app.jar

# Application listens on port 8080
EXPOSE 8080

# Start the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
