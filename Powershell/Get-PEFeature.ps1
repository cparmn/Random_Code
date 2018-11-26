filter Get-PEFeature {
<#
.SYNOPSIS
Retrieves key features from PE files that can be used to build detections.
.DESCRIPTION
Get-PEFeature extracts key features of PE files that are relevant to building detections.
Author: Matthew Graeber (@mattifestation)
License: BSD 3-Clause
.EXAMPLE
ls C:\Windows\System32\*.exe | Get-PEFeature
.EXAMPLE
ls C:\Windows\System32\*.exe | Get-PEFeature | ConvertTo-Json
#>

    [CmdletBinding()]
    param (
        [Parameter(Position = 0, Mandatory = $True, ValueFromPipelineByPropertyName = $True)]
        [String]
        [Alias('FullName')]
        $Path
    )

    $HeaderBytes = Get-Content -TotalCount 2 -Encoding Byte -Path $Path

    if (($HeaderBytes.Count -ne 2) -or ([Text.Encoding]::ASCII.GetString($HeaderBytes) -ne 'MZ')) {
        Write-Verbose "$Path is not a valid PE file."
    } else {
        $FileInfo = Get-Item -Path $Path
        $FileVersionInfo = $FileInfo.VersionInfo

        # If a path starts with %windir%, %ProgramFiles%, %ProgramFiles(x86)%, or %APPDATA%,
        # replace it to account for alternate system drives
        $ExpectedPath = $FileInfo.DirectoryName -replace "^$([Regex]::Escape($Env:windir))", '%windir%'
        $ExpectedPath = $ExpectedPath -replace "^$([Regex]::Escape($Env:ProgramFiles))", '%ProgramFiles%'
        $ExpectedPath = $ExpectedPath -replace "^$([Regex]::Escape(${Env:ProgramFiles(x86)}))", '%ProgramFiles(x86)%'
        $ExpectedPath = $ExpectedPath -replace "^$([Regex]::Escape($Env:APPDATA))", '%APPDATA%'
        $ExpectedPath = $ExpectedPath -replace "^$([Regex]::Escape($Env:LOCALAPPDATA))", '%LOCALAPPDATA%'

        $OriginalFilename = $FileVersionInfo.OriginalFilename
        $FileDescription = $FileVersionInfo.FileDescription

        # Note that Get-AuthenticodeSignature will prefer catalog signatures over embedded Authenticode signatures.
        $SignatureInfo = Get-AuthenticodeSignature $Path
        $SigningStatus = $SignatureInfo.Status
        $OSBinary = $SignatureInfo.IsOSBinary

        $SignerThumbprint = $null
        $SignerSubject = $null
        $RootThumbprint = $null
        $RootSubject = $null

        if ($SignatureInfo.SignerCertificate) {
            $SignerCertificate = $SignatureInfo.SignerCertificate
            # These will be subject to change as the certificate approaches the end of its validity period
            $SignerThumbprint = $SignerCertificate.Thumbprint
            $SignerSubject = $SignerCertificate.Subject

            # Build a signer chain so the root certificate info can be extracted.
            $SignerChain = New-Object -TypeName Security.Cryptography.X509Certificates.X509Chain
            $null = $SignerChain.Build($SignerCertificate)

            $RootCertificate = $SignerChain.ChainElements[$SignerChain.ChainElements.Count - 1].Certificate
            $RootThumbprint = $RootCertificate.Thumbprint
            $RootSubject = $RootCertificate.Subject
        }

        [PSCustomObject] @{
            ExpectedPath = $ExpectedPath
            ExpectedFileName = $FileInfo.Name
            OriginalFileName = $OriginalFilename
            FileDescription = $FileDescription
            SigningStatus = $SigningStatus
            IsOSBinary = $OSBinary
            SignerSubject = $SignerSubject
            SignerThumbprint = $SignerThumbprint
            RootSubject = $RootSubject
            RootThumbprint = $RootThumbprint
        }
    }
}
