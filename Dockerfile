# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-slim

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the target directory into the container
COPY target/hello-world-game-*.jar /app/app.jar

# Expose the application port (modify if needed)
EXPOSE 8080

# Run the JAR file
CMD ["java", "-jar", "/app/app.jar"]
