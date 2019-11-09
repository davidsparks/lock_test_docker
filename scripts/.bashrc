PROJECT_BASE_DIR="/var/www/html"
export PATH="$PROJECT_BASE_DIR/scripts:$PATH"

LS_COLORS='di=32:fi=37:ln=31:pi=5:so=5:bd=5:cd=5:or=31:mi=0:ex=35:*.rpm=90'
export LS_COLORS

PS1="\[\033[0;32m\]\u@\H \[\033[0;36m\]\w \[\033[0;32m\]\\$\[\033[00m\] "

alias d="ls -aFhl --color=auto"
alias ..="cd ..; d"

alias xdoff="xdebug-toggle.sh off"
alias xdon="xdebug-toggle.sh on"

alias dl="drush @default.dev"
alias dcc="dl cc all"
alias dwst="dl ws --extended --count=100 --tail"
