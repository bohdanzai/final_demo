# Demo 3

<h3><b>Objective:</b> Deploying of application using AWS ECR, ECS and Terraform </h3>

<hr>

<h1>Infrastructure</h1>

<h2>ECR</h2>

- Creates ECR repository
- Null-resource 

<h2>ECS</h2>

- Creates ECS cluster with 1 service and task definition
- Roles and policies for the interaction of the task and the cluster are prescribed

<h2>Network</h2>

- Creates application load balancer, listener and target group
- Creates autoscaling group and launch configuration
- Creates security groups for all components and for application load balancer
- Creates public & private subnets
- Creates Internet & NAT gateways
- Creates VPC

<hr>