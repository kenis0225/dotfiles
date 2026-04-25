#!/bin/bash
rm -rf /tmp/oh-my-rime && \
git clone --depth 1 https://github.com/Mintimate/oh-my-rime.git /tmp/oh-my-rime && \
cp -rf /tmp/oh-my-rime/* $HOME/.local/share/fcitx5/rime/ && \
rm -rf /tmp/oh-my-rime