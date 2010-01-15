From: Oleg Gawriloff <barzog@telecom.by>
Subject: Re: [Bug 14877] MSI/MSI-X support in 2.6.31.xx and 2.6.32.xx seems
 broken
Date: Fri, 15 Jan 2010 09:23:50 +0200
Message-ID: <4B501806.4070804@telecom.by>
References: <bug-14877-11613@http.bugzilla.kernel.org/>	<201001142227.o0EMRIVt019573@demeter.kernel.org> <20100114150159.caffb336.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms020508090101050307040400"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.telecom.by ([213.184.225.35]:57933 "EHLO mail.telecom.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932094Ab0AOHzZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Jan 2010 02:55:25 -0500
In-Reply-To: <20100114150159.caffb336.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-scsi@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org, James Smart <James.Smart@Emulex.Com>

This is a cryptographically signed message in MIME format.

--------------ms020508090101050307040400
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

15.01.2010 1:01, Andrew Morton =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> Oleg, please send that lpfc patch via emailed reply-to-all to this emai=
l.
> Include a brief description for the changelog and a Signed-off-by: as
> per Documentation/SubmittingPatches, thanks.
Signed-off-by version available at
http://marc.info/?l=3Dlinux-scsi&m=3D126342842601776&w=3D2

From: George Kadianakis <desnacked {bomb} gmail {point} com>

A Gentoo bug report [1] showed that as of 2.6.31 lpfc only uses INTx=20
interrupts.
This patch restores lpfc's ability to support MSI-X/MSI interrupts that t=
he
"Addition of SLI4 Interface - Base Support" patch [2] broke.
It reestablishes MSI-X as the default interrupt method and in case MSI-X =

is not
supported lpfc_sli{4,}_enable_intr fallbacks to MSI and then to INTx.

[1]: http://bugs.gentoo.org/show_bug.cgi?id=3D296319
[2]: commit da0436e915a5c17ee79e72c1bf978a4ebb1cbf4d

Signed-off-by:  George Kadianakis <desnacked {cat} gmail {dog} com>
---
  drivers/scsi/lpfc/lpfc_attr.c |    6 +++---
  1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.=
