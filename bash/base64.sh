#!/bin/bash
#Based64 Decoder

read -p  "Enter Base64 Text: " C_BASE

C_BASE_1=$(echo $C_BASE | sed 's/%3D/=/g' | sed 's/%2F/\//g' | sed 's/%2B/+/g')

echo $C_BASE_1  | base64 --decode
#echo -e "\n" 
echo ""
