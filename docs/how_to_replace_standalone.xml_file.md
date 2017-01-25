#How to replace standalone.xml file

##Adding standalone-openshift.xml under configuration folder(configuration)
Openshift EAP s2i builder image provide the feature to replace of standalone-openshift.xml file

### How-To
~~~
mkdir configuration 
cp standalone.xml ./configuration/standalone-openshift.xml
~~~

Example :

##Using cli then commit (/opt/eap/bin/jboss-cli.sh)
