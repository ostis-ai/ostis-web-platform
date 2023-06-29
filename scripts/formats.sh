stage()
{
  ([ -n "$(tput setaf 1 2<&-)" ] && { tput setaf 4 && tput bold && echo "$1" && tput sgr0; }) || echo "$1"
}
