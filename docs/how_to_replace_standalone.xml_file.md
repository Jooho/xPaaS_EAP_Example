#How to replace standalone.xml file

##Adding standalone-openshift.xml under configuration folder(configuration)
Openshift EAP s2i builder image provide the feature to replace of standalone-openshift.xml file

### How-To
~~~
mkdir configuration 
cp standalone.xml ./configuration/standalone-openshift.xml
~~~

[Example](https://github.com/Jooho/xPaaS_EAP_Example/tree/master/replace_configuration/configuration)

### Test with OpenShift 
~~~
oc new-project test
oc new-app
oc new-app --template=eap64-http-s2i -p SOURCE_REPOSITORY_URL=https://github.com/Jooho/xPaaS_EAP_Example,SOURCE_REPOSITORY_REF=master,CONTEXT_DIR= -l app=eap-app-test

##Using cli then commit (/opt/eap/bin/jboss-cli.sh)
