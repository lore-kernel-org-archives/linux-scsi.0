From: Sebastian Wasilewski <sebastian@wasilewski.name>
Subject: mptbase Code={Abort}
Date: Sun, 13 Apr 2008 02:36:35 +0100
Message-ID: <480163A3.1030302@wasilewski.name>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms090408000204040502000801"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hel.fizyka.umk.pl ([158.75.5.90]:59061 "EHLO hel.fizyka.umk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753873AbYDMBrp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Apr 2008 21:47:45 -0400
Received: from [172.20.1.117] (vampire.vpn.phys.uni.torun.pl [172.20.1.117])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by hel.fizyka.umk.pl (Postfix) with ESMTP id 3A16D30A7C3
	for <linux-scsi@vger.kernel.org>; Sun, 13 Apr 2008 03:38:53 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090408000204040502000801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello Everyone,

I have a problem with a new custom build server. The machine has three 
LSI SAS1068 PCI-X SAS cards and 10 Seagate ST31000340NS disk connected 
to them. On the top of it I have configured a software RAID6 with stripe 
size 128kB.

The problem is that during a heavy load (for example RAID rebuilding) 
messages following messages are registered by a syslog.

mptbase: ioc0: LogInfo(0x31123000): Originator={PL}, Code={Abort}, 
SubCode(0x3000)

After each RAID rebuild I have around 100 of them. The RAID itself works 
fine.

Does anyone have any ideas what might be wrong, and what does this 
messages means? I have updated a card's firmware to the newest one, but 
still no changes.

Thanx. Technical details below.
Sebastian

Details of the machine:

System: Fedora 8 x86_64
Kernel: 2.6.21.7-2.fc8xen-local (recompiled with the newest LSI MPT 
Fusion driver (4.00.21.00))
HW: 2x Intel Xeon E5320, 16GB RAM

