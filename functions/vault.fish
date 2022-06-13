function vault -d "multi vault instance handler"
  set vault_bin (type -p -f vault)

  if test ( string match -r 'vumc|skj|spock|tokens' $argv[1] )
    set instance $argv[1]
    set -e argv[1]
  end

  switch $instance
    case tokens
      for v in vumc
        _vault_generate_token $v
      end
    case vumc
      if set -q VUMC_VAULT_TOKEN
        _vault_generate_token $instance
      else
        _vault_token_check $instance $VUMC_VAULT_TOKEN
      end

      command env VAULT_ADDR=https://(_vault_fqdn $instance) VAULT_TOKEN=$VUMC_VAULT_TOKEN $vault_bin $argv

    case skj
      if set -q HOME_VAULT_TOKEN
        _vault_generate_token $instance
      else
        _vault_token_check $instance $HOME_VAULT_TOKEN
      end

      command env VAULT_ADDR=https://(_vault_fqdn $instance) VAULT_TOKEN=$HOME_VAULT_TOKEN $vault_bin $argv

    case "*"
      command $vault_bin $argv
  end

end

function _vault_generate_token -d "generates vault token"
  set vault_bin (type -p -f vault)
  set awsvault (type -p aws-vault)

  switch $argv[1]
    case vumc
      set aws_profile payer-admin
      set vault_aws_path aws
      set vault_aws_role cloudservices-admin
      set vault_fqdn (_vault_fqdn vumc)

      set -gx VUMC_VAULT_TOKEN (command $awsvault exec $aws_profile -- $vault_bin login -field=token -method aws -path=$vault_aws_path -address=https://$vault_fqdn header_value=$vault_fqdn role=$vault_aws_role)

    case skj
      set vault_fqdn (_vault_fqdn home)
      set user (command whoami)

      set -gx HOME_VAULT_TOKEN (command $vault_bin login -field token -address=https://$vault_fqdn -method=userpass username=$user password=(command security find-generic-password -a $user -s $vault_fqdn -w))

  end

  if test -f ~/.vault-token
    rm -f ~/.vault-token
  end

end


function _vault_token_check -d "validates a vault token, and regenerates if needed"
  set token $argv[2]
  set fqdn (_vault_fqdn $argv[1])
  set curl (type -p curl)
  set jq (type -p jq)

  set token_check (command $curl -s --header "X-Vault-Token:$token" "https://$fqdn/v1/auth/token/lookup-self" | $jq -r ".errors[]?")

  if test (string match -r 'permission denied|missing client token' $token_check)
    _vault_generate_token $argv[1]
  end

end


function _vault_fqdn -d "maps vault instance name to fqdn"
  switch $argv[1]
    case vumc
      echo "vault.cloudservices.aws.vumc.cloud"
    case home
      echo "vault.skj.dev"
    case "*"
      echo "none"
  end
end
