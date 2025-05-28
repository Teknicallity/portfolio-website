# Serverless Resume Website on AWS

This project is a **cloud-native, serverless resume site** deployed entirely on AWS and inspired by the [Cloud Resume Challenge](https://cloudresumechallenge.dev/). It showcases full-stack development, infrastructure as code, CI/CD automation, and modern frontend tooling.

## 🚀 Features

- **Frontend**
    - Built with [Vite](https://vitejs.dev/) and [Tailwind CSS](https://tailwindcss.com/)
    - Hosted on **Amazon S3** with global distribution via **CloudFront**
    - HTTPS enabled with **AWS Certificate Manager**

- **Backend**
    - Visitor counter API using **API Gateway**, **Lambda (Python)**, and **DynamoDB**

- **Infrastructure as Code**
    - All resources provisioned via **Terraform**
    - Uses **OpenID Connect (OIDC)** for secure GitHub Actions access to AWS

- **CI/CD**
    - Automated builds and deployments using **GitHub Actions**

## 📁 Structure

```
.
├── frontend/           # Vite + Tailwind static site
├── backend/            # Lambda function code
├── terraform/          # Infrastructure as Code
└── .github/workflows/  # CI/CD pipeline
```

## 📚 Based On

This project is based on the [Cloud Resume Challenge](https://cloudresumechallenge.dev/) by Forrest Brazeal.
