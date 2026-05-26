# Docker Labs 07

## Introduction

This document contains detailed Docker theory, practical lab explanations, command breakdowns, internal working concepts, and real-world containerization understanding based on Docker labs and hands-on experimentation. :contentReference[oaicite:0]{index=0}

The focus areas include:
- Docker architecture
- Docker images and containers
- Docker storage
- ENTRYPOINT and CMD
- MySQL container deployment
- Docker volumes
- Persistent storage
- Docker networking
- Overlay2 storage driver
- Container lifecycle
- Docker Compose
- Multi-container applications

This document is designed to provide both conceptual understanding and practical operational knowledge of Docker.

---

# What is Docker?

Docker is a containerization platform used to package, deploy, and run applications inside isolated environments called containers.

A container includes:
- Application code
- Runtime
- Libraries
- Dependencies
- Configuration files

Docker ensures applications behave consistently across different systems and environments.

---

# Why Docker is Important

Traditional application deployment often causes:
- dependency conflicts
- environment mismatch
- deployment inconsistency

Docker solves these problems by packaging everything required by the application into a portable container.

Benefits:
- Fast deployment
- Lightweight virtualization
- Isolation
- Portability
- Scalability
- Efficient resource usage

---

# Virtual Machine vs Docker Container

| Virtual Machine | Docker Container |
|---|---|
| Uses full operating system | Shares host kernel |
| Heavyweight | Lightweight |
| Slower startup | Faster startup |
| Higher memory usage | Lower memory usage |
| Requires hypervisor | Requires Docker Engine |

---

# Docker Architecture

Docker architecture mainly contains the following components:

| Component | Purpose |
|---|---|
| Docker Client | User interface for Docker commands |
| Docker Daemon | Background service managing Docker operations |
| Docker Engine | Core runtime environment |
| Docker Images | Read-only templates |
| Containers | Running instances of images |
| Docker Registry | Stores Docker images |

---

# Docker Client

The Docker Client is the command-line interface used by users.

Example:

```bash
docker run ubuntu
```

The client sends commands to the Docker Daemon.

---

# Docker Daemon

Docker Daemon is the background service responsible for:
- building images
- running containers
- managing networks
- managing storage

It continuously listens for Docker commands.

---

# Docker Image

A Docker image is a read-only blueprint used to create containers.

It contains:
- operating system layers
- application binaries
- dependencies
- runtime configuration

Examples:

```bash
ubuntu
mysql
nginx
redis
```

---

# Docker Container

A container is a running instance of an image.

Conceptually:

```text
Docker Image + Execution = Docker Container
```

When a container starts, Docker creates:
- isolated filesystem
- network namespace
- process space
- runtime environment

---

# Docker Storage Location

Docker stores internal data inside:

```bash
/var/lib/docker
```

This location contains:
- images
- containers
- networks
- volumes
- metadata
- logs

---

# Explanation of `/var/lib/docker`

| Path Part | Meaning |
|---|---|
| `/` | Root directory |
| `var` | Variable data |
| `lib` | Application data |
| `docker` | Docker storage directory |

---

# Important Directories Inside Docker Storage

| Directory | Purpose |
|---|---|
| containers | Container metadata |
| image | Docker image storage |
| overlay2 | Layered filesystem storage |
| volumes | Persistent storage |
| network | Docker networking files |
| tmp | Temporary files |

---

# Listing Docker Storage

## Command

```bash
ls /var/lib/docker
```

## Purpose

Displays Docker internal storage directories.

## Learning

Helps understand where Docker stores:
- container files
- image layers
- metadata
- networking information

---

# Docker Container Metadata

## Command

```bash
docker ps -a
```

Displays:
- container IDs
- names
- images
- states
- status

---

# Container Metadata Storage

Each container gets a unique directory:

```bash
/var/lib/docker/containers/<container-id>
```

This stores:
- logs
- configuration
- hostname
- network configuration
- DNS configuration

---

# Important Container Files

| File | Purpose |
|---|---|
| config.v2.json | Container configuration |
| hostconfig.json | Host-side settings |
| hostname | Container hostname |
| resolv.conf | DNS configuration |
| hosts | Host mappings |
| json.log | Container logs |

---

# Running MySQL Container

## Command

```bash
docker run -d --name mysql-db -e MYSQL_ROOT_PASSWORD=db_pass123 mysql
```

---

# Command Breakdown

| Part | Meaning |
|---|---|
| docker | Docker CLI |
| run | Create and start container |
| -d | Detached mode |
| --name mysql-db | Assign custom name |
| -e | Environment variable |
| MYSQL_ROOT_PASSWORD | MySQL root password |
| mysql | MySQL image |

---

# Internal Working of `docker run`

When executed, Docker:
1. Pulls image if unavailable
2. Creates writable layer
3. Configures networking
4. Starts container process
5. Executes startup commands

---

# Detached Mode

Detached mode runs containers in the background.

Example:

```bash
docker run -d nginx
```

Without detached mode:
- terminal remains attached
- logs continuously display

---

# Container Naming

Example:

```bash
--name mysql-db
```

Purpose:
- easier management
- easier logging
- easier container control

Example commands:

```bash
docker stop mysql-db
docker logs mysql-db
docker rm mysql-db
```

---

# Environment Variables

Environment variables pass configuration into containers.

Example:

```bash
-e MYSQL_ROOT_PASSWORD=db_pass123
```

Docker injects this value into the container environment.

MySQL startup scripts then:
- create root user
- assign password
- initialize database

---

# MySQL Docker Image

