# Use OpenJDK 17
FROM openjdk:17-jdk-slim

# Set working directory
WORKDIR /app

# Copy the exact JAR file from the target directory
COPY target/hello-world-game-1.0.0-20250227-070448.jar /app/app.jar

# Expose application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/app.jar"]
