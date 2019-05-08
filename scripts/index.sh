#!/bin/bash 
# chmod 644 /var/ww/html/index.html
# chown root:root /var/ww/html/index.html
#mv -f /var/www/html/index.html /var/www/index.html.bkp
#mv -f /var/www/index.html /var/www/html
#chmod 644 /var/www/html/index.html
#chown root:root /var/www/html/index.html
# touch /var/www/html/tst.tst

#FILE=/opt/bitnami/apache-tomcat/webapps/petclinic.war
#if test -e "$FILE"; then
#    rm -f $FILE
#fi
#sudo apt-get install -y maven
sudo ufw allow 8080
MANAGERFILE=/opt/bitnami/apache-tomcat/conf/Catalina/localhost/manager.xml
if test ! -e "$MANAGERFILE"; then
    touch $MANAGERFILE
    echo "<Context privileged=\"true\" antiResourceLocking=\"false\" docBase=\"\${catalina.home}/webapps/manager\">" > $MANAGERFILE
    echo "    <Valve className=\"org.apache.catalina.valves.RemoteAddrValve\" allow=\"^.*\$\" />" >> $MANAGERFILE
    echo "</Context>" >> $MANAGERFILE
fi
touch /opt/bitnami/apache-tomcat/webapps/petclinic/WEB-INF/web.xml 
#java -jar target/*.jar
