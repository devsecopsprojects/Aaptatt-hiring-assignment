# Sample spark-java-war-example
Build war with maven and sparkjava framework

Steps:
### Launched 2 ec2 ubuntu servers of t2.medium
### FIRST SERVER
### 1. Install jdk11, maven3, docker, jenkins and Trivy
jekins and java installation [HERE](https://www.jenkins.io/doc/book/installing/linux/#debianubuntu)
#### Cloned the repository on jenkins machine
```sh
mvn package
```
### 2. Installed below plugins

Click on Jenkins Dash board >> Manage Jenkins >> Plugins >> Available Plugins >> Install bellow Plugins

   a. Deploy to container
   b. Sonarqube scanner
   c. Maven intergration
   c. Eclipse Temurin installer
   d. Docker
   e. Docker commons
   f. Docker Pipeline

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
docker run -d --name sonar -p 9000:9000 sonarqube:lts-community

Grab the Public IP Address of your EC2 Instance, 
Sonarqube works on Port 9000, 

http://<Public IP>:9000
admin
admin
change password

Click on Administration on sonar ui → Security → Users → Click on Tokens and Update Token → Give any name →  click on Generate Token

copy Token → add sonar token in jenkins under credentials.
Add docker credentials also in jenkins.
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

http:<public-ip>:9000
attach sonar-token
save

# Create a pipeline with name project1

General section: No. of builds to keep 2

Under pipeline section: add pipeline script

Build

