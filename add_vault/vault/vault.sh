#!/bin/bash

function configure_vault() {
  vault="<!-- No vault configuration discovered -->"
  if [ -n "${VAULT_KEYSTORE_PASSWORD}" -a -n "${VAULT_KEYSTORE_ALIAS}" -a -n "${VAULT_SALT}" -a -n "${VAULT_ITERATION_COUNT}" -a -n "${VAULT_KEYSTORE_SECRET}"  -a -n "${VAULT_ENC_FILE_SECRET}" ] ; then
  
         vault="<vault> \
            <vault-option name=\"KEYSTORE_URL\" value=\"/etc/${VAULT_KEYSTORE_SECRET}/vault.keystore\"/> \
            <vault-option name=\"KEYSTORE_PASSWORD\" value=\"${VAULT_KEYSTORE_PASSWORD}\"/> \
            <vault-option name=\"KEYSTORE_ALIAS\" value=\"${VAULT_KEYSTORE_ALIAS}\"/> \
            <vault-option name=\"SALT\" value=\"${VAULT_SALT}\"/> \
            <vault-option name=\"ITERATION_COUNT\" value=\"${VAULT_ITERATION_COUNT}\"/> \
            <vault-option name=\"ENC_FILE_DIR\" value=\"/opt/eap/bin\"/> \
           </vault>"

  else
        echo "WARNING! Vault configuration parameters has issue, the Vault WILL NOT be configured."
        echo "Check following"
        echo ""
        echo "VAULT_KEYSTORE_SECRET=/etc/${VAULT_KEYSTORE_SECRET}/vault.keystore"
        echo "VAULT_KEYSTORE_PASSWORD=${VAULT_KEYSTORE_PASSWORD}"
        echo "VAULT_KEYSTORE_ALIAS=${VAULT_KEYSTORE_ALIAS}"
        echo "VAULT_SALT=${VAULT_SALT}"
        echo "VAULT_ITERATION_COUNT=${VAULT_ITERATION_COUNT}"
        echo "VAULT_ENC_FILE_SECRET=/etc/${VAULT_ENC_FILE_SECRET}"


  fi
  sed -i "s|<!-- ##VAULT## -->|${vault}|" $CONFIG_FILE
}

# Secret can not give capital letter for key so it can not use Secret
#<vault-option name=\"ENC_FILE_DIR\" value=\"/etc/${VAULT_ENC_FILE_SECRET}\"/> \
