if [ -z "$RBENV_GEMSET_SYSTEM_ROOT" ]; then
  export RBENV_GEMSET_SYSTEM_ROOT="/usr/local/share/ruby-gemsets"
fi
if [ "$(rbenv-version-name)" = "system" ]; then
  RBENV_GEMSET_ROOT="$RBENV_GEMSET_SYSTEM_ROOT"
else
  RBENV_GEMSET_ROOT="$(rbenv-prefix)/gemsets"
fi

export RBENV_GEMSETS=$(rbenv-gemset active 2>/dev/null)

if [ -z "$IGNORE_GEMSETS" ]; then
  # Protect from recursion when handling default gemsepc
  for gemset in $RBENV_GEMSETS; do
    if [ "default" = "$gemset" ]; then
      unset GEM_HOME GEM_PATH
      path=$(IGNORE_GEMSETS=true rbenv-exec gem environment GEM_HOME 2> /dev/null)
      paths=$(IGNORE_GEMSETS=true rbenv-exec gem environment GEM_PATH 2> /dev/null)
    else
      path="${RBENV_GEMSET_ROOT}/$gemset"
      paths=$path
    fi
    if [ -n "$path" ]; then
      if [ -z "$gem_home" ]; then
        gem_home="$path"
        gem_path="$paths"
      else
        gem_path="$gem_path:$paths"
      fi
    fi
  done

  if [ -n "$gem_home" ]; then
    export GEM_HOME=$gem_home GEM_PATH=$gem_path
  fi
fi
