From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 7/8] fusion - adding MSI support
Date: Mon, 16 Jan 2006 18:53:24 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC84@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61B08.CD90A0DB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9435 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751332AbWAQBx0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 20:53:26 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0H1mFNI021612
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:48:15 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0H1rPNx007158
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:53:25 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61B08.CD90A0DB
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Adding MSI support, and command line for enabling=20
it.  By default, the command line option has MSI disabled.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C61B08.CD90A0DB
Content-Type: application/octet-stream;
	name="fusion-7-msi-support.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-7-msi-support.patch
Content-Disposition: attachment;
	filename="fusion-7-msi-support.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0YmFzZS5jIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMKLS0tIGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRi
YXNlLmMJMjAwNi0wMS0xNiAxODoxMjoxOC4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMJMjAwNi0wMS0xNiAxODoxMDoxOS4wMDAwMDAwMDAgLTA3
MDAKQEAgLTgxLDYgKzgxLDEwIEBACiAvKgogICogIGNtZCBsaW5lIHBhcmFtZXRlcnMKICAqLwor
c3RhdGljIGludCBtcHRfbXNpX2VuYWJsZSA9IDA7Cittb2R1bGVfcGFyYW0obXB0X21zaV9lbmFi
bGUsIGludCwgMCk7CitNT0RVTEVfUEFSTV9ERVNDKG1wdF9tc2lfZW5hYmxlLCAiIE1TSSBTdXBw
b3J0IEVuYWJsZSAoZGVmYXVsdD0wKSIpOworCiAjaWZkZWYgTUZDTlQKIHN0YXRpYyBpbnQgbWZj
b3VudGVyID0gMDsKICNkZWZpbmUgUFJJTlRfTUZfQ09VTlQgMjAwMDAKQEAgLTE0NDQsNiArMTQ0
OCwxMyBAQAogCiAJaW9jLT5wY2lfaXJxID0gLTE7CiAJaWYgKHBkZXYtPmlycSkgeworCisJCWlm
ICgobXB0X21zaV9lbmFibGUgPT0gMSkgJiYKKwkJICAgIChwY2lfZW5hYmxlX21zaShwZGV2KT09
MCkpCisJCQlwcmludGsoTVlJT0Nfc19JTkZPX0ZNVAorCQkJICAgICJQQ0ktTVNJIGVuYWJsZWQg
Zm9yIHRoaXMgaG90cGx1ZyBjb250cm9sbGVyXG4iLAorCQkJICAgIGlvYy0+bmFtZSk7CisKIAkJ
ciA9IHJlcXVlc3RfaXJxKHBkZXYtPmlycSwgbXB0X2ludGVycnVwdCwgU0FfU0hJUlEsIGlvYy0+
bmFtZSwgaW9jKTsKIAogCQlpZiAociA8IDApIHsKQEAgLTE0ODMsNiArMTQ5NCw4IEBACiAKIAkJ
bGlzdF9kZWwoJmlvYy0+bGlzdCk7CiAJCWZyZWVfaXJxKGlvYy0+cGNpX2lycSwgaW9jKTsKKwkJ
aWYgKG1wdF9tc2lfZW5hYmxlID09IDEpCisJCQlwY2lfZGlzYWJsZV9tc2kocGRldik7CiAJCWlv
dW5tYXAobWVtKTsKIAkJa2ZyZWUoaW9jKTsKIAkJcGNpX3NldF9kcnZkYXRhKHBkZXYsIE5VTEwp
OwpAQCAtMjEzNiw2ICsyMTQ5LDggQEAKIAogCWlmIChpb2MtPnBjaV9pcnEgIT0gLTEpIHsKIAkJ
ZnJlZV9pcnEoaW9jLT5wY2lfaXJxLCBpb2MpOworCQlpZiAobXB0X21zaV9lbmFibGUgPT0gMSkK
KwkJCXBjaV9kaXNhYmxlX21zaShpb2MtPnBjaWRldik7CiAJCWlvYy0+cGNpX2lycSA9IC0xOwog
CX0KIAo=

------_=_NextPart_001_01C61B08.CD90A0DB--
