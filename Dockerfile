FROM tomcat:latest
RUN cp -R  /usr/local/tomcat/webapps.dist/*  /usr/local/tomcat/webapps
COPY COPY webapp/target/webapp.war /usr/local/tomcat/webapps/ROOT.war

