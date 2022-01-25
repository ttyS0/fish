function awscreds -d "generate aws credentials for specific profiles"
  source $__fish_config_dir/functions/vault.fish

  set -l options (fish_opt -s t -l ttl --required-val)
  set options $options (fish_opt -s p -l profile --required-val)
  set options $options (fish_opt -s i -l instance --required-val)
  set options $options (fish_opt -s c -l console)
  argparse --name=awscreds $options -- $argv

  if set -q $_flag_ttl
    set _flag_ttl 1h
    set _flag_t 1h
  end

  switch $_flag_instance
    case vumc
      set aws_profile_credentials "$HOME/.aws/credentials.$_flag_profile"
      set secrets_engine cloudservices-aws
      set vault_aws_role $_flag_profile-admin
      set fqdn (_vault_fqdn $_flag_instance)

      if set -q VUMC_VAULT_TOKEN
        _vault_generate_token $_flag_instance
      else
        _vault_token_check $_flag_instance $VUMC_VAULT_TOKEN
      end

      set vtoken $VUMC_VAULT_TOKEN
      set token_name VUMC_VAULT_TOKEN

    case home
      set secrets_engine aws
      set vault_aws_role admin
      set fqdn (_vault_fqdn $_flag_instance)
      set aws_profile_credentials "$HOME/.aws/credentials.default"

      if set -q HOME_VAULT_TOKEN
        _vault_generate_token $_flag_instance
      else
        _vault_token_check $_flag_instance $HOME_VAULT_TOKEN
      end

      set vtoken $HOME_VAULT_TOKEN
      set token_name HOME_VAULT_TOKEN

    case "*"
      echo "ERROR: unknown instance $_flag_instance!"
      exit 1
  end

  if test $_flag_console
    set time_unit (string match -r '.$' $_flag_ttl)
    set time_int (string trim -c $time_unit $_flag_ttl)

    switch $time_unit
      case m
        set ttl (command expr $time_int \* 60)
      case h
        set ttl (command expr $time_int \* 3600)
      case "*"
        set ttl 900
    end

    set tmpdir (mktemp -d /tmp/awsfox_userdata.XXXXXXXXXX)
    set login_url ($__fish_config_dir/scripts/aws_url.py --url $fqdn --role $vault_aws_role --mount $secrets_engine --ttl $ttl --token_name $token_name)

    command mkdir -p $tmpdir
    /Applications/Firefox.app/Contents/MacOS/firefox \
      -no-remote \
      -profile $tmpdir \
      -new-instance \
      -silent \
      $login_url \
      >/dev/null 2>&1 &

  else
    set aws_credentials "$HOME/.aws/credentials"

    echo "[$_flag_profile]" > $aws_profile_credentials

    curl -s --header "X-Vault-Token:$vtoken" --request GET "https://$fqdn/v1/$secrets_engine/sts/$vault_aws_role?ttl=$_flag_ttl" | jq -r ".data|to_entries|map(\"\(.key) = \(.value|tostring)\")|.[]" | sed -e 's/access_key/aws_access_key_id/' -e 's/secret_key/aws_secret_access_key/' -e 's/security_token/aws_session_token/' >> $aws_profile_credentials

    touch $aws_credentials

    truncate -s 0 $aws_credentials

    find "$HOME/.aws" -name "credentials.*" -exec cat {} >> $aws_credentials \;

  end



end
