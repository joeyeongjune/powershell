$system32 = "C:\Windows\system32"


##### Logserver #####
$logserver = "D:\LogServer"

#compress logfiles
$compressDate = (Get-Date).AddMonths(-1).ToString("yyyyMMdd")
$logfolder = $logserver + $compressDate
if (Test-path $logfolder)
{    
    cd $system32
    bzip2.exe -z $logfolder\*.txt
}

#delete logfiles
$deleteDate = (Get-Date).AddMonths(-3).ToString("yyyyMMdd")
$logfolder = ""
$logfolder = $logserver + "\" + $deleteDate

if (Test-Path $logfolder)
{
    Remove-Item $logfolder -Recurse -Force
}


##### Logserver #####
$logserver = "D:\LOG\BACKUP"

#compress logfiles
$compressDate = ""
$compressDate = (Get-Date).AddMonths(-6).ToString("yyyyMM")
if (Test-path $logserver)
{    
    $pre_files = $logserver + "\" + $compressDate + "*.pre"
    
    cd $system32    
    bzip2.exe -z $pre_files
}

#delete logfiles
$deleteDate = ""
$deleteDate = (Get-Date).AddMonths(-7).ToString("yyyyMM")
if (Test-Path $logserver)
{
    $pre_files = $logserver + "\" + $deleteDate + "*.bz2"

    cd $system32
    Remove-Item $pre_files -Recurse -Force
}
