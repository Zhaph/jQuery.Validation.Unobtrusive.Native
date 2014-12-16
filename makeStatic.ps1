$jVUNDemo = "$($env:APPVEYOR_BUILD_FOLDER)\jVUNDemo"
$staticSite = "$jVUNDemo\..\..\"
write-host "jVUNDemo location: $jVUNDemo"
write-host "static site location: $staticSite"

write-host "Spin up jVUNDemo site"
Start-Job –Name RunIisExpress –Scriptblock {& 'C:\Program Files (x86)\IIS Express\iisexpress.exe' /path:$jVUNDemo /port:57612}

Wait-Job -Name RunIisExpress -Timeout 5

write-host "Create static version of demo site here: $staticSite"
cd $staticSite
wget.exe --recursive --convert-links -E --directory-prefix=static-site --no-host-directories http://localhost:57612/

write-host "Shut down jVUNDemo site"
Receive-Job -Name RunIisExpress
Get-Job –Name RunIisExpress | Stop-Job
Get-Job –Name RunIisExpress | Remove-Job

ls $staticSite