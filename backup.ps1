$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

		$vm = Get-AzureRmVM
				
				$rsvaultname1 = "Azure-Backup-Vault-Dev"
				$rsvaultname2 = "Azure-Backup-Vault-Prod"
				$backupPolicy1 = "my-policy"
				$backuppolicy2 = "my-policy"
				$location = "South India"
				 
				
				foreach ($virtualmachines in $vm)
				{
    				# Check for direct tag or group-inherited tag
    				if($virtualmachines.Tags -eq $null)
    				{
        				Write-Output "[$($virtualmachines.Name)]: Not fully tagged for Backup. Skipping this VM. Please rerun the script after correcting following tags: DEV"
            				
    				}
        				elseif (($virtualmachines.Tags["INFY_EA_Role"] -contains "Dev-Backup"))
    				{
        				# VM has direct tag (possible for resource manager deployment model VMs). Prefer this tag for backup schedule.
        				$backup = Get-AzureRmTag -Name "INFY_EA_Role" | select values -ExpandProperty values | select Name -ExpandProperty Name
        				Write-Output "[$($virtualmachines.Name)]: Found VM Backup tag with value: $backup"
      				
				
        				# Register the Recovery Services provider and create a resource group
        				#Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
    				
        				# Set Recovery Services Vault context 
        				Get-AzureRmRecoveryServicesVault -Name $rsvaultname1  | Set-AzureRmRecoveryServicesVaultContext 
				
        				# Get Protection Policy and Enable Protection
        				$pol = Get-AzureRmRecoveryServicesBackupProtectionPolicy -Name $backuppolicy2
     				
				
        				Write-Output "[$($virtualmachines.Name)]: Enabling protection"
        				Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name $virtualmachines.Name -ResourceGroupName $virtualmachines.ResourceGroupName 
    				}
        				
				}
					
				foreach ($virtualmachines in $vm)
				{
    				# Check for direct tag or group-inherited tag
    				if($virtualmachines.Tags -eq $null)
    				{
        				Write-Output "[$($virtualmachines.Name)]: Not fully tagged for Backup. Skipping this VM. Please rerun the script after correcting following tags: DEV"
            				
    				}
        				elseif (($virtualmachines.Tags["INFY_EA_Role"] -contains "Prod-Backup"))
    				{
        				# VM has direct tag (possible for resource manager deployment model VMs). Prefer this tag for backup schedule.
        				$backup = Get-AzureRmTag -Name "Backup2" | select values -ExpandProperty values | select Name -ExpandProperty Name
        				Write-Output "[$($virtualmachines.Name)]: Found VM Backup tag with value: $backup"
      				
				
        				# Register the Recovery Services provider and create a resource group
        				#Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
    				
        				# Set Recovery Services Vault context 
        				Get-AzureRmRecoveryServicesVault -Name $rsvaultname2 | Set-AzureRmRecoveryServicesVaultContext 
				
        				# Get Protection Policy and Enable Protection
        				$pol = Get-AzureRmRecoveryServicesBackupProtectionPolicy -Name $backupPolicy1
				
        				#Write-Output "[$($virtualmachines.Name)]: Enabling protection"
        				Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name $virtualmachines.Name -ResourceGroupName $virtualmachines.ResourceGroupName
    				}
        				
				}
	$connectionName = "AzureRunAsConnection"
try
{
    # Get the connection "AzureRunAsConnection "
    $servicePrincipalConnection=Get-AutomationConnection -Name $connectionName         

    "Logging in to Azure..."
    Add-AzureRmAccount `
        -ServicePrincipal `
        -TenantId $servicePrincipalConnection.TenantId `
        -ApplicationId $servicePrincipalConnection.ApplicationId `
        -CertificateThumbprint $servicePrincipalConnection.CertificateThumbprint 
}
catch {
    if (!$servicePrincipalConnection)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}

		$vm = Get-AzureRmVM
				
				$rsvaultname1 = "Azure-Backup-Vault-Dev"
				$rsvaultname2 = "Azure-Backup-Vault-Prod"
				$backupPolicy1 = "my-policy"
				$backuppolicy2 = "my-policy"
				$location = "South India"
				 
				
				foreach ($virtualmachines in $vm)
				{
    				# Check for direct tag or group-inherited tag
    				if($virtualmachines.Tags -eq $null)
    				{
        				Write-Output "[$($virtualmachines.Name)]: Not fully tagged for Backup. Skipping this VM. Please rerun the script after correcting following tags: DEV"
            				
    				}
        				elseif (($virtualmachines.Tags["INFY_EA_Role"] -contains "Dev-Backup"))
    				{
        				# VM has direct tag (possible for resource manager deployment model VMs). Prefer this tag for backup schedule.
        				$backup = Get-AzureRmTag -Name "INFY_EA_Role" | select values -ExpandProperty values | select Name -ExpandProperty Name
        				Write-Output "[$($virtualmachines.Name)]: Found VM Backup tag with value: $backup"
      				
				
        				# Register the Recovery Services provider and create a resource group
        				#Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
    				
        				# Set Recovery Services Vault context 
        				Get-AzureRmRecoveryServicesVault -Name $rsvaultname1  | Set-AzureRmRecoveryServicesVaultContext 
				
        				# Get Protection Policy and Enable Protection
        				$pol = Get-AzureRmRecoveryServicesBackupProtectionPolicy -Name $backuppolicy2
     				
				
        				Write-Output "[$($virtualmachines.Name)]: Enabling protection"
        				Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name $virtualmachines.Name -ResourceGroupName $virtualmachines.ResourceGroupName 
    				}
        				
				}
					
				foreach ($virtualmachines in $vm)
				{
    				# Check for direct tag or group-inherited tag
    				if($virtualmachines.Tags -eq $null)
    				{
        				Write-Output "[$($virtualmachines.Name)]: Not fully tagged for Backup. Skipping this VM. Please rerun the script after correcting following tags: DEV"
            				
    				}
        				elseif (($virtualmachines.Tags["INFY_EA_Role"] -contains "Prod-Backup"))
    				{
        				# VM has direct tag (possible for resource manager deployment model VMs). Prefer this tag for backup schedule.
        				$backup = Get-AzureRmTag -Name "Backup2" | select values -ExpandProperty values | select Name -ExpandProperty Name
        				Write-Output "[$($virtualmachines.Name)]: Found VM Backup tag with value: $backup"
      				
				
        				# Register the Recovery Services provider and create a resource group
        				#Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
    				
        				# Set Recovery Services Vault context 
        				Get-AzureRmRecoveryServicesVault -Name $rsvaultname2 | Set-AzureRmRecoveryServicesVaultContext 
				
        				# Get Protection Policy and Enable Protection
        				$pol = Get-AzureRmRecoveryServicesBackupProtectionPolicy -Name $backupPolicy1
				
        				#Write-Output "[$($virtualmachines.Name)]: Enabling protection"
        				Enable-AzureRmRecoveryServicesBackupProtection -Policy $pol -Name $virtualmachines.Name -ResourceGroupName $virtualmachines.ResourceGroupName
    				}
        				
				}
