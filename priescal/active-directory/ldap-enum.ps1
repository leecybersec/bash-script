# Generate LDAP path, file `ldap-enum.ps1`

# .\ldap-enum.ps1
# LDAP://WIN-GFL2HT22DPG.leecybersec.com/DC=leecybersec,DC=local

$domainObj = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
# $domainObj

# .\ldap-enum.ps1
# Forest                  : leecybersec.local
# DomainControllers       : {WIN-GFL2HT22DPG.leecybersec.com}
# Children                : {}
# DomainMode              : Windows2012R2Domain
# Parent                  : 
# PdcRoleOwner            : WIN-GFL2HT22DPG.leecybersec.com
# RidRoleOwner            : WIN-GFL2HT22DPG.leecybersec.com
# InfrastructureRoleOwner : WIN-GFL2HT22DPG.leecybersec.com
# Name                    : leecybersec.local

$PDC = ($domainObj.PdcRoleOwner).Name
# $PDC

# .\ldap-enum.ps1
# WIN-GFL2HT22DPG.leecybersec.com

$SearchString = "LDAP://"
$SearchString += $PDC + "/"
$DistinguishedName = "DC=$($domainObj.Name.Replace('.', ',DC='))"
$SearchString += $DistinguishedName
# $SearchString

# .\ldap-enum.ps1
# LDAP://WIN-GFL2HT22DPG.leecybersec.com/DC=leecybersec,DC=local

$Searcher = New-Object System.DirectoryServices.DirectorySearcher([ADSI]$SearchString)
$objDomain = New-Object System.DirectoryServices.DirectoryEntry
$Searcher.SearchRoot = $objDomain

# supply 0x30000000 (decimal 805306368) to enumerate all users in the domain
# $Searcher.filter="samAccountType=805306368"

# Execute LDAP search for user admin
$Searcher.filter="name=admin"

$Result = $Searcher.FindAll()

Foreach($obj in $Result)
{
	Foreach($prop in $obj.Properties)
	{
		$prop
	}
	Write-Host "------------------------"
}

# .\ldap-enum.ps1

# Name                           Value                                                                                                                                                         
# ----                           -----                                                                                                                                                         
# givenname                      {admin}                                                                                                                                                       
# codepage                       {0}                                                                                                                                                           
# objectcategory                 {CN=Person,CN=Schema,CN=Configuration,DC=leecybersec,DC=local}                                                                                                
# dscorepropagationdata          {5/27/2021 2:57:16 AM, 1/1/1601 12:00:00 AM}                                                                                                                  
# usnchanged                     {45105}                                                                                                                                                       
# instancetype                   {4}                                                                                                                                                           
# logoncount                     {5}                                                                                                                                                           
# name                           {admin}                                                                                                                                                       
# badpasswordtime                {0}                                                                                                                                                           
# pwdlastset                     {132664962515096897}                                                                                                                                          
# objectclass                    {top, person, organizationalPerson, user}                                                                                                                     
# badpwdcount                    {0}                                                                                                                                                           
# samaccounttype                 {805306368}                                                                                                                                                   
# lastlogontimestamp             {132664962751518669}                                                                                                                                          
# usncreated                     {24601}                                                                                                                                                       
# objectguid                     {15 87 192 238 124 124 42 73 147 19 205 173 228 51 249 189}                                                                                                   
# memberof                       {CN=Remote Desktop Users,CN=Builtin,DC=leecybersec,DC=local, CN=Administrators,CN=Builtin,DC=leecybersec,DC=local}                                            
# whencreated                    {5/26/2021 9:50:51 AM}                                                                                                                                        
# adspath                        {LDAP://CN=admin,CN=Users,DC=leecybersec,DC=local}                                                                                                            
# useraccountcontrol             {512}                                                                                                                                                         
# cn                             {admin}                                                                                                                                                       
# countrycode                    {0}                                                                                                                                                           
# primarygroupid                 {513}                                                                                                                                                         
# whenchanged                    {5/27/2021 2:57:16 AM}                                                                                                                                        
# lastlogon                      {132665573401599512}                                                                                                                                          
# distinguishedname              {CN=admin,CN=Users,DC=leecybersec,DC=local}                                                                                                                   
# admincount                     {1}                                                                                                                                                           
# samaccountname                 {admin}                                                                                                                                                       
# objectsid                      {1 5 0 0 0 0 0 5 21 0 0 0 41 185 80 171 212 6 7 187 76 98 180 53 85 4 0 0}                                                                                    
# lastlogoff                     {0}                                                                                                                                                           
# displayname                    {admin}                                                                                                                                                       
# accountexpires                 {9223372036854775807}                                                                                                                                         
# userprincipalname              {admin@leecybersec.local}                                                                                                                                     
# ------------------------