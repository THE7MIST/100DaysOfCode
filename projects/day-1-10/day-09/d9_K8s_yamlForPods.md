# Kubernetes YAML in Kubernetes

# Kubernetes Pod Definition File

## File

```yaml
pod-definition.yml
```

## Contents

```yaml
apiVersion: v1
kind: Pod

metadata:
  name: myapp-pod

  labels:
    app: myapp
    type: front-end

spec:
  containers:
    - name: nginx-container
      image: nginx
```

---

# Command Used

```bash
kubectl create -f pod-definition.yml
```

## Meaning

| Part               | Description                  |
| ------------------ | ---------------------------- |
| kubectl            | Kubernetes command line tool |
| create             | Create a resource            |
| -f                 | Read configuration from file |
| pod-definition.yml | YAML manifest file           |

---

# Kubernetes YAML Structure

Every Kubernetes YAML file follows this hierarchy:

```text
apiVersion
kind
metadata
spec
```

---

# 1. apiVersion

Defines which Kubernetes API version should process the object.

## Example

```yaml
apiVersion: v1
```

## Purpose

Kubernetes contains many APIs.

Different resources belong to different API groups.

The API version tells Kubernetes:

* Which API group?
* Which version?
* How should this object be interpreted?

## Examples

| Resource    | API Version |
| ----------- | ----------- |
| Pod         | v1          |
| Service     | v1          |
| ConfigMap   | v1          |
| Secret      | v1          |
| ReplicaSet  | apps/v1     |
| Deployment  | apps/v1     |
| StatefulSet | apps/v1     |
| DaemonSet   | apps/v1     |

## Table from Slide

| Kind       | Version |
| ---------- | ------- |
| Pod        | v1      |
| Service    | v1      |
| ReplicaSet | apps/v1 |
| Deployment | apps/v1 |

---

# 2. kind

Defines what Kubernetes object will be created.

## Example

```yaml
kind: Pod
```

## Common Values

```yaml
kind: Pod
kind: Service
kind: ReplicaSet
kind: Deployment
kind: ConfigMap
kind: Secret
kind: StatefulSet
kind: DaemonSet
kind: Job
kind: CronJob
```

## Purpose

Kubernetes reads:

```yaml
kind: Pod
```

and understands:

```text
Create a Pod object
```

If:

```yaml
kind: Deployment
```

then:

```text
Create a Deployment object
```

---

# 3. metadata

Stores information describing the object.

## Example

```yaml
metadata:
  name: myapp-pod
```

## Metadata Fields

### name

Unique object name.

```yaml
metadata:
  name: myapp-pod
```

### labels

Key-value tags attached to objects.

```yaml
metadata:
  labels:
    app: myapp
    type: front-end
```

## Why Labels Matter

Labels help Kubernetes group resources.

Example:

```yaml
labels:
  app: myapp
```

A Service may use:

```yaml
selector:
  app: myapp
```

to find matching Pods.

### Example

```yaml
metadata:
  name: nginx-pod

  labels:
    app: web
    environment: production
```

---

# 4. spec

The most important section.

Spec defines:

```text
Desired State
```

What you want Kubernetes to create.

## Example

```yaml
spec:
  containers:
    - name: nginx-container
      image: nginx
```

## Kubernetes Philosophy

You declare:

```text
What should exist
```

Kubernetes decides:

```text
How to make it exist
```

---

# containers

Inside spec:

```yaml
containers:
```

is a list.

## Why List?

A Pod may contain:

* 1 Container
* 2 Containers
* 5 Containers

Therefore Kubernetes stores containers as an array.

### Example

```yaml
containers:
  - name: nginx-container
    image: nginx
```

---

# Structure

```text
containers
    ↓
List
    ↓
Dictionary
```

---

# Container Name

```yaml
- name: nginx-container
```

Container identifier inside the Pod.

---

# Container Image

```yaml
image: nginx
```

Container image to download.

Equivalent Docker command:

```bash
docker run nginx
```

Kubernetes internally pulls:

```text
docker.io/library/nginx
```

and starts the container.

---

# Complete YAML Hierarchy

```text
Pod
│
├── apiVersion
│
├── kind
│
├── metadata
│     │
│     ├── name
│     │
│     └── labels
│            │
│            ├── app
│            └── type
│
└── spec
      │
      └── containers
              │
              └── List
                    │
                    └── Container
                           │
                           ├── name
                           └── image
```

---

# YAML Structure Classification

## Dictionary

```yaml
metadata:
  name: myapp-pod
```

## Dictionary Inside Dictionary

```yaml
metadata:
  labels:
    app: myapp
```

## List

```yaml
containers:
```

## List of Dictionaries

```yaml
containers:
  - name: nginx
    image: nginx
```

---

# Equivalent JSON

```json
{
  "apiVersion": "v1",

  "kind": "Pod",

  "metadata": {
    "name": "myapp-pod",

    "labels": {
      "app": "myapp",
      "type": "front-end"
    }
  },

  "spec": {
    "containers": [
      {
        "name": "nginx-container",
        "image": "nginx"
      }
    ]
  }
}
```

---

# What Happens When You Run

```bash
kubectl create -f pod-definition.yml
```

## Step 1

Kubectl reads YAML file.

```text
pod-definition.yml
```

↓

## Step 2

Sends request to API Server.

↓

## Step 3

API Server validates:

```text
apiVersion
kind
metadata
spec
```

↓

## Step 4

Scheduler chooses node.

↓

