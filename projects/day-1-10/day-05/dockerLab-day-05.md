# Docker Lab 8 and Docker Lab 9

## Docker Registry, Docker Networking, Multi-Container Communication, and Custom Networks

---

# Introduction

This document contains detailed notes, commands, explanations, and concepts from Docker Lab 8 and Docker Lab 9.

The labs focused on:
- Docker Registry
- Docker image management
- Image tagging and pushing
- Local private registry setup
- Docker networking
- Bridge networking
- Host networking
- None networking
- Custom Docker networks
- Multi-container application deployment
- MySQL container deployment
- Web application networking

These labs provide practical understanding of Docker image distribution systems and Docker networking architecture.

---

# Docker Lab 8

# Docker Registry

## Question 2

### Question

What is a Docker Registry?

---

## Answer

A Docker Registry is a storage and distribution system for Docker images.

---

## Explanation

Docker registries allow users to:
- store images
- download images
- upload images
- share images across systems

Docker images are stored in repositories inside registries.

---

## Examples of Docker Registries

| Registry | Purpose |
|---|---|
| Docker Hub | Public Docker registry |
| AWS ECR | Amazon Elastic Container Registry |
| Azure Container Registry | Microsoft container registry |
| Private Registry | Self-hosted Docker registry |

---

## Important Terms

| Term | Meaning |
|---|---|
| Docker Image | Read-only template used to create containers |
| Registry | Storage system for Docker images |
| Repository | Collection of image versions |
| Tag | Version label for image |

---

# Question 3

## Question

By default, the Docker Engine interacts with which registry?

---

## Correct Answer

Docker Engine interacts with Docker Hub by default.

---

## Explanation

When users run:

```bash
docker pull nginx
```

Docker automatically searches:

```text
docker.io/library/nginx
```

This means Docker connects to Docker Hub unless another registry is specified.

---

## Full Forms

| Term | Full Form |
|---|---|
| Docker Engine | Core Docker Runtime Engine |
| Docker Hub | Docker Hosted Registry Platform |

---

# Question 5

## Question

Which command is used to login to a self-hosted registry?

---

## Command

```bash
docker login [SERVER]
```

---

## Example

```bash
docker login localhost:5000
```

---

## Explanation

This command authenticates the Docker client with a registry server.

---

## Command Breakdown

| Part | Meaning |
|---|---|
| docker | Docker CLI |
| login | Authenticate user |
| localhost:5000 | Registry server address |

---

## Related Commands

| Command | Purpose |
|---|---|
| docker logout | Remove login session |
| docker pull | Download image |
| docker push | Upload image |

---

# Question 6

## Question

Deploy a registry server named `my-registry` using image `registry:2`.

Requirements:
- Container name = my-registry
- Port mapping = 5000:5000
- Restart policy = always

---

## Command

```bash
docker run -d --name my-registry --restart always -p 5000:5000 registry:2
```

---

## Command Breakdown

| Part | Meaning |
|---|---|
| docker run | Create and start container |
| -d | Detached mode |
| --name my-registry | Assign container name |
| --restart always | Restart automatically |
| -p 5000:5000 | Port mapping |
| registry:2 | Docker registry image |

---

## Learning

This command creates a local private Docker registry running on port 5000.

---

## Full Forms

| Term | Full Form |
|---|---|
| CLI | Command Line Interface |
| TCP | Transmission Control Protocol |

---

# Question 7

## Question

Push the following images to local registry:
- nginx:latest
- httpd:latest

---

# Step 1: Pull Images

## Command

```bash
docker pull nginx:latest
docker pull httpd:latest
```

---

## Explanation

| Command | Meaning |
|---|---|
| docker pull | Download image |
| nginx:latest | Latest NGINX image |
| httpd:latest | Latest Apache HTTP Server image |

---

# Step 2: Tag Images

## Command

```bash
docker tag nginx:latest localhost:5000/nginx:latest
docker tag httpd:latest localhost:5000/httpd:latest
```

---

## Explanation

| Part | Meaning |
|---|---|
| docker tag | Create another image reference |
| localhost:5000 | Local registry |
| nginx:latest | Original image |
| localhost:5000/nginx:latest | New tagged image |

