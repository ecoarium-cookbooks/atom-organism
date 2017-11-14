export ATOM_BIN=/usr/local/bin/atom

if [[ "$OS_NAME" == 'Windows' ]]; then
  export ATOM_BIN=$HOME/AppData/Local/atom/bin/atom
fi

function atom() {
  if [[ -n "${*}" && -t 0 ]]; then
    # if no stdin and arg(s) open arg(s)/file_path(s)

    if [[ -z "$2" && ! -e "$1" ]]; then
      local dir="$(dirname "$1")"
      if [[ ! -e "${dir}" ]]; then
        mkdir -p "${dir}"
      fi
    fi

    atom_open "${*}"

  elif [[ -z "${*}" && ! -t 0 ]]; then
    # if stdin and no args open each line as file path

    local IFS=
    local data=''
    while read file_path ; do
      local dir="$(dirname "${file_path}")"
      if [[ ! -e "${dir}" ]]; then
        mkdir -p "${dir}"
      fi

      atom_open "${file_path}"
    done

  elif [[ -n "$1" && -z "$2" && ! -t 0 ]]; then
    # if stdin and one arg write stdin into arg/file_path and then open file

    local dir="$(dirname "$1")"
    if [[ ! -e "${dir}" ]]; then
      mkdir -p "${dir}"
    fi

    local IFS=
    local data=''
    while read data ; do
      echo "$data" >> "${1}"
    done

    atom_open "$1"
  else
    fail 'Why the face?, did you pass multiple arguments and pipe output to this function?'
  fi
}

function atom_open() {
  "${ATOM_BIN}" "${*}"
}

function atom_project() {
  atom_open -a "${PATHS_PROJECT_HOME}"
}
