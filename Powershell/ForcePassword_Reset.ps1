'''
Force Users to reset password based on file with usernames.
'''
function Force-Reset
{
    param (
        [Parameter(Mandatory=$True)]
        [ValidateNotNull()]
        [ValidateNotNullorEmpty()]
        [ValidatePattern("[a-z][A-Z]")]
        [string[]]$FILE
        )

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
                        set-aduser $userID -changepasswordatlogon $true
                        if($?)
                        {
                            if([bool] (Get-ADUser -filter {SamAccountName -eq $userID} -Properties PasswordExpired | where {$_.PasswordExpired -eq $True}))
                            {
                                write-host "Success: User account '$userID' set to change password on next login."
                            }
                            else
                            {
                                write-host -ForegroundColor red "Error:  Cannot find an object with identity: '$userID'" 
                            }
                        }
                        else
                        {
                            write-host -ForegroundColor red "Error: $userID was not changed"
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
