#!/bin/zsh
#
# Symlink this repository's config files into their expected locations.
#
# Existing real files are moved into a timestamped backup directory before the
# symlink is created; links that already point at this repo are left alone, so
# the script is safe to re-run. VSCode / Cursor / Sublime configs and the
# legacy Windows / Grunt leftovers are deliberately not handled here.
#
# Usage: ./install.zsh [--dry-run]

set -eu

script_name=${0:t}
repo_dir=${0:A:h}
target_home=${HOME:?HOME is required}
config_home=${XDG_CONFIG_HOME:-"${target_home}/.config"}
dry_run=false
backup_dir=""
linked=0
skipped=0
backed_up=0

usage() {
  print -r -- "Usage: ${script_name} [--dry-run]"
  print -r -- ""
  print -r -- "Symlink the dotfiles in ${repo_dir} into \$HOME and \$XDG_CONFIG_HOME."
  print -r -- "Displaced files are backed up to ~/.dotfiles-backup-<timestamp>/."
}

case ${1:-} in
  "") ;;
  --dry-run) dry_run=true ;;
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

# repo-relative source -> absolute destination
typeset -a links
links=(
  ".zshrc:${target_home}/.zshrc"
  ".zshenv:${target_home}/.zshenv"
  ".zprofile:${target_home}/.zprofile"
  ".bashrc:${target_home}/.bashrc"
  ".bash_profile:${target_home}/.bash_profile"
  ".vimrc:${target_home}/.vimrc"
  ".tmux.conf:${target_home}/.tmux.conf"
  ".gitconfig:${target_home}/.gitconfig"
  ".gitignore_global:${target_home}/.gitignore_global"
  ".actrc:${target_home}/.actrc"
  ".claude/settings.json:${target_home}/.claude/settings.json"
  ".claude/cmux-dmux-notify.sh:${target_home}/.claude/cmux-dmux-notify.sh"
  "gh/config.yml:${config_home}/gh/config.yml"
  "ghostty/config:${config_home}/ghostty/config"
  "herdr/config.toml:${config_home}/herdr/config.toml"
  "hunk/config.toml:${config_home}/hunk/config.toml"
  "zed/settings.json:${config_home}/zed/settings.json"
  "zed/themes/azurish.json:${config_home}/zed/themes/azurish.json"
)

ensure_backup_dir() {
  if [[ -n "$backup_dir" ]]; then
    return
  fi

  backup_dir="${target_home}/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
  if [[ -e "$backup_dir" ]]; then
    backup_dir="${backup_dir}.$$"
  fi

  if [[ "$dry_run" == true ]]; then
    print -r -- "would create backup dir: ${backup_dir}"
    return
  fi

  mkdir -p "$backup_dir"
}

for entry in "${links[@]}"; do
  source_rel=${entry%%:*}
  dest=${entry#*:}
  source_abs="${repo_dir}/${source_rel}"

  if [[ ! -e "$source_abs" ]]; then
    print -u2 -r -- "Missing source, aborting: ${source_abs}"
    exit 1
  fi

  # Already pointing at this repo: nothing to do.
  if [[ -L "$dest" && ${dest:A} == ${source_abs:A} ]]; then
    (( skipped += 1 ))
    continue
  fi

  if [[ -e "$dest" && ! -f "$dest" && ! -L "$dest" ]]; then
    print -u2 -r -- "Refusing to replace a non-file path: ${dest}"
    exit 1
  fi

  dest_dir=${dest:h}
  if [[ ! -d "$dest_dir" ]]; then
    if [[ "$dry_run" == true ]]; then
      print -r -- "would mkdir -p ${dest_dir}"
    else
      mkdir -p "$dest_dir"
    fi
  fi

  # Displace whatever is there: real files are kept, stale symlinks are dropped.
  if [[ -L "$dest" ]]; then
    if [[ "$dry_run" == true ]]; then
      print -r -- "would remove stale symlink ${dest} -> ${dest:A}"
    else
      rm -f "$dest"
    fi
  elif [[ -e "$dest" ]]; then
    ensure_backup_dir
    backup_path="${backup_dir}/${dest#${target_home}/}"
    if [[ "$dry_run" == true ]]; then
      print -r -- "would back up ${dest} -> ${backup_path}"
    else
      mkdir -p "${backup_path:h}"
      mv "$dest" "$backup_path"
    fi
    (( backed_up += 1 ))
  fi

  if [[ "$dry_run" == true ]]; then
    print -r -- "would link ${dest} -> ${source_abs}"
  else
    ln -s "$source_abs" "$dest"
    print -r -- "linked ${dest} -> ${source_abs}"
  fi
  (( linked += 1 ))
done

print -r -- ""
if [[ "$dry_run" == true ]]; then
  print -r -- "dry run: ${linked} to link, ${skipped} already correct, ${backed_up} to back up"
else
  print -r -- "done: ${linked} linked, ${skipped} already correct, ${backed_up} backed up"
  if [[ -n "$backup_dir" ]]; then
    print -r -- "backup: ${backup_dir}"
  fi
fi

print -r -- ""
print -r -- "Codex config is handled separately: ${repo_dir}/codex/install.zsh"
