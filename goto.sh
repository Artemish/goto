declare -A __gotodb
__alias_file=~/aliases.txt

__read_gotodb() {
  __gotodb=()
  while read line; do
    DELIM=${IFS}; IFS=":"
    tokens=(${line}); IFS=$DELIM

    key=${tokens[0]};
    value=${tokens[1]};
    __gotodb["$key"]="$value"
  done < ${__alias_file}
}

__write_gotodb() {
  > ${__alias_file}
  for key in "${!__gotodb[@]}"; do
    echo "${key}:${__gotodb[${key}]}" >> ${__alias_file}
  done
}

goto() {
  local usage='Usage: goto [-m destination] name'

  if [[ $# == 0 ]] ; then
    echo "$usage"
    return 1
  fi
  
  if [ -z ${__gotodb} ]; then 
    __read_gotodb
  fi

  # getopt seemed like overkill
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

    __gotodb["$3"]=${abspath}

    __write_gotodb

  elif [[ $1 == '-d' ]]; then
    if [[ $# -ne 2 ]]; then
      echo "$usage"
      return 1
    fi

    local result=${__gotodb[$2]}
    if [[ -z "$result" ]] ; then
      echo "No alias for '$2'."
      return -1
    fi

    __gotodb["$2"]=''
    __write_gotodb

  else
    local result=${__gotodb[$1]}
    if [[ -e "$result" ]] ; then
      cd "$result"
      return 0
    else
      echo "No alias for '$1'."
      return -1
    fi
  fi
}
