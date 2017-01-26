#How to replace standalone.xml file

##Adding standalone-openshift.xml under configuration folder(configuration)
Openshift EAP s2i builder image provide the feature to replace of standalone-openshift.xml file

Pros:
  - Can use official image directly

Cons:
  - Need to train developer how to add configuration file in their repository.
  - Need to provide standard configuration file to developers.

### How-To
~~~
$ mkdir configuration 
$ cp standalone.xml ./configuration/standalone-openshift.xml
~~~

[Example Repo](https://github.com/Jooho/xPaaS_EAP_Example/tree/master/replace_configuration/configuration)

### Test with OpenShift 
~~~
$ oc new-project test
$ oc new-app --template=eap64-http-s2i -p SOURCE_REPOSITORY_URL=https://github.com/Jooho/xPaaS_EAP_Example,SOURCE_REPOSITORY_REF=master,CONTEXT_DIR=replace_configuration -l app=eap-app-test
~~~


##Using cli then commit (/opt/eap/bin/jboss-cli.sh)
Openshift EAP still provide jboss-cli.sh. However, the changes will be rollback when the container re-deployed.
In order to keep data, it should commit and create new image. 

Pros:
  - Full Set of new Image
  - Easy to provide to developer

Cons:
  - Need to recreate when new official image release
  - Need to manage image version

### How-to

#### Create new app with official image
~~~
$ oc new-project test
$ oc new-app --template=eap64-http-s2i -p SOURCE_REPOSITORY_URL=https://github.com/Jooho/xPaaS_EAP_Example,SOURCE_REPOSITORY_REF=master,CONTEXT_DIR=replace_configuration -l app=eap-app-test
$ oc get is
NAME      DOCKER REPO                                 TAGS      UPDATED
eap-app   172.30.207.94:5000/sample-eap-ssl/eap-app   latest    13 minutes ago

#### Deploy built image with docker command and attach the container
~~~
$ oc login
$ docker login -u $USER -p $(oc whoami -t) -e $EMAIL 172.30.207.94:5000
$ docker pull 172.30.207.94:5000/sample-eap-ssl/eap-app
$ docker run -d --name=eap64 172.30.207.94:5000/sample-eap-ssl/eap-app 
~~~

#### Copy jboss cli script and Execute the script 
~~~
$ cat <<EOF> config.cli
batch
/socket-binding-group=standard-sockets/socket-binding=https2:add(port=8888)
exit
EOF

$ docker cp ./config.cli eap64:/opt/eap/bin/.
$ docker exec -it eap64 /bin/bash
$ cd /opt/eap/bin/jboss-cli.sh --connect --file=./config.cli
Picked up JAVA_TOOL_OPTIONS: -Duser.home=/home/jboss -Duser.name=jboss
The batch executed successfully

Ctrl-p -> Ctrl-q

$ docker commit eap64 172.30.207.94:5000/sample-eap-ssl/eap-app:custom
$ docker push 172.30.207.94:5000/sample-eap-ssl/eap-app:custom
~~~

