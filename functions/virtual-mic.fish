function virtual-mic --description 'add a virtual microphone decieve apps'
    argparse --name=virtual-mic pa pw -- $argv
    or return 172
    argparse --name=virtual-mic --min-args=1 --max-args=1 -- $argv
    or return 172

    # COMMAND
    if test "$argv[1]" = add
        set -f COMMAND add
    else if test \( "$argv[1]" = del \) -o \( "$argv[1]" = delete \)
        set -f COMMAND del
    else if test -n "$argv[1]"
        echo "Unknown command. Try `add` or `del`"
        return 255
    else
        echo "Need a command. Try `add` or `del`"
        return 254
    end

    # USED SERVER
    if test -n "$_flag_pw"
        if type -q pw-cli
            set -f SERVER pw
        else
            echo "Could find `pw-cli`"
            return 1
        end
    else if test -n "$_flag_pa"
        if type -q pactl
            set -f SERVER pa
        else
            echo "Could find `pactl`"
            return 1
        end
    else
        if type -q pw-cli
            set -f SERVER pw
        else if type -q pactl >/dev/null
            set -f SERVER pa
        else
            echo "Could find neither `pw-cli`, not `pactl`"
            return 1
        end
    end

    # EXISTS
    if test "$SERVER" = pw
        if pw-cli list-objects | grep "pw-virt-mic@$(whoami)"
            set -f EXISTS true
        else
            set -f EXISTS nil
        end
    else if test "$SERVER" = pa
        if pactl list | grep "pa-virt-mic@$(whoami)"
            set -f EXISTS true
        else
            set -f EXISTS nil
        end
    end

    # MAIN
    if test "$COMMAND" = add
        if test "$EXISTS" = true
            echo "Virtual microphone already exists" &>2
            return 32
        else if test "$SERVER" = pw
            pw-cli create-node adapter "{ factory.name=support.null-audio-sink node.name=pw-virt-mic@$(whoami) media.class=Audio/Source/Virtual object.linger=true audio.position=[FL FR] monitor.channel-volumes=true }"
        else if test "$SERVER" = pa
            pactl load-module module-null-sink media.class=Audio/Source/Virtual sink_name=pa-virt-mic@$(whoami) channel_map=front-left,front-right >$HOME/.cache/pa-virt-mic
        end
    else if test "$COMMAND" = del
        if test "$EXISTS" = false
            echo "Virtual microphone does not exist" &>2
            return 32
        else if test "$SERVER" = pw
            pw-cli destroy pw-virt-mic@$(whoami)
        else if test "$SERVER" = pa
            pactl unload-module $(cat $HOME/.cache/pa-virt-mic)
        end
    end
end

complete --command virtual-mic -xa "add delete"
complete --command virtual-mic -l pw -d "Use pw-cli"
complete --command virtual-mic -l pa -d "Use pactl"
