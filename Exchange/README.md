### Exchange scripts
**Requirements:**
- Powershell 4.0

**DeployToExchange2010.ps1**
(ex: DeployToExchange2010.ps1 comodo.com) (Used in conjunction with Tools like CertifyTheWeb that doesn't have a 2010 Deploy script)
1. Gets a list of all installed Certs of $domain
2. Remembers the Thumbprint of the newest Cert
3. Applies found Cert to POP,IMAP,SMTP and IIS

**DeployToIIS.ps1**
(ex: DeployToIIS.ps1 -SiteName comodo.com -CertThumbprint xyz) (Supports $result from CertifyTheWeb scripting)
1. Gets site with $SiteName and binding type https
2. Sets Cert to be $CertThumbprint
