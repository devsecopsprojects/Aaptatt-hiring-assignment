# Sample spark-java-war-example
Build war with maven and sparkjava framework

Steps:

### Launched 2 ec2 ubuntu servers of t2.medium
### Configured jenkins on first server, tomcat on second server
Download a fresh [Tomcat 8 distribution](https://tomcat.apache.org/download-80.cgi)
Clone this repository to your local machine
Run mvn package
Copy the generated `sparkjava-hello-world-1.0.war` to the Tomcat `webapps` folder
Start Tomcat by running `bin\startup.bat` (or `bin/startaup.sh` for Linux)
Tomcat will automatically deploy the war
Open [http://localhost:8080/sparkjava-hello-world-1.0/aaptatt] in your browser 
