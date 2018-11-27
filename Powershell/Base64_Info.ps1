$Text = ‘hello’
$Bytes = [System.Text.Encoding]::Unicode.GetBytes($Text)
$EncodedText =[Convert]::ToBase64String($Bytes)
$EncodedText
$DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedText))
$DecodedText 


$b  = [System.Text.Encoding]::UTF8.GetBytes("hello")
$b
[System.Convert]::ToBase64String($b)

$EncodedText = 'aGVsbG8K'
$DecodedText = [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($EncodedText))
$DecodedText 


powershell.exe -enc cABpAG4AZwAgAHcAdwB3AC4AZwBvAG8AZwBsAGUALgBjAG8AbQA=




$EncodedText = ' cABpAG4AZwAgAHcAdwB3AC4AZwBvAG8AZwBsAGUALgBjAG8AbQA='
$EncodedText
$DecodedText = [System.Text.Encoding]::UTF8.GetBytes([System.Convert]::FromBase64String($EncodedText))
$DecodedText 

$b  = [System.Text.Encoding]::UTF8.GetBytes("hello")
[System.Convert]::ToBase64String($b)

$DecodedText = [System.Text.Encoding]::UTF8.GetBytes([System.Convert]::FromBase64String($b))
