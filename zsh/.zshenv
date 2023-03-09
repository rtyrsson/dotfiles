XDG_CONFIG_HOME="$HOME/.config"
source "$XDG_CONFIG_HOME/user-dirs.dirs"
ZDOTDIR="$HOME/.config/zsh"
export JUPYTER_CONFIG_DIR="$HOME/.config/.jupyter"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export LESSHISTFILE="$XDG_CONFIG_HOME/lesshst"
export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"
if [[ "$HOST" =~ "MB-FFM-16" ]]; then
	export PATH="/usr/local/opt/coreutils/libexec/gnubin:${PATH}"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:${MANPATH}"
fi
