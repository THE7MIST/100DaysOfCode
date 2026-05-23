# Docker Labs : Day 1

## Overview

This document contains notes, commands, explanations, outputs, and concepts learned while performing Docker labs on KodeKloud.

The focus of this lab was:
- Docker basics
- Container lifecycle management
- Image management
- Port mapping
- Container inspection
- Docker command structure
- Host vs container networking

---

# Docker Basics

## What is Docker?

Docker is a containerization platform used to package, deploy, and run applications inside isolated environments called containers.

Containers are lightweight, portable, and consistent across systems.

---

# Important Docker Components

| Component | Description |
|---|---|
| Container | Running isolated instance of an application |
| Image | Blueprint used to create containers |
| Docker Engine | Core Docker service running on host |
| Host | System running Docker |
| Docker Hub | Registry for Docker images |
| Alpine | Lightweight Linux distribution |
| Nginx | Web server and reverse proxy |
| Redis | In-memory database and cache |

---

# Lab 1 : Docker Basics

---

## Question 1

### Task
Check Docker Engine version running on the host.

### Command

```bash
docker -v
```

### Output

```bash
Docker version 25.0.5
```

### Explanation

| Part | Meaning |
|---|---|
| docker | Docker CLI |
| -v | Show Docker version |

### Learning
Verified Docker installation and engine availability.

---

## Question 2

### Task
Check number of currently running containers.

### Commands

```bash
docker ps
```

```bash
docker ps | tail -n +2 | wc -l
```

### Explanation

| Command | Purpose |
|---|---|
| docker ps | List running containers |
| tail -n +2 | Remove header line |
| wc -l | Count lines |

### Output

```bash
0
```

### Learning
Learned how to inspect active containers and count results using Linux pipelines.

---

## Question 3

### Task
Check total Docker images available on host.

### Commands

```bash
docker images
```

```bash
docker images | tail -n +2 | wc -l
```

### Output

```bash
9
```

### Learning
Learned image inspection and command-line filtering techniques.

---

## Question 4

### Task
Run a Redis container.

### Command

```bash
docker run -d redis
```

### Explanation

| Part | Meaning |
|---|---|
| docker run | Create and start container |
| -d | Run in detached mode |
| redis | Redis image |

### Learning
Understood how containers are launched from images.

---

## Question 5

### Task
Stop the running Redis container.

### Commands

```bash
docker ps
```

```bash
docker stop <container_id>
```

### Example

```bash
docker stop 9c
```

### Learning
Learned container lifecycle management.

---

## Question 6

### Task
Verify currently running containers after stopping Redis.

### Command

```bash
docker ps | tail -n +2 | wc -l
```

### Output

```bash
0
```

### Learning
Verified stopped containers are removed from active process list.

---

## Question 7

### Task
Check total running containers again.

### Commands

```bash
docker ps
```

```bash
docker ps | tail -n +2 | wc -l
```

### Output

```bash
4
```

---

## Question 8

### Task
Check total containers present on host.

### Commands

```bash
docker ps -a
```

```bash
docker ps -a | tail -n +2 | wc -l
```

### Output

```bash
6
```

### Learning
Learned difference between:
- running containers
- stopped containers
- all containers

---

## Question 9

### Task
Identify image used by nginx-1 container.

### Command

```bash
docker ps -a | grep ngi
```

### Answer

```bash
nginx:alpine
```

### Learning
Used filtering with grep to inspect specific containers.

---

## Question 10

### Task
Find container created using Ubuntu image.

### Command

```bash
docker ps -a | grep ubun
```

### Answer

```bash
awesome_northcut
```

---

## Question 11

### Task
Find stopped Alpine container ID.

### Command

```bash
docker ps -a | grep alpine
```

### Output

```bash
0e3859be5f93 alpine "/bin/sh"
```

### Learning
Learned container identification and inspection.

---

## Question 12

### Task
Check state of stopped Alpine container.

### Command

