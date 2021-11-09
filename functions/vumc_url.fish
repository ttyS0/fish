function vumc_url -d "VUMC URL Disambiguation"
  curl --silent --location --output /dev/null --write-out '%{url_effective}' -- $argv | pbcopy && echo "url copied to clipboard!"
end
