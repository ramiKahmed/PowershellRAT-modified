$files  = @(
'C:\ProgramData\Microsoft\s.ps1',
'C:\ProgramData\Microsoft\m.ps1',
'C:\ProgramData\Microsoft\d.ps1',
'C:\symbols\s.vbs',
'C:\symbols\m.vbs',
'C:\symbols\d.vbs',
'C:\Program Files (x86)\windows nt\tabletextservice\en-US\s.bat',
'C:\Program Files (x86)\windows nt\tabletextservice\en-US\m.bat',
'C:\Program Files (x86)\windows nt\tabletextservice\en-US\d.bat'
)



foreach ($file in $files) {

Remove-Item -Path $file -Force -ErrorAction SilentlyContinue

}

Unregister-ScheduledTask -TaskName WindowsUpdateManager -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName WDAGUtilityUpdateClient -Confirm:$false -ErrorAction SilentlyContinue
Unregister-ScheduledTask -TaskName MicrosoftDefenderUpdateTask -Confirm:$false -ErrorAction SilentlyContinue

