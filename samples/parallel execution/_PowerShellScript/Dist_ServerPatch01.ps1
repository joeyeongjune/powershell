#SERVER LIST
$IP = "172.0.0.1"
$SERVER_IP = "\\" + $IP


#SERVER
$Patch_yotei = "\d$\Patch_server_yotei"

#DEFINE
$Logdir = "D:\Dist\_distlog"
$logfile_name = "Dist_ServerPatch01.txt"
$Source = "D:\Dist\Source"


## REDEFINE
$Source = $Source + "\"
$DeploymentConfig = $SERVER_IP + "\D$\Patch_server\WServer\Config\DeploymentConfig.xml"
#$ServerConfig = $SERVER_IP + "\D$\Patch_server\WServer\Config\ServerConfig.xml"
$amqp = $SERVER_IP + "\D$\Patch_server\WServer\Platform\amqp-gw\amqp-gw.ini"

#Init
if ((Test-Path $Logdir) -eq $false) { New-Item $Logdir -ItemType Directory }


#TARGET
$TARGET01 = $SERVER_IP + $Patch_yotei + "\"
$TARGET02 = $TARGET01 + "WServer\Config\DeploymentConfig.xml"
#$TARGET03 = $TARGET01 + "WServer\Config\ServerConfig.xml"
$TARGET04 = $TARGET01 + "WServer\Platform\amqp-gw\amqp-gw.ini"

## Execute Script ###
$now = Get-Date -Format "yyyy/MM/dd hh:mm:ss"
$logfile = $Logdir + "\" + $logfile_name
$logmessage = $now + " Wait!! Dist server patch to " + $IP + "..."
Write-Output $logmessage > $logfile

#Dist Server Patch
if ((Test-Path $TARGET01) -eq $true) {
    Remove-Item  $TARGET01 -Recurse -Force  
    Copy-Item $Source -Recurse $TARGET01
}
else {
    Copy-Item $Source -Recurse $TARGET01
}

#Copy Config
Copy-Item $DeploymentConfig $TARGET02 -Force
#Copy-Item $ServerConfig $TARGET03 -Force
Copy-Item $amqp $TARGET04 -Force

$now = Get-Date -Format "yyyy/MM/dd hh:mm:ss"
$logfile = $Logdir + "\" + $logfile_name
$logmessage = $now + " OK!! Server(" + $IP + ")"
Write-Output $logmessage > $logfile