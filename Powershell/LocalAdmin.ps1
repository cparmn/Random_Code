'''
Not really written to be a script....
''
$computer=@(Get-ADComputer -LDAPFilter "(name=ComputerNameFilter*)"-SearchBase "OU=Workstations,DC=Organziation,DC=org")
$GroupName = "Administrators"
$ComputerName=$computer.Name
$AdminTable = @{}
$ComputerName | % {
    $_
    $test = [ADSI]"WinNT://$_,computer"
    if ($test = $null)
    {
        write-host "Unable to connect to $_"
    }
    Else
    {
        $Group = [ADSI]"WinNT://$_/$GroupName,group";
        $Members = @($Group.psbase.Invoke('Members'));
        $CurrentComputer=$_
        $AdminTable.$CurrentComputer = @()
        $Members | %{
            $name = $_.GetType().InvokeMember("Name", 'GetProperty', $null, $_, $null)
            $AdminTable.$CurrentComputer  += $name
            }
     }
 }
 $AdminTable
