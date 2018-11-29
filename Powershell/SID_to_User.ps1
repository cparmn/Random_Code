 $objSID = New-Object System.Security.Principal.SecurityIdentifier("s-1-5-21-1164055144-3978474625-4174481481-1003")
 $objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
 $objUser.Value


 get-adcomputer -filter "sid -eq 's-1-5-21-1164055144-3978474625-4174481481-1003'" -Properties *

 Get-ADUser -Filter "sid -eq 's-1-5-21-1164055144-3978474625-4174481481-1003'"
