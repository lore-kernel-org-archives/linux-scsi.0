From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
Date: Mon, 17 Jul 2006 15:17:54 -0500
Message-ID: <B8857D46D8618E48B51E0199BB9C26F3016C81DA@cceexcsp04.americas.cpqcorp.net>
References: <664A4EBB07F29743873A87CF62C26D7022583D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	micalg=SHA1;
	protocol="application/x-pkcs7-signature";
	boundary="----=_NextPart_000_0090_01C6A9B4.2D362B50"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas03.cce.hp.com ([161.114.21.106]:23223 "EHLO
	ccerelbas03.cce.hp.com") by vger.kernel.org with ESMTP
	id S1751168AbWGQUSU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Jul 2006 16:18:20 -0400
Content-class: urn:content-classes:message
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7022583D@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>
Cc: dougg@torque.net, linux-scsi@vger.kernel.org, "Johnson, Steve" <Steve.Johnson@lsil.com>, "Rivera, Peter" <Peter.Rivera@lsil.com>, "Besmer, Brad" <Brad.Besmer@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>

This is a multi-part message in MIME format.

------=_NextPart_000_0090_01C6A9B4.2D362B50
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

If one place is more palatable than another, we can favor that location.

My first inclination would be next to the Retry Data Frames bit, which is in
the basic frame header outside of the information unit portion.



--
Rob Elliott, elliott@hp.com
Hewlett-Packard Industry Standard Server Storage Advanced Technology
https://ecardfile.com/id/RobElliott


 

> -----Original Message-----
> From: Moore, Eric [mailto:Eric.Moore@lsil.com] 
> Sent: Monday, July 17, 2006 1:39 PM
> To: James Bottomley; Patterson, Andrew D (Linux R&D)
> Cc: dougg@torque.net; linux-scsi@vger.kernel.org; Elliott, 
> Robert (Server Storage); Johnson, Steve; Rivera, Peter; 
> Besmer, Brad; Shirron, Stephen
> Subject: RE: [PATCH 1/10] mptfusion : Transport Layer Retry support
> 
> On Friday, July 14, 2006 5:25 PM, James Bottomley wrote: 
> > I have no idea about the fusion ... the frame control is 
> > embedded deeply
> > in the firmware, so I think it would probably require a firmware
> > upgrade.  Eric can comment on this better than I.
> > 
> 
> Yes, frame creation is in the firmware, not driver.  
> Currently the linux driver knows TLR is implmented in firmware by
> looking
> at IOCFacts->IOCCapabilities (bit 11).
> 
> From sas2r04a.pdf, section 9.2.1 ssp_frame_format, there is
> RETRY_DATA_FRAME (byte 10, bit 2) - write data frames retried 
> (xfer_rdy)
> RETRANSMIT (byte 10, bit 1) - control frame retried (task, response,
> xfer_rdy)
> 
> Rob Elliot wrote: "the initiator could set a similar bit in 
> COMMAND and TASK frames to let the target know that it is 
> safe to retry frames for the whole command."
> 
> Which bit is in consideration for being set? In the ssp frame 
> header or
> IU?
> 
> 

------=_NextPart_000_0090_01C6A9B4.2D362B50
Content-Type: application/x-pkcs7-signature;
	name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="smime.p7s"

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIN9TCCAwMw
ggJsAhEAuS9gzIifoXpGCbhbcGyKrzANBgkqhkiG9w0BAQUFADCBwTELMAkGA1UEBhMCVVMxFzAV
BgNVBAoTDlZlcmlTaWduLCBJbmMuMTwwOgYDVQQLEzNDbGFzcyAyIFB1YmxpYyBQcmltYXJ5IENl
cnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzIxOjA4BgNVBAsTMShjKSAxOTk4IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5l
dHdvcmswHhcNOTgwNTE4MDAwMDAwWhcNMjgwODAxMjM1OTU5WjCBwTELMAkGA1UEBhMCVVMxFzAV
BgNVBAoTDlZlcmlTaWduLCBJbmMuMTwwOgYDVQQLEzNDbGFzcyAyIFB1YmxpYyBQcmltYXJ5IENl
cnRpZmljYXRpb24gQXV0aG9yaXR5IC0gRzIxOjA4BgNVBAsTMShjKSAxOTk4IFZlcmlTaWduLCBJ
bmMuIC0gRm9yIGF1dGhvcml6ZWQgdXNlIG9ubHkxHzAdBgNVBAsTFlZlcmlTaWduIFRydXN0IE5l
dHdvcmswgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAKeIASF0LOcaA/CY4Zc8DyEI8Zzbl+ma
/MIEBhO+X1LIzB4sElYsuAFpLMyZH62wlq55BPITOcF7mLoILOjChBMsqmnpCfTHqQKkQsIjT0rY
8A6i+zFsyeZvmScH9eb0THiebetGhvq5hslU8rLEr9RGHFrJFTD/DWz1LQ5tzn93AgMBAAEwDQYJ
KoZIhvcNAQEFBQADgYEAci75f9HxcfvEnvbFXlGKQJi4aPibHIPY4p29/+2h5mbqLwn0ytfqpSuV
9iRghk1ELoOlxC2g0654aW9y2myuCPBjkjfmu8QwF613zEk1qs/Yj9G+txiWR3NqVCI0ZC22FptZ
W7RRWTqzCxT0Et9noPStMmResUZyJ4wSe8VEtK4wggQlMIIDjqADAgECAhBWO27ntnEulADNe55i
te6UMA0GCSqGSIb3DQEBBQUAMIHBMQswCQYDVQQGEwJVUzEXMBUGA1UEChMOVmVyaVNpZ24sIElu
Yy4xPDA6BgNVBAsTM0NsYXNzIDIgUHVibGljIFByaW1hcnkgQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkgLSBHMjE6MDgGA1UECxMxKGMpIDE5OTggVmVyaVNpZ24sIEluYy4gLSBGb3IgYXV0aG9yaXpl
ZCB1c2Ugb25seTEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazAeFw0wMTA0MjQwMDAw
MDBaFw0wOTA0MjMyMzU5NTlaMIHiMSAwHgYDVQQKExdIZXdsZXR0LVBhY2thcmQgQ29tcGFueTEf
MB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0d29yazE7MDkGA1UECxMyVGVybXMgb2YgdXNlIGF0
IGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9ycGEgKGMpMDExMDAuBgNVBAsTJ0NsYXNzIDIgT25T
aXRlIEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTEuMCwGA1UEAxMlQ29sbGFib3JhdGlvbiBDZXJ0
aWZpY2F0aW9uIEF1dGhvcml0eTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAwHBTCwUTa0hb
aHog6TMn4eE7398EjzwgM69HP+K7kNyVfFWph26qBIDYAZLebCYtGIb7k9yTmPRVIWAdYDgw28tQ
+Q8belgqEWmwzmv9ISTlEgFvOFLKc+cgI9/FKCiRN2QW12uHsugJhKBwNJ21zB7MDoEdBjGY1MyY
5T1+5TsCAwEAAaOB+jCB9zAPBgNVHRMECDAGAQH/AgEAMEQGA1UdIAQ9MDswOQYLYIZIAYb4RQEH
AQEwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly93d3cudmVyaXNpZ24uY29tL3JwYTALBgNVHQ8EBAMC
AQYwEQYJYIZIAYb4QgEBBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFi
ZWwxLTM4MjA0BgNVHR8ELTArMCmgJ6AlhiNodHRwOi8vY3JsLnZlcmlzaWduLmNvbS9wY2EyLWcy
LmNybDAdBgNVHQ4EFgQU7+0gzUNFH4NHYBWWQ3JK5MbM5z0wDQYJKoZIhvcNAQEFBQADgYEAQZJR
XIBAaNmQVGuF68nKEMhda/Wl56rvk9AuHYkKV0sP/9ktuyn7KMuHKiFj4uAKwCZLiq36wjYqiK3j
gk9MZ5TPkAuf1TyWJ1MqnoFn6+7WcQk/leJwbVDTtKV7T0bfTP8fGF57cV8qJ6SSWifpDseYdKh+
CnjP1kI3jkLTJ28wggbBMIIGKqADAgECAhAKdHan+h3w0DJ5y2g6sZ4+MA0GCSqGSIb3DQEBBQUA
MIHiMSAwHgYDVQQKExdIZXdsZXR0LVBhY2thcmQgQ29tcGFueTEfMB0GA1UECxMWVmVyaVNpZ24g
VHJ1c3QgTmV0d29yazE7MDkGA1UECxMyVGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlz
aWduLmNvbS9ycGEgKGMpMDExMDAuBgNVBAsTJ0NsYXNzIDIgT25TaXRlIEluZGl2aWR1YWwgU3Vi
c2NyaWJlciBDQTEuMCwGA1UEAxMlQ29sbGFib3JhdGlvbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0
eTAeFw0wNTA2MTkwMDAwMDBaFw0wNzA2MTkyMzU5NTlaMIGTMSAwHgYDVQQKFBdIZXdsZXR0LVBh
Y2thcmQgQ29tcGFueTEmMCQGA1UECxQdRW1wbG95bWVudCBTdGF0dXMgLSBFbXBsb3llZXMxDzAN
BgNVBAsUBlMvTUlNRTEXMBUGA1UEAxMOUm9iZXJ0IEVsbGlvdHQxHTAbBgkqhkiG9w0BCQEWDmVs
bGlvdHRAaHAuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/MZfCi58Dp+1cot3dstzT
F6CfjU4trSwBW89oZZ4j1zB1kHMbZz/fVOandm3r2kg4n2GsVEAyAWWGLXwCIGHoRzx5yQ/Mdo99
yLnoXKPRRNe+ish2MTHHbuBdNWHZ2gAliEenkEacaMlKsTvzJ1lxCPL1XyM9SAhsU2g3ug2KBQID
AQABo4IDwzCCA78wKQYDVR0RBCIwIIEOZWxsaW90dEBocC5jb22BDkVsbGlvdHRAaHAuY29tMAwG
A1UdEwEB/wQCMAAwDgYDVR0PAQH/BAQDAgWgMB8GA1UdIwQYMBaAFO/tIM1DRR+DR2AVlkNySuTG
zOc9MB0GA1UdDgQWBBSH3KjM077e0B3Y+Ur0isKkVCX1rzBXBgNVHR8EUDBOMEygSqBIhkZodHRw
Oi8vb25zaXRlY3JsLnZlcmlzaWduLmNvbS9IZXdsZXR0UGFja2FyZENvbXBhbnlTTUlNRS9MYXRl
c3RDUkwuY3JsMBYGA1UdJQEB/wQMMAoGCCsGAQUFBwMEMIIBPQYDVR0gBIIBNDCCATAwggEsBgtg
hkgBhvhFAQcXAjCCARswKAYIKwYBBQUHAgEWHGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9DUFMw
ge4GCCsGAQUFBwICMIHhMB4WF0hld2xldHQtUGFja2FyZCBDb21wYW55MAMCAQIagb5BdXRob3Jp
dHkgdG8gYmluZCBIUCBkb2VzIG5vdCBjb3JyZXNwb25kIHdpdGggdXNlIG9yIHBvc3Nlc3Npb24g
b2YgdGhpcyBjZXJ0aWZpY2F0ZS4gSXNzdWVkIHRvIGZhY2lsaXRhdGUgY29tbXVuaWNhdGlvbiB3
aXRoIEhQLiBWZXJpU2lnbidzIENQUyBpbmNvcnAuIEJ5IHJlZmVyZW5jZSBsaWFiLiBsdGQuIChj
KTk3IFZlcmlTaWduMIIBMwYIKwYBBQUHAQEEggElMIIBITArBggrBgEFBQcwAYYfaHR0cDovL29u
c2l0ZS1vY3NwLnZlcmlzaWduLmNvbTCB8QYIKwYBBQUHMAKkgeQwgeExLjAsBgNVBAMTJUNvbGxh
Ym9yYXRpb24gQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkxMDAuBgNVBAsTJ0NsYXNzIDIgT25TaXRl
IEluZGl2aWR1YWwgU3Vic2NyaWJlciBDQTE6MDgGA1UECxMxVGVybXMgb2YgdXNlIGF0IGh0dHBz
Oi8vd3d3LnZlcmlzaWduLmNvbS9ycGEoYykwMTEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0
d29yazEgMB4GA1UEChMXSGV3bGV0dC1QYWNrYXJkIENvbXBhbnkwSwYJKoZIhvcNAQkPBD4wPDAO
BggqhkiG9w0DAgICAIAwDgYIKoZIhvcNAwICAgBAMA4GCCqGSIb3DQMEAgIAgDAKBggqhkiG9w0D
BzANBgkqhkiG9w0BAQUFAAOBgQBLOiJhtw+czXKryTgRylHQ2rKaKxWhiRYdN2fk4zuu1ez9QHIF
8jSnaYG/3TeyjeRCHzH1AanRRVijHPkq/BUtvEEet40rrjckg1DzCQUldlTNjNNmqF7iCXEzxsry
T9on3gWRBf3HkiEFCuzYsGDfOlPG6J0wdaaZT+CJOaB+/zGCBIIwggR+AgEBMIH3MIHiMSAwHgYD
VQQKExdIZXdsZXR0LVBhY2thcmQgQ29tcGFueTEfMB0GA1UECxMWVmVyaVNpZ24gVHJ1c3QgTmV0
d29yazE7MDkGA1UECxMyVGVybXMgb2YgdXNlIGF0IGh0dHBzOi8vd3d3LnZlcmlzaWduLmNvbS9y
cGEgKGMpMDExMDAuBgNVBAsTJ0NsYXNzIDIgT25TaXRlIEluZGl2aWR1YWwgU3Vic2NyaWJlciBD
QTEuMCwGA1UEAxMlQ29sbGFib3JhdGlvbiBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eQIQCnR2p/od
8NAyectoOrGePjAJBgUrDgMCGgUAoIIC4DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqG
SIb3DQEJBTEPFw0wNjA3MTcyMDE3NTRaMCMGCSqGSIb3DQEJBDEWBBRp67YZJvdLhksbgauuOe9c
AfyRUDBnBgkqhkiG9w0BCQ8xWjBYMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG
9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDAHBgUrDgMCGjAKBggqhkiG9w0CBTCCAQgG
CSsGAQQBgjcQBDGB+jCB9zCB4jEgMB4GA1UEChMXSGV3bGV0dC1QYWNrYXJkIENvbXBhbnkxHzAd
BgNVBAsTFlZlcmlTaWduIFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1zIG9mIHVzZSBhdCBo
dHRwczovL3d3dy52ZXJpc2lnbi5jb20vcnBhIChjKTAxMTAwLgYDVQQLEydDbGFzcyAyIE9uU2l0
ZSBJbmRpdmlkdWFsIFN1YnNjcmliZXIgQ0ExLjAsBgNVBAMTJUNvbGxhYm9yYXRpb24gQ2VydGlm
aWNhdGlvbiBBdXRob3JpdHkCEAp0dqf6HfDQMnnLaDqxnj4wggEKBgsqhkiG9w0BCRACCzGB+qCB
9zCB4jEgMB4GA1UEChMXSGV3bGV0dC1QYWNrYXJkIENvbXBhbnkxHzAdBgNVBAsTFlZlcmlTaWdu
IFRydXN0IE5ldHdvcmsxOzA5BgNVBAsTMlRlcm1zIG9mIHVzZSBhdCBodHRwczovL3d3dy52ZXJp
c2lnbi5jb20vcnBhIChjKTAxMTAwLgYDVQQLEydDbGFzcyAyIE9uU2l0ZSBJbmRpdmlkdWFsIFN1
YnNjcmliZXIgQ0ExLjAsBgNVBAMTJUNvbGxhYm9yYXRpb24gQ2VydGlmaWNhdGlvbiBBdXRob3Jp
dHkCEAp0dqf6HfDQMnnLaDqxnj4wDQYJKoZIhvcNAQEBBQAEgYCr1myvpxE6VyTXSHx1kzI/Y+1w
reJW5lWP5082O+O49ckdm2qbo4wb0T5n+IbP94v6/a0hOrODy33KMha0YyMosPy6CrOkeJ6gTbd+
QTGWSGXbkFnU6hBw4LHB5dX8Q0u2jxcfLE8CICZlz2XD9lVrNHv0ATgtyTLKHhSzO0lXmgAAAAAA
AA==

------=_NextPart_000_0090_01C6A9B4.2D362B50--
