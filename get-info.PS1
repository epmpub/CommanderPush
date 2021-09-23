
$winModel = Get-WmiObject -Query "SELECT * FROM Win32_ComputerSystem" | Select-Object Model|ForEach-Object {$_.Model}
$winCpu = Get-WmiObject -Query "SELECT * FROM Win32_Processor" | Select-Object Caption |ForEach-Object {$_.Caption}

$winarch = get-ciminstance win32_operatingsystem | select-object osarchitecture | ForEach-Object { $_.osarchitecture }
$winos = get-ciminstance win32_operatingsystem | select-object caption | ForEach-Object { $_.caption }
$winbuild = get-ciminstance win32_operatingsystem | select-object buildnumber | ForEach-Object { $_.buildnumber }
$manuf = get-ciminstance -classname win32_computersystem | select-object manufacturer | ForEach-Object { $_.manufacturer }
$serialnum = Get-WmiObject win32_bios | select-object serialnumber | ForEach-Object { $_.serialnumber }
$windomain = get-ciminstance -classname win32_computersystem | select-object domain | ForEach-Object { $_.domain }
$owner = get-ciminstance -classname win32_computersystem | select-object primaryownername | ForEach-Object { $_.primaryownername }
$loggedon = get-ciminstance -classname win32_computersystem  | select-object username | ForEach-Object { $_.username }
$ipaddress = (get-wmiobject -class win32_networkadapterconfiguration | Where-Object {$_.defaultipgateway -ne $null}).ipaddress | select-object -first 1
$ipgateway = (get-wmiobject -class win32_networkadapterconfiguration | Where-Object {$_.defaultipgateway -ne $null}).defaultipgateway | select-object -first 1
$operatingsystem = get-wmiobject -class win32_operatingsystem
$osinstalldate = ($operatingsystem.converttodatetime($operatingsystem.installdate).toshortdatestring())


$info = @(
    $winModel,
    $winCpu,
    $winarch,
    $winos,
    $winbuild,
    $manuf,
    $serialnum,
    $windomain,
    $owner,
    $loggedon,
    $ipaddress,
    $ipgateway,
    $osinstalldate
)

$cmdbLogPath = "c:\log\cmdb\"

if (-Not (Test-Path -Path $cmdbLogPath)) {

    New-Item -ItemType directory -Path $cmdbLogPath
    
}

$softLogPath = "c:\log\soft\"

if (-Not (Test-Path -Path $softLogPath)) {

    New-Item -ItemType directory -Path $softLogPath
}



$CMDBLogname = $cmdbLogPath + (get-date -Format "yyyy-MM-dd-HH-mm-ss").ToString() + "-cmdb.log"
$SoftLogname = $softLogPath + (get-date -Format "yyyy-MM-dd-HH-mm-ss").ToString() + "-soft.log"




$info | ForEach-Object {$_+"|"}| Out-File -NoNewline -Encoding utf8 -FilePath $CMDBLogname 


$content = Get-Content $CMDBLogname
$newContent = $content.Substring(0,$content.Length-1)
$newContent | Out-File -Encoding utf8 -FilePath $CMDBLogname


Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName ,DisplayVersion | where-object {$_.displayname -ne $null} | Export-Csv -Path $SoftLogname -NoTypeInformation -Encoding UTF8

Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName ,DisplayVersion | where-object {$_.displayname -ne $null} | Export-Csv -Path $SoftLogname -NoTypeInformation -Encoding UTF8 -Append


# 2021/9/18 11:15




$cmdbLogPath = "c:\log\autorun\"
if (-Not (Test-Path -Path $cmdbLogPath)) {
    New-Item -ItemType directory -Path $cmdbLogPath
}

$cmdbLogPathTemp = "c:\log\autorun\temp"
if (-Not (Test-Path -Path $cmdbLogPathTemp)) {
    New-Item -ItemType directory -Path $cmdbLogPathTemp
}



$AutoRunLogname = (get-date -Format "yyyy-MM-dd-HH-mm-ss").ToString() + "-autorun.log"
autorunsc64.exe  -accepteula -nobanner -a * -m -c -o $cmdbLogPath$AutoRunLogname
$logs = Get-ChildItem $cmdbLogPath -File -Filter *.log
Write-Host $logs
foreach ($item in $logs) {
    Write-Host "Process... "$item
    Get-Content $cmdbLogPath$item | Out-File -Encoding utf8 -FilePath $cmdbLogPath"temp\"$item
}

