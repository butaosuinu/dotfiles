#!/bin/zsh

set -eu

script_name=${0:t}
repo_codex_dir=${0:A:h}
template_path="${repo_codex_dir}/config.toml.template"
generated_config_path="${repo_codex_dir}/config.toml"
target_home_dir=${HOME:?HOME is required}
target_codex_dir=${CODEX_HOME:-"${target_home_dir}/.codex"}
target_cache_dir=${XDG_CACHE_HOME:-"${target_home_dir}/.cache"}
live_config_path="${target_codex_dir}/config.toml"
replace_existing=false
live_is_managed=false

usage() {
  print -r -- "Usage: ${script_name} [--replace-existing]"
  print -r -- ""
  print -r -- "Render config.toml.template for this Mac and link it to the Codex config path."
  print -r -- "An existing config is backed up only when it matches the rendered template,"
  print -r -- "unless --replace-existing is specified."
}

case ${1:-} in
  "") ;;
  --replace-existing) replace_existing=true ;;
  -h|--help)
    usage
    exit 0
    ;;
  *)
    usage >&2
    exit 2
    ;;
esac

if (( $# > 1 )); then
  usage >&2
  exit 2
fi

if [[ ! -f "$template_path" ]]; then
  print -u2 -r -- "Template not found: ${template_path}"
  exit 1
fi

mkdir -p "$target_codex_dir"

if [[ -L "$live_config_path" ]]; then
  if [[ -f "$generated_config_path" && ${live_config_path:A} == ${generated_config_path:A} ]]; then
    live_is_managed=true
  else
    print -u2 -r -- "Refusing to replace an unexpected symlink: ${live_config_path}"
    exit 1
  fi
fi

if [[ -e "$live_config_path" && ! -f "$live_config_path" ]]; then
  print -u2 -r -- "Refusing to replace a non-file path: ${live_config_path}"
  exit 1
fi

if [[ -e "$generated_config_path" && "$live_is_managed" != true ]]; then
  print -u2 -r -- "Refusing to overwrite an existing generated config: ${generated_config_path}"
  exit 1
fi

temp_config_path=$(mktemp "${repo_codex_dir}/.config.toml.tmp.XXXXXX")
cleanup() {
  if [[ -n ${temp_config_path:-} && -e "$temp_config_path" ]]; then
    rm -f "$temp_config_path"
  fi
}
trap cleanup EXIT HUP INT TERM

while IFS= read -r config_line || [[ -n "$config_line" ]]; do
  config_line=${config_line//__DOTFILES_CODEX_HOME__/${target_codex_dir}}
  config_line=${config_line//__DOTFILES_CACHE_HOME__/${target_cache_dir}}
  config_line=${config_line//__DOTFILES_HOME__/${target_home_dir}}
  print -r -- "$config_line"
done < "$template_path" > "$temp_config_path"

if grep -q '__DOTFILES_' "$temp_config_path"; then
  print -u2 -r -- "Unresolved path token found in rendered config."
  exit 1
fi

chmod 600 "$temp_config_path"

if [[ "$live_is_managed" == true ]]; then
  if cmp -s "$generated_config_path" "$temp_config_path"; then
    print -r -- "Codex config is already up to date: ${live_config_path}"
    exit 0
  fi

  if [[ "$replace_existing" != true ]]; then
    print -u2 -r -- "Managed Codex config differs from the template: ${generated_config_path}"
    print -u2 -r -- "Review it first, then rerun with --replace-existing to apply the template."
    exit 1
  fi

  backup_config_path="${target_codex_dir}/config.toml.backup-$(date +%Y%m%d-%H%M%S)"
  if [[ -e "$backup_config_path" ]]; then
    backup_config_path="${backup_config_path}.$$"
  fi

  cp "$generated_config_path" "$backup_config_path"
  chmod 600 "$backup_config_path"
  mv "$temp_config_path" "$generated_config_path"
  temp_config_path=""

  print -r -- "Updated generated Codex config: ${generated_config_path}"
  print -r -- "Linked Codex config: ${live_config_path}"
  print -r -- "Backed up previous config: ${backup_config_path}"
  exit 0
fi

if [[ -f "$live_config_path" ]] && ! cmp -s "$live_config_path" "$temp_config_path" && [[ "$replace_existing" != true ]]; then
  print -u2 -r -- "Existing Codex config differs from the template: ${live_config_path}"
  print -u2 -r -- "Review it first, then rerun with --replace-existing if replacement is intended."
  exit 1
fi

if ! mv "$temp_config_path" "$generated_config_path"; then
  print -u2 -r -- "Could not install the generated config: ${generated_config_path}"
  exit 1
fi
temp_config_path=""

backup_config_path=""
if [[ -f "$live_config_path" ]]; then
  backup_config_path="${target_codex_dir}/config.toml.backup-$(date +%Y%m%d-%H%M%S)"
  if [[ -e "$backup_config_path" ]]; then
    backup_config_path="${backup_config_path}.$$"
  fi

  if ! mv "$live_config_path" "$backup_config_path"; then
    rm -f "$generated_config_path"
    print -u2 -r -- "Could not back up the existing config: ${live_config_path}"
    exit 1
  fi
  chmod 600 "$backup_config_path"
fi

if ! ln -s "$generated_config_path" "$live_config_path"; then
  rm -f "$generated_config_path"
  if [[ -n "$backup_config_path" ]]; then
    mv "$backup_config_path" "$live_config_path"
  fi
  print -u2 -r -- "Could not create Codex config symlink: ${live_config_path}"
  exit 1
fi

print -r -- "Generated Codex config: ${generated_config_path}"
print -r -- "Linked Codex config: ${live_config_path}"
if [[ -n "$backup_config_path" ]]; then
  print -r -- "Backed up previous config: ${backup_config_path}"
fi
