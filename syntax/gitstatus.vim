
if exists("b:current_syntax")
  finish
endif

syn match statusNormal "^.*$"
syn match statusTrackedTitle "\v^On branch.*"
syn match statusUntrackedTitle "\v^Untracked files:$"
syn match statusNewFile "\v^\snew file.*$"
syn match statusModified "\v^\smodified.*$"
syn match statusDeleted "\v^\sdeleted.*$"

let b:current_syntax = "gitstatus"

hi def link statusNormal       Comment
hi def link statusTrackedTitle Title
hi def link statusUntrackedTitle Title
hi def link statusNewFile      diffNewFile
hi def link statusModified     diffChanged
hi def link statusDeleted      diffRemoved
