alias ncal='ncal -bMw'
alias year='ncal -y'
alias wanip='dig +short myip.opendns.com @resolver1.opendns.com'
alias copylastcommand='history -p \!\! | xsel -ib'
alias e='emacsclient -n'
alias ec='emacsclient -c -n'
#alias et='emacsclient -t'
et() {
  emacsclient -t "$@" 2>/dev/null || emacs -nw "$@"
}
