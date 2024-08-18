# Stage 1: Build the application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY myapp/src ./src
RUN mvn clean package -DskipTests

# Stage 2: Create the Docker image
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

# Create a non-root user and switch to it
RUN useradd -m nonrootuser
USER nonrootuser

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
