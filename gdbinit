# intel-style asm
set disassembly-flavor intel

# page size
set pagination off

# history
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

# promot
set prompt \001\033[1;31m\002[\033[01;31mgdb\033[01;31m\]\033[01;90m\> \001\033[0m\002

# alias
alias exit = quit

# scripts
python
sys.path.insert(0, '/home/sheng/.dotfiles/gdb/scripts')
import backtrace
end
