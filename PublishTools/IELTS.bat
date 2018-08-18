:: this is batch file to upload publish file to server and create container and run host
:: for using this batch zip.exe must be exist and putty should be install


cd <Path to publish dir>

del publish.zip

zip -r publish.zip *.*

pscp -pw <Server password> publish.zip <User>@<Host machine ip or address>:/<stage dir>/publish.zip 

putty -ssh -l <user> -pw <Server password> -m LinuxCommands.txt <Host machine ip or address>

cmd /k

