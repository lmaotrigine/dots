command_not_found_handler () {
  local pkgs cmd="$1"
  pkgs=(${(f)"$(pkgfile -b -v  -- "$cmd" 2>/dev/null)"})
  if [[ -n "$pkgs" ]]
  then
    printf '%s may be found in the following packages:\n' "$cmd"
    printf '  %s\n' $pkgs[@]
    first="$(echo "$pkgs" | sed -E 's:\w+/::; s:\s.*$::' | head -n 1)"
    printf 'Install %s? [y|N]:' "$first"
    read res
    if [ "$res" = "y" ] || [ "$res" = "Y" ]; then
      sudo pacman -S "$first"
    fi
  else
    printf 'zsh: command not found: %s\n' "$cmd"
  fi >&2
  return 127
}
