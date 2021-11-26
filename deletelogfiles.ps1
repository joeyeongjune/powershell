###################################
# 지정 한 파일및 폴더의 삭제와 압축
###################################

## 필요한 날짜값 취득
$bzip2_date = (Get-Date).AddDays(-1).ToString("yyyyMMdd") 
$delete_date = (Get-Date).AddDays(-14).ToString("yyyyMMdd") 
#Write-Host ===== Delete data files And log folder on gameoserver =====
#Write-Host 'delete: '$delete_date

# 경로설정
$path = "D:\Log"
$dst_folder = $path + "\" + $delete_date
$compressLog = $path + "\" + $bzip2_date

# Delete files: 지정 확장자의 파일을 삭제한다
if (Test-path $path)
{
    Remove-Item $path\debugValue*.dat -Force
}

# Delete log folder: 설정한 날짜의 폴더가 있으면 삭제한다
if (Test-path $dst_folder)
{
    Remove-Item -Path $dst_folder -Recurse -Force    
}

# Compress logfiles: 지정 경로 밑에 txt 파일들 압축
set-location "C:\Windows\system32" ## 해당 경로에 bzip2.exe 파일이 있어야 압축을 진행
if (Test-path $compressLog)
{
    bzip2.exe -z  $compressLog\logfile*.txt
}