'''
RandomStuff
'''
 $(netsh -f C:\Test\script.ps1 | % {[regex]::matches($_ ,'(?<=The following command was not found: )(.*?)(?=\.$)')} | % {$_.value -replace "∩╗┐"})
Invoke-Command -ScriptBlock {$Script}
Invoke-Expression & $Script
powershell -c $Script




$test= (netsh -f itsfine.ps1 | % {[regex]::matches($_ ,'(?<=The following command was not found: )(.*?)(?=\.$)')} | % { $_.value -replace "ï»¿" })
$ExecutionContext.InvokeCommand($test)




$test=(netsh -f newone.ps1 | % {[regex]::matches($_ ,'(?<=The following command was not found: )(.*?)(?=\.$)')} | % { $_.value -replace 'ï»¿' })


$test1=$ExecutionContext.InvokeCommand.NewScriptBlock($test)

Invoke-Command  -ScriptBlock $test1


$test

powershell  % -command $test

Invoke-Expression -Command [string]$test
