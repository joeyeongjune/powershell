## Git_Process.ps1, git_config.xml ファイルは xml ファイルの中の <source_path> に配置します。
#読み込み対象Xmlファイル設定
$xmlFile = "./git_config.xml"
$xmlName = [xml](Get-Content $xmlFile)

$a = (Get-Host).UI.RawUI 
$b = $a.WindowSize 
$b.Width = 105 
$b.Height = 30 
$a.WindowTitle = "------Git Process------"
$a.WindowSize = $b

#############XMLファイルから関連情報読み込み#############
$titleName = $xmlName.Configuration.titlename
$sourcePath = $xmlName.Configuration.source_path
$gitPath = $xmlName.Configuration.git_path
$generatePath = $xmlName.Configuration.generate_path
$versioniniFile = $xmlName.Configuration.versionini_file

$typename = "System.Management.Automation.Host.ChoiceDescription"
$sabun = new-object $typename("差分作成(&s)","差分作成") 
$diff = new-object $typename("&Diff","Diff作成") 
$gitLog = new-object $typename("gitLog確認(&l)","gitLog確認") 
$Iie = new-object $typename("作業無し(&N)","実行しない")

$choice = [System.Management.Automation.Host.ChoiceDescription[]]($sabun,$diff,$gitLog,$Iie)
Write-Host "=======================================================================" -BackgroundColor blue -ForegroundColor white
Write-Host "                          【 TEST Git作業 】" -BackgroundColor Black -ForegroundColor white
Write-Host "=======================================================================" -BackgroundColor blue -ForegroundColor white
$answer = $host.ui.PromptForChoice("<どちらの作業を進行しますか>","=============================",$choice,3)

switch ($answer)
{
#############差分作成及びコミットID生成#############
    0 {   
        
        Write-Host "=========================================="-BackgroundColor Black -ForegroundColor yellow
        Set-Location $gitPath
        powershell git log -4 > ./.git\Commit_ID_log.txt
        $commit_id_1 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[4..4]
        $commit_id_2 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[10..10]
        $commit_id_1_N=$commit_id_1.Replace("    ","")
        $commit_id_2_N=$commit_id_2.Replace("    ","")

        write-host "$titleName Indexリスト"-BackgroundColor green -ForegroundColor black
        Write-host $commit_id_1_N
        Write-host $commit_id_2_N

        Write-Host "=========================================="-BackgroundColor Black -ForegroundColor yellow
        Write-Host ""        
        Write-Host  "↓↓INDEX名の入力例" -BackgroundColor black -ForegroundColor yellow 
        Write-Host $titleName"_日付" -BackgroundColor yellow -ForegroundColor black
        $newIndexName = Read-Host "Commit ID生成 >>" 
        $commitSabun = "git commit -m `"$newIndexName`""

        $sabunString = 
@"
------------------------------------------------------------------------
$commitSabun
------------------------------------------------------------------------

"@
        write-host $sabunString -BackgroundColor Black -ForegroundColor yellow

        $yes_sabun = Read-Host "上記のスクリプトをを実行しますか？ y/n" 
        if ($yes_sabun -eq "y"){
           Set-Location $gitPath
           Write-Host "Git作業中。。。。。" -BackgroundColor yellow -ForegroundColor black
           powershell git add -A .
           powershell "git commit -m `"$newIndexName`""
           powershell git log -1 > ./.git\Commit_ID_log.txt
           $commit_id =(Get-Content $gitPath\.git\Commit_ID_log.txt)[0..0]
           $commit_id_num=$commit_id.Replace("commit ","")

           #############差分Indexファイル作成#############
           Set-Location $generatePath
           powershell "./generate-index.exe $gitPath $commit_id_num $newIndexName"

           ##########version.iniファイルのIndex名修正#####################
           $getIndexName = ((Get-Content $versioniniFile)[3..3]).replace("INDEX = ","")
           $replaceIndexName = $(Get-Content $versioniniFile) -replace $getIndexName,$newIndexName
           $replaceIndexName > $versioniniFile
           ##########################################################
           
           Write-Host "========================================="-BackgroundColor Black -ForegroundColor yellow
           write-host $commit_id_num
           Write-Host "========================================="-BackgroundColor Black -ForegroundColor yellow
           write-host "実行⇒ git add -A ."-BackgroundColor white -ForegroundColor black
           Write-Host "実行⇒ $commitSabun"-BackgroundColor white -ForegroundColor black
           write-host "実行⇒ generate-index.exe $gitPath $commit_id_num $newIndexName"-BackgroundColor Black -ForegroundColor yellow
           
           Write-Host "================================="-BackgroundColor Black -ForegroundColor yellow
           Write-Host "差分作成完了"-BackgroundColor yellow -ForegroundColor black
           Write-Host "`n"         
         }
        else{Write-Host "作業無し`n"-BackgroundColor red -ForegroundColor white}
        Set-Location $sourcePath
        powershell ./Git_Process.ps1
    }