---

# Step 3: Push Images

## Command

```bash
docker push localhost:5000/nginx:latest
docker push localhost:5000/httpd:latest
```

---

## Explanation

| Part | Meaning |
|---|---|
| docker push | Upload image |
| localhost:5000 | Registry server |
| nginx:latest | Image repository |

---

# Verify Images in Registry

## Command

```bash
curl -X GET localhost:5000/v2/_catalog
```

---

## Explanation

| Part | Meaning |
|---|---|
| curl | Data transfer utility |
| -X GET | HTTP GET request |
| /v2/_catalog | Registry API endpoint |

---

## Learning

This verifies uploaded images stored inside local registry.

---

## Full Forms

| Term | Full Form |
|---|---|
| HTTP | HyperText Transfer Protocol |
| API | Application Programming Interface |
| NGINX | Engine X |
| HTTPD | HyperText Transfer Protocol Daemon |

---

# Question 8

## Question

Remove dangling images locally.

---

## Command

```bash
docker image prune -a
```

---

## Explanation

| Part | Meaning |
|---|---|
| docker image | Manage images |
| prune | Remove unused objects |
| -a | Remove all unused images |

---

# What are Dangling Images?

Dangling images are:
- untagged images
- unused layers
- leftover build images

These consume unnecessary disk space.

---

# Verification Command

## Command

```bash
docker image ls
```

---

## Purpose

Displays all locally stored Docker images.

---

# Question 10

## Question

Stop and remove `my-registry` container.

---

# Step 1: Check Running Containers

## Command

```bash
docker ps
```

---

## Step 2: Stop Container

## Command

```bash
docker stop my-registry
```

---

## Step 3: Remove Container

## Command

```bash
docker rm my-registry
```

---

## Combined Command

```bash
docker stop my-registry && docker rm my-registry
```

---

## Explanation

| Symbol | Meaning |
|---|---|
| && | Run second command if first succeeds |

---

# Important Docker Registry Commands

| Command | Purpose |
|---|---|
| docker pull | Download image |
| docker push | Upload image |
| docker tag | Tag image |
| docker login | Authenticate registry |
| docker logout | Logout registry |
| docker image ls | List images |
| docker image prune -a | Remove unused images |

---

# Docker Registry Architecture Flow

