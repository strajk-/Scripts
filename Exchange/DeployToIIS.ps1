param($result, [String] $SiteName, [String] $CertThumbprint)

# Dependencies
Import-Module Webadministration

# In case CertifyTheWeb was used
if($result){
	$CertThumbprint = $result.ManagedItem.CertificateThumbprintHash;
}

if(!$SiteName -Or !$CertThumbprint){
	Write-Output("Input SiteName and CertificateThumbprint as parameters to run this script")
	Write-Output("Example: -SiteName comodo.com -CertThumbprint a909502dd82ae41433e6f83886b00d4277a32a7b")
}else{
	$binding = Get-WebBinding -Name $SiteName -Protocol "https"
	$binding.AddSslCertificate($CertThumbprint, "my")
}
