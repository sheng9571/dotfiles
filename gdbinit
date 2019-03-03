# intel-style asm
set disassembly-flavor intel

# page size
set pagination off

# c++ name mangling
set print asm-demangle on

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

# ignore alarm()
handle SIGALRM ignore

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
sys.path.insert(0, os.getenv('HOME') + '/.ctf_tools/gdb/scripts')
import backtrace
# cmd lists
import cmd
import magic
import map
import adv_map
import at
import checksec
import ld_preload
import relf
import h2b
import ep
import bm
import libc_str
import libc
import plt_parse
import asch
import ssch
end

# self-defined function

# si ( step in function call on x86 )
define sie
    si
    echo EIP\t
    x/wi $eip
    echo ESP\t
    x/wx $esp
    echo EBP\t
    x/wx $ebp
end

# ni ( do not trace into function call on x86 )
define nie
    ni
    echo EIP\t
    x/wi $eip
    echo ESP\t
    x/wx $esp
    echo EBP\t
    x/wx $ebp
end


# print eip、esp、ebp
define peisb
    echo EIP\t
    x/wi $eip
    echo ESP\t
    x/wx $esp
    echo EBP\t
    x/wx $ebp
end


# print offset + 44 stack value ( x86 )
define pes
    x/44wx $esp
end


# print 10 instructions ( x86 )
define pei
    x/10i $eip
end


# si ( step in function call on x64 )
define sir
    si
    echo RIP\t
    x/gi $rip
    echo RSP\t
    x/gx $rsp
    echo RBP\t
    x/gx $rbp
end

# ni ( do not trace into function call on x64 )
define nir
    ni
    echo RIP\t
    x/gi $rip
    echo RSP\t
    x/gx $rsp
    echo RBP\t
    x/gx $rbp
end


# print rip、rsp、rbp
define prisb
    echo RIP\t
    x/gi $rip
    echo RSP\t
    x/gx $rsp
    echo RBP\t
    x/gx $rbp
end


# print offset + 44 stack value ( x64 )
define prs
    x/44gx $rsp
end


# print 10 instructions ( x64 )
define pri
    x/10i $rip
end
