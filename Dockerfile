# Use OpenJDK 17 as the base image
FROM openjdk:17-jdk-slim

# Set working directory inside the container
WORKDIR /app

# Copy the built JAR file to the container
COPY target/*-SNAPSHOT.jar /app/app.jar

# Expose the application port
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "/app/app.jar"]
