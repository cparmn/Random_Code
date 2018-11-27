for /l %x in () do @for /l %y in (0,1,255) do @for /l %z in (0,1,255) do @ping -f -l 1 -w 1 -n 1 10.201.%y.%z | findstr /i "reply from" > target.txt
