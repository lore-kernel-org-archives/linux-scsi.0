From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Changeable queue depth
Date: Wed, 30 May 2007 10:01:14 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01A54FF1@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF019E18B5@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7A2C2.FCC8FBB4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52982 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587AbXE3OBR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 May 2007 10:01:17 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id EE6751851BC
	for <linux-scsi@vger.kernel.org>; Wed, 30 May 2007 07:01:15 -0700 (PDT)
Content-class: urn:content-classes:message
In-reply-to: <AE4F746F2AECFC4DA4AADD66A1DFEF019E18B5@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7A2C2.FCC8FBB4
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Inspired by Brian King's patch to the ibmvscsi driver. Adds support for
a changeable queue depth to the aacraid driver.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7A2C2.FCC8FBB4
Content-Type: application/octet-stream;
	name="aacraid_change_queue_depth.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_change_queue_depth.patch
Content-Disposition: attachment;
	filename="aacraid_change_queue_depth.patch"

ZGlmZiAtcnUgYS8vZHJpdmVycy9zY3NpL2FhY3JhaWQvbGluaXQuYyBiLy9kcml2ZXJzL3Njc2kv
YWFjcmFpZC9saW5pdC5jCi0tLSBhLy9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDct
MDUtMzAgMDk6MjY6NDEuNTg3OTE3OTg3IC0wNDAwCisrKyBiLy9kcml2ZXJzL3Njc2kvYWFjcmFp
ZC9saW5pdC5jCTIwMDctMDUtMzAgMDk6Mjg6NTIuNzgwOTM3NDg1IC0wNDAwCkBAIC00NDYsNiAr
NDQ2LDQzIEBACiAJcmV0dXJuIDA7CiB9CiAKKy8qKgorICoJYWFjX2NoYW5nZV9xdWV1ZV9kZXB0
aAkJLQlhbHRlciBxdWV1ZSBkZXB0aHMKKyAqCUBzZGV2OglTQ1NJIGRldmljZSB3ZSBhcmUgY29u
c2lkZXJpbmcKKyAqCUBkZXB0aDoJZGVzaXJlZCBxdWV1ZSBkZXB0aAorICoKKyAqCUFsdGVycyBx
dWV1ZSBkZXB0aHMgZm9yIHRhcmdldCBkZXZpY2UgYmFzZWQgb24gdGhlIGhvc3QgYWRhcHRlcidz
CisgKgl0b3RhbCBjYXBhY2l0eSBhbmQgdGhlIHF1ZXVlIGRlcHRoIHN1cHBvcnRlZCBieSB0aGUg
dGFyZ2V0IGRldmljZS4KKyAqLworCitzdGF0aWMgaW50IGFhY19jaGFuZ2VfcXVldWVfZGVwdGgo
c3RydWN0IHNjc2lfZGV2aWNlICpzZGV2LCBpbnQgZGVwdGgpCit7CisJaWYgKHNkZXYtPnRhZ2dl
ZF9zdXBwb3J0ZWQgJiYgKHNkZXYtPnR5cGUgPT0gVFlQRV9ESVNLKSAmJgorCSAgICAoc2Rldl9j
aGFubmVsKHNkZXYpID09IENPTlRBSU5FUl9DSEFOTkVMKSkgeworCQlzdHJ1Y3Qgc2NzaV9kZXZp
Y2UgKiBkZXY7CisJCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3QgPSBzZGV2LT5ob3N0OworCQl1bnNp
Z25lZCBudW0gPSAwOworCisJCV9fc2hvc3RfZm9yX2VhY2hfZGV2aWNlKGRldiwgaG9zdCkgewor
CQkJaWYgKGRldi0+dGFnZ2VkX3N1cHBvcnRlZCAmJiAoZGV2LT50eXBlID09IFRZUEVfRElTSykg
JiYKKwkJCSAgICAoc2Rldl9jaGFubmVsKGRldikgPT0gQ09OVEFJTkVSX0NIQU5ORUwpKQorCQkJ
CSsrbnVtOworCQkJKytudW07CisJCX0KKwkJaWYgKG51bSA+PSBob3N0LT5jYW5fcXVldWUpCisJ
CQludW0gPSBob3N0LT5jYW5fcXVldWUgLSAxOworCQlpZiAoZGVwdGggPiAoaG9zdC0+Y2FuX3F1
ZXVlIC0gbnVtKSkKKwkJCWRlcHRoID0gaG9zdC0+Y2FuX3F1ZXVlIC0gbnVtOworCQlpZiAoZGVw
dGggPiAyNTYpCisJCQlkZXB0aCA9IDI1NjsKKwkJZWxzZSBpZiAoZGVwdGggPCAyKQorCQkJZGVw
dGggPSAyOworCQlzY3NpX2FkanVzdF9xdWV1ZV9kZXB0aChzZGV2LCBNU0dfT1JERVJFRF9UQUcs
IGRlcHRoKTsKKwl9IGVsc2UKKwkJc2NzaV9hZGp1c3RfcXVldWVfZGVwdGgoc2RldiwgMCwgMSk7
CisJcmV0dXJuIHNkZXYtPnF1ZXVlX2RlcHRoOworfQorCiBzdGF0aWMgaW50IGFhY19pb2N0bChz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKnNkZXYsIGludCBjbWQsIHZvaWQgX191c2VyICogYXJnKQogewog
CXN0cnVjdCBhYWNfZGV2ICpkZXYgPSAoc3RydWN0IGFhY19kZXYgKilzZGV2LT5ob3N0LT5ob3N0
ZGF0YTsKQEAgLTg0NCw2ICs4ODEsNyBAQAogCS5iaW9zX3BhcmFtICAgICAJCT0gYWFjX2Jpb3Nw
YXJtLAkKIAkuc2hvc3RfYXR0cnMJCQk9IGFhY19hdHRycywKIAkuc2xhdmVfY29uZmlndXJlCQk9
IGFhY19zbGF2ZV9jb25maWd1cmUsCisJLmNoYW5nZV9xdWV1ZV9kZXB0aAkJPSBhYWNfY2hhbmdl
X3F1ZXVlX2RlcHRoLAogCS5laF9hYm9ydF9oYW5kbGVyCQk9IGFhY19laF9hYm9ydCwKIAkuZWhf
aG9zdF9yZXNldF9oYW5kbGVyCQk9IGFhY19laF9yZXNldCwKIAkuY2FuX3F1ZXVlICAgICAgCQk9
IEFBQ19OVU1fSU9fRklCLAkK

------_=_NextPart_001_01C7A2C2.FCC8FBB4--
