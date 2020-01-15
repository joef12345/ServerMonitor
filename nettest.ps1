param 
( 
[Parameter(Position=0, Mandatory = $false, HelpMessage="Creates 'scheduled task' in Windows Scheduler that can be adjusted in the future to perform synchronization cycle(s) at particular time interval")]
[Switch] $INSTALL
)
if ($INSTALL) {
Install-Module AWSPowerShell
$taskname = "Network Alerts"
schtasks.exe /create /sc MINUTE /MO 5 /st 06:00 /RU SYSTEM /tn "$taskname" /tr "$PSHOME\powershell.exe -c '. ''$($myinvocation.mycommand.definition)'''"
exit
}
$alertbody = ""
foreach($line in Get-Content "c:\server alerts\Servers.txt") {
$IP,$Description,$Port = $line.split(',')


    if (!$port){
    $PingTest = Test-NetConnection $IP
    if ($PingTest.PingSucceeded -eq $False){
    $PingTest = Test-NetConnection $IP
    if ($PingTest.PingSucceeded -eq $False){
    $AlertBody = $AlertBody + "=-" + $Description + "-=" + "`n" +  
    "Remote Address:      " + $PingTest.RemoteAddress + "`n" +
    "Interface Alias:     " + $PingTest.InterfaceAlias + "`n" +
    "PingSucceeded:       " + "False" + "`n" +  "`n"
    }
     }
     }
     else {
     $PingTest = Test-NetConnection $IP -Port $port
         if ($PingTest.TcpTestSucceeded -eq $False){
            $PingTest = Test-NetConnection $IP -Port $port
            if ($PingTest.TcpTestSucceeded -eq $False){
                $AlertBody = $AlertBody + "=-" + $Description + "-=" + "`n" +  
                "Remote Address:      " + $PingTest.RemoteAddress + "`n" +
                "Interface Alias:     " + $PingTest.InterfaceAlias + "`n" +
                "TCP Port:            " + $port + "`n" +
                "TCP Succeeded:       " + $pingtest.TcpTestSucceeded + "`n" +  "`n"
            }
         }
     }
       $pingtest.PingReplyDetails

}
if ($AlertBody -ne "")
{
    $AlertBody = "Server Alerts " + $env:computername + "`n`n" + $AlertBody
    $AlertBody
    Import-Module AWSPowerShell
    Set-AWSCredentials -StoreAs default -AccessKey YourAWSAccessKeyHere -SecretKey YourAWSSecretKeyHERE
    Publish-SNSMessage -TopicArn "YourAWSTopicARNHERE" -Message $AlertBody -Region us-east-1
}

