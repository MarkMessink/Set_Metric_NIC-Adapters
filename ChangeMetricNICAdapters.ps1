<#
.SYNOPSIS
	Set Interface Metric Ethernet adapter from automatic to a metric of 35
	
	FileName:    ChangeMetricNICAdapters.ps1
    Author:      Mark Messink
    Contact:     
    Created:     2021-12-21
    Updated:     2022-11-21

    Version history:
    1.0.0 - (2021-12-21) Initial Script
	1.0.1 - (2022-11-21) Script vernieuwd
	1.1.0 - 

.DESCRIPTION
	This script sets the adapter metric. When establishing a VPN connection, the VPN's automatic metric is 25.
	This solves the problem of using the VPN adapter with the on-premises DNS settings instead of the Ethernet adapters with the public DNS settings.

.PARAMETER
	<beschrijf de parameters die eventueel aan het script gekoppeld moeten worden>

.INPUTS
 Defaults:
 LAN = 25
 Ethernet = 50
 Wi-Fi = 35
 Mobile = 55
 Bluetooth = 65
 
 Settings:
 LAN = 35
 Wi-Fi = 40
 
.OUTPUTS
	logfiles:
	PSlog_<naam>	Log gegenereerd door een powershell script
	INlog_<naam>	Log gegenereerd door Intune (Win32)
	AIlog_<naam>	Log gegenereerd door de installer van een applicatie bij de installatie van een applicatie
	ADlog_<naam>	Log gegenereerd door de installer van een applicatie bij de de-installatie van een applicatie
	Een datum en tijd wordt automatisch toegevoegd

.EXAMPLE
	./scriptnaam.ps1

.LINK Information

.NOTES
	WindowsBuild:
	Het script wordt uitgevoerd tussen de builds LowestWindowsBuild en HighestWindowsBuild
	LowestWindowsBuild = 0 en HighestWindowsBuild 50000 zijn alle Windows 10/11 versies
	LowestWindowsBuild = 19000 en HighestWindowsBuild 19999 zijn alle Windows 10 versies
	LowestWindowsBuild = 22000 en HighestWindowsBuild 22999 zijn alle Windows 11 versies
	Zie: https://learn.microsoft.com/en-us/windows/release-health/windows11-release-information

#>

#################### Variabelen #####################################
$logpath = "C:\IntuneLogs"
$NameLogfile = "PSlog_ChangeMetricNICAdapters.txt"
$LowestWindowsBuild = 0
$HighestWindowsBuild = 50000



#################### Einde Variabelen ###############################


#################### Start base script ##############################
### Niet aanpassen!!!

# Prevent terminating script on error.
$ErrorActionPreference = 'Continue'

# Create logpath (if not exist)
If(!(test-path $logpath))
{
      New-Item -ItemType Directory -Force -Path $logpath
}

# Add date + time to Logfile
$TimeStamp = "{0:yyyyMMdd}" -f (get-date)
$logFile = "$logpath\" + "$TimeStamp" + "_" + "$NameLogfile"

# Start Transcript logging
Start-Transcript $logFile -Append -Force

# Start script timer
$scripttimer = [system.diagnostics.stopwatch]::StartNew()

# Controle Windows Build
$WindowsBuild = [System.Environment]::OSVersion.Version.Build
Write-Output "------------------------------------"
Write-Output "Windows Build: $WindowsBuild"
Write-Output "------------------------------------"
If ($WindowsBuild -ge $LowestWindowsBuild -And $WindowsBuild -le $HighestWindowsBuild)
{
#################### Start base script ################################

#################### Start uitvoeren script code ####################
Write-Output "#####################################################################################"
Write-Output "### Start uitvoeren script code                                                   ###"
Write-Output "#####################################################################################"

	Write-Output "-------------------------------------------------------------------"
    Write-Output "List Network Adapters"
	Get-NetIPInterface | FT InterfaceAlias, InterfaceMetric
	Write-Output "-------------------------------------------------------------------"
	Write-Output "Change Metric" 
	Get-NetIPInterface LAN* | Set-NetIPInterface -InterFaceMetric 35
	Get-NetIPInterface Wi-F* | Set-NetIPInterface -InterFaceMetric 40
	
	# Get-NetIPInterface Ethernet* | Set-NetIPInterface -InterFaceMetric 50
	# Get-NetIPInterface Mobi* | Set-NetIPInterface -InterFaceMetric 55
	# Get-NetIPInterface Blue* | Set-NetIPInterface -InterFaceMetric 65
    Write-Output "-------------------------------------------------------------------"
	Write-Output "List Network Adapters"
	Get-NetIPInterface | FT InterfaceAlias, InterfaceMetric
	Write-Output "-------------------------------------------------------------------"

Write-Output "#####################################################################################"
Write-Output "### Einde uitvoeren script code                                                   ###"
Write-Output "#####################################################################################"
#################### Einde uitvoeren script code ####################

#################### End base script #######################

# Controle Windows Build
}Else {
Write-Output "-------------------------------------------------------------------------------------"
Write-Output "### Windows Build versie voldoet niet, de script code is niet uitgevoerd. ###"
Write-Output "-------------------------------------------------------------------------------------"
}

#Stop and display script timer
$scripttimer.Stop()
Write-Output "------------------------------------"
Write-Output "Script elapsed time in seconds:"
$scripttimer.elapsed.totalseconds
Write-Output "------------------------------------"

#Stop Logging
Stop-Transcript
#################### End base script ################################

#################### Einde Script ###################################
