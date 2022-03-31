### 패치가 배포되는 서버가 다수라서 처리하는데 시간이 오래 걸림.
### 배포 스크립트를 별도로 만들어 병렬 처리 실행

#로그파일 생성 폴더
$Logdir = "D:\Dist\_distlog"

#폴더가 없을 경우 생성
if((Test-Path $Logdir) -eq $false){ New-Item $Logdir -ItemType Directory }

## Execute Script ###
Write-Host " "
Write-Host "This is IBT 2" -BackgroundColor Black -ForegroundColor yellow
$user_input = (Read-Host "Do you want to distribute Patch (y/n)?")
if(($user_input -eq "y") -Or ($user_input -eq "Y")){
    
    ## 배포 스크립트 실행
    Start-Process powershell.exe -ArgumentList "-file D:\Dist\_PowerShellScript\Dist_ServerPatch01.ps1" -WindowStyle Hidden

    ## Result    
    Write-Host " "
    Write-Host "Wait!! Copying to folder now ......" -BackgroundColor Black -ForegroundColor red
    Write-Host " "
    Write-Host " "
    Write-Host " "
    Start-Sleep 180

	## 180초 경과후 로그 파일을 읽어들여 화면에 표시
    $user_input = "y"
    while(($user_input -eq "y") -Or ($user_input -eq "Y")){
        Write-Host " "
        Write-Host "---------- [Result] ----------" -BackgroundColor Black -ForegroundColor yellow
        Get-Content $Logdir\Dist_ServerPatch*.txt
        Write-Host "---------- [Result] ----------" -BackgroundColor Black -ForegroundColor yellow
        $user_input = (Read-Host "Do you want to check again...(y/n)?")
        Clear-Host
    }
    break

}else{
    #pass
}

