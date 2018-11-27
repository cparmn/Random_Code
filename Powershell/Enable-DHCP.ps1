'''
This might be broken, I found out it didnt work with Windows 7 
'''
function Enable-DHCP
{
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNull()]
        [ValidateNotNullorEmpty()]
        [string]$COMPUTER
        )

#Verify Computer Exist and view Current DNS looking information.
       
        try {$NAME =(Resolve-DnsName $COMPUTER -ErrorAction Stop | Where-object {$_.Type -eq "A"} ); write-host "$COMPUTER Current DNS address:"$NAME.IPAddress}
		catch {Write-Warning -Message "$COMPUTER - No Reverse DNS"}
#Now lets connect to the Computer We need to be logged into Powershell with Permissions that can connect to this computer.

    invoke-command -ComputerName $COMPUTER -ScriptBlock { $InterfaceIPType = "IPv4" ` 
    $ActiveAdapter = Get-NetAdapter | ? {$_.Status -eq "up"} ` 
    $CurrentInterface = $ActiveAdapter | Get-NetIPInterface -AddressFamily $InterfaceIPType ` 
        If ($CurrentInterface.Dhcp -eq "Disabled") 
        {
        # Remove exi$insting gateway
            If (($CurrentInterface | Get-NetIPConfiguration).Ipv4DefaultGateway) 
            {
                $CurrentInterface | Remove-NetRoute -Confirm:$false
            }
    # Enable DHCP
            $CurrentInterface | Set-NetIPInterface -DHCP Enabled
    # Configure the DNS Servers automatically
            $CurrentInterface | Set-DnsClientServerAddress -ResetServerAddresses
        }
        Else
        {
            Write-Host "DHCP Already enabled on Interface:" $ActiveAdapter.Name "MAC Address:" $ActiveAdapter.MacAddress
        }
    }
}

Enable-DHCP $args[0]
