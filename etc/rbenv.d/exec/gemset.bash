if [ "$(rbenv-version-name)" = "system" ]; then
  RBENV_GEMSET_ROOT="$RBENV_GEMSET_SYSTEM_ROOT"
else
  RBENV_GEMSET_ROOT="$(rbenv-prefix)/gemsets"
fi

export RBENV_GEMSETS=$(rbenv-gemset active 2>/dev/null)

for gemset in $RBENV_GEMSETS; do
  path="${RBENV_GEMSET_ROOT}/$gemset"
  if [ -z "$gem_home" ]; then
    gem_home="$path"
    gem_path="$path"
  else
    gem_path="$gem_path:$path"
  fi
done

if [ -n "$gem_home" ]; then
  export GEM_HOME=$gem_home GEM_PATH=$gem_path
fi
