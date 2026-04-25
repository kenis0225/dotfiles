#!/usr/bin/env bash
set -euo pipefail

cd ~/.local/opt
rm -rf nvim-macos-x86_64.tar.gz
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-macos-x86_64.tar.gz
rm -rf nvim-macos-x86_64
tar -xf nvim-macos-x86_64.tar.gz
