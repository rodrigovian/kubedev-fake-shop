# Fake Shop

Exemplo de aplicação web utilizando Flask, PostgreSQL e Kubernetes. Este projeto foi configurado e implementado com AWS CloudFormation, EKS e ECR para demonstrar práticas modernas de DevOps e implantação em nuvem.

## Variável de Ambiente - .env

_Criar arquivo .env_

```sh
# Server
DB_HOST=Host do banco de dados PostgreSQL.

DB_USER=Nome do usuário do banco de dados PostgreSQL.

DB_PASSWORD=Senha do usuário do banco de dados PostgreSQL.

DB_NAME=Nome do banco de dados PostgreSQL.

DB_PORT=Porta de conexão com o banco de dados PostgreSQL.

# Postgre
POSTGRES_DB=Nome do banco de dados PostgreSQL.

POSTGRES_USER=Nome do usuário do banco de dados PostgreSQL.

POSTGRES_PASSWORD=Senha do usuário do banco de dados PostgreSQL.
```

## AWS

[Instalar AWS CLI (PT-BR)](https://aws.amazon.com/pt/cli/)

### Configurar

```sh
aws configure
```

### AWS CloudFormation

#### Subir `CloudFormation stack`

```sh
aws cloudformation create-stack --stack-name <stack-name> --template-body file://<path-to-your-yaml-file> --region <your-region>
```

#### Atualizar `CloudFormation stack` existente

```sh
aws cloudformation update-stack --stack-name <stack-name> --template-body file://<path-to-your-yaml-file> --region <your-region>
```

#### Deletar `CloudFormation stack`

```sh
aws cloudformation delete-stack --stack-name <stack-name> --region <your-region>
```

### AWS EKS

#### Criar cluster

```sh
aws eks update-kubeconfig --name <cluster-name> --region us-east-1
```

#### Criar node group

```sh
aws eks create-nodegroup \
  --cluster-name <cluster-name> \
  --nodegroup-name <nodegroup-name> \
  --subnets <private:subnet-123> <private:subnet-321> \
  # t3a.small | t3a.medium | t3.small | t3.medium
  --instance-types t3a.medium \
  --scaling-config minSize=2,maxSize=4,desiredSize=2 \
  --capacity-type ON_DEMAND \
  --ami-type AL2_x86_64 \
  --node-role <arn:aws:iam::123:role/my-role> \
  # N. Virginia
  --region us-east-1
```

#### Deletar EKS Node Group

```sh
aws eks delete-nodegroup --cluster-name <cluster-name> --nodegroup-name <nodegroup-name>
```

#### Deletar EKS Cluster

```sh
aws eks delete-cluster --name <cluster-name>
```

## AWS Extra

### AWS ECR

#### Criar ECR Repository

```sh
aws ecr create-repository --repository-name <repository-name> --region <your-region>
```

#### Autenticar Docker para ECR

```sh
aws ecr get-login-password --region <your-region> | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<your-region>.amazonaws.com
```

#### Montar imagem Docker

```sh
docker build -t <repository-name> .
```

#### Tag para imagem Docker

```sh
docker tag <repository-name>:latest <aws_account_id>.dkr.ecr.<your-region>.amazonaws.com/<repository-name>:latest
```

#### Subir imagem Docker para ECR

```sh
docker push <aws_account_id>.dkr.ecr.<your-region>.amazonaws.com/<repository-name>:latest
```

#### Deletar o ECR Repository

```sh
aws ecr delete-repository --repository-name <repository-name> --region <your-region> --force
```

### Erro de token

Caso retorne uma mensagem de falha como `... The security token included in the request is invalid.`, execute:

```sh
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
```

Depois, refaça o passo de configuração da AWS.

### Passos de remoção

Os itens a seguir podem gerar cobranças caso permaneçam ativos: CloudFormation, EKS e ECR. Siga o passo a passo para removê-los.

1. Delete o EKS Node Group.
2. Delete o EKS Cluster.
3. Delete o CloudFormation stack.
4. Delete o ECR Registry. _\*Caso esteja usando o Repositório `ECR` da AWS_

## Deploy

### Docker hub

[albuquerquefabio/kubedev-fake-shop](https://hub.docker.com/r/albuquerquefabio/kubedev-fake-shop)

### Kubernetes

#### Criar `aula-secrets`:

```sh
kubectl create secret generic aula-secrets --from-env-file=.env
```

#### Subir pods (deployment | service):

```sh
kubectl apply -f k8s/deployment.yaml
```

#### Detalhes:

```sh
kubectl get all
```

```sh
kubectl get service
```

#### Remover pods

```sh
kubectl delete deployment fake-shop
kubectl delete deployment postgre

kubectl delete service fake-shop
kubectl delete service postgre

kubectl delete secret aula-secrets
```
