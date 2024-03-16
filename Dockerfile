FROM tomcat:8.0.20-jre8
COPY target/aaptatt*.war /usr/local/tomcat/webapps/aaptatt.war
