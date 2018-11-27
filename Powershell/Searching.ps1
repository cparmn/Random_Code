ls -r -file -filter *power*

ls -r  -file | % {select-string -path $_ -pattern Power}
