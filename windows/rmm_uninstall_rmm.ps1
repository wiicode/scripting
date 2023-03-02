$result = gwmi win32_product -filter "Name LIKE 'RMM'" | select IdentifyingNumber;
[string] $a = $result.identifyingNumber;
msiexec.exe /X $a /qn