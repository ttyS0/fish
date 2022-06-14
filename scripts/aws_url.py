#!/usr/bin/env python3

# This script requires Python3 and the following modules
import json
import urllib.parse
import requests
import hvac
import argparse
import sys
import os

# By default, CloudServices Vault instance, CloudServices AWS Secrets Engine, CloudServices Admin Role,
# and us-east-1 region is assumed. If any elements are different, use the following arguments to modify them.
parser = argparse.ArgumentParser(description='Generate Signed AWS URL for Console Login')
parser.add_argument('--url', nargs='?', help='FQDN of Vault instance', default='vault.ttys0.net',
                    dest='vaultURL')
parser.add_argument('--token_name', nargs='?', help='ENV name of Vault Token', default='HOME_VAULT_TOKEN', dest='vaultTokenName')
parser.add_argument('--role', nargs='?', help='Name of Vault AWS Role', default='admin', dest='vaultRole')
parser.add_argument('--mount', nargs='?', help='Name of AWS Secret Engine Mount', default='aws',
                    dest='vaultAWS')
parser.add_argument('--region', nargs='?', help='AWS Region', default='us-east-1', dest='regionAWS')
parser.add_argument('--ttl', nargs='?', help='TTL of AWS Session in seconds', default='3600', dest='ttlAWS')
args = parser.parse_args()

# Instantiate a Vault client object. A valid token in VAULT_TOKEN or ~/.vault-token is required.
vault = hvac.Client(
    url='https://' + args.vaultURL,
    token=os.environ[args.vaultTokenName],
)

if not vault.is_authenticated():
    sys.exit("Vault Token is not valid!")

# Fetch AWS STS Credentials for AWS Role
gen_creds_response = vault.secrets.aws.generate_credentials(
    name=args.vaultRole,
    mount_point=args.vaultAWS,
)

# Format resulting temporary credentials into JSON
json_string_with_temp_credentials = '{'
json_string_with_temp_credentials += '"sessionId":"' + gen_creds_response['data']['access_key'] + '",'
json_string_with_temp_credentials += '"sessionKey":"' + gen_creds_response['data']['secret_key'] + '",'
json_string_with_temp_credentials += '"sessionToken":"' + gen_creds_response['data']['security_token'] + '"'
json_string_with_temp_credentials += '}'

# Make request to AWS federation endpoint to get sign-in token. Construct the parameter string with
# the sign-in action request, a 12-hour session duration, and the JSON document with temporary credentials
# as parameters.
request_parameters = "?Action=getSigninToken"
request_parameters += "&SessionDuration=" + args.ttlAWS
request_parameters += "&Session=" + urllib.parse.quote_plus(json_string_with_temp_credentials)
request_url = "https://signin.aws.amazon.com/federation" + request_parameters
r = requests.get(request_url)
# Returns a JSON document with a single element named SigninToken.
signin_token = json.loads(r.text)

# Create URL where users can use the sign-in token to sign in to
# the console. This URL must be used within 15 minutes after the
# sign-in token was issued.
request_parameters = "?Action=login"
request_parameters += "&Issuer=" + args.vaultURL
request_parameters += "&Destination=" + urllib.parse.quote_plus(
    "https://console.aws.amazon.com/console/home?region=") + args.regionAWS
request_parameters += "&SigninToken=" + signin_token["SigninToken"]
request_url = "https://signin.aws.amazon.com/federation" + request_parameters

# Send final URL to stdout
print(request_url)
