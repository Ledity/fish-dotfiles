if status is-interactive
    if test -e "$HOME/.profile"
        if type -q bass
            bass source "$HOME/.profile"
        else
            printf "'bass' extension is not installed, unable to source .profile"
        end
    end

    abbr --add ":q" exit
end