lspci output:
----------------
0:00.0 Host bridge: Intel Corporation 5000V Chipset Memory Controller 
Hub (rev b1)
00:02.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x8 
Port 2-3 (rev b1)
00:03.0 PCI bridge: Intel Corporation 5000 Series Chipset PCI Express x4 
Port 3 (rev b1)
00:08.0 System peripheral: Intel Corporation 5000 Series Chipset DMA 
Engine (rev b1)
00:10.0 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:10.1 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:10.2 Host bridge: Intel Corporation 5000 Series Chipset FSB Registers 
(rev b1)
00:11.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:13.0 Host bridge: Intel Corporation 5000 Series Chipset Reserved 
Registers (rev b1)
00:15.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:16.0 Host bridge: Intel Corporation 5000 Series Chipset FBD Registers 
(rev b1)
00:1c.0 PCI bridge: Intel Corporation 631xESB/632xESB/3100 Chipset PCI 
Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #3 (rev 09)
00:1d.3 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
UHCI USB Controller #4 (rev 09)
00:1d.7 USB Controller: Intel Corporation 631xESB/632xESB/3100 Chipset 
EHCI USB2 Controller (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation 631xESB/632xESB/3100 Chipset LPC 
Interface Controller (rev 09)
00:1f.3 SMBus: Intel Corporation 631xESB/632xESB/3100 Chipset SMBus 
Controller (rev 09)
01:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Upstream Port (rev 01)
01:00.3 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express to 
PCI-X Bridge (rev 01)
02:00.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E1 (rev 01)
02:02.0 PCI bridge: Intel Corporation 6311ESB/6321ESB PCI Express 
Downstream Port E3 (rev 01)
04:00.0 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
04:00.1 Ethernet controller: Intel Corporation 80003ES2LAN Gigabit 
Ethernet Controller (Copper) (rev 01)
05:01.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X 
Fusion-MPT SAS (rev 01)
05:02.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X 
Fusion-MPT SAS (rev 01)
05:03.0 SCSI storage controller: LSI Logic / Symbios Logic SAS1068 PCI-X 
Fusion-MPT SAS (rev 01)
07:00.0 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet 
Controller (rev 06)
07:00.1 Ethernet controller: Intel Corporation 82571EB Gigabit Ethernet 
Controller (rev 06)
08:01.0 PCI bridge: Intel Corporation 21154 PCI-to-PCI Bridge
08:02.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
09:04.0 Ethernet controller: Intel Corporation 82557/8/9 Ethernet Pro 
100 (rev 0d)
09:05.0 Ethernet controller: Intel Corporation 82557/8/9 Ethernet Pro 
100 (rev 0d)



--------------ms090408000204040502000801
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIPSzCC
BGQwggNMoAMCAQICAhtMMA0GCSqGSIb3DQEBBAUAMIGDMQswCQYDVQQGEwJQTDExMC8GA1UE
ChMoVW5pd2Vyc3l0ZXQgTWlrb2xhamEgS29wZXJuaWthIHcgVG9ydW5pdTEhMB8GA1UEAxMY
Q2VudHJ1bSBDZXJ0eWZpa2FjamkgVU1LMR4wHAYJKoZIhvcNAQkBFg9jYUB1bmkudG9ydW4u
cGwwHhcNMDYwNTA1MjAxOTU2WhcNMTEwNTA0MjAxOTU2WjCB0DELMAkGA1UEBhMCUEwxMTAv
BgNVBAoTKFVuaXdlcnN5dGV0IE1pa29sYWphIEtvcGVybmlrYSB3IFRvcnVuaXUxPDA6BgNV
BAsTM1d5ZHppYWwgRml6eWtpLCBBc3Ryb25vbWlpIGkgSW5mb3JtYXR5a2kgU3Rvc293YW5l
ajEdMBsGA1UEAxMUU2ViYXN0aWFuIFdhc2lsZXdza2kxMTAvBgkqhkiG9w0BCQEWIlNlYmFz
dGlhbi5XYXNpbGV3c2tpQGZpenlrYS51bWsucGwwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJ
AoGBAMrwrPasXgbvrz65NTM4NPohCfBVAUG4JCpcPQi9JIMIjtsX6DfitQReQJfhlVNLvKTj
8ClfncrAbam76l8H5THkQGv8XomTBJfW4WPTwSNlJaURllTaiyafGaf44mIJhzc/8axHbttz
XpRgKSo6yDF8eveFo0uQpXZ3JVCcVHDfAgMBAAGjggEVMIIBETARBglghkgBhvhCAQEEBAMC
BaAwCwYDVR0PBAQDAgWgMB0GA1UdDgQWBBRh4gBvapXgSvzjJc88cQ7E0vXfSzCBsAYDVR0j
BIGoMIGlgBSAZUHaCDgyd1NzAuti4PrVLpspMKGBiaSBhjCBgzELMAkGA1UEBhMCUEwxMTAv
BgNVBAoTKFVuaXdlcnN5dGV0IE1pa29sYWphIEtvcGVybmlrYSB3IFRvcnVuaXUxITAfBgNV
BAMTGENlbnRydW0gQ2VydHlmaWthY2ppIFVNSzEeMBwGCSqGSIb3DQEJARYPY2FAdW5pLnRv
cnVuLnBsggEAMB0GA1UdJQQWMBQGA1UdDgYDVR0jBggrBgEFBQcDAzANBgkqhkiG9w0BAQQF
AAOCAQEAaxBZz0uEpenGvNLEr5d3sTE4XsQmvzAsUOYAY45SHZRzacCUzmTgHeCW0k27rMx4
ensJqZ5GuIV06zfNsJue+XQY8HORxBCiSsQGQYeIiyyttgQcy9b10u4dPlU0x7xO/gfGbzD6
j+BSKXxc7c0YAX2wduIyq1e1JS4rBPlUQLx3wziKLVi/5MoLXwzHsKV+jczj1p0kRpj3snPt
Q0sQxLW2iYQrGFTEG/x5LkgkYM++dIsx7/F3CIHKmeFss0hD2YY80jIYmW1qJ7zSLwX9MfO8
rxafbgNrpfmdyvJzO4VWuJQxp8tpVDTZnIQTqkv3U8ulLSk0TAFqEv1A/AhpRjCCBIowggNy
oAMCAQICECf06hH0eobEbp27bqkXBwcwDQYJKoZIhvcNAQEFBQAwbzELMAkGA1UEBhMCU0Ux
FDASBgNVBAoTC0FkZFRydXN0IEFCMSYwJAYDVQQLEx1BZGRUcnVzdCBFeHRlcm5hbCBUVFAg
TmV0d29yazEiMCAGA1UEAxMZQWRkVHJ1c3QgRXh0ZXJuYWwgQ0EgUm9vdDAeFw0wNTA2MDcw
ODA5MTBaFw0yMDA1MzAxMDQ4MzhaMIGuMQswCQYDVQQGEwJVUzELMAkGA1UECBMCVVQxFzAV
BgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUgVVNFUlRSVVNUIE5ldHdvcmsx
ITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2MDQGA1UEAxMtVVROLVVTRVJG
aXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWlsMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAsjmFpPJ9q0E7YkY3rs3BYHW8OWX5ShpHornMSMxqmNVNNRm5pELl
zkniii8efNIxB8dOtINknS4p1aJkxIW9hVE1eaROaJB7HHqkkqgX8pgV8pPMyaQylbsMTzC9
mKALi+VuG6JG+ni8om+rWV6lL8/K2m2qL+usobNqqrcuZzWLeeEeaYji5kbNoKXqvgvOdjp6
Dpvq/NonWz1zHyLmSGHGTPNpsaguG7bUMSAsvIKKjqQOpdeJQ/wWWq8dcdcRWdq6hw2v+vPh
wvCkxWeM1tZUOt4KpLoDd7NlyP0e03RiqhjKaJMeoYV+9Udly/hNVyh00jT/MLbu9mIwFIws
6wIDAQABo4HhMIHeMB8GA1UdIwQYMBaAFK29mHo0tCb3+sQmVO8DveAky1QaMB0GA1UdDgQW
BBSJgmd9xJ0mcABLtFBIfN49rgRufTAOBgNVHQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB
/zB7BgNVHR8EdDByMDigNqA0hjJodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9BZGRUcnVzdEV4
dGVybmFsQ0FSb290LmNybDA2oDSgMoYwaHR0cDovL2NybC5jb21vZG8ubmV0L0FkZFRydXN0
RXh0ZXJuYWxDQVJvb3QuY3JsMA0GCSqGSIb3DQEBBQUAA4IBAQAZ2IkRbyispgCi54fBm5AD
236hEv0e8+LwAamUVEJrmgnEoG3XkJIEA2Z5Q3H8+G+v23ZF4jcaPd3kWQR4rBz0g0bzes9b
hHIt5UbBuhgRKfPLSXmHPLptBZ2kbWhPrXIUNqi5sf2/z3/wpGqUNVCPz4FtVbHdWTBK322g
nGQfSXzvNrv042n0+DmPWq1LhTq3Du3Tzw1EovsEv+QvcI4l+1pUBrPQxLxtjftzMizpm4Qk
LdZ/kXpoAlAfDj9N6cz1u2fo3BwuO/xOzf4CjuOoEwqlJkRl6RDyTVKnrtw+ymsyXEFs/vVd
oOr/0fqbhlhtPZZH5f4ulQTCAMyOofK7MIIGUTCCBTmgAwIBAgIRAIuGSd9lm5YjiBVwEZuS
ZaowDQYJKoZIhvcNAQEFBQAwga4xCzAJBgNVBAYTAlVTMQswCQYDVQQIEwJVVDEXMBUGA1UE
BxMOU2FsdCBMYWtlIENpdHkxHjAcBgNVBAoTFVRoZSBVU0VSVFJVU1QgTmV0d29yazEhMB8G
A1UECxMYaHR0cDovL3d3dy51c2VydHJ1c3QuY29tMTYwNAYDVQQDEy1VVE4tVVNFUkZpcnN0
LUNsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgRW1haWwwHhcNMDcwODI3MDAwMDAwWhcNMDgw
ODI2MjM1OTU5WjCB6TE1MDMGA1UECxMsQ29tb2RvIFRydXN0IE5ldHdvcmsgLSBQRVJTT05B
IE5PVCBWQUxJREFURUQxRjBEBgNVBAsTPVRlcm1zIGFuZCBDb25kaXRpb25zIG9mIHVzZTog
aHR0cDovL3d3dy5jb21vZG8ubmV0L3JlcG9zaXRvcnkxHzAdBgNVBAsTFihjKTIwMDMgQ29t
b2RvIExpbWl0ZWQxHTAbBgNVBAMTFFNlYmFzdGlhbiBXYXNpbGV3c2tpMSgwJgYJKoZIhvcN
AQkBFhlzZWJhc3RpYW5Ad2FzaWxld3NraS5uYW1lMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAtNlOUL8oeETIvEOcAwq5lBDq+7TqdtxT4ri+kA/VqN71NuaIbvQKb6zEziE9
fSuAcdYpo2uLgOx+9K6EJUAjPEzBw25ZKCa05lrdS9K8Xale0fJ6ZVH9JiM80WeBf2UjeDFh
2WK2EWRl6t+QNxOpYAfFcg58k0w2Lljk0l447q1tacVSpNrA0CtTh9Zve5ho26Gdrh5TPIL1
RiVWSAHSpA6JLMfgIBxWbZcPthQ7kdFVu414dOchcCjKY9o2tbG0sMYeAzeLaTgccEW7B/o6
gGSS+BH/v8Kv3QmXtlPFwZh7SFfL/CZlPpYAzoQ4WaVQjMOwTRQLR38YgeXXqvximQIDAQAB
o4ICKzCCAicwHwYDVR0jBBgwFoAUiYJnfcSdJnAAS7RQSHzePa4Ebn0wHQYDVR0OBBYEFDOg
M7vsGeGAj200arcExeUQkoKnMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMCAGA1Ud
JQQZMBcGCCsGAQUFBwMEBgsrBgEEAbIxAQMFAjARBglghkgBhvhCAQEEBAMCBSAwRgYDVR0g
BD8wPTA7BgwrBgEEAbIxAQIBAQEwKzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29t
b2RvLm5ldC9DUFMwgaUGA1UdHwSBnTCBmjBMoEqgSIZGaHR0cDovL2NybC5jb21vZG9jYS5j
b20vVVROLVVTRVJGaXJzdC1DbGllbnRBdXRoZW50aWNhdGlvbmFuZEVtYWlsLmNybDBKoEig
RoZEaHR0cDovL2NybC5jb21vZG8ubmV0L1VUTi1VU0VSRmlyc3QtQ2xpZW50QXV0aGVudGlj
YXRpb25hbmRFbWFpbC5jcmwwfAYIKwYBBQUHAQEEcDBuMDYGCCsGAQUFBzAChipodHRwOi8v
Y3J0LmNvbW9kb2NhLmNvbS9VVE5BQUFDbGllbnRDQS5jcnQwNAYIKwYBBQUHMAKGKGh0dHA6
Ly9jcnQuY29tb2RvLm5ldC9VVE5BQUFDbGllbnRDQS5jcnQwJAYDVR0RBB0wG4EZc2ViYXN0
aWFuQHdhc2lsZXdza2kubmFtZTANBgkqhkiG9w0BAQUFAAOCAQEAMkro/eoHrznPnh3YmoyJ
8V91GC7SMJ9R2ezqAfDVdjp3qCBqoPlHjcy3tgn0Hc2LyCoLMRUb2OHhRP7umnQVdELtwehS
jnFohZrAY+WKSq4bcU8oe/jXHOTA1PzgkTeGUjTjA2ChwhUwLZxvinIYVXuI7EqgPVaKTAy4
2XxDKDB44ussql6pYViEZT7xtZfFxOni2uPQS0Ex9keHxdnTK6kDkpj+gPyxNHgkaKbnhN7/
PUeX407VMN0+iUKEt+mEbQMjPu2taZkfxrB9+BZYTYo/eSonsa0X1VdxlV2p+CHaVQHVbyRb
enwKWYaRtC4o+0T2lhgc0uWlwJgqF2XGWTGCA98wggPbAgEBMIHEMIGuMQswCQYDVQQGEwJV
UzELMAkGA1UECBMCVVQxFzAVBgNVBAcTDlNhbHQgTGFrZSBDaXR5MR4wHAYDVQQKExVUaGUg
VVNFUlRSVVNUIE5ldHdvcmsxITAfBgNVBAsTGGh0dHA6Ly93d3cudXNlcnRydXN0LmNvbTE2
MDQGA1UEAxMtVVROLVVTRVJGaXJzdC1DbGllbnQgQXV0aGVudGljYXRpb24gYW5kIEVtYWls
AhEAi4ZJ32WbliOIFXARm5JlqjAJBgUrDgMCGgUAoIIB7zAYBgkqhkiG9w0BCQMxCwYJKoZI
hvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wODA0MTMwMTM2MzVaMCMGCSqGSIb3DQEJBDEWBBQt
/ExLNL2K5p+MaRchcgxzDRvtPDBSBgkqhkiG9w0BCQ8xRTBDMAoGCCqGSIb3DQMHMA4GCCqG
SIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBmwYJ
KwYBBAGCNxAEMYGNMIGKMIGDMQswCQYDVQQGEwJQTDExMC8GA1UEChMoVW5pd2Vyc3l0ZXQg
TWlrb2xhamEgS29wZXJuaWthIHcgVG9ydW5pdTEhMB8GA1UEAxMYQ2VudHJ1bSBDZXJ0eWZp
a2FjamkgVU1LMR4wHAYJKoZIhvcNAQkBFg9jYUB1bmkudG9ydW4ucGwCAhtMMIGdBgsqhkiG
9w0BCRACCzGBjaCBijCBgzELMAkGA1UEBhMCUEwxMTAvBgNVBAoTKFVuaXdlcnN5dGV0IE1p
a29sYWphIEtvcGVybmlrYSB3IFRvcnVuaXUxITAfBgNVBAMTGENlbnRydW0gQ2VydHlmaWth
Y2ppIFVNSzEeMBwGCSqGSIb3DQEJARYPY2FAdW5pLnRvcnVuLnBsAgIbTDANBgkqhkiG9w0B
AQEFAASCAQAjdrGDD1KvOoWHuXe5lNyiOCoZ60bAQcqji6NvhV2RPmy1zoh0BNiMIRu+RCNM
o1TSpNfLvhwEJwqbj11DDVx8fa4HKSZmypfUWuOK8Xj+uKXb4TkWEOdYfeNW9JtcgaahuwAN
GZWpWUARek1b5pj/nyy9AKT9+klJd3Iyen4BL6dOLs0QdgdUdCAjFXv7SGhujpok2BkfKP3o
gosXMtPh6AbEaAYzy1LYas3sQQlvduzp7r7EZ/5wkpIWRH96essvifl6LQKds1zQs3OWwqFw
zj6Ji5JtZQwe9Anxttt5TrWZ5GlUdEDkxoEgIOzp2JyXW4MfZNFqtbiqCISaZ+btAAAAAAAA

--------------ms090408000204040502000801--
