

```
# Particle41 DevOps Challenge – SimpleTimeService

This repository contains my submission for the Particle41 DevOps Team Challenge. It demonstrates a full DevOps workflow, including:

- ✅ Minimal Python web app (SimpleTimeService)
- ✅ Docker containerization using best practices (non-root, minimal base image)
- ✅ Terraform-based infrastructure on AWS (VPC, ECS Fargate, ALB)
- ✅ Complete setup and deployment documentation

---

## 📦 Application – SimpleTimeService

### 🌐 What it does:
A lightweight Flask web service that returns the following JSON on the `/` route:

```
{
  "timestamp": "<UTC timestamp>",
  "ip": "<requester's IP address>"
}
```

---

## 🐳 Docker Image

### 📂 Location
`/app`

### 🔧 Build Locally

```
cd app/
docker build -t simpletimeservice .
```

### ▶️ Run Locally

```bash
docker run -p 8080:8080 simpletimeservice
```

Test:
```bash
curl http://localhost:8080
```

Expected:
```json
{
  "timestamp": "2025-04-14T12:34:56.789Z",
  "ip": "127.0.0.1"
}
```

> ✅ The container runs as a **non-root user** for security.

### 🐳 Docker Hub

The image is publicly available at:  
👉 **https://hub.docker.com/r/psdike/particle41-assignment-devops**

Use it directly:
```bash
docker run -p 8080:8080 psdike/particle41-assignment-devops
```

---

## ☁️ Infrastructure – Terraform on AWS ECS Fargate

### 📂 Location
`/terraform`

### 🚀 What It Deploys:

- ✅ A new VPC with 2 public and 2 private subnets
- ✅ ECS Fargate Cluster in the private subnets
- ✅ ALB in public subnets
- ✅ ECS Task running `psdike/particle41-assignment-devops` container
- ✅ Internet-facing access via ALB

---

## 🛠️ Prerequisites

Install the following tools:

- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Git](https://git-scm.com/)

✅ Authenticate with AWS CLI:
```bash
aws configure
```

---

## 📋 How to Deploy the Infrastructure

```bash
cd terraform/
terraform init
terraform plan
terraform apply
```

After deployment, the output will include the public Load Balancer DNS.  
You can access the app via:

```bash
curl http://<alb_dns_name>
```

