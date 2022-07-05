# install nix
echo "🚀 Installing nix"
sh <(curl -L https://nixos.org/nix/install) --no-daemon

# source nix 
. ~/.nix-profile/etc/profile.d/nix.sh

echo "🚀 Installing packages"
# install packages
packages=(
  zsh 
  antibody
  neovim 
  gcc 
  yarn 
  bat 
  tmux 
  stow 
  git 
)

for package in ${packages[@]}
do 
  echo "📦 Installing $package"
  nix-env -iA nixpkgs.$package
done

# stow files
stow_dirs=(
  zsh
  tmux
  git
  nvim
  p10k
)

for dirs in ${stow_dirs[@]}
do
  echo "➦ Creating symlinks for $dirs"
  stow $dirs
done
  

# add zsh as a login shell
echo "🚀 Configuring ZSH as default shell"
command -v zsh | sudo tee -a /etc/shells
chsh -s $(which zsh) $USER

# bundle zsh plugins
echo "🎁 Bundle antibody plugins"
antibody bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.sh

# install packer
echo "🚀 Installing nvim plugin manager"
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	~/.local/share/nvim/site/pack/packer/start/packer.nvim

# install plugins
echo "🔨 Installing nvim plugins"
nvim --headless +PackerSync +qa 

# execute zsh
echo "⚙️  Executing zsh"
exec zsh
