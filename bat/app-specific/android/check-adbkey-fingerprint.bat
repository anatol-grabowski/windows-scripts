awk '{print $1}' < %USERPROFILE%/.android/adbkey.pub | openssl base64 -A -d -a | openssl md5 -c
@pause