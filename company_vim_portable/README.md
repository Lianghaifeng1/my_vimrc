# company_vim_portable

Portable offline Vim/gVim configuration for company servers.

## Contents

- `.vimrc`: merged personal habits from `/home/eda/.vimrc` and SV/UVM settings from `my_vimrc`.
- `.gvimrc`: gVim UI/font settings.
- `.vim/`: offline plugins and syntax files. fzf and rust.vim are removed.
- `bin/exctags`, `bin/exreadtags`: ctags tools used by Tagbar/Taglist.
- `install.sh`: copy installer with backup.

## Install

```bash
cd company_vim_portable
bash install.sh
gvim -V9/tmp/gvim_startup.log test.sv
```

The installer only copies Vim related files. It does not touch `.bashrc`,
`.cshrc`, `.gitconfig`, `.gitignore`, or `.emacs.d`.

Existing files are moved to `~/.vim_portable_backup_<timestamp>/`.

## Compatibility Notes

- Target company version: gvim 7.4.629.
- fzf is intentionally removed.
- gutentags is enabled only when Vim has `+job`; Vim 7.4.629 should skip it.
- mucomplete auto popup is enabled only on Vim 7.4.775+; older Vim keeps manual/menu completion.
- F4/F8 use Tagbar if available, otherwise fall back to Taglist.
- Pre-generated tag databases are not included. Generate project tags on the
  company server, for example: `~/bin/exctags -R -f tags .`.

## Package

From `/home/eda/prj/vim_cfg`:

```bash
tar czf company_vim_portable.tar.gz company_vim_portable
```