#################Diffファイル作成#################
    1 {
        #############Indexファイル名前取得#############
        Set-Location $gitPath\.git
        $selectIndexFiles = Get-ChildItem | where-object {$_.Name -like "*$titleName*"} | Sort-Object LastWriteTime -Desc | Select-object Name -first 2 | ForEach-object {$_.Name}
        $lastIndex = $selectIndexFiles[0]
        $beforeIndex = $selectIndexFiles[1]

        Write-Host "=========================================="-BackgroundColor Black -ForegroundColor green
        write-host "$titleName Indexリスト"-BackgroundColor green -ForegroundColor black
        Get-ChildItem | where-object {$_.Name -like "*$titleName*"} | Sort-Object LastWriteTime -Desc | Select-object Name -first 4 | ForEach-object {$_.Name}
        Write-Host "=========================================="-BackgroundColor Black -ForegroundColor green

        $inputBeforeIndex = Read-Host "  前のバージョンのINDEX ex) $beforeIndex >" 
        $inputLastIndex = Read-Host "最新のバージョンのINDEX ex) $lastIndex >" 
        $generateDiff = "generate-diff.exe $gitPath\ $inputBeforeIndex $inputLastIndex"

        $diffString = 
@"
------------------------------------------------------------------------
$generateDiff
------------------------------------------------------------------------

"@
        
        write-host $diffString -BackgroundColor Black -ForegroundColor green

        $yes_diff = Read-Host "上記のスクリプトを実行しますか？ y/n" 
        if ($yes_diff -eq "y"){
           Set-Location $generatePath
           powershell "./generate-diff.exe $gitPath\ $inputBeforeIndex $inputLastIndex"
           write-host "実行⇒ $generateDiff"-BackgroundColor white -ForegroundColor black
           Write-Host "================================="-BackgroundColor Black -ForegroundColor yellow 
           Write-Host "Diff作成完了"-BackgroundColor green -ForegroundColor black
           Write-Host "`n"
         }
        else{Write-Host "作業無し`n"-BackgroundColor red -ForegroundColor white}
        Set-Location $sourcePath
        powershell ./Git_Process.ps1
      }

#################GitLog確認#################
    2 {                
        Write-Host "================Git Log 確認==============="-BackgroundColor Black -ForegroundColor yellow
        Set-Location $gitPath
        powershell git log -4 > ./.git\Commit_ID_log.txt

        $commit_id_1 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[4..4]
        $commit_id_1_N=$commit_id_1.Replace("    ","")
        $commit_num_1 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[0..0]
        $commit_num_1_N=$commit_num_1.Replace("commit ","")

        $commit_id_2 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[10..10]
        $commit_id_2_N=$commit_id_2.Replace("    ","")
        $commit_num_2 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[6..6]
        $commit_num_2_N=$commit_num_2.Replace("commit ","")

        $commit_id_3 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[16..16]
        $commit_id_3_N=$commit_id_3.Replace("    ","")
        $commit_num_3 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[12..12]
        $commit_num_3_N=$commit_num_3.Replace("commit ","")

        $commit_id_4 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[22..22]
        $commit_id_4_N=$commit_id_4.Replace("    ","")
        $commit_num_4 =(Get-Content $gitPath\.git\Commit_ID_log.txt)[18..18]
        $commit_num_4_N=$commit_num_4.Replace("commit ","")

        write-host $commit_id_1_N -BackgroundColor yellow -ForegroundColor black
        write-host $commit_num_1_N
        Write-Host "-------------------------------------------"-BackgroundColor Black -ForegroundColor yellow
        write-host $commit_id_2_N -BackgroundColor yellow -ForegroundColor black
        write-host $commit_num_2_N
        Write-Host "-------------------------------------------"-BackgroundColor Black -ForegroundColor yellow
        write-host $commit_id_3_N -BackgroundColor yellow -ForegroundColor black
        write-host $commit_num_3_N
        Write-Host "-------------------------------------------"-BackgroundColor Black -ForegroundColor yellow
        write-host $commit_id_4_N -BackgroundColor yellow -ForegroundColor black
        write-host $commit_num_4_N
        Write-Host "==========================================="-BackgroundColor Black -ForegroundColor yellow

        Set-Location $sourcePath
        powershell ./Git_Process.ps1
      }

    3{ Write-Host "XXX作業無しXXX"-BackgroundColor red -ForegroundColor white }
}