# Use official OpenJDK image as base
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy the JAR file from the target folder to the container
COPY target/hello-world-game-*.jar /app/hello-world-game.jar

# Expose the port your app runs on
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/hello-world-game.jar"]
