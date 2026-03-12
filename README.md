# dotfiles

## Setup

### homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew bundle --global
```

```bash
brew bundle dump --global --force --describe
```

### chezmoi

```bash
mkdir ~/.config/chezmoi
cp ./chezmoi.yaml ~/.config/chezmoi/chezmoi.yaml
```
### Git

```bash
git config --global user.name "ken.huang1"
git config --global user.email "ken.huang1@ecoflow.com"
```

### Code
 
#### settings.json

```bash
mv ~/Library/Application\ Support/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings.json.bak
ln -s ~/.config/Code/User/settings.json ~/Library/Application\ Support/Code/User/settings.json

mv ~/Library/Application\ Support/Code/User/mcp.json ~/Library/Application\ Support/Code/User/mcp.json.bak
ln -s ~/.config/Code/User/mcp.json ~/Library/Application\ Support/Code/User/mcp.json
```

#### extensions

.Brewfile 也会导出 vscode extensions，macOS 可以不用单独管理 vscode extensions

```bash
code --list-extensions > extensions.txt
```

```bash
cat extensions.txt | xargs -n 1 code --install-extension
```

### kitty

```bash
ln -s ./tokyo-night.conf ./theme.conf
```

### PowerShell

```pwsh
new-Item -ItemType SymbolicLink -Path ~/Documents/PowerShell -Target ~/.config/PowerShell
```
