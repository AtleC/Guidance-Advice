###Meta###
	# Date: 2021 July 20th
	# Authors: Tom Ellson & Dray Agha
	# Org: JUMPSEC Labs
	# Purpose: This script was written in response to the discovery that the SAM file had a permissions error that allows any user to read it's contents. This facilitates privilege escalation and as such, we quickly put this script together to help the community quickly determine how widespread their internal attack surface was for this.
	# Contact: for more information, contact tellson@jumpsec.com or dray.agha@jumpsec.com

#Ensure errors don't ruin anything for us
$ErrorActionPreference = "SilentlyContinue"

#Print basic script info
Write-host "`nThis script will collect OS info and determine if the SAM file can be read by any user due to permissions error`n"
write-host -foregroundcolor Magenta "`nRunning Script.......`n"


###collect computer information###
	# Funnily enough, this takes the longest 

#Variables for OS version
$Name = ([System.Net.Dns]::GetHostByName(($env:computerName))).Hostname
$OS = gin | select -expandproperty OsName
$Ver = gin | select -expandproperty WindowsVersion
$Build= gin | select -expandproperty OSBuildNumber


Write-host "`n---OS Info---"

#print variables for OS version. Stupid formatting here to get the colours because I am extra
Write-host -foregroundcolor Magenta "`n$Name " -NoNewline
write-host "is running " -NoNewline 
write-host -foregroundcolor Magenta "$OS " -NoNewline
write-host "version number " -NoNewline
write-host -foregroundcolor Magenta "$Ver " -NoNewline
write-host "and build number "  -NoNewline
write-host -foregroundcolor Magenta "$Build`n"

###Determine if SAM is vulnerable###

write-host "`n---Vulnerability Results---"

if ((get-acl C:\windows\system32\config\sam).Access |
	? IdentityReference -match 'BUILTIN\\Users' | 
	select -expandproperty filesystemrights | 
	select-string 'Read')
	{write-host -foregroundcolor Red "`n$Name may be vulnerable: Arbitrary Read permissions for SAM file`n"}
else {
	write-host  -foregroundcolor Green "`n$Name does not seem to be vulnerable, SAM permissions are fine`n"}
