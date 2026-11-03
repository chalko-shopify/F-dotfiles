# .zprofile: login shell zsh setup and profile snippet loader

# load zsh profile config files
profile_files=(${XDG_CONFIG_HOME}/**/*.zprofile(N))
for file in ${profile_files}
do
  source $file
done
