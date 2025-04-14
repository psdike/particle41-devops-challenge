# Particle41 DevOps Challenge

This repository contains a complete solution to the Particle41 DevOps challenge. It consists of:

- `SimpleTimeService`: A lightweight Python-based web service that returns a JSON object containing the current timestamp and the caller's IP address.
- A Dockerized deployment of the service.
- Terraform infrastructure code to provision AWS resources and deploy the service to ECS Fargate within a secure VPC.
- Complete instructions for building, running, and deploying both locally and in the cloud.

---

## 🔧 Prerequisites

Before proceeding, ensure you have the following tools installed:

- [Docker](https://docs.docker.com/get-docker/)
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Git](https://git-scm.com/downloads)

Ensure your AWS credentials are configured properly via:

```bash
aws configure
