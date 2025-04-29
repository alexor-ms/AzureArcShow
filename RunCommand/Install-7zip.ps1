# Install 7zip via Arc RunCommand
$7ZIPURL = 'https://www.7-zip.org/a/7z2409-x64.exe'
$SourceFolder = 'C:\Windows\Temp\7z2301-x64.exe'
Invoke-WebRequest -Uri $7ZIPURL -OutFile $SourceFolder
