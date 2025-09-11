set -x NNN_BMS "h:$HOME;d:$HOME/Документы;D:$HOME/Загрузки;s:$HOME/Документы/Учеба"
set -x NNN_SSHFS "sshfs -o follow_symlinks"
set -x NNN_TRASH 1
set -x NNN_FIFO /tmp/nnn.fifo
set -x NNN_PLUG "i:imgview;p:preview-tui"
set -x NNN_TMPFILE /tmp/nnn.tmp

set -x NNN_BMS "$NNN_BMS;b:$HOME/Документы/Учеба/5-семестр/Острик/lwc-server/crate"
