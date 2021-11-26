# PoerShell

> Windows Server 를 운용하면서 업무의 편의를 위해 만든 스크립트


### 윈도우 스케쥴러를 사용해 스크립트를 자동 실행 할때
- Action: Start a program
- Program/script: %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe
- Add arguments: -Command ".\deletelogfiles.ps1"
- Start in: 파워쉘 스크립트가 놓여 있는 폴더


### 스크립트 설명


1. parallel execution  

    ①_PowerShellScript\Dist_ServerPatch01.ps1
    ② Dist.ps1  
    
   패치를 다수의 서버로 배포 시키는데 시간이 오래 걸려  
   [배포 스크립트] 와 [실행 스크립트] 를 따로 만들어 병령 처리  


2. deletelogfiles.ps1  
   필요 없는 로그 파일과 폴더를 삭제및 압축 처리