The official MySQL image contains:
- Linux base image
- MySQL binaries
- startup scripts
- database engine

---

# Docker ENTRYPOINT

ENTRYPOINT defines the main executable command of a container.

Example:

```dockerfile
ENTRYPOINT ["docker-entrypoint.sh"]
```

This command always executes during container startup.

---

# Docker CMD

CMD provides default arguments to ENTRYPOINT.

Example:

```dockerfile
CMD ["apache2-foreground"]
```

---

# ENTRYPOINT + CMD

Docker combines both instructions:

```text
ENTRYPOINT + CMD
```

Example:

```dockerfile
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apache2-foreground"]
```

Final executed command:

```bash
docker-entrypoint.sh apache2-foreground
```

---

# Running Custom Commands

Example:

```bash
docker run -d ubuntu sleep 1000
```

The container executes:

```bash
sleep 1000
```

instead of the default Bash shell.

This overrides the default CMD instruction.

---

# Docker Volumes

Volumes provide persistent storage for containers.

Example:

```bash
docker run -v /opt/data:/var/lib/mysql -d --name mysql-db -e MYSQL_ROOT_PASSWORD=db_pass123 mysql
```

---

# Volume Mapping

Volume syntax:

```text
HOST_PATH:CONTAINER_PATH
```

Example:

```text
/opt/data:/var/lib/mysql
```

Meaning:
- `/opt/data` exists on host
- `/var/lib/mysql` exists inside container

Docker synchronizes data between them.

---

# Why Volumes are Important

Without volumes:
- data disappears when container is removed

With volumes:
- data survives deletion and restart

Important for:
- databases
- logs
- uploads
- configuration files

---

# Persistent Storage

Persistent storage means data remains available even after:
- restart
- crash
- container recreation

Critical for production systems.

---

# Docker Networking

Every Docker container receives:
- IP address
- network namespace
- virtual network interface

Docker automatically creates a bridge network.

---

# Port Mapping

Port mapping connects host ports with container ports.

Example:

```bash
-p 8085:5000
```

Meaning:
- Host exposes port 8085
- Container internally uses port 5000

---

# Container Linking

Container linking enables communication between containers.

Example:

```bash
--link redis:redis
```

Purpose:
- application container communicates with Redis container

---

# Redis Container Deployment

## Command

```bash
docker run -d --name redis redis:alpine
```

Redis is commonly used for:
- caching
- counters
- session management
- fast key-value storage

---

# Multi-Container Application

## Command

```bash
docker run -d --name clickcounter --link redis:redis -p 8085:5000 kodekloud/click-counter
```

This deploys:
- application container
- Redis backend
- network communication

---

# Docker Compose

Docker Compose manages multi-container applications using YAML configuration files.

---

# Example Compose File

```yaml
version: '3.8'

services:
  redis:
    image: redis:alpine

  clickcounter:
    image: kodekloud/click-counter
    ports:
      - "8085:5000"
    depends_on:
      - redis
```

---

# Docker Compose Execution

## Command

```bash
docker-compose up -d
```

Purpose:
- create services
- start containers
- orchestrate dependencies

---

# Service Dependency

Example:

```yaml
depends_on:
  - redis
```

Ensures Redis starts before application container.

---

# Port Conflict Error

## Error

```text
Bind for 0.0.0.0:8085 failed: port is already allocated
```

Cause:
- another container already uses port 8085

Fix:

```bash
docker stop clickcounter
docker rm clickcounter
docker-compose up -d
```

---

# Overlay2 Storage Driver

Overlay2 is Docker’s layered filesystem driver.

Purpose:
- efficient image storage
- shared layers
- reduced disk usage

---

# Layered Filesystem Structure

Docker images are built in layers:

```text
Base OS Layer
Application Layer
Dependency Layer
Configuration Layer
Writable Container Layer
```

Advantages:
- faster builds
- reduced storage
- shared caching

---

# Docker Container Lifecycle

| State | Meaning |
|---|---|
| Created | Container initialized |
| Running | Container executing |
| Paused | Temporarily suspended |
| Exited | Process stopped |
| Removed | Container deleted |

---

# Important Docker Commands

| Command | Purpose |
|---|---|
| docker ps | Running containers |
| docker ps -a | All containers |
| docker images | List images |
| docker run | Create container |
| docker stop | Stop container |
| docker start | Start existing container |
| docker rm | Remove container |
| docker logs | View logs |
| docker exec | Execute inside container |

---

# Important Full Forms

| Short Form | Full Form |
|---|---|
| CLI | Command Line Interface |
| DB | Database |
| SQL | Structured Query Language |
| JSON | JavaScript Object Notation |
| DNS | Domain Name System |
| VM | Virtual Machine |
| TCP | Transmission Control Protocol |
| IP | Internet Protocol |

---

# Key Learning Outcomes

After completing these Docker labs and theory sections, the following concepts became clear:

- Docker architecture
- Image and container relationship
- Docker storage internals
- Container metadata
- ENTRYPOINT and CMD behavior
- Runtime command overriding
- Persistent storage using volumes
- Multi-container deployment
- Redis integration
- Docker networking
- Docker Compose orchestration
- Layered filesystem architecture
- Container lifecycle management

---

# Conclusion

Docker simplifies modern application deployment by providing isolated, portable, and lightweight runtime environments called containers.

Understanding Docker internals such as:
- storage
- networking
- startup commands
- volumes
- orchestration

is essential for DevOps engineering, cloud infrastructure, backend deployment, and cybersecurity operations.

These practical labs and theoretical concepts provide a strong foundation for working with real-world containerized systems and scalable infrastructure environments.
