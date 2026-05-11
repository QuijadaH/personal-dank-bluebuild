if [[ $- == *i* ]] && [[ -z $FASTFETCH_SHOWN ]]; then
    fastfetch
    export FASTFETCH_SHOWN=1
fi

if [[ -z $STARSHIP_SHELL ]]; then
    eval "$(starship init bash)"
fi