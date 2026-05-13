$Servicetier="BC280"
$AppName="Production Order Final Costing"
$Path="C:\Install\Bech-Andersen Consult ApS_Production Order Final Costing_27.0.0.0.app"

Import-Module 'C:\Program Files\Microsoft Dynamics 365 Business Central\280\Service\NavAdminTool.ps1'

# Publish app to database
Publish-NAVApp -ServerInstance $Servicetier -Path $Path -SkipVerification
Sync-NAVApp -ServerInstance $Servicetier -Name $AppName -version $NewVersion #-Mode ForceSync
install-NAVApp  -ServerInstance $Servicetier -Name $AppName -Version $OldVersion 