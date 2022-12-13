# Dependencies
Add-PSSnapIn Microsoft.Exchange.Management.PowerShell.E2010

if(!$args[0]){
	Write-Output("Input a domain or subdomain as a parameter to run this script")
	Write-Output("Example: comodo.com")
}else{
	# Variables
	$domain = $args[0]
	$foundNewer = $false;
	$CertThumbprint = "";
	$CertStartDate = [datetime]::ParseExact('01.01.0001 00:00:00','dd.MM.yyyy HH:mm:ss',[Globalization.CultureInfo]::InvariantCulture)
	$CertList = Get-ExchangeCertificate | Select-Object NotBefore, Thumbprint, CertificateDomains | Where-Object {$_.CertificateDomains -match "($($domain))"} | Format-List | Out-String
	
	$CertList.Split([Environment]::NewLine) | ForEach-Object {
		$line = $_.Trim()
		if($line.Length -gt 0){
			# Replace first : with | and split the Property Name with the Value, DateTime can have :, hence only the first occurence
			[regex]$pattern = "\:"
			$line = $pattern.replace($line, "|", 1)
			$lineArr = ($line.Split('|') | ForEach-Object { $_.Trim() })
			
			# For Debug Purposes
			#Write-Output($line)
			
			# Check if Cert is the newest so far, if so, set flag and remember DateTime
			if($lineArr[0] -eq "NotBefore"){
				$lineDate = [datetime]::ParseExact($lineArr[1],'dd.MM.yyyy HH:mm:ss',[Globalization.CultureInfo]::InvariantCulture)
				if($lineDate.Ticks -gt $CertStartDate.Ticks){
					$CertStartDate = $lineDate
					$foundNewer = $true
				}
			} 
	
			# Check if Cert flag was set, if so, remember Thumbprint and reset flag
			if($lineArr[0] -eq "Thumbprint" -and $foundNewer){
				$CertThumbprint = $lineArr[1]
				$foundNewer = $false
			}
		}
	}
	
	# If a newer Cert was found, deploy it to all services
	if($CertThumbprint){
		Enable-ExchangeCertificate -Thumbprint $CertThumbprint -Services POP,IMAP,SMTP,IIS -Force
	}
	
	# For Debug purposes
	#Write-Output($CertStartDate.ToString() + " " + $CertThumbprint)
}