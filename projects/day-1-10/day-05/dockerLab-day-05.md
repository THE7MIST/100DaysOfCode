# Docker Lab 8 and Docker Lab 9
## Docker Registry, Image Management, Docker Networking, and Multi-Container Communication

# Introduction

This document contains detailed explanations, command breakdowns, concepts, architecture, and practical understanding from Docker Lab 8 and Docker Lab 9.

The labs focused on:
- Docker Registry
- Image storage and distribution
- Docker image tagging and pushing
- Private registry deployment
- Docker networking
- Bridge networking
- Host networking
- None networking
- Custom Docker networks
- Multi-container communication
- MySQL container deployment
- Web application deployment
- Environment variables
- Port mapping

These labs provided practical understanding of how Docker images are distributed and how containers communicate inside Docker networks.

---

# Docker Lab 8
# Docker Registry and Image Distribution

# What is a Docker Registry?

A Docker Registry is a storage and distribution system for Docker images.

Registries allow users to:
- upload Docker images
- download Docker images
- store versions
- share containerized applications

Examples:
- Docker Hub
- AWS ECR
- Azure Container Registry
- Private Docker Registry

---

# Important Docker Registry Concepts

| Term | Meaning |
|---|---|
| Docker Image | Read-only template used to create containers |
| Registry | Storage location for Docker images |
| Repository | Collection of image versions |
| Tag | Version label of image |

---

# Docker Hub

Docker Hub is Docker’s default public registry.

When executing:

```bash
docker pull nginx
```

Docker automatically searches:

```text
docker.io/library/nginx
```

This means Docker communicates with Docker Hub unless another registry is specified.

---

# Docker Login

Docker login authenticates the Docker client with a registry server.

## Command

```bash
docker login localhost:5000
```

---

# Command Breakdown

| Part | Meaning |
|---|---|
| docker | Docker CLI |
| login | Authenticate user |
| localhost:5000 | Registry server address |

---

# Related Registry Commands

| Command | Purpose |
|---|---|
| docker login | Authenticate registry |
| docker logout | Remove login session |
| docker pull | Download image |
| docker push | Upload image |

---

# Deploying Private Docker Registry

## Command

```bash
docker run -d --name my-registry --restart always -p 5000:5000 registry:2
```

---

# Command Explanation

| Part | Meaning |
|---|---|
| docker run | Create and start container |
| -d | Detached mode |
| --name my-registry | Assign container name |
| --restart always | Restart automatically after reboot |
| -p 5000:5000 | Port mapping |
| registry:2 | Docker registry image |

---

# Registry Architecture Flow

```text
Docker Hub / Registry
        ↓
   docker pull
        ↓
   Local Images
        ↓
   docker run
        ↓
    Container
        ↓
   docker push
        ↓
 Private Registry
```

---

# Pulling Docker Images

## Commands

```bash
docker pull nginx:latest
docker pull httpd:latest
```

---

# Purpose

Downloads images from Docker Hub into local Docker image storage.

---

# Image Tagging

## Commands

```bash
docker tag nginx:latest localhost:5000/nginx:latest
docker tag httpd:latest localhost:5000/httpd:latest
```

---

# Why Tagging is Required

Docker needs registry reference information before pushing images.

Tag format:

```text
REGISTRY/IMAGE:TAG
```

Example:

```text
localhost:5000/nginx:latest
```

---

# Docker Push

## Commands

```bash
docker push localhost:5000/nginx:latest
docker push localhost:5000/httpd:latest
```

---

# Purpose

Uploads images into local private registry.

---

# Registry Verification

## Command

```bash
curl -X GET localhost:5000/v2/_catalog
```

---

# Purpose

Displays repositories stored inside registry.

---

# Command Breakdown

| Part | Meaning |
|---|---|
| curl | Data transfer utility |
| -X GET | HTTP GET request |
| /v2/_catalog | Docker Registry API endpoint |

---

# Dangling Images

## Definition

Dangling images are:
- untagged images
- unused layers
- leftover build images

These consume unnecessary storage space.

---

# Remove Dangling Images

## Command

```bash
docker image prune -a
```

---

# Command Breakdown

| Part | Meaning |
|---|---|
| docker image | Image management |
| prune | Remove unused objects |
| -a | Remove all unused images |

---

# List Docker Images

## Command

```bash
docker image ls
```

Displays all locally stored images.

---

# Stopping and Removing Registry

## Stop Container

```bash
docker stop my-registry
```

## Remove Container

```bash
docker rm my-registry
```

---

# Combined Command

```bash
docker stop my-registry && docker rm my-registry
```

---

# Logical AND Operator

| Symbol | Meaning |
|---|---|
| && | Run second command only if first succeeds |

---

# Important Docker Registry Commands

| Command | Purpose |
|---|---|
| docker pull | Download image |
| docker push | Upload image |
| docker tag | Create image reference |
| docker login | Registry authentication |
| docker logout | Logout registry |
| docker image prune -a | Remove unused images |

---

# Docker Lab 9
# Docker Networking and Multi-Container Communication

# Docker Networking

Docker networking allows containers to communicate:
- with each other
- with host machine
- with external systems

Every Docker container receives:
- IP address
- virtual network interface
- network namespace

---

# List Docker Networks

## Command

```bash
docker network ls
```

