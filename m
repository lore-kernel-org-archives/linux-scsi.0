From: =?ISO-8859-1?Q?Roger_H=E5kansson?= <hson@ludd.luth.se>
Subject: Re: sym53c8xx driver hangs
Date: Fri, 18 Feb 2005 18:05:22 +0100
Message-ID: <42162052.9030304@ludd.luth.se>
References: <4214BD90.7030002@ludd.luth.se> <20050218051916.GX29917@parcelfarce.linux.theplanet.co.uk> <4215BDFF.6040703@ludd.luth.se> <20050218121556.GY29917@parcelfarce.linux.theplanet.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms040205020809020009060507"
Received: from mother.ludd.ltu.se ([130.240.16.3]:26846 "EHLO
	mother.ludd.ltu.se") by vger.kernel.org with ESMTP id S261407AbVBRRFZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2005 12:05:25 -0500
In-Reply-To: <20050218121556.GY29917@parcelfarce.linux.theplanet.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms040205020809020009060507
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Matthew Wilcox wrote:
> Oh.  I think I'm confused as to which version of sym2 is in which version
> of Linus' tree.  The same line in my development tree reads:
> 
>         if ((goal->options & PPR_OPT_MASK) || (goal->period < 0xa)) {
> 
> Does it still work if you use that?  The problem with Frage Schnell's
> patch is that it won't try to negotiate U160 speeds; it'll be capped
> at U80.
> 

Well, I guess that part of the driver is rewritten a bit, I get a 
compile error if I put that in ;)
But yes, it works if I put in:

if ((tp->tinfo.goal.options & PPR_OPT_MASK) ||
     (tp->tinfo.goal.period < 0xa)) {

--------------ms040205020809020009060507
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
MIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC50
aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYDVR0PBAQDAgEGMCkG
A1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODANBgkqhkiG9w0BAQUF
AAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82L8D0HFAgk3A8/a3h
YWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr394fWxghOrvbqNOUQ
Gls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCArowggK2AgEBMGkwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMMmzAwCQYFKw4DAhoFAKCCAacwGAYJ
KoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDUwMjE4MTcwNTIyWjAj
BgkqhkiG9w0BCQQxFgQUjYZJr46GnUJDkz7eMUoYUAUbHKMwUgYJKoZIhvcNAQkPMUUwQzAK
BggqhkiG9w0DBzAOBggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYI
KoZIhvcNAwICASgweAYJKwYBBAGCNxAEMWswaTBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECAwybMDB6BgsqhkiG9w0BCRACCzFroGkwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAgMMmzAwDQYJKoZIhvcNAQEB
BQAEgYAwrkZzrsn8GswmwqElW+aluvYCH3WVLtzLSW3ctK36Xt4Sq+Jb+cd/Hg6kiVyUmApJ
OsmAdkd6j05V++R02z/MEaH3MfP9vIQKVKKdO0Cg0MilnWtbONuTmmB04n9VFWXAX9bsSowb
Y5ZmY4ZBoYW2iPgCoXtYqPcWxK5KpAwLhAAAAAAAAA==
--------------ms040205020809020009060507--
