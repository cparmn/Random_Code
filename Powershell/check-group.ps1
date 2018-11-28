function Check-Group
{
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNull()]
        [ValidateNotNullorEmpty()]
        [ValidatePattern(“[a-z][A-Z]”)]
        [string[]]$FILE
        )
        $count=0
        $groups = 'Duo_Enroll_Users'
        foreach ($group in $groups) {
       			$members = Get-ADGroupMember -Identity $group -Recursive | Select -ExpandProperty SamAccountName
		        foreach ($LINE in Get-Content $FILE){
		            foreach ($UserID in $LINE){
		                if (($UserID -eq $Null) -or ($UserID -eq '')) 
		                {
		                    write-host "Username is empty"
		                }
		                else 
		                {
		                    if([bool] (Get-ADUser -Filter { SamAccountName -eq $userID }))
		                      {
                                if($?)
		                        {
		                            if ($members -contains $userID) {
		                                Write-Host "$userID is a member of $group"
                                        $count = $count +1
		                                }
		                            else {
		                                Write-Host "$userID is not a member of $group"
		                                }
		                        }
		                        else
		                        {
		                            write-host -ForegroundColor red "Error:  Cannot find an object with identity: '$userID'" 
		                        }
		                    }
		                }
		            }
		        }
		}
    Write-Host $count " Users are already in the group."
}
Check-Group $args[0]
