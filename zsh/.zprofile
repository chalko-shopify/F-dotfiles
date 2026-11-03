# .zprofile: login shell zsh setup and profile snippet loader

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"

# load zsh profile config files
profile_files=(${XDG_CONFIG_HOME}/**/*.zprofile(N))
for file in ${profile_files}
do
  source $file
done
