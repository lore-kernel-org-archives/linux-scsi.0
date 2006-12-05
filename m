From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] Add ASC-29320LPE ids to aic79xx driver
Date: Tue, 5 Dec 2006 14:37:30 -0500
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01202892@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C718A4.CEB43F6F"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:55916 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968663AbWLEThd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Dec 2006 14:37:33 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@SteelEye.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C718A4.CEB43F6F
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Simple patch to add the new PCIe version of the 29320 card.

Signed-off: Mark Salyzyn <Mark_Salyzyn@adaptec.com>

------_=_NextPart_001_01C718A4.CEB43F6F
Content-Type: application/octet-stream;
	name="ASC-29320LPE.patch"
Content-Transfer-Encoding: base64
Content-Description: ASC-29320LPE.patch
Content-Disposition: attachment;
	filename="ASC-29320LPE.patch"

LS0tIGEvZHJpdmVycy9zY3NpL2FpYzd4eHgvYWljNzl4eF9vc21fcGNpLmMJMjAwNi0xMi0wNSAw
NzoyNTo1OS42NTI4MTUwMDYgLTA1MDAKKysrIGIvZHJpdmVycy9zY3NpL2FpYzd4eHgvYWljNzl4
eF9vc21fcGNpLmMJMjAwNi0xMi0wNSAwNzoyODoyNS4yODg2NTg0MTAgLTA1MDAKQEAgLTYyLDYg
KzYyLDcgQEAKIAkvKiBhaWM3OTAxIGJhc2VkIGNvbnRyb2xsZXJzICovCiAJSUQoSURfQUhBXzI5
MzIwQSksCiAJSUQoSURfQUhBXzI5MzIwQUxQKSwKKwlJRChJRF9BSEFfMjkzMjBMUEUpLAogCS8q
IGFpYzc5MDIgYmFzZWQgY29udHJvbGxlcnMgKi8KIAlJRChJRF9BSEFfMjkzMjApLAogCUlEKElE
X0FIQV8yOTMyMEIpLAotLS0gYS9kcml2ZXJzL3Njc2kvYWljN3h4eC9haWM3OXh4X3BjaS5jCTIw
MDYtMTItMDUgMDc6MjY6MTUuNTQxODM0NDk5IC0wNTAwCisrKyBiL2RyaXZlcnMvc2NzaS9haWM3
eHh4L2FpYzc5eHhfcGNpLmMJMjAwNi0xMi0wNSAwNzozNToyNi40NjkxMDUzMDIgLTA1MDAKQEAg
LTEwOSw3ICsxMDksMTMgQEAKIAl7CiAJCUlEX0FIQV8yOTMyMEFMUCwKIAkJSURfQUxMX01BU0ss
Ci0JCSJBZGFwdGVjIDI5MzIwQUxQIFVsdHJhMzIwIFNDU0kgYWRhcHRlciIsCisJCSJBZGFwdGVj
IDI5MzIwQUxQIFBDSXggVWx0cmEzMjAgU0NTSSBhZGFwdGVyIiwKKwkJYWhkX2FpYzc5MDFfc2V0
dXAKKwl9LAorCXsKKwkJSURfQUhBXzI5MzIwTFBFLAorCQlJRF9BTExfTUFTSywKKwkJIkFkYXB0
ZWMgMjkzMjBMUEUgUENJZSBVbHRyYTMyMCBTQ1NJIGFkYXB0ZXIiLAogCQlhaGRfYWljNzkwMV9z
ZXR1cAogCX0sCiAJLyogYWljNzkwMUEgYmFzZWQgY29udHJvbGxlcnMgKi8KLS0tIGEvZHJpdmVy
cy9zY3NpL2FpYzd4eHgvYWljNzl4eF9wY2kuaAkyMDA2LTEyLTA1IDA3OjI0OjM2LjI2MzIwNzU3
NiAtMDUwMAorKysgYi9kcml2ZXJzL3Njc2kvYWljN3h4eC9haWM3OXh4X3BjaS5oCTIwMDYtMTIt
MDUgMDc6MjU6MjIuODI1NDA1MDIwIC0wNTAwCkBAIC01MSw2ICs1MSw3IEBACiAjZGVmaW5lIElE
X0FJQzc5MDEJCQkweDgwMEY5MDA1RkZGRjkwMDV1bGwKICNkZWZpbmUgSURfQUhBXzI5MzIwQQkJ
CTB4ODAwMDkwMDUwMDYwOTAwNXVsbAogI2RlZmluZSBJRF9BSEFfMjkzMjBBTFAJCQkweDgwMTc5
MDA1MDA0NDkwMDV1bGwKKyNkZWZpbmUgSURfQUhBXzI5MzIwTFBFCQkJMHg4MDE3OTAwNTAwNDU5
MDA1dWxsCiAKICNkZWZpbmUgSURfQUlDNzkwMUEJCQkweDgwMUU5MDA1RkZGRjkwMDV1bGwKICNk
ZWZpbmUgSURfQUhBXzI5MzIwTFAJCQkweDgwMTQ5MDA1MDA0NDkwMDV1bGwK

------_=_NextPart_001_01C718A4.CEB43F6F--
