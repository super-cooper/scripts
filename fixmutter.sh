#!/bin/env bash

cd ~/Downloads

mkdir mutter
cd mutter

sudo apt build-dep mutter
apt source mutter
cd $(ls | grep mutter-*)
sed -i -E 's/workspace_manager->workspace_layout_overridden = TRUE;/workspace_manager->workspace_layout_overridden = FALSE;/g' src/core/meta-workspace-manager.c
dpkg-buildpackage -us -uc -nc
sudo dpkg -i ../*.deb
