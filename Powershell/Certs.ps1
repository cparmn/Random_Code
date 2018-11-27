#Get a usable cert and view it;

$Cert=(Get-ChildItem Cert:CurrentUser\My\ -CodeSigningCert);$Cert;

#Get a script file and view basic file properties;

$ScriptPath="FILE";Get-Item $ScriptPath;

#Sign the code with the cert and a timestamp server;

Set-AuthenticodeSignature $ScriptPath $Cert -TimestampServer "http://timestamp.comodoca.com/?td=sha256";

#Validate the signature;

Get-AuthenticodeSignature $ScriptPath|FL;