---

# Default Docker Networks

| Network | Meaning |
|---|---|
| bridge | Default isolated Docker network |
| host | Uses host machine networking |
| none | No networking attached |

---

# Bridge Network

Bridge is Docker’s default isolated network.

Characteristics:
- containers communicate internally
- isolated from host network
- Docker creates virtual bridge interface

---

# Host Network

Host network mode allows containers to share host networking stack.

Characteristics:
- no isolation
- container uses host IP directly
- higher performance

---

# None Network

None network disables networking completely.

Characteristics:
- no internet access
- no container communication
- fully isolated

---

# Inspecting Container Network

## Command

```bash
docker inspect alpine-1 | grep -i net
```

---

# Important Output

```text
"NetworkMode": "host"
```

Meaning:
- container uses host networking

---

# Inspecting Bridge Network

## Command

```bash
docker network inspect bridge | grep -i subnet
```

---

# Output

```text
"Subnet": "172.12.0.0/24"
```

---

# Subnet Meaning

A subnet is a logical network segment.

Example:

```text
172.12.0.0/24
```

Meaning:
- network range allocated to Docker bridge network

---

# Creating Container Without Networking

## Command

```bash
docker run --name alpine-2 --network none alpine
```

---

# Purpose

Creates container with:
- no internet access
- no external communication
- isolated networking

---

# Creating Custom Docker Network

## Command

```bash
docker network create --driver bridge --subnet 182.18.0.0/24 --gateway 182.18.0.1 wp-mysql-network
```

---

# Command Breakdown

| Part | Meaning |
|---|---|
| network create | Create Docker network |
| --driver bridge | Use bridge driver |
| --subnet | Define subnet |
| --gateway | Define gateway IP |
| wp-mysql-network | Network name |

---

# CIDR Notation

CIDR means:

```text
Classless Inter-Domain Routing
```

Example:

```text
182.18.0.0/24
```

Defines:
- network range
- subnet mask

---

# Deploying MySQL Database

## Command

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=db_pass123 --name mysql-db --network wp-mysql-network mysql:5.7
```

---

# Purpose

Deploys MySQL container connected to custom Docker network.

---

# Environment Variables

Example:

```bash
-e MYSQL_ROOT_PASSWORD=db_pass123
```

Purpose:
- configure container during startup
- pass runtime settings

---

# Deploying Web Application

## Command

```bash
docker run --network=wp-mysql-network -e DB_Host=mysql-db -e DB_Password=db_pass123 -p 38080:8080 --name webapp --link mysql-db:mysql-db -d kodekloud/simple-webapp-mysql
```

---

# Command Breakdown

| Part | Meaning |
|---|---|
| --network | Attach network |
| -e DB_Host=mysql-db | Database hostname |
| -e DB_Password=db_pass123 | Database password |
| -p 38080:8080 | Port mapping |
| --name webapp | Container name |
| --link mysql-db:mysql-db | Link MySQL container |
| -d | Detached mode |

---

# Port Mapping

Port mapping format:

```text
HOST_PORT:CONTAINER_PORT
```

Example:

```text
38080:8080
```

Meaning:
- browser accesses host port 38080
- traffic forwards to container port 8080

---

# Multi-Container Communication

The web application successfully communicated with MySQL because:
- both containers shared same Docker network
- correct environment variables were passed
- Docker networking resolved container names internally

---

# Docker Networking Architecture

```text
Browser
   ↓
Host Port 38080
   ↓
Web Application Container
   ↓
Docker Network
   ↓
MySQL Container
```

---

# Important Docker Networking Concepts

| Network Type | Meaning |
|---|---|
| bridge | Default isolated network |
| host | Uses host networking |
| none | No networking |
| custom bridge | User-created isolated network |

---

# Important Docker Networking Commands

| Command | Purpose |
|---|---|
| docker network ls | List networks |
| docker network inspect | Inspect network |
| docker network create | Create network |
| docker inspect | Container details |
| docker run | Create container |
| docker ps | Running containers |

---

# Full Forms

| Short Form | Full Form |
|---|---|
| CLI | Command Line Interface |
| TCP | Transmission Control Protocol |
| HTTP | HyperText Transfer Protocol |
| API | Application Programming Interface |
| CIDR | Classless Inter-Domain Routing |
| IP | Internet Protocol |
| DNS | Domain Name System |
| NGINX | Engine X |
| HTTPD | HyperText Transfer Protocol Daemon |

---

# Key Learning Outcomes

After completing Docker Lab 8 and Docker Lab 9, the following concepts became clear:

- Docker image distribution
- Docker Registry architecture
- Private registry deployment
- Docker image tagging and pushing
- Registry authentication
- Docker networking modes
- Bridge networking
- Host networking
- None networking
- Custom Docker networks
- Multi-container communication
- Environment variables in Docker
- Port mapping and forwarding
- MySQL and web application integration

---

# Conclusion

Docker Lab 8 and Docker Lab 9 provided strong practical understanding of:
- Docker Registry management
- Image distribution workflows
- Docker networking architecture
- Multi-container application deployment

These concepts are essential for:
- DevOps engineering
- Cloud infrastructure
- Container orchestration
- Backend deployment
- Production container environments

Understanding Docker networking and registries is fundamental for building scalable, secure, and distributed containerized systems.