# 업무 자동화를 위한 PowerShell Script

---

| Directory             | explanation                                                                                                                                                  |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| GitProcess            | Index file 생성과 Diff file 작성                                                                                                                             |
| deletelogfiles.ps1    | 지정 폴더안에 있는 파일을 압축및 삭제<br>・bzip2 을 사용해서 압축을 진행                                                                                     |
| parallel excution.zip | 패치 파일들을 지정 장소에 배포<br>・배포시간을 줄이기 위해 [실행 스크립트] 와 [배포 스크립트] 를 분리해서 병렬 처리<br>・배포 스크립트는 백그라운드에서 실행 |

### 윈도우 스케쥴러로 파워쉘 파일을 자동실행 설정

1.  Start Windows task scheduler
2.  Setup scheduler

- Action: Start a program
- Program/script: %SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe
- Add arguments: -Command ".\PowerShellFile.ps1"
- Start in: 파워쉘 스크립트가 놓여 있는 폴더