```text
Docker Registry
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

# Docker Lab 9

# Docker Networking

## Question 1

### Question

Identify the number of Docker networks existing on the system.

---

## Command

```bash
docker network ls
```

---

## Output

```text
bridge
host
none
```

---

## Answer

```text
3
```

---

## Command Breakdown

| Part | Meaning |
|---|---|
| docker | Docker CLI |
| network | Manage Docker networks |
| ls | List networks |

---

## Docker Default Networks

| Network | Meaning |
|---|---|
| bridge | Default isolated network |
| host | Shares host networking |
| none | No networking attached |

---

# Question 2

## Question

What is the ID associated with bridge network?

---

## Command

```bash
docker network ls
```

---

## Answer

```text
3cf7221ecd61
```

---

# Question 3

## Question

We just ran a container named alpine-1. Identify the network it is attached to.

---

## Command

```bash
docker inspect alpine-1 | grep -i net
```

---

## Important Output

```text
"NetworkMode": "host"
```

---

## Answer

```text
host
```

---

## Concepts

| Term | Meaning |
|---|---|
| inspect | Detailed object information |
| NetworkMode | Networking mode used |
| host mode | Container shares host networking |

---

# Question 4

## Question

What is the subnet configured on bridge network?

---

## Command

```bash
docker network inspect bridge | grep -i subnet
```

---

## Output

```text
"Subnet": "172.12.0.0/24"
```

---

## Answer

```text
172.12.0.0/24
```

---

# Question 5

## Question

Run a container named alpine-2 using the alpine image and attach it to the none network.

---

## Command

```bash
docker run --name alpine-2 --network none alpine
```

---

## Command Breakdown

| Part | Meaning |
|---|---|
| run | Create and start container |
| --name alpine-2 | Container name |
| --network none | Disable networking |
| alpine | Image name |

---

# Question 6

## Question

Create a new network named `wp-mysql-network` using bridge driver.

Requirements:
- Subnet = 182.18.0.0/24
- Gateway = 182.18.0.1

---

## Command

```bash
docker network create --driver bridge --subnet 182.18.0.0/24 --gateway 182.18.0.1 wp-mysql-network
```

---

## Command Breakdown

| Part | Meaning |
|---|---|
| network create | Create Docker network |
| --driver bridge | Use bridge networking |
| --subnet | Define subnet |
| --gateway | Define gateway |
| wp-mysql-network | Network name |

---

## Concepts

| Term | Meaning |
|---|---|
| subnet | Logical IP network segment |
| gateway | Entry/exit point of network |
| CIDR | Classless Inter-Domain Routing |

---

# Question 7

## Question

Deploy MySQL database container using image `mysql:5.7`.

Requirements:
- Container name = mysql-db
- Attach to wp-mysql-network
- Root password = db_pass123

---

## Command

```bash
docker run -d -e MYSQL_ROOT_PASSWORD=db_pass123 --name mysql-db --network wp-mysql-network mysql:5.7
```

---

## Command Breakdown

| Part | Meaning |
|---|---|
| -d | Detached mode |
| -e | Environment variable |
| MYSQL_ROOT_PASSWORD | Root password variable |
| --name mysql-db | Container name |
| --network | Attach network |
| mysql:5.7 | MySQL image |

---

# Question 8

## Question

Deploy web application using image:

```text
kodekloud/simple-webapp-mysql
```

Requirements:
- Host port = 38080
- Container port = 8080
- Attach to wp-mysql-network
- Environment variables:
  - DB_Host=mysql-db
  - DB_Password=db_pass123

---

## Command

```bash
docker run --network=wp-mysql-network -e DB_Host=mysql-db -e DB_Password=db_pass123 -p 38080:8080 --name webapp --link mysql-db:mysql-db -d kodekloud/simple-webapp-mysql
```

---

## Command Breakdown

| Part | Meaning |
|---|---|
| --network | Attach Docker network |
| -e DB_Host=mysql-db | Database hostname |
| -e DB_Password=db_pass123 | Database password |
| -p 38080:8080 | Port mapping |
| --name webapp | Container name |
| --link mysql-db:mysql-db | Link MySQL container |
| -d | Detached mode |

---

# Port Mapping

```text
HOST_PORT:CONTAINER_PORT
38080:8080
```

Meaning:
- Browser accesses port 38080
- Request forwarded to container port 8080

---

# Question 9

## Verification

Open browser:

```text
HOST:38080
```

---

## Result

```text
SUCCESS
Successfully connected to the MySQL database.
```

---

## Meaning

The web application successfully:
- connected to MySQL
- used environment variables correctly
- communicated through Docker network

---

# Important Docker Networking Concepts

| Network Type | Meaning |
|---|---|
| bridge | Default isolated Docker network |
| host | Shares host network stack |
| none | No networking |
| custom bridge | User-created isolated network |

---

# Important Docker Networking Commands

| Command | Purpose |
|---|---|
| docker network ls | List networks |
| docker network inspect | Network details |
| docker inspect | Container details |
| docker network create | Create network |
| docker run | Create/start container |
| docker ps | Running containers |

---

# Overall Lab Objectives

These labs helped understand:
1. Docker Registry architecture
2. Image tagging and pushing
3. Private registry deployment
4. Docker network inspection
5. Bridge networking
6. Host networking
7. None networking
8. Custom Docker networks
9. Multi-container communication
10. MySQL container deployment
11. Environment variables
12. Port forwarding
13. Web application deployment
14. Container networking architecture

---

# Conclusion

Docker Lab 8 and Docker Lab 9 provided practical understanding of Docker image distribution systems and Docker networking architecture.

The labs demonstrated:
- how Docker registries manage image storage and distribution
- how Docker networks isolate and connect containers
- how multi-container applications communicate
- how databases and applications interact inside custom networks

These concepts are fundamental in:
- DevOps engineering
- Cloud infrastructure
- Container orchestration
- Backend deployment
- Microservices architecture
- Cybersecurity infrastructure