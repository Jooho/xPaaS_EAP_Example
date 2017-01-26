#xPaaS_EAP_Example 
This repos provide xPaaS eap examples.

## Doc List
- [How to replace standalone.xml file](https://github.com/Jooho/xPaaS_EAP_Example/blob/master/docs/how_to_replace_standalone.xml_file.md)
- [How to add modules](https://github.com/Jooho/xPaaS_EAP_Example/blob/master/docs/how_to_add_modules.md)
- How to configure Datasource
- [How to set Vault](https://github.com/Jooho/xPaaS_EAP_Example/blob/master/docs/how_to_set_vault)
- How to set SSL for https



## Topic
- Do we need management console controller with RBAC?
  - xPaaS EAP does not provide webconsole but still it allows to be connected by jboss-cli.sh inside container
    Although it can modify configuration, the changes will be disappeared when the container is restarted. 
    Back to original question, do we still need to configure RBAC? From my understanding, it is not needed because jboss-cli only affect to container itself not image. However, RBAC can be configured if it is really wanted to be. 


