function exip -d "display external IP (v4 & v6)"
  set -l v4 (curl -s ipv4.icanhazip.com)
  set -l v6 (curl -s icanhazip.com)
  if test $v4 != $v6
    echo $v4
    echo $v6
  else
    echo $v4
  end
end
