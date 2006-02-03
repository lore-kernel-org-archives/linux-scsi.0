From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 1/8]  fusion - mptctl - MPTCOMMAND - adding function types.
Date: Thu, 2 Feb 2006 17:19:30 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F243695@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62857.8092E283"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3736 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751195AbWBCATc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 19:19:32 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k130EDNI021721
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:14:13 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k130JVFw026596
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:19:31 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62857.8092E283
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

This adds support for new function types in
the existing MPTCOMMAND ioctl.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C62857.8092E283
Content-Type: application/octet-stream;
	name="1-mpt_command.patch"
Content-Transfer-Encoding: base64
Content-Description: 1-mpt_command.patch
Content-Disposition: attachment;
	filename="1-mpt_command.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3RsLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdGN0bC5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3Rs
LmMJMjAwNi0wMi0wMSAxMjo1Mjo1OC4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRjdGwuYwkyMDA2LTAyLTAyIDE0OjM1OjQ1LjAwMDAwMDAwMCAtMDcwMApA
QCAtMTgxNyw2ICsxODE3LDggQEAKIAljYXNlIE1QSV9GVU5DVElPTl9TQ1NJX0VOQ0xPU1VSRV9Q
Uk9DRVNTT1I6CiAJY2FzZSBNUElfRlVOQ1RJT05fRldfRE9XTkxPQUQ6CiAJY2FzZSBNUElfRlVO
Q1RJT05fRkNfUFJJTUlUSVZFX1NFTkQ6CisJY2FzZSBNUElfRlVOQ1RJT05fVE9PTEJPWDoKKwlj
YXNlIE1QSV9GVU5DVElPTl9TQVNfSU9fVU5JVF9DT05UUk9MOgogCQlicmVhazsKIAogCWNhc2Ug
TVBJX0ZVTkNUSU9OX1NDU0lfSU9fUkVRVUVTVDoKQEAgLTE4ODgsNiArMTg5MCwyNSBAQAogCQl9
CiAJCWJyZWFrOwogCisJY2FzZSBNUElfRlVOQ1RJT05fU01QX1BBU1NUSFJPVUdIOgorCQkvKiBD
aGVjayBtZi0+UGFzc3RocnVGbGFncyB0byBkZXRlcm1pbmUgaWYKKwkJICogdHJhbnNmZXIgaXMg
SW1tZWRpYXRlTW9kZSBvciBub3QuCisJCSAqIEltbWVkaWF0ZSBtb2RlIHJldHVybnMgZGF0YSBp
biB0aGUgUmVwbHlGcmFtZS4KKwkJICogRWxzZSwgd2UgYXJlIHNlbmRpbmcgcmVxdWVzdCBhbmQg
cmVzcG9uc2UgZGF0YQorCQkgKiBpbiB0d28gU0dMcyBhdCB0aGUgZW5kIG9mIHRoZSBtZi4KKwkJ
ICovCisJCWJyZWFrOworCisJY2FzZSBNUElfRlVOQ1RJT05fU0FUQV9QQVNTVEhST1VHSDoKKwkJ
aWYgKCFpb2MtPnNoKSB7CisJCQlwcmludGsoS0VSTl9FUlIgIiVzQCVkOjptcHRjdGxfZG9fbXB0
X2NvbW1hbmQgLSAiCisJCQkJIlNDU0kgZHJpdmVyIGlzIG5vdCBsb2FkZWQuIFxuIiwKKwkJCQkJ
X19GSUxFX18sIF9fTElORV9fKTsKKwkJCXJjID0gLUVGQVVMVDsKKwkJCWdvdG8gZG9uZV9mcmVl
X21lbTsKKwkJfQorCQlicmVhazsKKwogCWNhc2UgTVBJX0ZVTkNUSU9OX1JBSURfQUNUSU9OOgog
CQkvKiBKdXN0IGFkZCBhIFNHRQogCQkgKi8K

------_=_NextPart_001_01C62857.8092E283--
