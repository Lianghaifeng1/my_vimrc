#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
backup_root="${HOME}/.vim_portable_backup_$(date +%Y%m%d_%H%M%S)"

backup_path() {
    local target="$1"

    if [ -L "$target" ]; then
        rm -f "$target"
        return
    fi

    if [ -e "$target" ]; then
        mkdir -p "$backup_root"
        mv "$target" "$backup_root/"
        echo "backup: $target -> $backup_root/"
    fi
}

link_path() {
    local source="$1"
    local target="$2"

    if [ ! -e "$source" ]; then
        echo "skip missing source: $source"
        return
    fi

    backup_path "$target"
    ln -s "$source" "$target"
    echo "link: $target -> $source"
}

copy_path() {
    local source="$1"
    local target="$2"

    if [ ! -e "$source" ]; then
        echo "skip missing source: $source"
        return
    fi

    backup_path "$target"
    cp -a "$source" "$target"
    echo "copy: $target <- $source"
}

mkdir -p "${HOME}/bin"

copy_path "${repo_dir}/.vimrc" "${HOME}/.vimrc"
copy_path "${repo_dir}/.gvimrc" "${HOME}/.gvimrc"
copy_path "${repo_dir}/.vim" "${HOME}/.vim"
copy_path "${repo_dir}/.uvmrc" "${HOME}/.uvmrc"
copy_path "${repo_dir}/.ctags" "${HOME}/.ctags"
copy_path "${repo_dir}/.ctags.d" "${HOME}/.ctags.d"

copy_path "${repo_dir}/bin/exctags" "${HOME}/bin/exctags"
copy_path "${repo_dir}/bin/exreadtags" "${HOME}/bin/exreadtags"

echo "done."
echo "test: gvim -V9/tmp/gvim_startup.log test.sv"
