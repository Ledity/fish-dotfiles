if status is-interactive # Commands to run in interactive sessions can go here
    function _add_abbr_if_exists
        if test -e "$argv[2]"
            set -f dest "$(string escape --style=script -- $argv[2])"
            abbr --add "$argv[1]" --position=anywhere --set-cursor "$dest/%"
        end
    end

    _add_abbr_if_exists work-d "$HOME/Work"
    _add_abbr_if_exists doc-d "$HOME/Документы"
    _add_abbr_if_exists vid-d "$HOME/Видео"
    _add_abbr_if_exists down-d "$HOME/Загрузки"
    _add_abbr_if_exists game-d "$HOME/Игры"
    _add_abbr_if_exists img-d "$HOME/Изображения"
    _add_abbr_if_exists mus-d "$HOME/Музыка"
    _add_abbr_if_exists com-d "$HOME/Общедоступные"
    _add_abbr_if_exists desk-d "$HOME/Рабочий Стол"
    _add_abbr_if_exists temp-d "$HOME/Шаблоны"

    function list-homedir-abbrs --description "Сокращения каталогов в \$HOME"
        echo -e "\
work-d\t\"$HOME/Work\"\n\
doc-d\t\"$HOME/Документы\"\n\
vid-d\t\"$HOME/Видео\"\n\
down-d\t\"$HOME/Загрузки\"\n\
game-d\t\"$HOME/Игры\"\n\
img-d\t\"$HOME/Изображения\"\n\
mus-d\t\"$HOME/Музыка\"\n\
com-d\t\"$HOME/Общедоступные\"\n\
desk-d\t\"$HOME/Рабочий стол\"\n\
temp-d\t\"$HOME/Шаблоны\"\n\
        " >&2
    end
end