c
index e1a30a1..936ecaf 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2890,12 +2890,12 @@ LPFC_ATTR_RW(poll_tmo, 10, 1, 255,
  /*
  # lpfc_use_msi: Use MSI (Message Signaled Interrupts) in systems that
  # 				 support this feature
-#       0  =3D MSI disabled (default)
+#       0  =3D MSI disabled
  #       1  =3D MSI enabled
-#       2  =3D MSI-X enabled
+#       2  =3D MSI-X enabled (default)
  # Value range is [0,2]. Default value is 0.
  */
-LPFC_ATTR_R(use_msi, 0, 0, 2, "Use Message Signaled Interrupts (1) or "
+LPFC_ATTR_R(use_msi, 2, 0, 2, "Use Message Signaled Interrupts (1) or "
  					      "MSI-X (2), if possible");

  /*

--=20
Signed, Oleg Gawriloff.


--------------ms020508090101050307040400
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIHtDCC
A9YwggM/oAMCAQICAgMUMA0GCSqGSIb3DQEBBAUAMIGYMQswCQYDVQQGEwJCWTEQMA4GA1UE
CBMHQmVsYXJ1czEOMAwGA1UEBxMFTWluc2sxFzAVBgNVBAoTDkF0bGFudC1UZWxlY29tMRcw
FQYDVQQLEw5BdGxhbnQtVGVsZWNvbTETMBEGA1UEAxMKdGVsZWNvbS5ieTEgMB4GCSqGSIb3
DQEJARYRYmFyem9nQHRlbGVjb20uYnkwHhcNMDkwNzMwMTMyMzA4WhcNMTAwNzMwMTMyMzA4
WjCBnzELMAkGA1UEBhMCQlkxEDAOBgNVBAgTB0JlbGFydXMxDjAMBgNVBAcTBU1pbnNrMRcw
FQYDVQQKEw5BdGxhbnQtVGVsZWNvbTEXMBUGA1UECxMOQXRsYW50LVRlbGVjb20xGjAYBgNV
BAMUEWJhcnpvZ0B0ZWxlY29tLmJ5MSAwHgYJKoZIhvcNAQkBFhFiYXJ6b2dAdGVsZWNvbS5i
eTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxBQ8gZWDyi0qZTZf2V5PJLz966hXwCFh
mXxTUG4HCUpbiL8tm4qRiCMQOTqbpX58sUW1dVsvUzr9j3y37jGXfZ9XCe2fd5e83GdJePHa
EajAaLBw5HkpMFRrDpUUJa3mO0oOv4J73+D970JcRdqLEMHAQmdBv09pb5v8FlPMbLkCAwEA
AaOCASQwggEgMAkGA1UdEwQCMAAwLAYJYIZIAYb4QgENBB8WHU9wZW5TU0wgR2VuZXJhdGVk
IENlcnRpZmljYXRlMB0GA1UdDgQWBBQyrMjDyMXZPhjhHVBu+qpOE7i+yTCBxQYDVR0jBIG9
MIG6gBQ1Q0N4+R+9Wg0AAlfWqtErWCUf9aGBnqSBmzCBmDELMAkGA1UEBhMCQlkxEDAOBgNV
BAgTB0JlbGFydXMxDjAMBgNVBAcTBU1pbnNrMRcwFQYDVQQKEw5BdGxhbnQtVGVsZWNvbTEX
MBUGA1UECxMOQXRsYW50LVRlbGVjb20xEzARBgNVBAMTCnRlbGVjb20uYnkxIDAeBgkqhkiG
9w0BCQEWEWJhcnpvZ0B0ZWxlY29tLmJ5ggEAMA0GCSqGSIb3DQEBBAUAA4GBAHoSxW6/T0BC
4ZwTxIdZskRKaHXJwlAXWFHQHUJ7C5akA59fknBZVKGbhwyII2zrrMyxkgJdim6sN0If4ZD2
FoLRYkBtcMS9CWt9Edrdnlrbi8XYy9Pn7iRQV4mF3W+IVdRAAdk07F7ASr8iXzxKXu87iyxq
PnAnCHz8O3nQ5RVcMIID1jCCAz+gAwIBAgICAxQwDQYJKoZIhvcNAQEEBQAwgZgxCzAJBgNV
BAYTAkJZMRAwDgYDVQQIEwdCZWxhcnVzMQ4wDAYDVQQHEwVNaW5zazEXMBUGA1UEChMOQXRs
YW50LVRlbGVjb20xFzAVBgNVBAsTDkF0bGFudC1UZWxlY29tMRMwEQYDVQQDEwp0ZWxlY29t
LmJ5MSAwHgYJKoZIhvcNAQkBFhFiYXJ6b2dAdGVsZWNvbS5ieTAeFw0wOTA3MzAxMzIzMDha
Fw0xMDA3MzAxMzIzMDhaMIGfMQswCQYDVQQGEwJCWTEQMA4GA1UECBMHQmVsYXJ1czEOMAwG
A1UEBxMFTWluc2sxFzAVBgNVBAoTDkF0bGFudC1UZWxlY29tMRcwFQYDVQQLEw5BdGxhbnQt
VGVsZWNvbTEaMBgGA1UEAxQRYmFyem9nQHRlbGVjb20uYnkxIDAeBgkqhkiG9w0BCQEWEWJh
cnpvZ0B0ZWxlY29tLmJ5MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEFDyBlYPKLSpl
Nl/ZXk8kvP3rqFfAIWGZfFNQbgcJSluIvy2bipGIIxA5OpulfnyxRbV1Wy9TOv2PfLfuMZd9
n1cJ7Z93l7zcZ0l48doRqMBosHDkeSkwVGsOlRQlreY7Sg6/gnvf4P3vQlxF2osQwcBCZ0G/
T2lvm/wWU8xsuQIDAQABo4IBJDCCASAwCQYDVR0TBAIwADAsBglghkgBhvhCAQ0EHxYdT3Bl
blNTTCBHZW5lcmF0ZWQgQ2VydGlmaWNhdGUwHQYDVR0OBBYEFDKsyMPIxdk+GOEdUG76qk4T
uL7JMIHFBgNVHSMEgb0wgbqAFDVDQ3j5H71aDQACV9aq0StYJR/1oYGepIGbMIGYMQswCQYD
VQQGEwJCWTEQMA4GA1UECBMHQmVsYXJ1czEOMAwGA1UEBxMFTWluc2sxFzAVBgNVBAoTDkF0
bGFudC1UZWxlY29tMRcwFQYDVQQLEw5BdGxhbnQtVGVsZWNvbTETMBEGA1UEAxMKdGVsZWNv
bS5ieTEgMB4GCSqGSIb3DQEJARYRYmFyem9nQHRlbGVjb20uYnmCAQAwDQYJKoZIhvcNAQEE
BQADgYEAehLFbr9PQELhnBPEh1myREpodcnCUBdYUdAdQnsLlqQDn1+ScFlUoZuHDIgjbOus
zLGSAl2Kbqw3Qh/hkPYWgtFiQG1wxL0Ja30R2t2eWtuLxdjL0+fuJFBXiYXdb4hV1EAB2TTs
XsBKvyJfPEpe7zuLLGo+cCcIfPw7edDlFVwxggNwMIIDbAIBATCBnzCBmDELMAkGA1UEBhMC
QlkxEDAOBgNVBAgTB0JlbGFydXMxDjAMBgNVBAcTBU1pbnNrMRcwFQYDVQQKEw5BdGxhbnQt
VGVsZWNvbTEXMBUGA1UECxMOQXRsYW50LVRlbGVjb20xEzARBgNVBAMTCnRlbGVjb20uYnkx
IDAeBgkqhkiG9w0BCQEWEWJhcnpvZ0B0ZWxlY29tLmJ5AgIDFDAJBgUrDgMCGgUAoIICJjAY
BgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0xMDAxMTUwNzIzNTFa
MCMGCSqGSIb3DQEJBDEWBBQWBTa2aAomT4ZRSW5PtIB1mDpzDTBfBgkqhkiG9w0BCQ8xUjBQ
MAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwIC
AUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgwgbAGCSsGAQQBgjcQBDGBojCBnzCBmDELMAkG
A1UEBhMCQlkxEDAOBgNVBAgTB0JlbGFydXMxDjAMBgNVBAcTBU1pbnNrMRcwFQYDVQQKEw5B
dGxhbnQtVGVsZWNvbTEXMBUGA1UECxMOQXRsYW50LVRlbGVjb20xEzARBgNVBAMTCnRlbGVj
b20uYnkxIDAeBgkqhkiG9w0BCQEWEWJhcnpvZ0B0ZWxlY29tLmJ5AgIDFDCBsgYLKoZIhvcN
AQkQAgsxgaKggZ8wgZgxCzAJBgNVBAYTAkJZMRAwDgYDVQQIEwdCZWxhcnVzMQ4wDAYDVQQH
EwVNaW5zazEXMBUGA1UEChMOQXRsYW50LVRlbGVjb20xFzAVBgNVBAsTDkF0bGFudC1UZWxl
Y29tMRMwEQYDVQQDEwp0ZWxlY29tLmJ5MSAwHgYJKoZIhvcNAQkBFhFiYXJ6b2dAdGVsZWNv
bS5ieQICAxQwDQYJKoZIhvcNAQEBBQAEgYB3jg4+EsrLeSWhpBbBTu/VfB4CfGpmqutGhs0j
TzBALR8kbrmIuPB+xWqjXskkw/hc26vTxvy9hZCFJvZac8usZnwNNnDEZh2nZ6C6/+s12I/u
+4HQOAftBr5VpEPafvnBScBTIflgdTor6Wyf3Aje3Y98QN28rgerDJCwsY20LQAAAAAAAA==
--------------ms020508090101050307040400--
