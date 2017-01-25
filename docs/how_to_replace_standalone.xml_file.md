#How to replace standalone.xml file

##Adding standalone-openshift.xml under configuration folder(configuration)
Openshift EAP s2i builder image provide the feature to replace of standalone-openshift.xml file

### How-To
~~~
mkdir configuration 
cp standalone.xml ./configuration/standalone-openshift.xml
~~~

[Example](https://github.com/Jooho/xPaaS_EAP_Example/tree/master/replace_configuration/configuration)

##Using cli then commit (/opt/eap/bin/jboss-cli.sh)