```bash
docker ps -a | grep alpine
```

### Answer

```bash
Exited
```

### Learning
Understood Docker container states.

---

## Question 13

### Task
Remove all containers from host.

### Command

```bash
docker rm -f $(docker ps -aq)
```

### Explanation

| Part | Meaning |
|---|---|
| docker rm | Remove containers |
| -f | Force removal |
| docker ps -aq | Get all container IDs |

### Learning
Learned bulk cleanup operations.

---

## Question 14

### Task
Delete Ubuntu image.

### Command

```bash
docker rmi -f ubuntu
```

### Learning
Learned Docker image removal process.

---

## Question 15

### Task
Pull specific Nginx Alpine image.

### Command

```bash
docker pull nginx:1.14-alpine
```

### Learning
Learned image downloading from Docker Hub.

---

## Question 16

### Task
Run Nginx container named webapp.

### Command

```bash
docker run -d --name webapp nginx:1.14-alpine
```

### Explanation

| Part | Meaning |
|---|---|
| --name | Assign custom container name |
| nginx:1.14-alpine | Image and version |

### Learning
Learned named container deployment.

---

## Question 17

### Task
Cleanup Docker environment.

### Commands

```bash
docker rm -f $(docker ps -aq)
```

```bash
docker rmi -f $(docker images -q)
```

### Learning
Performed complete Docker cleanup process.

---

# Lab 2 : Docker Run & Networking

---

## Question 1

### Task
Check running containers.

### Command

```bash
docker ps
```

### Output

```bash
1
```

---

## Question 2

### Task
Identify image used by running container.

### Command

```bash
docker ps
```

### Answer

```bash
nginx:alpine
```

---

## Question 3

### Task
Check number of published ports.

### Command

```bash
docker ps --format '{{.Ports}}' | grep -oE '[0-9]+/tcp|[0-9]+/udp' | sort -u | wc -l
```

### Output

```bash
2
```

### Learning
Learned Docker port inspection and Linux text processing.

---

## Question 4

### Task
Find container-side mapped ports.

### Command

```bash
docker ps --format '{{.Ports}}' | grep -oE '>[0-9]+' | sort -u
```

### Output

```bash
3456
80
```

### Learning
Understood internal container networking.

---

## Question 5

### Task
Find host-side published ports.

### Command

```bash
docker ps --format '{{.Ports}}' | grep -oE ':[0-9]+' | sort -u
```

### Output

```bash
3456
38080
```

### Learning
Learned host-to-container port mapping.

---

## Question 6

### Task
Deploy blue application container.

### Requirements
- Container name: blue-app
- Host port: 38282
- Container port: 8080

### Command

```bash
docker run -d --name blue-app -p 38282:8080 kodekloud/simple-webapp:blue
```

### Explanation

| Part | Meaning |
|---|---|
| -p 38282:8080 | Host-to-container port mapping |
| kodekloud/simple-webapp:blue | Application image |

### Learning
Learned application deployment and custom port exposure.

---

# Important Docker Commands

| Purpose | Command |
|---|---|
| Docker version | docker -v |
| Running containers | docker ps |
| All containers | docker ps -a |
| List images | docker images |
| Pull image | docker pull |
| Run container | docker run |
| Stop container | docker stop |
| Remove container | docker rm |
| Remove image | docker rmi |

---

# Important Concepts Learned

| Concept | Description |
|---|---|
| Detached Mode | Run container in background |
| Port Mapping | Connect host and container ports |
| Image Tag | Specific image version |
| Container Lifecycle | Create, run, stop, remove |
| Host Networking | External machine networking |
| Container Networking | Internal container networking |

---

# Key Learning Outcomes

After completing these labs, I learned:

- Docker installation verification
- Running and managing containers
- Docker image handling
- Container inspection techniques
- Linux command-line filtering
- Docker networking basics
- Port publishing and exposure
- Container cleanup operations
- Host vs container architecture
- Docker command patterns used in real environments
