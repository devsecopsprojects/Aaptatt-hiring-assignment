# Sample spark-java-war-example
# Build war with maven and sparkjava framework

Steps:
### Launched 2 ec2 ubuntu servers of t2.medium
### FIRST SERVER
### 1. Install jdk11, maven3, docker, jenkins and Trivy
Install jekins and java [FROM HERE](https://www.jenkins.io/doc/book/installing/linux/#debianubuntu)
#### Cloned the repository on jenkins machine
```bash
mvn package
```
### 2. Installed below plugins

Click on Jenkins Dash board >> Manage Jenkins >> Plugins >> Available Plugins >> Install bellow Plugins
```bash
   a. Deploy to container
   b. Sonarqube scanner
   c. Maven intergration
   c. Eclipse Temurin installer
   d. Docker
   e. Docker commons
   f. Docker Pipeline
```
## 3. Configure Jenkins server:
   
#### click on "Install suggested plugins"

#### click on "skip and continue as admin"

#### click on "save and finish"

#### click on "start using jenkins"

#### click on "manage jenkins"

#### click on "users" under security section

#### click on "settings" symbol 

#### Go to Password section and change password and click on save

#### You are automatically logged out

#### Login again

# SONARQUBE
Run sonar on continer
```bash
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community
```
Grab the Public IP Address of your EC2 Instance, 
Sonarqube works on Port 9000
```bash
http://Public-IP:9000
admin
admin
change password
```
Click on Administration on sonar ui → Security → Users → Click on Tokens and Update Token → Give any name →  click on Generate Token

copy Token → add sonar token in jenkins under credentials.
Add docker credentials also in jenkins.<br>
In the Sonarqube Dashboard add a quality gate also

Goto administration –> Configuration–>Webhooks-> create webhook

#in url section of quality gate
<http://jenkins-public-ip:8080>/sonarqube-webhook/

  
## Goto Jenkins Tools section configure tools
1. click on add jdk >> jdk11 >> jdk-11.8.0
2. click on add maven >> maven3 > MAVEN 3.8.0
3. click on add SonarQube Scanner >> sonar-scanner >> SonarQube Scanner 5.0.1.3006
4. click on add docker >> latest

## Create credentials on jenkins
1. Docker: To push image to dockerhub
2. tomcat: To deploy app on tomcat server

## Dashboard → Manage Jenkins → System

Click on add sonarQube installations

sonar-server

http://public-ip:9000
attach sonar-token
save

# Create a pipeline with name aaptatt

General section: No. of builds to keep 2

Under pipeline section: add pipeline script

Build

Pipeline Script:
```bash
pipeline {
    agent any
    tools{
        jdk 'jdk11'
        maven 'maven3'
    }
    environment{
        SCANNER_HOME= tool 'sonar-scanner'
    }

    stages {
	 stage('clean workspace'){
            steps{
                cleanWs()
            }
        }
        stage('git-checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/devsecopsprojects/aaptatt.git'
            }
        }

        stage('Code-Compile') {
            steps {
               sh "mvn clean package"
            }
        }
        stage('Sonar Analysis') {
            steps {
               withSonarQubeEnv('sonar-server'){
                   sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=aaptatt \
                   -Dsonar.java.binaries=. \
                   -Dsonar.projectKey=aaptatt '''
               }
            }
        }
	stage('TRIVY FS SCAN') {
            steps {
                sh "trivy fs . > trivyfs.txt"
            }
        }
        stage('Code-Build') {
            steps {
               sh "mvn clean install"
            }
        }
        
        stage('Docker Build and Push') {
            steps {
               script{
                   withDockerRegistry(credentialsId: 'docker', toolName: 'docker') {
                    sh "docker build -t devsecopsprojects/aaptatt:latest ."
                    sh "docker push  devsecopsprojects/aaptatt:latest "
                 }
               }
            }
        }
        stage("TRIVY"){
            steps{
                sh "trivy image devsecopsprojects/aaptatt:latest > trivyimage.txt" 
            }
        }
         stage("Deploy To Tomcat"){
            steps{
                deploy adapters: [tomcat8(credentialsId: '59787285-2018-4b2e-8025-4f274776546a', path: '', url: 'http://18.233.66.203:8080/')], contextPath: null, onFailure: false, war: 'target/*.war'
            }
        }
    }
}
```
## Configure Domain yourname.xyz
## Create A Record with tomcat public IP.
## Create CNAME Record for www.yourname.xyz
## Install nginx
## Configure Reverse proxy 
```bash
cd /etc/nginx/conf.d
sudo vi yourname.xyz.conf
server {
        server_name yourname.xyz www.yourname.xyz;
        location / {
                proxy_pass http://127.0.0.1:8080/;
		proxy_http_version 1.1;
    		proxy_set_header Upgrade $http_upgrade;
    		proxy_set_header Connection 'upgrade';
    		proxy_set_header Host $host;
    		proxy_cache_bypass $http_upgrade;

        }
}
```
#### Test the configuration and Reload nginx
```bash
sudo nginx -t
sudo nginx -s reload
```