## Step 5

Kubelet receives instruction.

↓

## Step 6

Container runtime pulls image.

```text
nginx
```

↓

## Step 7

Pod starts.

↓

## Step 8

Pod becomes Running.

---

# Most Important Exam Point

Every Kubernetes resource is defined using four top-level sections:

```yaml
apiVersion:
kind:
metadata:
spec:
```

Everything else in Kubernetes YAML is placed inside one of these sections.

---

# Kubernetes YAML Lab - Question 1 of 5

## Question

Create a YAML file at:

```text
/root/web-pod.yaml
```

with the following specifications:

| Item           | Value               |
| -------------- | ------------------- |
| Pod Name       | web-pod             |
| Container Name | nginx-container     |
| Image          | nginx               |
| Labels         | app: web, env: prod |

---

## YAML File

```yaml
apiVersion: v1

kind: Pod

metadata:
  name: web-pod

  labels:
    app: web
    env: prod

spec:
  containers:
    - name: nginx-container
      image: nginx
```

---

## Apply the Manifest

```bash
kubectl apply -f /root/web-pod.yaml
```

### Output

```text
pod/web-pod created
```

---

## Verification

### Command

```bash
kubectl get pod
```

### Output

```text
NAME      READY   STATUS    RESTARTS   AGE
web-pod   1/1     Running   0          14s
```

---

# Question 4 of 5

## Question

A YAML file exists at:

```text
/root/broken-pod.yaml
```

Goal:

Create a Pod named:

```text
static-web
```

using image:

```text
httpd
```

The file contains multiple issues.

Identify the issues, fix them, and deploy the Pod.

---

## Correct YAML

```yaml
apiVersion: v1

kind: Pod

metadata:
  name: static-web

  labels:
    app: static
    env: prod

spec:
  containers:
    - name: httpd-container
      image: httpd
```

---

## Deploy

```bash
kubectl apply -f /root/broken-pod.yaml
```

### Output

```text
pod/static-web created
```

---

## Verification

```bash
kubectl get pod
```

### Output

```text
NAME            READY   STATUS    RESTARTS   AGE
newpods-brn6t   1/1     Running   0          112s
newpods-klnfs   1/1     Running   0          112s
newpods-vp9bm   1/1     Running   0          112s
redis-pod       1/1     Running   0          2m10s
static-web      1/1     Running   0          14s
web-pod         1/1     Running   0          3m27s
```

---

# Common YAML Errors Usually Found

## Wrong apiVersion

### Wrong

```yaml
apiversion: v1
```

### Correct

```yaml
apiVersion: v1
```

---

## Wrong Kind

### Wrong

```yaml
kind: pod
```

### Correct

```yaml
kind: Pod
```

---

## Wrong Indentation

### Wrong

```yaml
spec:
containers:
```

### Correct

```yaml
spec:
  containers:
```

---

## Wrong Container List

### Wrong

```yaml
containers:
  name: httpd
```

### Correct

```yaml
containers:
  - name: httpd
```

---

## Wrong Image Field

### Wrong

```yaml
imageName: httpd
```

### Correct

```yaml
image: httpd
```

---

# Question 5 of 5

## Question

A Pod named:

```text
node-api
```

has already been deployed.

The container contains an environment variable:

```text
APP_COLOR
```

Find the value configured inside the container.

---

## Command Used

```bash
kubectl describe pod node-api | grep -i app
```

### Output

```text
APP_COLOR: green
```

---

## Correct Answer

```text
green
```

---

# Why This Works

## kubectl describe pod

Displays detailed Pod information.

```bash
kubectl describe pod node-api
```

Shows:

* Metadata
* Labels
* Events
* Images
* Ports
* Environment Variables
* Volumes
* Conditions

---

## grep -i app

Filters lines containing:

```text
app
```

Case-insensitive.

Examples matched:

```text
APP_COLOR
app
App
APP
```

---

# Environment Variable Section

Typical Output:

```text
Environment:
  APP_COLOR: green
  APP_MODE: production
```

---

# Kubernetes YAML Equivalent

The environment variable may have been configured as:

```yaml
apiVersion: v1

kind: Pod

metadata:
  name: node-api

spec:
  containers:
    - name: webapp-color
      image: kodekloud/webapp-color:v1

      env:
        - name: APP_COLOR
          value: green
```

---

# Concepts Covered

| Question | Concept                       |
| -------- | ----------------------------- |
| Q1       | Create Pod YAML               |
| Q4       | Debug Broken YAML             |
| Q5       | Inspect Environment Variables |

---

# Commands Learned

| Command                         | Purpose                          |
| ------------------------------- | -------------------------------- |
| kubectl apply -f file.yaml      | Create/Update resource from YAML |
| kubectl get pod                 | List Pods                        |
| kubectl describe pod <pod-name> | Detailed Pod information         |
| grep -i text                    | Case-insensitive search          |
| cat file.yaml                   | View YAML file                   |

---

# YAML Structures Used

## Dictionary

```yaml
metadata:
  name: web-pod
```

## Nested Dictionary

```yaml
labels:
  app: web
  env: prod
```

## List

```yaml
containers:
```

## List of Dictionaries

```yaml
containers:
  - name: nginx-container
    image: nginx
```

---

# Final Note

These structures are the foundation for:

* Pods
* ReplicaSets
* Deployments
* Services
* ConfigMaps
* Secrets
* StatefulSets
* DaemonSets
* Jobs
* CronJobs

in Kubernetes.

