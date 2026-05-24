# Docker Lab 3 and Lab 4
## Docker Images, Dockerfile, Environment Variables, and MySQL

---

# Table of Contents

1. Docker Lab 3
   - Docker Images
   - Dockerfile Instructions
   - Building Images
   - Port Mapping
   - Image Optimization

2. Docker Lab 4
   - Environment Variables
   - Docker Inspect
   - MySQL Container Deployment

3. Important Commands

4. Full Forms and Terminologies

---

# Docker Lab 3

## Question 1
### How many images are available on this host?

#### Command

```bash
docker images
```

#### Better Counting Command

```bash
docker images | tail -n +2 | wc -l
```

#### Explanation

| Command | Meaning |
|---|---|
| docker images | Lists all Docker images |
| tail -n +2 | Skips heading line |
| wc -l | Counts total lines |

#### Output

```bash
9
```

#### Answer

```text
9
```

---

## Question 2
### What is the size of the ubuntu image?

#### Command

```bash
docker images
```

#### Better Inspection Command

```bash
docker image inspect ubuntu --format='{{.Size}}'
```

#### Convert Bytes to MB

```bash
echo $((size/1024/1024)) MB
```

#### Explanation

| Command | Meaning |
|---|---|
| inspect | Shows detailed image information |
| --format | Displays selected field only |
| .Size | Image size in bytes |

#### Answer

```text
78MB
```

---

## Question 3
### What is the tag on the newly pulled NGINX image?

#### Command

```bash
docker images | grep -i nginx
```

#### Explanation

| Command | Meaning |
|---|---|
| grep | Search matching text |
| -i | Ignore uppercase/lowercase |

#### Output

```bash
nginx alpine
nginx latest
nginx 1.14-alpine
```

#### Answer

```text
1.14-alpine
```

---

## Question 4
### What is the base image used in the Dockerfile?

#### Read Dockerfile

```bash
cat webapp-color/Dockerfile
```

#### Dockerfile Content

```dockerfile
FROM python:3.6

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python","app.py"]
```

#### Explanation

| Instruction | Meaning |
|---|---|
| FROM | Base image instruction |

#### Answer

```text
python:3.6
```

---

## Question 5
### To what location within the container is the application code copied?

#### Dockerfile Line

```dockerfile
COPY . /opt/
```

#### Explanation

| Part | Meaning |
|---|---|
| COPY | Copies files |
| . | Current directory |
| /opt/ | Destination path inside container |

#### Answer

```text
/opt
```

---

## Question 6
### Which instruction defines the startup command?

#### Dockerfile Line

```dockerfile
ENTRYPOINT ["python","app.py"]
```

#### Explanation

| Instruction | Meaning |
|---|---|
| ENTRYPOINT | Defines startup command |

#### Executed Command

```bash
python app.py
```

#### Answer

```text
python app.py
```

---

## Question 7
### What port does the application run on?

#### Dockerfile Line

```dockerfile
EXPOSE 8080
```

#### Explanation

| Instruction | Meaning |
|---|---|
| EXPOSE | Documents listening port |

#### Answer

```text
8080
```

---

## Question 8
### Build a Docker image named webapp-color

#### Command

```bash
cd webapp-color

docker build -t webapp-color .
```

#### Explanation

| Command Part | Meaning |
|---|---|
| docker build | Builds image |
| -t | Assign image name/tag |
| . | Current directory build context |

#### Answer

```text
webapp-color
```

---

## Question 9
### Run webapp-color and map port 8080 to 8282

#### Command

```bash
docker run -p 8282:8080 webapp-color
```

#### Explanation

| Part | Meaning |
|---|---|
| -p | Port mapping |
| 8282 | Host port |
| 8080 | Container port |

#### Meaning

```text
Host:8282 -> Container:8080
```

---

## Question 10
### Access application using HOST:8282

#### Open

```text
HOST:8282
```

#### Stop Container

```bash
CTRL + C
```

---

## Question 11
### What is the base OS used by python:3.6 image?

#### Command

```bash
docker run python:3.6 cat /etc/os-release
```

#### Output

```bash
PRETTY_NAME="Debian GNU/Linux 11 (bullseye)"
```

#### Explanation

| File | Meaning |
|---|---|
| /etc/os-release | Linux OS information |

#### Answer

```text
debian
```

---

## Question 12
### What is the approximate size of webapp-color image?

#### Command

```bash
docker image inspect webapp-color --format='{{.Size}}'
```

