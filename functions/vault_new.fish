function vault -d "vault <instance> <command>"

  set VUMC_VAULT_FQDN "vault.cloudservices.aws.vumc.cloud"
  set HOME_VAULT_FQDN "vault.ttys0.net"
  set SMAUG_VAULT_FQDN "smaug.ttys0.net"

  set vault_instance $argv[1]

  switch $vault_instance
    case vumc
      if not set -q VUMC_VAULT_TOKEN
        _get_vault_token vumc

  case $vault_instance in
    vumc)
      if [ -z ${VUMC_VAULT_TOKEN} ]; then
        vault_token vumc
        export VUMC_VAULT_TOKEN=${VTOKEN}
      else
        token_check=$(curl -s --header "X-Vault-Token:${VUMC_VAULT_TOKEN}" "https://${VUMC_VAULT_FQDN}/v1/auth/token/lookup-self" | jq -r ".errors[]?")

        if [[ "$token_check" == "permission denied" || "$token_check" == "missing client token" ]] ; then
          vault_token vumc
          export VUMC_VAULT_TOKEN=${VTOKEN}
        fi

      fi

      VAULT_ADDR=https://${VUMC_VAULT_FQDN} VAULT_TOKEN=${VUMC_VAULT_TOKEN} ${vault_bin} $@

      ;;

    home)
      if [ -z ${HOME_VAULT_TOKEN} ]; then
        vault_token home
        export HOME_VAULT_TOKEN=${VTOKEN}
      else
        token_check=$(curl -s --header "X-Vault-Token:${HOME_VAULT_TOKEN}" "https://${HOME_VAULT_FQDN}/v1/auth/token/lookup-self" | jq -r ".errors[]?")

        if [[ "$token_check" == "permission denied" || "$token_check" == "missing client token" ]] ; then
          vault_token home
          export HOME_VAULT_TOKEN=${VTOKEN}
        fi

      fi

      VAULT_ADDR=https://${HOME_VAULT_FQDN} VAULT_TOKEN=${HOME_VAULT_TOKEN} ${vault_bin} $@
      ;;

    smaug)
      if [ -z ${SMAUG_VAULT_TOKEN} ]; then
        vault_token smaug
        export TOM_VAULT_TOKEN=${VTOKEN}
      else
        token_check=$(curl -s --header "X-Vault-Token:${SMAUG_VAULT_TOKEN}" "https://${SMAUG_VAULT_FQDN}/v1/auth/token/lookup-self" | jq -r ".errors[]?")

        if [[ "$token_check" == "permission denied" || "$token_check" == "missing client token" ]] ; then
          vault_token smaug
          export SMAUG_VAULT_TOKEN=${VTOKEN}
        fi

      fi

      VAULT_ADDR=https://${SMAUG_VAULT_FQDN} VAULT_TOKEN=${SMAUG_VAULT_TOKEN} ${vault_bin} $@
      ;;

    local)
      VAULT_ADDR=http://localhost:8200 ${vault_bin} $@
      ;;

    tokens)
      vault_token vumc
      export VUMC_VAULT_TOKEN=${VTOKEN}

      vault_token home
      export HOME_VAULT_TOKEN=${VTOKEN}

      vault_token smaug
      export SMAUG_VAULT_TOKEN=${VTOKEN}

      echo "Vault tokens generated!"
      ;;


    *)
      ${vault_bin} $@
      ;;

  esac




function _vault_token -d "generate vault token"
  vault_instance=$1

  if [[ "$vault_instance" == "vumc" ]] ; then
    VAULT_AWS_PROFILE="payer-admin"
    VAULT_AWS_PATH="aws"
    VAULT_AWS_ROLE="cloudservices-admin"
    VAULT_FQDN=${VUMC_VAULT_FQDN}

    export VTOKEN=$(aws-vault exec ${VAULT_AWS_PROFILE} -- vault login -field=token -method aws -path=${VAULT_AWS_PATH} -address=https://${VAULT_FQDN} header_value=${VAULT_FQDN} role=${VAULT_AWS_ROLE})
    #export VTOKEN=$(${vault_bin} login -field=token -method oidc -address=https://${VAULT_FQDN})

  elif [[ "$vault_instance" == "home" ]]; then
    VAULT_FQDN=${HOME_VAULT_FQDN}

    export VTOKEN=$(${vault_bin} login -field token -address=https://${VAULT_FQDN} -method=userpass username=${USER} password=$(security find-generic-password -a sean -s vault.ttys0.net -w))

  elif [[ "$vault_instance" == "smaug" ]]; then
    VAULT_FQDN=${SMAUG_VAULT_FQDN}

    export VTOKEN=$(${vault_bin} login -field token -address=https://${VAULT_FQDN} -method=userpass username=${USER} password=$(security find-generic-password -a sean -s vault.ttys0.net -w))

  else
    echo "VAULT instance ${vault_instance} is not configured!"
    exit 0
  fi


  if [ -f ~/.vault-token ]; then
    rm -f ~/.vault-token
  fi


