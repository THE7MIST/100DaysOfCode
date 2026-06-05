# Docker Swarm Lab

## Overview

This lab covers Docker Swarm fundamentals including:

- Service creation and scaling
- Replica management
- Task scheduling
- Node maintenance
- Rolling updates
- Overlay networking

---

# Question 1

## Task

Create an Nginx service with 3 replicas, expose it on port 80, verify access from a browser, then scale it to 5 replicas.

---

## Step 1: Initialize Swarm

### Command

```bash
docker swarm init
```

### Explanation

Creates a Docker Swarm cluster and makes the current machine the Manager Node.

---

## Step 2: Create Service

### Command

```bash
docker service create --name nginx-service --replicas 3 -p 80:80 nginx
```

### Explanation

Creates an Nginx service with 3 replicas and publishes port 80.

---

## Step 3: Verify Service

### Command

```bash
docker service ls
```

### Explanation

Displays running services and replica count.

---

## Step 4: Scale Service

### Command

```bash
docker service scale nginx-service=5
```

### Explanation

Increases replicas from 3 to 5.

---

## Step 5: Verify Scaling

### Command

```bash
docker service ps nginx-service
```

### Explanation

Displays all running tasks.

---

## Cleanup

### Remove Service

```bash
docker service rm nginx-service
```

### Leave Swarm

```bash
docker swarm leave --force
```

---

# Question 2

## Task

Create a service with 2 replicas and inspect where the containers are running.

---

## Step 1: Initialize Swarm

### Command

```bash
docker swarm init
```

---

## Step 2: Create Service

### Command

```bash
docker service create --name web --replicas 2 nginx
```

### Explanation

Creates a service with 2 containers.

---

## Step 3: Inspect Tasks

### Command

```bash
docker service ps web
```

### Explanation

Displays tasks and the node on which each container is running.

---

## Concept Learned

Docker Swarm automatically schedules containers on available nodes.

---

## Cleanup

### Remove Service

```bash
docker service rm web
```

### Leave Swarm

```bash
docker swarm leave --force
```

---

# Question 3

## Task

Simulate node maintenance by draining a worker node.

---

## Step 1: List Nodes

### Command

```bash
docker node ls
```

### Explanation

Lists all nodes in the swarm.

---

## Step 2: Drain Worker Node

### Command

```bash
docker node update --availability drain worker1
```

### Explanation

Marks worker1 unavailable for scheduling.

---

## Step 3: Verify Task Migration

### Command

```bash
docker service ps nginx-service
```

### Explanation

Observe tasks moving to another node.

---

## Step 4: Restore Node

### Command

```bash
docker node update --availability active worker1
```

### Explanation

Makes the node available again.

---

## Concept Learned

Swarm maintains service availability during node maintenance.

---

## Cleanup

### Remove Service

```bash
docker service rm nginx-service
```

### Leave Swarm

```bash
docker swarm leave --force
```

---

# Question 4

## Task

Perform a rolling update from Nginx latest to Nginx alpine.

---

## Step 1: Initialize Swarm

### Command

```bash
docker swarm init
```

---

## Step 2: Create Service

### Command

```bash
docker service create --name web --replicas 3 nginx
```

---

## Step 3: Update Service Image

### Command

```bash
docker service update --image nginx:alpine web
```

### Explanation

Updates containers one by one.

---

## Step 4: Verify Update

### Command

```bash
docker service ps web
```

### Explanation

Verify updated containers.

---

## Concept Learned

Rolling updates provide near-zero downtime deployment.

---

## Cleanup

### Remove Service

```bash
docker service rm web
```

### Leave Swarm

```bash
docker swarm leave --force
```

---

# Question 5

## Task

Create an overlay network and attach a service to it.

---

## Step 1: Initialize Swarm

### Command

```bash
docker swarm init
```

---

## Step 2: Create Overlay Network

### Command

```bash
docker network create -d overlay mynet
```

### Explanation

Creates a swarm-wide overlay network.

---

## Step 3: Deploy Service

### Command

```bash
docker service create --name web --network mynet nginx
```

### Explanation

Deploys the service on the overlay network.

---

## Step 4: Inspect Network

### Command

```bash
docker network inspect mynet
```

### Explanation

Displays network information.

---

## Concept Learned

Overlay networks allow communication between containers running on different swarm nodes.

---

## Cleanup

### Remove Service

```bash
docker service rm web
```

### Remove Network

```bash
docker network rm mynet
```

### Leave Swarm

```bash
docker swarm leave --force
```

---

# Quick Memory Trick

| Action | Command |
|----------|----------|
| Initialize Swarm | `docker swarm init` |
| Create Service | `docker service create ...` |
| List Services | `docker service ls` |
| Inspect Tasks | `docker service ps <service>` |
| Scale Service | `docker service scale <service>=5` |
| Update Service | `docker service update ...` |
| Remove Service | `docker service rm <service>` |
| Leave Swarm | `docker swarm leave --force` |

---

# Docker Swarm Workflow

```text
Initialize Swarm
        ↓
Create Service
        ↓
Verify Service
        ↓
Modify Service
        ↓
Verify Changes
        ↓
Remove Service
        ↓
Leave Swarm
```

This sequence works for most Docker Swarm laboratory exercises and practical examinations.
