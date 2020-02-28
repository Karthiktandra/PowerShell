	$passwd = '69a930b7-f38a-437a-92c6-2966bdfc297b’ | ConvertTo-SecureString -AsPlainText -Force
        $AppUserId = "607e8b31-37b4-467b-a623-c4702a20fd6b"
        $tenant = "7571a489-bd29-4f38-b9a6-7c880f8cddf0"
        $subscription = "84e4a2d3-4d52-4e80-92bd-c9634d76f301"
        $pscredential = New-Object System.Management.Automation.PSCredential($AppUserId, $passwd)
        Connect-AzureRmAccount -ServicePrincipal -Credential $pscredential -Tenant $tenant -Subscription $subscription
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