Copy-Item -Path $cmdbLogPath"temp\"*.log -Recurse -Destination $cmdbLogPath -Force

Remove-Item -Path $cmdbLogPath"temp\" -Force -Recurse

#2021-09-22 12:18

# SIG # Begin signature block
# MIImWAYJKoZIhvcNAQcCoIImSTCCJkUCAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQUZyYuJ/GXxSRTByQA89EBlzbh
# tQ2ggiC9MIIEMjCCAxqgAwIBAgIBATANBgkqhkiG9w0BAQUFADB7MQswCQYDVQQG
# EwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHDAdTYWxm
# b3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8GA1UEAwwYQUFBIENl
# cnRpZmljYXRlIFNlcnZpY2VzMB4XDTA0MDEwMTAwMDAwMFoXDTI4MTIzMTIzNTk1
# OVowezELMAkGA1UEBhMCR0IxGzAZBgNVBAgMEkdyZWF0ZXIgTWFuY2hlc3RlcjEQ
# MA4GA1UEBwwHU2FsZm9yZDEaMBgGA1UECgwRQ29tb2RvIENBIExpbWl0ZWQxITAf
# BgNVBAMMGEFBQSBDZXJ0aWZpY2F0ZSBTZXJ2aWNlczCCASIwDQYJKoZIhvcNAQEB
# BQADggEPADCCAQoCggEBAL5AnfRu4ep2hxxNRUSOvkbIgwadwSr+GB+O5AL686td
# UIoWMQuaBtDFcCLNSS1UY8y2bmhGC1Pqy0wkwLxyTurxFa70VJoSCsN6sjNg4tqJ
# VfMiWPPe3M/vg4aijJRPn2jymJBGhCfHdr/jzDUsi14HZGWCwEiwqJH5YZ92IFCo
# kcdmtet4YgNW8IoaE+oxox6gmf049vYnMlhvB/VruPsUK6+3qszWY19zjNoFmag4
# qMsXeDZRrOme9Hg6jc8P2ULimAyrL58OAd7vn5lJ8S3frHRNG5i1R8XlKdH5kBjH
# Ypy+g8cmez6KJcfA3Z3mNWgQIJ2P2N7Sw4ScDV7oL8kCAwEAAaOBwDCBvTAdBgNV
# HQ4EFgQUoBEKIz6W8Qfs4q8p74Klf9AwpLQwDgYDVR0PAQH/BAQDAgEGMA8GA1Ud
# EwEB/wQFMAMBAf8wewYDVR0fBHQwcjA4oDagNIYyaHR0cDovL2NybC5jb21vZG9j
# YS5jb20vQUFBQ2VydGlmaWNhdGVTZXJ2aWNlcy5jcmwwNqA0oDKGMGh0dHA6Ly9j
# cmwuY29tb2RvLm5ldC9BQUFDZXJ0aWZpY2F0ZVNlcnZpY2VzLmNybDANBgkqhkiG
# 9w0BAQUFAAOCAQEACFb8AvCb6P+k+tZ7xkSAzk/ExfYAWMymtrwUSWgEdujm7l3s
# Ag9g1o1QGE8mTgHj5rCl7r+8dFRBv/38ErjHT1r0iWAFf2C3BUrz9vHCv8S5dIa2
# LX1rzNLzRt0vxuBqw8M0Ayx9lt1awg6nCpnBBYurDC/zXDrPbDdVCYfeU0BsWO/8
# tqtlbgT2G9w84FoVxp7Z8VlIMCFlA2zs6SFz7JsDoeA3raAVGI/6ugLOpyypEBMs
# 1OUIJqsil2D4kF501KKaU73yqWjgom7C12yxow+ev+to51byrvLjKzg6CYG1a4XX
# vi3tPxq3smPi9WIsgtRqAEFQ8TmDn5XpNpaYbjCCBP4wggPmoAMCAQICEA1CSuC+
# Ooj/YEAhzhQA8N0wDQYJKoZIhvcNAQELBQAwcjELMAkGA1UEBhMCVVMxFTATBgNV
# BAoTDERpZ2lDZXJ0IEluYzEZMBcGA1UECxMQd3d3LmRpZ2ljZXJ0LmNvbTExMC8G
# A1UEAxMoRGlnaUNlcnQgU0hBMiBBc3N1cmVkIElEIFRpbWVzdGFtcGluZyBDQTAe
# Fw0yMTAxMDEwMDAwMDBaFw0zMTAxMDYwMDAwMDBaMEgxCzAJBgNVBAYTAlVTMRcw
# FQYDVQQKEw5EaWdpQ2VydCwgSW5jLjEgMB4GA1UEAxMXRGlnaUNlcnQgVGltZXN0
# YW1wIDIwMjEwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDC5mGEZ8WK
# 9Q0IpEXKY2tR1zoRQr0KdXVNlLQMULUmEP4dyG+RawyW5xpcSO9E5b+bYc0VkWJa
# uP9nC5xj/TZqgfop+N0rcIXeAhjzeG28ffnHbQk9vmp2h+mKvfiEXR52yeTGdnY6
# U9HR01o2j8aj4S8bOrdh1nPsTm0zinxdRS1LsVDmQTo3VobckyON91Al6GTm3dOP
# L1e1hyDrDo4s1SPa9E14RuMDgzEpSlwMMYpKjIjF9zBa+RSvFV9sQ0kJ/SYjU/aN
# Y+gaq1uxHTDCm2mCtNv8VlS8H6GHq756WwogL0sJyZWnjbL61mOLTqVyHO6fegFz
# +BnW/g1JhL0BAgMBAAGjggG4MIIBtDAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/
# BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDBBBgNVHSAEOjA4MDYGCWCGSAGG
# /WwHATApMCcGCCsGAQUFBwIBFhtodHRwOi8vd3d3LmRpZ2ljZXJ0LmNvbS9DUFMw
# HwYDVR0jBBgwFoAU9LbhIB3+Ka7S5GGlsqIlssgXNW4wHQYDVR0OBBYEFDZEho6k
# urBmvrwoLR1ENt3janq8MHEGA1UdHwRqMGgwMqAwoC6GLGh0dHA6Ly9jcmwzLmRp
# Z2ljZXJ0LmNvbS9zaGEyLWFzc3VyZWQtdHMuY3JsMDKgMKAuhixodHRwOi8vY3Js
# NC5kaWdpY2VydC5jb20vc2hhMi1hc3N1cmVkLXRzLmNybDCBhQYIKwYBBQUHAQEE
# eTB3MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wTwYIKwYB
# BQUHMAKGQ2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydFNIQTJB
# c3N1cmVkSURUaW1lc3RhbXBpbmdDQS5jcnQwDQYJKoZIhvcNAQELBQADggEBAEgc
# 3LXpmiO85xrnIA6OZ0b9QnJRdAojR6OrktIlxHBZvhSg5SeBpU0UFRkHefDRBMOG
# 2Tu9/kQCZk3taaQP9rhwz2Lo9VFKeHk2eie38+dSn5On7UOee+e03UEiifuHokYD
# Tvz0/rdkd2NfI1Jpg4L6GlPtkMyNoRdzDfTzZTlwS/Oc1np72gy8PTLQG8v1Yfx1
# CAB2vIEO+MDhXM/EEXLnG2RJ2CKadRVC9S0yOIHa9GCiurRS+1zgYSQlT7LfySmo
# c0NR2r1j1h9bm/cuG08THfdKDXF+l7f0P4TrweOjSaH6zqe/Vs+6WXZhiV9+p7SO
# Z3j5NpjhyyjaW4emii8wggUxMIIEGaADAgECAhAKoSXW1jIbfkHkBdo2l8IVMA0G
# CSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJ
# bmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAiBgNVBAMTG0RpZ2lDZXJ0
# IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0xNjAxMDcxMjAwMDBaFw0zMTAxMDcxMjAw
# MDBaMHIxCzAJBgNVBAYTAlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNV
# BAsTEHd3dy5kaWdpY2VydC5jb20xMTAvBgNVBAMTKERpZ2lDZXJ0IFNIQTIgQXNz
# dXJlZCBJRCBUaW1lc3RhbXBpbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
# ggEKAoIBAQC90DLuS82Pf92puoKZxTlUKFe2I0rEDgdFM1EQfdD5fU1ofue2oPSN
# s4jkl79jIZCYvxO8V9PD4X4I1moUADj3Lh477sym9jJZ/l9lP+Cb6+NGRwYaVX4L
# J37AovWg4N4iPw7/fpX786O6Ij4YrBHk8JkDbTuFfAnT7l3ImgtU46gJcWvgzyIQ
# D3XPcXJOCq3fQDpct1HhoXkUxk0kIzBdvOw8YGqsLwfM/fDqR9mIUF79Zm5WYScp
# iYRR5oLnRlD9lCosp+R1PrqYD4R/nzEU1q3V8mTLex4F0IQZchfxFwbvPc3WTe8G
# Qv2iUypPhR3EHTyvz9qsEPXdrKzpVv+TAgMBAAGjggHOMIIByjAdBgNVHQ4EFgQU
# 9LbhIB3+Ka7S5GGlsqIlssgXNW4wHwYDVR0jBBgwFoAUReuir/SSy4IxLVGLp6ch
# nfNtyA8wEgYDVR0TAQH/BAgwBgEB/wIBADAOBgNVHQ8BAf8EBAMCAYYwEwYDVR0l
# BAwwCgYIKwYBBQUHAwgweQYIKwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRw
# Oi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYBBQUHMAKGN2h0dHA6Ly9jYWNlcnRz
# LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcnQwgYEGA1Ud
# HwR6MHgwOqA4oDaGNGh0dHA6Ly9jcmw0LmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFz
# c3VyZWRJRFJvb3RDQS5jcmwwOqA4oDaGNGh0dHA6Ly9jcmwzLmRpZ2ljZXJ0LmNv
# bS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RDQS5jcmwwUAYDVR0gBEkwRzA4BgpghkgB
# hv1sAAIEMCowKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LmRpZ2ljZXJ0LmNvbS9D
# UFMwCwYJYIZIAYb9bAcBMA0GCSqGSIb3DQEBCwUAA4IBAQBxlRLpUYdWac3v3dp8
# qmN6s3jPBjdAhO9LhL/KzwMC/cWnww4gQiyvd/MrHwwhWiq3BTQdaq6Z+CeiZr8J
# qmDfdqQ6kw/4stHYfBli6F6CJR7Euhx7LCHi1lssFDVDBGiy23UC4HLHmNY8ZOUf
# SBAYX4k4YU1iRiSHY4yRUiyvKYnleB/WCxSlgNcSR3CzddWThZN+tpJn+1Nhiaj1
# a5bA9FhpDXzIAbG5KHW3mWOFIoxhynmUfln8jA/jb7UBJrZspe6HUSHkWGCbugwt
# K22ixH67xCUrRwIIfEmuE7bhfEJCKMYYVs9BNLZmXbZ0e/VWMyIvIjayS6JKldj1
# po5SMIIFbzCCBFegAwIBAgIQSPyTtGBVlI02p8mKidaUFjANBgkqhkiG9w0BAQwF
# ADB7MQswCQYDVQQGEwJHQjEbMBkGA1UECAwSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHDAdTYWxmb3JkMRowGAYDVQQKDBFDb21vZG8gQ0EgTGltaXRlZDEhMB8G
# A1UEAwwYQUFBIENlcnRpZmljYXRlIFNlcnZpY2VzMB4XDTIxMDUyNTAwMDAwMFoX
# DTI4MTIzMTIzNTk1OVowVjELMAkGA1UEBhMCR0IxGDAWBgNVBAoTD1NlY3RpZ28g
# TGltaXRlZDEtMCsGA1UEAxMkU2VjdGlnbyBQdWJsaWMgQ29kZSBTaWduaW5nIFJv
# b3QgUjQ2MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAjeeUEiIEJHQu
# /xYjApKKtq42haxH1CORKz7cfeIxoFFvrISR41KKteKW3tCHYySJiv/vEpM7fbu2
# ir29BX8nm2tl06UMabG8STma8W1uquSggyfamg0rUOlLW7O4ZDakfko9qXGrYbNz
# szwLDO/bM1flvjQ345cbXf0fEj2CA3bm+z9m0pQxafptszSswXp43JJQ8mTHqi0E
# q8Nq6uAvp6fcbtfo/9ohq0C/ue4NnsbZnpnvxt4fqQx2sycgoda6/YDnAdLv64Ip
# lXCN/7sVz/7RDzaiLk8ykHRGa0c1E3cFM09jLrgt4b9lpwRrGNhx+swI8m2JmRCx
# rds+LOSqGLDGBwF1Z95t6WNjHjZ/aYm+qkU+blpfj6Fby50whjDoA7NAxg0POM1n
# qFOI+rgwZfpvx+cdsYN0aT6sxGg7seZnM5q2COCABUhA7vaCZEao9XOwBpXybGWf
# v1VbHJxXGsd4RnxwqpQbghesh+m2yQ6BHEDWFhcp/FycGCvqRfXvvdVnTyheBe6Q
# THrnxvTQ/PrNPjJGEyA2igTqt6oHRpwNkzoJZplYXCmjuQymMDg80EY2NXycuu7D
# 1fkKdvp+BRtAypI16dV60bV/AK6pkKrFfwGcELEW/MxuGNxvYv6mUKe4e7idFT/+
# IAx1yCJaE5UZkADpGtXChvHjjuxf9OUCAwEAAaOCARIwggEOMB8GA1UdIwQYMBaA
# FKARCiM+lvEH7OKvKe+CpX/QMKS0MB0GA1UdDgQWBBQy65Ka/zWWSC8oQEJwIDaR
# XBeF5jAOBgNVHQ8BAf8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zATBgNVHSUEDDAK
# BggrBgEFBQcDAzAbBgNVHSAEFDASMAYGBFUdIAAwCAYGZ4EMAQQBMEMGA1UdHwQ8
# MDowOKA2oDSGMmh0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0FBQUNlcnRpZmljYXRl
# U2VydmljZXMuY3JsMDQGCCsGAQUFBwEBBCgwJjAkBggrBgEFBQcwAYYYaHR0cDov
# L29jc3AuY29tb2RvY2EuY29tMA0GCSqGSIb3DQEBDAUAA4IBAQASv6Hvi3SamES4
# aUa1qyQKDKSKZ7g6gb9Fin1SB6iNH04hhTmja14tIIa/ELiueTtTzbT72ES+Btlc
# Y2fUQBaHRIZyKtYyFfUSg8L54V0RQGf2QidyxSPiAjgaTCDi2wH3zUZPJqJ8ZsBR
# NraJAlTH/Fj7bADu/pimLpWhDFMpH2/YGaZPnvesCepdgsaLr4CnvYFIUoQx2jLs
# FeSmTD1sOXPUC4U5IOCFGmjhp0g4qdE2JXfBjRkWxYhMZn0vY86Y6GnfrDyoXZ3J
# HFuu2PMvdM+4fvbXg50RlmKarkUT2n/cR/vfw1Kf5gZV6Z2M8jpiUbzsJA8p1FiA
# hORFe1rYMIIGGjCCBAKgAwIBAgIQYh1tDFIBnjuQeRUgiSEcCjANBgkqhkiG9w0B
# AQwFADBWMQswCQYDVQQGEwJHQjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMS0w
# KwYDVQQDEyRTZWN0aWdvIFB1YmxpYyBDb2RlIFNpZ25pbmcgUm9vdCBSNDYwHhcN
# MjEwMzIyMDAwMDAwWhcNMzYwMzIxMjM1OTU5WjBUMQswCQYDVQQGEwJHQjEYMBYG
# A1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1YmxpYyBD
# b2RlIFNpZ25pbmcgQ0EgUjM2MIIBojANBgkqhkiG9w0BAQEFAAOCAY8AMIIBigKC
# AYEAmyudU/o1P45gBkNqwM/1f/bIU1MYyM7TbH78WAeVF3llMwsRHgBGRmxDeEDI
# ArCS2VCoVk4Y/8j6stIkmYV5Gej4NgNjVQ4BYoDjGMwdjioXan1hlaGFt4Wk9vT0
# k2oWJMJjL9G//N523hAm4jF4UjrW2pvv9+hdPX8tbbAfI3v0VdJiJPFy/7XwiunD
# 7mBxNtecM6ytIdUlh08T2z7mJEXZD9OWcJkZk5wDuf2q52PN43jc4T9OkoXZ0arW
# ZVeffvMr/iiIROSCzKoDmWABDRzV/UiQ5vqsaeFaqQdzFf4ed8peNWh1OaZXnYvZ
# QgWx/SXiJDRSAolRzZEZquE6cbcH747FHncs/Kzcn0Ccv2jrOW+LPmnOyB+tAfiW
# u01TPhCr9VrkxsHC5qFNxaThTG5j4/Kc+ODD2dX/fmBECELcvzUHf9shoFvrn35X
# Gf2RPaNTO2uSZ6n9otv7jElspkfK9qEATHZcodp+R4q2OIypxR//YEb3fkDn3Uay
# WW9bAgMBAAGjggFkMIIBYDAfBgNVHSMEGDAWgBQy65Ka/zWWSC8oQEJwIDaRXBeF
# 5jAdBgNVHQ4EFgQUDyrLIIcouOxvSK4rVKYpqhekzQwwDgYDVR0PAQH/BAQDAgGG
# MBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAwwCgYIKwYBBQUHAwMwGwYDVR0g
# BBQwEjAGBgRVHSAAMAgGBmeBDAEEATBLBgNVHR8ERDBCMECgPqA8hjpodHRwOi8v
# Y3JsLnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ1Jvb3RSNDYu
# Y3JsMHsGCCsGAQUFBwEBBG8wbTBGBggrBgEFBQcwAoY6aHR0cDovL2NydC5zZWN0
# aWdvLmNvbS9TZWN0aWdvUHVibGljQ29kZVNpZ25pbmdSb290UjQ2LnA3YzAjBggr
# BgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wDQYJKoZIhvcNAQEMBQAD
# ggIBAAb/guF3YzZue6EVIJsT/wT+mHVEYcNWlXHRkT+FoetAQLHI1uBy/YXKZDk8
# +Y1LoNqHrp22AKMGxQtgCivnDHFyAQ9GXTmlk7MjcgQbDCx6mn7yIawsppWkvfPk
# KaAQsiqaT9DnMWBHVNIabGqgQSGTrQWo43MOfsPynhbz2Hyxf5XWKZpRvr3dMapa
# ndPfYgoZ8iDL2OR3sYztgJrbG6VZ9DoTXFm1g0Rf97Aaen1l4c+w3DC+IkwFkvjF
# V3jS49ZSc4lShKK6BrPTJYs4NG1DGzmpToTnwoqZ8fAmi2XlZnuchC4NPSZaPATH
# vNIzt+z1PHo35D/f7j2pO1S8BCysQDHCbM5Mnomnq5aYcKCsdbh0czchOm8bkinL
# rYrKpii+Tk7pwL7TjRKLXkomm5D1Umds++pip8wH2cQpf93at3VDcOK4N7EwoIJB
# 0kak6pSzEu4I64U6gZs7tS/dGNSljf2OSSnRr7KWzq03zl8l75jy+hOds9TWSenL
# bjBQUGR96cFr6lEUfAIEHVC1L68Y1GGxx4/eRI82ut83axHMViw1+sVpbPxg51Tb
# nio1lB93079WPFnYaOvfGAA0e0zcfF/M9gXr+korwQTh2Prqooq2bYNMvUoUKD85
# gnJ+t0smrWrb8dee2CvYZXD5laGtaAxOfy/VKNmwuWuAh9kcMIIGuzCCBSOgAwIB
# AgIQQc8qdZtdXpTYE6t70Fj3tzANBgkqhkiG9w0BAQwFADBUMQswCQYDVQQGEwJH
# QjEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMSswKQYDVQQDEyJTZWN0aWdvIFB1
# YmxpYyBDb2RlIFNpZ25pbmcgQ0EgUjM2MB4XDTIxMDkxNDAwMDAwMFoXDTIyMDkx
# NDIzNTk1OVowgaIxCzAJBgNVBAYTAkNOMRIwEAYDVQQIDAnlub/kuJznnIExMDAu
# BgNVBAoMJ+W5v+W3nuW4guS9s+WPi+e7iOerr+enkeaKgOaciemZkOWFrOWPuDEb
# MBkGA1UECwwSV2ViIEFkbWluaXN0cmF0aW9uMTAwLgYDVQQDDCflub/lt57luILk
# vbPlj4vnu4jnq6/np5HmioDmnInpmZDlhazlj7gwggIiMA0GCSqGSIb3DQEBAQUA
# A4ICDwAwggIKAoICAQDVVX3vldU+sV1TqxQBclNFsKE1NRxoAAXEQq+hhfXehLwS
# D5TMi5vD2baEAGpUPGUWu+9+T1oN5/JFR1X9hXyXfIx7dXccpxA+YWoqvDfBMBcz
# lUAkhez+uwA0TLuPbGxDGAmqSpEYaWx61m0t3MuHnOleFhqubfmkbRS8AiDOW6+W
# V0F4lKU57aP7bfeg2Ngg94ebV7DMYCWLoEOulm89wyGGo3TwVoAUkxnZ6bln9X6Y
# 8ej7e+xw6Rfupl87DI6A5TUP/S5OdGG6Cu0GZ6HHePrEUpZ8DTi62GvtLn1m8JGC
# fyRlEuvZyJprGygdZjdokQkmHrt+sYgftLzdzNQ6xc5DYyVB3TZGT0n5DyKQX8eg
# 6esgQg5fw4Z0ZiIzGjAjHxHx3Lz5xrAH6cf4oxXvj60NUfu7TE31MkA9PUOVBKp3
# lu3S34lsWrfXdk6nLE1ySTe3HnkCZEPsbvVFpE3IXTSJgJzqFSwrIS0uTko5uXys
# z8TNZsRI8xI5oyS+0FwYOuoyAWK+9OXlkYY/YN5C4HvbFl5xn+wKpBEjMXR8lBg6
# r+VogsZ4nj2CvBYgBKEtxKI+AItNllLJ8ljQXq6YiT8eFDB59lx7H9Jf/Ii/e996
# p8PI1Qv8QnYTsMyroQxAgzfOVEseWSREV8sFEec6fbZ57YJLxEgJm89voFwrPQID
# AQABo4IBuDCCAbQwHwYDVR0jBBgwFoAUDyrLIIcouOxvSK4rVKYpqhekzQwwHQYD
# VR0OBBYEFE56/Vpdq2Hl38qZpYnLIPDHreUNMA4GA1UdDwEB/wQEAwIHgDAMBgNV
# HRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMDMBEGCWCGSAGG+EIBAQQEAwIE
# EDBKBgNVHSAEQzBBMDUGDCsGAQQBsjEBAgEDAjAlMCMGCCsGAQUFBwIBFhdodHRw
# czovL3NlY3RpZ28uY29tL0NQUzAIBgZngQwBBAEwSQYDVR0fBEIwQDA+oDygOoY4
# aHR0cDovL2NybC5zZWN0aWdvLmNvbS9TZWN0aWdvUHVibGljQ29kZVNpZ25pbmdD
# QVIzNi5jcmwweQYIKwYBBQUHAQEEbTBrMEQGCCsGAQUFBzAChjhodHRwOi8vY3J0
# LnNlY3RpZ28uY29tL1NlY3RpZ29QdWJsaWNDb2RlU2lnbmluZ0NBUjM2LmNydDAj
# BggrBgEFBQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wGgYDVR0RBBMwEYEP
# YW5keS5odUBpdDJ1LmNuMA0GCSqGSIb3DQEBDAUAA4IBgQBjIgKqnvA2Fxr/vJUS
# zMtYX6JhnBI6/nQb8lnxH/zV1oN8Ls66ITXHn96L1gSmhhKA3hrYR7FoYa2KTq9F
# q1Q7o5xS6YLPFQxIMNiTSYK0ZytbuCpdU79wnJ7sVyowqsgeDXdpko30gNMqPuBd
# MLbRWv09xUz03ldvs8XGfSWUa08d2sKrjLaXuEEJD1OgvMJjCziB7tDv3BNROlgq
# UnwW62G6ZSAMJRRIo29W6mULexZtvNT1zBY8FiItyNARZLFISVxSzzqvCpT7cK4u
# kdhZke3jYPlI8q2f0x82/ybwMI+MeJLEhj5Xj9Fd1R8rKTyVikLc3rcpgpSYQaSa
# 0SxwfqrUYsNDPyZharGagnltfospH/X9zdoRizL61hs/k26urcOUNTrY04M8y4i4
# +5m7xYhBwypcZBtGa/JQIc5Fs9SdK/kdJGLKv+J7+ZujVr9tJJpkzU2QHc+CPbVu
# +ouvfkcRS4QW0MDvx5aikUuTfs146jyZhMo4ewPO2E7uVbYxggUFMIIFAQIBATBo
# MFQxCzAJBgNVBAYTAkdCMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxKzApBgNV
# BAMTIlNlY3RpZ28gUHVibGljIENvZGUgU2lnbmluZyBDQSBSMzYCEEHPKnWbXV6U
# 2BOre9BY97cwCQYFKw4DAhoFAKBAMBkGCSqGSIb3DQEJAzEMBgorBgEEAYI3AgEE
# MCMGCSqGSIb3DQEJBDEWBBRAPkKDLthQNY/4Nvttkke3ueD/DjANBgkqhkiG9w0B
# AQEFAASCAgBJSpB95PjZV1fguPC7s+WAMIIYaIdsO2t/q6plnbCVNMfDoEEbVKgi
# HnokCCt9/Y56gSlSVS1gCN3gMNeDlfA37WcjxgNXvk8BIKAvA7m2E7susz4gmy3D
# lQ0V4htY9RJFtfwUzJGwXMeRR2m+MHC2qsvEC2MFEVHXiUhh93glLmverwtFZgoa
# 8FxPko6pWtTzP6lz/vmqG5JGN/yycaN9Xwzm1oTOlG0tziatyPDQ9ZJUuK2dOxP7
# cdPri/YxBnEd1Uw5le908HpDVsmdnj7XA4e0uind6NTRWebU9dqtZMCjjzeODkZk
# ZxJewVSy8Y/z58dAd2TXFHTvwM2ZtJH+6obg+kXQEIZfR2E/IHi2+Qmeg/6BX19m
# KJrwSU22i0J74LVztPpsY5uh6cusWNkmnJeaCq4/rPnJ1HuylnlNTfsu+EmkLZrC
# wOO/eoY6C9B0Ir5fulYWxh163tVGTb20sCMjCVGDp0y8Cp5+SwAT2+cT5MrqAr9e
# BTkJeZmtaEs1Hmo9FQG0a21P7ISN900dLltm2izQc4S/zwkFx8Wv+OJOYiiY4Njg
# vdVJVtCmc4bsxieg74LhHKoPZ0Jx0+q8RQySUPoRJ/FmGsP35s/j3JESJJNB9hr/
# 9/fW9FQfiLE2+PkC1g058krO27dryvNAGNZUeXeT04JjkXvsAKJ9G6GCAjAwggIs
# BgkqhkiG9w0BCQYxggIdMIICGQIBATCBhjByMQswCQYDVQQGEwJVUzEVMBMGA1UE
# ChMMRGlnaUNlcnQgSW5jMRkwFwYDVQQLExB3d3cuZGlnaWNlcnQuY29tMTEwLwYD
# VQQDEyhEaWdpQ2VydCBTSEEyIEFzc3VyZWQgSUQgVGltZXN0YW1waW5nIENBAhAN
# QkrgvjqI/2BAIc4UAPDdMA0GCWCGSAFlAwQCAQUAoGkwGAYJKoZIhvcNAQkDMQsG
# CSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMjEwOTIyMDcyMzA5WjAvBgkqhkiG
# 9w0BCQQxIgQgDHm+u1qXeslm257iWC23VasirzUBjQamkqzYEMIFHsIwDQYJKoZI
# hvcNAQEBBQAEggEAOWcy3MS0ffin1AnNcfK6zLrefilmt9kP0gm9dRM3/dXNK7Di
# WAj5ZP7rsaxUPLf/t7KIAVctdfC3tMKC/fd6og8ECP+riT9YhWtvlpbO3+z0E4xM
# Ycs+YM/R1gZBfaQ9kWCCddnMhynC9sVKNRtv94OIk5ngvAToLJDNFXxrl6Uwo0EH
# Zb2hsyjTigbrOSvLNy9pomBjl6rgOEXw+VNUtffD3jqBsozpDMPa7EBfHYiCnlxS
# CvI0F3X3JEXYktkPT04AG0KFF2bIItVoZU/1acMUgrwuR7dPQDhkDcjHf3vMrFG2
# mWp+DoQmiJT0T1VN4K6FWwP53TUV4JasfccpFg==
# SIG # End signature block
