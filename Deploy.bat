sc query getinfo && sc delete getinfo
copy *.exe c:\windows\system32 /y
sc create getinfo binPath=c:\windows\system32\MyService.exe start=auto
sc query getinfo && net start getinfo

