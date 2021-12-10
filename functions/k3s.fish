function k3s --wraps='kubectl --kubeconfig=/Users/sean/Documents/.dotfiles/kube/elrond' --description 'alias k3s kubectl --kubeconfig=/Users/sean/Documents/.dotfiles/kube/elrond'
  kubectl --kubeconfig=/Users/sean/Documents/.dotfiles/kube/elrond $argv; 
end
