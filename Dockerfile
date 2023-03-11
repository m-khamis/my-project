FROM tomcat:8-jre8 
COPY ./target/*.war /usr/local/tomcat/webapps
