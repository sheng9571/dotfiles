# intel-style asm
set disassembly-flavor intel

# page size
set pagination off

# history
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on
# set verbose off
# set print pretty on
# set print array off
# set print array-indexes on
# set python print-stack full

# promot
set prompt \001\033[1;31m\002[\033[01;31mgdb\033[01;31m\]\033[01;90m\> \001\033[0m\002

# alias
alias exit = quit
alias inr = info register
alias ipm = info proc mapping
alias mbt = backtrace

# scripts
python
import sys, os
sys.path.insert(0, os.getenv('HOME') + '/.dotfiles/gdb/scripts')
import backtrace
end

# self-defined function

# si ( step in function call on x86 )
define sie
    si
    echo EIP\t
    w/wi $eip
    echo ESP\t
    x/wx $esp
    echo EBP\t
    x/wx $ebp
end

# ni ( do not trace into function call on x86 )
define nie
    ni
    echo EIP\t
    w/wi $eip
    echo ESP\t
    x/wx $esp
    echo EBP\t
    x/wx $ebp
end


# si ( step in function call on x64 )
define sir
    si
    echo RIP\t
    w/wi $rip
    echo RSP\t
    x/wx $rsp
    echo RBP\t
    x/wx $rbp
end

# ni ( do not trace into function call on x64 )
define nie
    ni
    echo RIP\t
    w/wi $rip
    echo RSP\t
    x/wx $rsp
    echo RBP\t
    x/wx $rbp
end
