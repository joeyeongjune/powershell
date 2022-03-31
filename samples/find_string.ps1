#フォルダー内に含まれるすべてのファイル（サブフォルダーも含む）を対象に文字列検索
##select-string "検索したい文字列" (dir -recurse 対象のファイル)


#dir=D:\_RedStone\_temp\20170531-20201231
select-string "failed inflate. error in" (dir -recurse *.txt)