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

		$vm = Get-AzVM

        $TotalExistingBackupVMs = @()
        $rsvaults = Get-AzRecoveryServicesVault
        foreach ($rsvault in $rsvaults){
            Get-AzRecoveryServicesVault -Name $($rsvault.Name) | Set-AzRecoveryServicesVaultContext
            $ExistingBackupVMs = Get-AzrecoveryServicesBackupContainer -ContainerType AzureVM
            $TotalExistingBackupVMs += $ExistingBackupVMs.friendlyname
        }
				
				$rsvaultname1 = "Azure-Backup-Vault-Dev-WestUS"
				$rsvaultname2 = "Azure-Backup-Vault-Prod-WestUS"
				$backupPolicy1 = "backup-policy"
				$backuppolicy2 = "my-policy"
				$location = "West US"
			
                Get-AzRecoveryServicesVault -Name $rsvaultname1  | Set-AzRecoveryServicesVaultContext
				foreach ($virtualmachines in $vm)
				{
                    if ($TotalExistingBackupVMs -contains $($virtualmachines.Name)){
                        write-host "$($virtualmachines.Name) already part of a service vault"
                    }
                    else{
    				# Check for direct tag or group-inherited tag
    				if($virtualmachines.Tags -eq $null)
    				{
        				Write-Output "[$($virtualmachines.Name)]: Not fully tagged for Backup. Skipping this VM. Please rerun the script after correcting following tags: DEV"
            				
    				}
        				elseif (($virtualmachines.Tags["INFY_EA_Role"] -contains "Dev-Backup"))
    				{
        				# VM has direct tag (possible for resource manager deployment model VMs). Prefer this tag for backup schedule.
        				$backup = Get-AzTag -Name "INFY_EA_Role" | select values -ExpandProperty values | select Name -ExpandProperty Name
        				Write-Output "[$($virtualmachines.Name)]: Found VM Backup tag with value: $backup"
      				
				
        				# Register the Recovery Services provider and create a resource group
        				#Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
    				
        				# Set Recovery Services Vault context 
        
			
        				# Get Protection Policy and Enable Protection
        				$pol = Get-AzRecoveryServicesBackupProtectionPolicy -Name $backuppolicy2
     				
                        #$ExistingBackupVMs = $Null
				        #$ExistingBackupVMs = Get-AzrecoveryServicesBackupContainer -ContainerType AzureVM
                        #if ($($ExistingBackupVMs.friendlyname) -notcontains $($virtualmachines.Name)){
                            Write-Output "[$($virtualmachines.Name)]: Enabling protection"
        				    Enable-AzRecoveryServicesBackupProtection -Policy $pol -Name $virtualmachines.Name -ResourceGroupName $virtualmachines.ResourceGroupName 
                        #}
                        #else{
                        #    Write-Output "[$($virtualmachines.Name)]: Already exist in the $($rsvaultname1) recovery service vault"
                        #}
    				}
                }
        				
				}
					


        		Get-AzRecoveryServicesVault -Name $rsvaultname2 | Set-AzRecoveryServicesVaultContext 
				foreach ($virtualmachines in $vm)
				{
                    if ($TotalExistingBackupVMs -contains $($virtualmachines.Name)){
                        write-host "$($virtualmachines.Name) already part of a service vault"
                    }
                    else{
    				# Check for direct tag or group-inherited tag
    				if($virtualmachines.Tags -eq $null)
    				{
        				Write-Output "[$($virtualmachines.Name)]: Not fully tagged for Backup. Skipping this VM. Please rerun the script after correcting following tags: DEV"
            				
    				}
        				elseif (($virtualmachines.Tags["INFY_EA_Role"] -contains "Prod-Backup"))
    				{
        				# VM has direct tag (possible for resource manager deployment model VMs). Prefer this tag for backup schedule.
        				$backup = Get-AzTag -Name "INFY_EA_Role" | select values -ExpandProperty values | select Name -ExpandProperty Name
        				Write-Output "[$($virtualmachines.Name)]: Found VM Backup tag with value: $backup"
      				
				
        				# Register the Recovery Services provider and create a resource group
        				#Register-AzureRmResourceProvider -ProviderNamespace "Microsoft.RecoveryServices"
    				
        				# Set Recovery Services Vault context 

				
        				# Get Protection Policy and Enable Protection
        				$pol = Get-AzRecoveryServicesBackupProtectionPolicy -Name $backupPolicy1
				
                        #$ExistingBackupVMs = $Null
				        #$ExistingBackupVMs = Get-AzrecoveryServicesBackupContainer -ContainerType AzureVM
                        #if ($($ExistingBackupVMs.friendlyname) -notcontains $($virtualmachines.Name)){
                            Write-Output "[$($virtualmachines.Name)]: Enabling protection"
        				    Enable-AzRecoveryServicesBackupProtection -Policy $pol -Name $virtualmachines.Name -ResourceGroupName $virtualmachines.ResourceGroupName 
                        #}
                        #else{
                        #    Write-Output "[$($virtualmachines.Name)]: Already exist in the $($rsvaultname2) recovery service vault"
                        #}

    				}
                   }
        				
				}