#### Convert to MB

```bash
echo 912916134/1000/1000 | bc
```

#### Output

```bash
912
```

#### Approximate Size

```text
920MB
```

---

## Question 13
### Modify Dockerfile to use smaller base image

#### Old Dockerfile

```dockerfile
FROM python:3.6
```

#### Optimized Dockerfile

```dockerfile
FROM python:3.6-alpine

RUN pip install flask

COPY . /opt/

EXPOSE 8080

WORKDIR /opt

ENTRYPOINT ["python","app.py"]
```

#### Explanation

| Image | Meaning |
|---|---|
| alpine | Lightweight Linux distribution |

---

## Question 14
### Build optimized image named webapp-color:litle

#### Command

```bash
docker build -t webapp-color:litle .
```

#### Explanation

| Part | Meaning |
|---|---|
| webapp-color | Image name |
| litle | Image tag |

#### Validation

```text
Image size less than 150MB
```

---

## Question 15
### Run optimized image and map port 8080 to 8383

#### Command

```bash
docker run -p 8383:8080 webapp-color:litle
```

#### Meaning

```text
Host:8383 -> Container:8080
```

---

# Docker Lab 4

## Question 1
### Identify APP_COLOR environment variable value

#### Command

```bash
docker inspect <container_id> | grep APP
```

#### Output

```bash
"APP_COLOR=pink"
```

#### Explanation

| Command | Meaning |
|---|---|
| inspect | Detailed container information |
| grep APP | Filter APP variables |

#### Answer

```text
pink
```

---

## Question 2
### Run blue-app container with APP_COLOR=blue

#### Command

```bash
docker run --name blue-app -p 38282:8080 -e APP_COLOR=blue kodekloud/simple-webapp
```

#### Explanation

| Option | Meaning |
|---|---|
| --name | Assign container name |
| -p | Port mapping |
| -e | Environment variable |

#### Port Mapping

```text
Host:38282 -> Container:8080
```

---

## Question 3
### Access application on HOST:38282

#### Open

```text
HOST:38282
```

#### Result

```text
Application color = Blue
```

---

## Question 4
### Deploy MySQL container

#### Requirements

| Requirement | Value |
|---|---|
| Container Name | mysql-db |
| Image | mysql |
| Root Password | db_pass123 |

#### Command

```bash
docker run --name mysql-db -e MYSQL_ROOT_PASSWORD=db_pass123 mysql
```

#### Explanation

| Variable | Meaning |
|---|---|
| MYSQL_ROOT_PASSWORD | MySQL root password |

---

# Important Dockerfile Instructions

| Instruction | Meaning |
|---|---|
| FROM | Base image |
| RUN | Execute command during build |
| COPY | Copy files into image |
| WORKDIR | Set working directory |
| EXPOSE | Define application port |
| ENTRYPOINT | Startup command |

---

# Important Docker Commands

| Purpose | Command |
|---|---|
| List images | docker images |
| Inspect image | docker image inspect image |
| Build image | docker build -t name . |
| Run container | docker run image |
| Run detached | docker run -d image |
| Publish port | docker run -p host:container image |
| Set ENV variable | docker run -e KEY=value image |
| Inspect container | docker inspect container_id |

---

# Full Forms and Terminologies

| Term | Meaning |
|---|---|
| Docker | Containerization platform |
| NGINX | Engine-X web server |
| ENV | Environment Variable |
| grep | Global Regular Expression Print |
| wc | Word Count |
| MB | Megabyte |
| GB | Gigabyte |
| OS | Operating System |
| Alpine | Lightweight Linux distribution |

---

# Main Patterns Learned

## Build Image

```bash
docker build -t image_name .
```

## Run Container with Port Mapping

```bash
docker run -p host_port:container_port image_name
```

## Run Container with Environment Variable

```bash
docker run -e KEY=value image_name
```

## Run Named Container

```bash
docker run --name container_name image_name
```

## Inspect Environment Variables

```bash
docker inspect container_id | grep APP
```

## Read Dockerfile

```bash
cat Dockerfile
```

---

# Final Learning Outcomes

After completing these labs, you learned:

- Docker image management
- Dockerfile instructions
- Image building process
- Port publishing and mapping
- Environment variables
- Container inspection
- MySQL deployment
- Lightweight image optimization
- Docker command patterns
- Base image concepts
- Alpine Linux optimization

---

# End of Docker Lab 3 and Lab 4 Notes
