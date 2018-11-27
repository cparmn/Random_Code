'''
DNS-Resolution dns.txt
WARNING: 215.154.125.254 - No Reverse DNS
31.13.93.35, edge-star-mini-shv-02-dfw5.facebook.com
17.142.160.49, pv-searchcgi.apple.com
'''
function DNS-Resolution
{
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNull()]
        [ValidateNotNullorEmpty()]
        [string[]]$FILE
        )

	foreach ($COMPUTER in Get-Content $FILE)
	{
		try {$NAME =(Resolve-DnsName $COMPUTER -ErrorAction Stop | select-object NameHost); write-host "$COMPUTER,"$NAME.NameHost}
		catch {Write-Warning -Message "$COMPUTER - No Reverse DNS"}
	}
}
DNS-Resolution $args[0]
