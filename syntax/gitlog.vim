if exists("b:current_syntax")
  finish
endif

syn match logTitle "\v.*$"
syn match logHash "\v^\w+"
syn match logCCtype "\v\s\w+:\s"
syn match logCCscopedType "\v\s\w+(\()@=" nextgroup=logCCscope
syn match logCCscope "\v\(\w+\)(:)@=" nextgroup=logCCcolon
syn match logCCcolon "\v(\))@<=:(\s)@="
syn match logCCbreakingType "\v\s\w+!:"
syn match logCCbreakingScopedType "\v\s\w+!\(\w+\):"

let b:current_syntax = "gitlog"

hi def link logTitle                Normal
hi def link logHash                 diffIndexLine
hi def link logCCtype               diffFile
hi def link logCCscopedType         diffFile
hi def link logCCcolon              diffFile
hi def link logCCscope              diffAdded
hi def link logCCbreakingType       diffNewFile
hi def link logCCbreakingScopedType diffNewFile
