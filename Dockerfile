# Use OpenJDK 17
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the JAR file from the Maven target directory
COPY target/hello-world-game-*.jar /app/app.jar

# Expose application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/app.jar"]
