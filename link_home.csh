#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "link_home.csh is kept for compatibility."
echo "Using install_vim7.sh; shell/git config files will not be touched."
exec bash "${script_dir}/install_vim7.sh" "$@"
