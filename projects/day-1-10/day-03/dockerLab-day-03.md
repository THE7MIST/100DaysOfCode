# Docker Lab 5 and Lab 6
## ENTRYPOINT, CMD, Container Startup Commands, Redis, Docker Compose, and Multi-Container Applications

---

# Introduction

This document contains detailed notes for Docker Lab 5 and Docker Lab 6.

The labs focused on:
- ENTRYPOINT and CMD instructions
- Container startup behavior
- Running containers with custom commands
- Redis container deployment
- Container linking
- Multi-container applications
- Docker Compose
- Port mapping
- Service dependencies

These labs provided practical understanding of how Docker containers start, communicate, and operate together in real environments.

---

# Docker Lab 5

## Objective

The purpose of this lab was to understand:
- Docker ENTRYPOINT instruction
- Docker CMD instruction
- Final startup commands inside containers
- Running custom startup commands
- Docker container execution flow

---

# ENTRYPOINT in Docker

## Definition

`ENTRYPOINT` defines the main executable command of a container.

It specifies:
- what program always runs when container starts

Example:

```dockerfile
ENTRYPOINT ["python"]
```

This means the container always starts using Python.

---

# CMD in Docker

## Definition

`CMD` provides default arguments to ENTRYPOINT.

It specifies:
- default command or arguments used during container startup

Example:

```dockerfile
CMD ["app.py"]
```

---

# ENTRYPOINT + CMD

## Important Concept

Docker combines:

```text
ENTRYPOINT + CMD
```

to form the final startup command.

---

## Example

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

Final executed command:

```bash
python app.py
```

---

# Lab 5 Tasks and Concepts

## MySQL ENTRYPOINT Analysis

The MySQL Dockerfile was inspected to identify the ENTRYPOINT instruction.

### Command Used

```bash
cat Dockerfile-mysql | grep -i entry
```

### Result

```dockerfile
ENTRYPOINT ["docker-entrypoint.sh"]
```

### Learning

Understood how containers define startup executables.

---

## WordPress CMD Analysis

The WordPress Dockerfile was inspected to identify the CMD instruction.

### Command Used

```bash
cat Dockerfile-wordpress | grep -i cmd
```

### Result

```dockerfile
CMD ["apache2-foreground"]
```

### Learning

Learned how CMD provides default startup arguments.

---

## Final Startup Command

The lab demonstrated how Docker combines ENTRYPOINT and CMD.

### ENTRYPOINT

```dockerfile
ENTRYPOINT ["docker-entrypoint.sh"]
```

### CMD

```dockerfile
CMD ["apache2-foreground"]
```

### Final Startup Command

```bash
docker-entrypoint.sh apache2-foreground
```

### Learning

Understood Docker container execution flow and command hierarchy.

---

## Ubuntu Startup Command

The Ubuntu image was inspected to determine its default startup command.

### Result

```dockerfile
CMD ["bash"]
```

### Learning

Learned that Ubuntu containers start using Bash shell by default.

---

## Running Custom Commands

An Ubuntu container was started using a custom startup command.

### Command

```bash
docker run -d ubuntu sleep 1000
```

### Meaning

The container runs:

```bash
sleep 1000
```

instead of the default Bash shell.

### Learning

Learned how runtime commands override default CMD instructions.

---

# Docker Lab 6

## Objective

The purpose of this lab was to understand:
- Redis container deployment
- Container communication
- Docker linking
- Multi-container applications
- Docker Compose
- Service dependencies
- Port mapping

---

# Redis Container Deployment

## Redis Overview

Redis is an in-memory database commonly used for:
- caching
- counters
- session storage
- fast key-value storage

---

## Redis Container Creation

### Command

```bash
docker run -d --name redis redis:alpine
```

### Learning

Learned:
- container naming
- detached mode
- lightweight Alpine-based images

---

# Multi-Container Application

## Click Counter Application

A web application container was connected to Redis using Docker linking.

### Command

```bash
docker run -d --name clickcounter --link redis:redis -p 8085:5000 kodekloud/click-counter
```

---

## Port Mapping

### Structure

```text
HOST_PORT:CONTAINER_PORT
```

### Example

```text
8085:5000
```

Meaning:
- Host system exposes port 8085
- Container internally runs application on port 5000

---

## Container Linking

### Syntax

```bash
--link source_container:alias
```

### Example

```bash
--link redis:redis
```

### Purpose

Allows containers to communicate with each other.

### Learning

Understood inter-container communication.

---

# Container Verification

## Command

```bash
docker ps
```

### Purpose

Displays:
- running containers
- container IDs
- image names
- ports
- status

### Learning

Learned container inspection and monitoring.

---

# Container Removal

## Stop Containers

```bash
docker stop 8f 39
```

## Remove Containers

```bash
docker rm 8f 39
```

### Learning

Understood container lifecycle management:
- start
- stop
- remove

---

# Docker Compose

## Definition

Docker Compose is used to manage multi-container applications using a YAML configuration file.

---

# docker-compose.yml

## File Structure

```yaml
version: '3.8'

services:
  redis:
    image: redis:alpine
    restart: always

  clickcounter:
    image: kodekloud/click-counter
    ports:
      - "8085:5000"
    depends_on:
      - redis
    restart: always
```

---

# Docker Compose Execution

## Command

```bash
docker-compose up -d
```

### Purpose

- Creates services
- Starts containers
- Runs application in background

### Learning

Learned infrastructure orchestration using Docker Compose.

---

# Port Conflict Error

## Error

```text
Bind for 0.0.0.0:8085 failed: port is already allocated
```

---

## Cause

Port 8085 was already occupied by another container.

---

## Fix

### Stop Old Container

```bash
docker stop clickcounter
```

### Remove Old Container

```bash
docker rm clickcounter
```

### Restart Compose

```bash
docker-compose up -d
```

### Learning

Understood Docker port conflicts and troubleshooting.

---

# Important Docker Concepts Learned

| Concept | Meaning |
|---|---|
| ENTRYPOINT | Main executable command |
| CMD | Default arguments or command |
| Detached Mode | Run container in background |
| Port Mapping | Connect host port to container port |
| Docker Compose | Multi-container orchestration |
| Service Dependency | One service depends on another |
| Container Linking | Communication between containers |

---

# Important Commands Used

| Purpose | Command |
|---|---|
| Run container | docker run |
| Run detached | docker run -d |
| Stop container | docker stop |
| Remove container | docker rm |
| List containers | docker ps |
| Read Dockerfile | cat Dockerfile |
| Search text | grep |
| Start Compose services | docker-compose up -d |

---

# Full Forms

| Term | Full Form |
|---|---|
| CMD | Command |
| CLI | Command Line Interface |
| YAML | YAML Ain't Markup Language |
| Redis | Remote Dictionary Server |
| MySQL | My Structured Query Language |
| PS | Process Status |
| RM | Remove |
| TCP | Transmission Control Protocol |
| IP | Internet Protocol |

---

# Learning Outcomes

After completing these labs, the following concepts became clear:

- Docker startup command execution
- Difference between ENTRYPOINT and CMD
- Runtime command overriding
- Multi-container application deployment
- Redis integration
- Container networking
- Docker Compose orchestration
- Port mapping and troubleshooting
- Container lifecycle management

---

# Conclusion

Docker Lab 5 and Docker Lab 6 provided practical understanding of container startup behavior, multi-container applications, and Docker orchestration.

The labs demonstrated how Docker containers communicate, how applications are deployed using Compose, and how startup commands control container execution.

These concepts are fundamental in DevOps, cloud infrastructure, and containerized application deployment environments.
