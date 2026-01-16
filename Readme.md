 # Flight Reservation System
---
## Setup project infrastructure using terraform modules
**Refer repo:**
````
https://github.com/abhipraydhoble/flight-project-infra.git
````
#### Changes:
- **main.tf** instance-type
- **main.tf** bucket-name
- Note: once terraform infra ready.. setup database [check username & pass in rds module]
---
## Database Setup (AWS RDS)

---

## 🔹 1. Install MySQL Client 

Update package index and install MySQL:

```bash
sudo apt update -y
sudo apt install mysql-server -y
```

Start and enable MySQL service:

```bash
sudo systemctl start mysql
sudo systemctl enable mysql
```

Verify installation:

```bash
mysql --version
```

---

## 🔹 2. Connect to AWS RDS MySQL Instance

Use the RDS endpoint, username, and password provided while creating the RDS instance.

### 🔸 Syntax 

```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

### 🔸 Example

```bash
mysql -h flightdb.xxxxx.ap-south-1.rds.amazonaws.com -u admin -p
```

---

## 🔹 3. Create Database

Once connected to RDS, create the database:

```sql
CREATE DATABASE flightdb;
```

Exit MySQL:

```sql
EXIT;
```

---

## 🔹 4. Import Database Schema & Data

Ensure the file `flightdb.sql` is present in the current directory.

### 🔸 Import SQL file

```bash
mysql -h <RDS-ENDPOINT> -u admin -p flightdb < flightdb.sql
```

---

## 🔹 5. Verify Database & Tables

Login again to MySQL:

```bash
mysql -h <RDS-ENDPOINT> -u admin -p
```

Select database and verify tables:

```sql
USE flightdb;
SHOW TABLES;
```

Verify sample data:

```sql
SELECT COUNT(*) FROM flight;
```

---

## 🔹 6. Expected Tables

After successful import, the following tables should be available:

```
users
user_roles
flight
booking
check_in
```

---

✅ **Database setup completed successfully!**
You can now connect this RDS database to your backend application.


---
## Setup project backend 
### install jenkins server
````
sudo apt update
sudo apt install fontconfig openjdk-21-jre -y
sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
````
### install docker
````
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker jenkins
sudo usermod -aG docker ubuntu
newgrp docker
sudo chmod 777 /var/run/docker.sock
````

### install maven
````
sudo apt install maven -y
````

### install aws cli
````
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip 
unzip awscliv2.zip
sudo ./aws/install
aws --version
````
### Install kubectl:
````
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
````
````
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
````
````
chmod +x kubectl
mkdir -p ~/.local/bin
mv ./kubectl ~/.local/bin/kubectl
````
### Setup sonarqube server
````
# Install and configure Database
apt install openjdk-17-jdk -y
apt install postgresql -y
systemctl start postgresql
sudo -u postgres psql
>> CREATE USER linux PASSWORD 'redhat';
>> CREATE DATABASE sonarqube;
>> GRANT ALL PRIVILEGES ON DATABASE sonarqube TO linux;
>> \c sonarqube;
>> GRANT ALL PRIVILEGES ON SCHEMA public TO linux;
>> \q
# Configure Linux Machine
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
# Install and Configure Sonarqube
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-25.5.0.107428.zip
apt install unzip -y
unzip sonarqube-25.5.0.107428.zip
mv sonarqube-25.5.0.107428 /opt/sonar
cd /opt/sonar
   vim conf/sonar.properties
>> sonar.jdbc.username=linux
>> sonar.jdbc.password=redhat
>> sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
useradd sonar -m
chown sonar:sonar -R /opt/sonar
su sonar
cd /opt/sonar/bin/linux-x86-64
./sonar.sh start
./sonar.sh status
````

## Required Jenkins Plugins

1. **Core Plugins:**
   - Pipeline Plugin
   - Git Plugin
   - GitHub Plugin
   - Install git, docker, kubectl, maven, sonarqube
   - Pipeline: Declarative
   - Pipeline: GitHub
   - Pipeline: REST API
   - Pipeline: Build Step
   - Pipeline: Stage View

2. **Build Tools:**
   - Maven Integration
   - JDK Tool
   - Git Integration

3. **Testing & Quality:**
   - SonarQube Quality Gates Plugin
   - SonarQube Scanner Plugin

4. **Docker:**
   - Docker Pipeline
   - Docker plugin
   - Docker API Plugin
   - Docker Commons Plugin

5. **Kubernetes:**
   - Kubernetes CLI
   - Kubernetes Plugin

6. **Credentials:**
   - Credentials Binding
   - Docker Credentials

7. **Workspace Management:**
   - Workspace Cleanup Plugin

## Pipeline Configuration Steps

### 1. Install Required Plugins
1. Go to Jenkins Dashboard
2. Navigate to Manage Jenkins > Manage Plugins
3. Install all the required plugins listed above
4. Restart Jenkins after plugin installation

### 2. Configure Tools
1. Go to Manage Jenkins > Global Tool Configuration
2. Configure the following tools:
   - JDK17
   - Maven
   - Docker
   - kubectl

### 3. Configure Credentials
1. Go to Manage Jenkins > Credentials > System
2. Add the following credentials:
   - Docker Registry credentials (ID: 'docker-cred')
   - SonarQube token (ID: 'sonar-cred')
   - Git credentials (if using private repository)

### 4. Configure SonarQube
1. Go to Manage Jenkins > Configure System
2. Add SonarQube server configuration:
   - Name: SonarQube
   - Server URL: http://your-sonarqube-server:9000
   - Authentication token: Use the sonar-token credential

### 5. Configure k8s
1. Go to Manage Jenkins > Configure System
2. select kind as secret file
3. make sure you create and copy k8s config file on desktop
4. select file and configure
5. 
### copy kubeconfig to jenkins user
````
cp -rf ~/.kube /var/lib/jenkins/
````
### allow jenkins to use kubeconfig
````
chown jenkins -R /var/lib/jenkins/.kube
````
## Setup project backend Pipeline

```
pipeline {
    agent any

    tools {
        jdk 'JDK17'
        maven 'Maven'
        dockerTool 'Docker'
    }

    stages {
        stage('Code-pull') {
            steps {
                git branch: 'main', url: 'https://github.com/abhipraydhoble/flight-reservation-app.git'
            }
        }

        stage('Code-build') {
            steps {
                sh '''
                    cd FlightReservationApplication
                    mvn clean package -DskipTests
                '''
            }
        }

        stage('QA-TEST') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh '''
                        cd FlightReservationApplication
                        mvn sonar:sonar -Dsonar.projectKey=flight-reservation
                    '''
                }
            }
        }

        stage('Docker-build') {
            steps {
                sh '''
                    cd FlightReservationApplication
                    docker build -t abhipraydh96/flight-backend .
                '''
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([
                    file(credentialsId: 'kube-config', variable: 'KUBECONFIG'),
                    [$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-cred']
                ]) {
                    sh '''
                        cd FlightReservationApplication
                        kubectl get nodes
                        kubectl apply -f k8s/ns.yaml
                    '''
                }
            }
        }
    }
}
```
---

## After Backned created add database endpoint in **application.properties and .env** and ````src/main/resource/application.properties```` of backned
- also update image name in k8s/deployment.yaml file
---

## Setup project frontend

Configure Tools
- NodeJS (version 18.x)
- Change Bucket name of pipeline

```
pipeline{
    agent any
    stages{
        stage('code-pull'){
            steps{
                git branch: 'main', url: 'https://github.com/abhipraydhoble/flight-reservation-app.git'
            }
        }
        stage('build'){
            steps{
                sh '''
                    cd frontend
                    npm install
                    npm run build
                '''
            }
        }
        stage('Deploy'){
            steps{
                sh '''
                    cd frontend
                    aws s3 sync dist/ s3://flight-reservation-frontend/
                '''
            }
        }
    }
}
```

----

##  Frontend Pipeline Build then Add bucket policy to bucket

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::your-bucket-name/*"
        }
    ]
}
```
---

## Copy  s3 bucket static website endpoint and check
