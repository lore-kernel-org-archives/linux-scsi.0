From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 3/8]  fusion - mtctl -  change to wait_event_timeout
Date: Thu, 2 Feb 2006 17:19:37 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F243697@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62857.84397943"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:5528 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751197AbWBCATi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 19:19:38 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k130EJNI021727
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:14:19 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k130Jb4c026622
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:19:37 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62857.84397943
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Change from using wait_event_interruptible_timeout to
wait_event_timeout.  Also delete white space and duplicate
line of code.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C62857.84397943
Content-Type: application/octet-stream;
	name="3-interruptible.patch"
Content-Transfer-Encoding: base64
Content-Description: 3-interruptible.patch
Content-Disposition: attachment;
	filename="3-interruptible.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3RsLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdGN0bC5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3Rs
LmMJMjAwNi0wMi0wMiAxNDo1OTowMy4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRjdGwuYwkyMDA2LTAyLTAyIDE1OjQ0OjQ0LjAwMDAwMDAwMCAtMDcwMApA
QCAtMzg1LDE4ICszODUsMTggQEAKIAl9CiAKIAkvKiBOb3cgd2FpdCBmb3IgdGhlIGNvbW1hbmQg
dG8gY29tcGxldGUgKi8KLQlpaSA9IHdhaXRfZXZlbnRfaW50ZXJydXB0aWJsZV90aW1lb3V0KG1w
dGN0bF93YWl0LAorCWlpID0gd2FpdF9ldmVudF90aW1lb3V0KG1wdGN0bF93YWl0LAogCSAgICAg
aW9jdGwtPndhaXRfZG9uZSA9PSAxLAogCSAgICAgSFoqNSAvKiA1IHNlY29uZCB0aW1lb3V0ICov
KTsKIAogCWlmKGlpIDw9MCAmJiAoaW9jdGwtPndhaXRfZG9uZSAhPSAxICkpICB7CisJCW1wdF9m
cmVlX21zZ19mcmFtZShoZC0+aW9jLCBtZik7CiAJCWlvY3RsLT53YWl0X2RvbmUgPSAwOwogCQly
ZXR2YWwgPSAtMTsgLyogcmV0dXJuIGZhaWx1cmUgKi8KIAl9CiAKIG1wdGN0bF9idXNfcmVzZXRf
ZG9uZToKIAotCW1wdF9mcmVlX21zZ19mcmFtZShoZC0+aW9jLCBtZik7CiAJbXB0Y3RsX2ZyZWVf
dG1fZmxhZ3MoaW9jdGwtPmlvYyk7CiAJcmV0dXJuIHJldHZhbDsKIH0KQEAgLTgwNyw3ICs4MDcs
NyBAQAogCW1wdF9wdXRfbXNnX2ZyYW1lKG1wdGN0bF9pZCwgaW9jcCwgbWYpOwogCiAJLyogTm93
IHdhaXQgZm9yIHRoZSBjb21tYW5kIHRvIGNvbXBsZXRlICovCi0JcmV0ID0gd2FpdF9ldmVudF9p
bnRlcnJ1cHRpYmxlX3RpbWVvdXQobXB0Y3RsX3dhaXQsCisJcmV0ID0gd2FpdF9ldmVudF90aW1l
b3V0KG1wdGN0bF93YWl0LAogCSAgICAgaW9jcC0+aW9jdGwtPndhaXRfZG9uZSA9PSAxLAogCSAg
ICAgSFoqNjApOwogCkBAIC0xMTcyLDEyICsxMTcyLDExIEBACiAJCWthcmctPnBjaUluZm8udS5i
aXRzLmRldmljZU51bWJlciA9IFBDSV9TTE9UKCBwZGV2LT5kZXZmbiApOwogCQlrYXJnLT5wY2lJ
bmZvLnUuYml0cy5mdW5jdGlvbk51bWJlciA9IFBDSV9GVU5DKCBwZGV2LT5kZXZmbiApOwogCX0g
ZWxzZSBpZiAoY2ltX3JldiA9PSAyKSB7Ci0JCS8qIEdldCB0aGUgUENJIGJ1cywgZGV2aWNlLCBm
dW5jdGlvbiBhbmQgc2VnbWVudCBJRCBudW1iZXJzIAorCQkvKiBHZXQgdGhlIFBDSSBidXMsIGRl
dmljZSwgZnVuY3Rpb24gYW5kIHNlZ21lbnQgSUQgbnVtYmVycwogCQkgICBmb3IgdGhlIElPQyAq
LwogCQlrYXJnLT5wY2lJbmZvLnUuYml0cy5idXNOdW1iZXIgPSBwZGV2LT5idXMtPm51bWJlcjsK
IAkJa2FyZy0+cGNpSW5mby51LmJpdHMuZGV2aWNlTnVtYmVyID0gUENJX1NMT1QoIHBkZXYtPmRl
dmZuICk7CiAJCWthcmctPnBjaUluZm8udS5iaXRzLmZ1bmN0aW9uTnVtYmVyID0gUENJX0ZVTkMo
IHBkZXYtPmRldmZuICk7Ci0JCWthcmctPnBjaUluZm8udS5iaXRzLmZ1bmN0aW9uTnVtYmVyID0g
UENJX0ZVTkMoIHBkZXYtPmRldmZuICk7CiAJCWthcmctPnBjaUluZm8uc2VnbWVudElEID0gcGNp
X2RvbWFpbl9ucihwZGV2LT5idXMpOwogCX0KIApAQCAtMjE1Myw3ICsyMTUyLDcgQEAKIAogCS8q
IE5vdyB3YWl0IGZvciB0aGUgY29tbWFuZCB0byBjb21wbGV0ZSAqLwogCXRpbWVvdXQgPSAoa2Fy
Zy50aW1lb3V0ID4gMCkgPyBrYXJnLnRpbWVvdXQgOiBNUFRfSU9DVExfREVGQVVMVF9USU1FT1VU
OwotCXRpbWVvdXQgPSB3YWl0X2V2ZW50X2ludGVycnVwdGlibGVfdGltZW91dChtcHRjdGxfd2Fp
dCwKKwl0aW1lb3V0ID0gd2FpdF9ldmVudF90aW1lb3V0KG1wdGN0bF93YWl0LAogCSAgICAgaW9j
LT5pb2N0bC0+d2FpdF9kb25lID09IDEsCiAJICAgICBIWip0aW1lb3V0KTsKIAo=

------_=_NextPart_001_01C62857.84397943--
