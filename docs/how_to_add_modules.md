# How to add modules

##Adding library and module.xml files under modules folder
Openshift EAP s2i builder image provide the feature to add custom modules. All you need to do is copy the custom module under modules folder with source code.

Pros:
  - Can use official image directly

Cons:
  - A little more build time because of copying module time.
  - Need to provide standard module repos to developers and make them not to change it.

### How-To
~~~
cp -R $CUSTOM_MODULE $SOURCE/modules/.
~~~

[Example Repo](https://github.com/Jooho/xPaaS_EAP_Example/tree/master/add_modules/modules)

### Test with OpenShift
~~~
$ oc new-project test
$ oc new-app --template=eap64-http-s2i -p SOURCE_REPOSITORY_URL=https://github.com/Jooho/xPaaS_EAP_Example,SOURCE_REPOSITORY_REF=master,CONTEXT_DIR=add_modules -l app=eap-app-test
$ oc rsh $EAP_POD
$ ls /opt/eap/moudles/com/oracle/jdbc/main/ojdbc.jar
~~~

##Using cli then commit (/opt/eap/bin/jboss-cli.sh)
Openshift EAP still provide jboss-cli.sh. However, the changes will be gone when the container re-deployed.
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

#### Copy custom library and Execute the cli command
~~~
$ docker cp ./ojdbc.jar eap64:/opt/eap/bin/.
$ docker exec -it eap64 /bin/bash
$ cd /opt/eap/bin

$ ./jboss-cli.sh --command=" module add --name=com.oracle.jdbc --resources=./ojdbc6.jar --dependencies=javax.api,javax.transaction.api"
~~~

#### Check custom modules
~~~
$ ls modules/com/oracle/jdbc/main/ojdbc6.jar
$ cat modules/com/oracle/jdbc/main/ojdbc6.jar

<?xml version="1.0" ?>

<module xmlns="urn:jboss:module:1.1" name="com.oracle.jdbc">

    <resources>
        <resource-root path="ojdbc6.jar"/>
    </resources>

    <dependencies>
        <module name="javax.api"/>
        <module name="javax.transaction.api"/>
    </dependencies>
</module>
~~~

#### Create Custom Image and Push it to Internal Docker Registry
~~~
$ docker commit eap64 172.30.207.94:5000/sample-eap-ssl/eap-app:custom
$ docker push 172.30.207.94:5000/sample-eap-ssl/eap-app:custom
~~~

