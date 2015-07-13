declare -A GOTODB
__alias_file=~/aliases.txt

__goto_complete() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"

  COMPREPLY=( $(compgen -W "${!GOTODB[*]}" -- "${cur}") )
  return 0
}

complete -F __goto_complete goto

__read_gotodb() {
  GOTODB=()
  while read line; do
    # set & restore the bash field delimiter
    DELIM=${IFS}; IFS=":"
    tokens=(${line}); IFS=$DELIM

    key=${tokens[0]};
    value=${tokens[1]};
    GOTODB["$key"]="$value"
  done < ${__alias_file}
}

__write_gotodb() {
  # Clear the alias file
  > ${__alias_file}
  for key in "${!GOTODB[@]}"; do
    local value="${GOTODB[${key}]}"
    echo "${key}:${value}" >> ${__alias_file}
  done
}

goto() {
  local usage="\
    Usage: goto alias
  [-m destination] alias
  [-x alias] alias
  -l"

  if [[ $# == 0 ]] ; then
    echo "$usage"
    return 1
  fi

  if [ -z ${GOTODB} ]; then 
    __read_gotodb
  fi

  # getopt seemed like overkill
  # 'm' for making a new alias
  if [[ $1 == '-m' ]] ; then
    if [[ $# -ne 3 ]]; then
      echo "$usage"
      return 1
    fi

    local abspath=$(cd "$(dirname "$2")"; pwd)/"$(basename "$2")"

    if ! [[ -e $abspath ]] ; then
      echo "No such directory: $abspath"
      return 2
    fi

    GOTODB["$3"]=${abspath}

    __write_gotodb

    # 'd' for deleting an alias
  elif [[ $1 == '-d' ]]; then
    if [[ $# -ne 2 ]]; then
      echo "$usage"
      return 1
    fi

    local result=${GOTODB[$2]}
    if [[ -z "$result" ]] ; then
      echo "No alias for '$2'."
      return -1
    fi

    unset GOTODB["$2"]
    __write_gotodb

    # 'l' for listing aliases
  elif [[ $1 == '-l' ]]; then
    for key in "${!GOTODB[@]}"; do
      echo "${key} -> ${GOTODB[${key}]}" 
    done | column -t 

    # default case - find the entry and CD to it
  else
    local result=${GOTODB[$1]}
    if [[ -e "$result" ]] ; then
      cd "$result"
      return 0
    else
      echo "No alias for '$1'."
      return -1
    fi
  fi
}

__read_gotodb
