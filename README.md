# Java Spring Boot Application on Kubernetes

A hands-on DevOps project demonstrating how to build a Java Spring Boot REST API, package it into a Docker container, publish the image to Docker Hub, and deploy it to Kubernetes using Minikube.

## Project Overview

This project demonstrates the end-to-end deployment of a containerized Java application on a local Kubernetes cluster.

The Spring Boot application exposes a REST API that returns a greeting message. Docker is used to package the application, and Kubernetes manages its deployment, replicas, health checks, and service access.

## Architecture

```text
Developer
   |
   v
Java Spring Boot Application
   |
   v
Maven Build (Executable JAR)
   |
   v
Docker Image
   |
   v
Docker Hub
   |
   v
Minikube / Kubernetes
   |
   +--> Deployment
   |      |
   |      +--> Pod 1
   |      |
   |      +--> Pod 2
   |
   +--> Kubernetes Service
             |
             v
        Application Access
        localhost:80
```

## Technologies Used

- **Java 17** — application development
- **Spring Boot** — REST API and application health endpoint
- **Maven** — build and dependency management
- **Docker** — application containerization
- **Docker Hub** — container image registry
- **Kubernetes** — container orchestration
- **Minikube** — local Kubernetes cluster
- **kubectl** — Kubernetes command-line management tool
- **PowerShell / VS Code** — development environment

## Project Structure

```text
java-kubernetes-project/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/demo/
│       │       ├── SpringBootDemoApplication.java
│       │       └── HelloController.java
│       └── resources/
│           └── application.properties
├── k8s/
│   ├── deployment.yaml
│   └── service.yaml
├── target/
├── Dockerfile
├── pom.xml
└── README.md
```

## Application Endpoints

| Endpoint | Description |
|---|---|
| `/api/hello` | Returns a greeting message |
| `/actuator/health` | Checks application health |

Example response from `/api/hello`:

```text
Hello from Spring Boot running on Kubernetes!
```

Example health response:

```json
{
  "status": "UP"
}
```

## Prerequisites

Install the following tools before running the project:

- Java JDK 17
- Apache Maven
- Docker Desktop
- Minikube
- kubectl
- A Docker Hub account

Verify the installations:

```powershell
java -version
mvn -version
docker --version
minikube version
kubectl version --client
```

## Step 1: Build the Spring Boot Application

Clone the repository and navigate to the project directory:

```powershell
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd java-kubernetes-project
```

Build the executable JAR:

```powershell
mvn clean package
```

Run the application locally:

```powershell
java -jar .\target\java-kubernetes-project-0.0.1-SNAPSHOT.jar
```

Test the API in your browser:

- http://localhost:8080/api/hello
- http://localhost:8080/actuator/health

Stop the application with `Ctrl + C` before proceeding if it is still running.

## Step 2: Build the Docker Image

Build the image from the project root, where the Dockerfile is located:

```powershell
docker build -t java-kubernetes-project:v1 .
```

Verify that the image exists locally:

```powershell
docker images
```

Optionally, test the container before deploying it to Kubernetes:

```powershell
docker run --rm -p 8080:8080 java-kubernetes-project:v1
```

Access the application at http://localhost:8080/api/hello.

Stop the test container with `Ctrl + C`.

## Step 3: Push the Image to Docker Hub

Log in to Docker Hub:

```powershell
docker login
```

Tag the image using your Docker Hub username:

```powershell
docker tag java-kubernetes-project:v1 wprachiti/java-kubernetes-project:v1
```

Push the image:

```powershell
docker push wprachiti/java-kubernetes-project:v1
```

The Kubernetes Deployment will use this published image.

Docker Hub repository: https://hub.docker.com/r/wprachiti/java-kubernetes-project

## Step 4: Start Minikube

Start the local Kubernetes cluster:

```powershell
minikube start
```

Verify the cluster:

```powershell
minikube status
kubectl get nodes
```

The node should eventually report `Ready`.

## Step 5: Deploy the Application to Kubernetes

The Kubernetes Deployment is defined in `k8s/deployment.yaml`.

It configures two replicas of the Spring Boot application and uses HTTP health probes.

Example configuration:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: java-kubernetes-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: java-kubernetes-app
  template:
    metadata:
      labels:
        app: java-kubernetes-app
    spec:
      containers:
        - name: java-kubernetes-app
          image: wprachiti/java