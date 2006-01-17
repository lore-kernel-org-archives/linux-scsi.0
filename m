From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 8/8] fusion - adding task managment response code info
Date: Mon, 16 Jan 2006 18:53:26 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC85@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61B08.CF1EC843"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9691 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751333AbWAQBx2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 20:53:28 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0H1mHNI021615
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:48:17 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0H1rRLM007165
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:53:27 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61B08.CF1EC843
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Adding verbose message returned from firmware
when a task mangment request fails.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C61B08.CF1EC843
Content-Type: application/octet-stream;
	name="fusion-8-response.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-8-response.patch
Content-Disposition: attachment;
	filename="fusion-8-response.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYyBhL2RyaXZlcnMv
bWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYwotLS0gYi9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21w
dHNjc2loLmMJMjAwNi0wMS0xNiAxODowOTozMy4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVy
cy9tZXNzYWdlL2Z1c2lvbi9tcHRzY3NpaC5jCTIwMDYtMDEtMTYgMTg6MTY6MzAuMDAwMDAwMDAw
IC0wNzAwCkBAIC0yMDU4LDYgKzIwNTgsNDIgQEAKIH0KIAogLyo9LT0tPS09LT0tPS09LT0tPS09
LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0q
Lworc3RhdGljIHZvaWQKK21wdHNjc2loX3Rhc2ttZ210X3Jlc3BvbnNlX2NvZGUoTVBUX0FEQVBU
RVIgKmlvYywgdTggcmVzcG9uc2VfY29kZSkKK3sKKwljaGFyICpkZXNjOworCisJc3dpdGNoIChy
ZXNwb25zZV9jb2RlKSB7CisJY2FzZSBNUElfU0NTSVRBU0tNR01UX1JTUF9UTV9DT01QTEVURToK
KwkJZGVzYyA9ICJUaGUgdGFzayBjb21wbGV0ZWQuIjsKKwkJYnJlYWs7CisJY2FzZSBNUElfU0NT
SVRBU0tNR01UX1JTUF9JTlZBTElEX0ZSQU1FOgorCQlkZXNjID0gIlRoZSBJT0MgcmVjZWl2ZWQg
YW4gaW52YWxpZCBmcmFtZSBzdGF0dXMuIjsKKwkJYnJlYWs7CisJY2FzZSBNUElfU0NTSVRBU0tN
R01UX1JTUF9UTV9OT1RfU1VQUE9SVEVEOgorCQlkZXNjID0gIlRoZSB0YXNrIHR5cGUgaXMgbm90
IHN1cHBvcnRlZC4iOworCQlicmVhazsKKwljYXNlIE1QSV9TQ1NJVEFTS01HTVRfUlNQX1RNX0ZB
SUxFRDoKKwkJZGVzYyA9ICJUaGUgcmVxdWVzdGVkIHRhc2sgZmFpbGVkLiI7CisJCWJyZWFrOwor
CWNhc2UgTVBJX1NDU0lUQVNLTUdNVF9SU1BfVE1fU1VDQ0VFREVEOgorCQlkZXNjID0gIlRoZSB0
YXNrIGNvbXBsZXRlZCBzdWNjZXNzZnVsbHkuIjsKKwkJYnJlYWs7CisJY2FzZSBNUElfU0NTSVRB
U0tNR01UX1JTUF9UTV9JTlZBTElEX0xVTjoKKwkJZGVzYyA9ICJUaGUgTFVOIHJlcXVlc3QgaXMg
aW52YWxpZC4iOworCQlicmVhazsKKwljYXNlIE1QSV9TQ1NJVEFTS01HTVRfUlNQX0lPX1FVRVVF
RF9PTl9JT0M6CisJCWRlc2MgPSAiVGhlIHRhc2sgaXMgaW4gdGhlIElPQyBxdWV1ZSBhbmQgaGFz
IG5vdCBiZWVuIHNlbnQgdG8gdGFyZ2V0LiI7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCWRlc2Mg
PSAidW5rbm93biI7CisJCWJyZWFrOworCX0KKwlwcmludGsoTVlJT0Nfc19JTkZPX0ZNVCAiUmVz
cG9uc2UgQ29kZSgweCUwOHgpOiBGL1c6ICVzXG4iLAorCQlpb2MtPm5hbWUsIHJlc3BvbnNlX2Nv
ZGUsIGRlc2MpOworfQorCisvKj0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0t
PS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPS09LT0tPSovCiAvKioKICAqCW1wdHNjc2lo
X3Rhc2ttZ210X2NvbXBsZXRlIC0gUmVnaXN0ZXJlZCB3aXRoIEZ1c2lvbiBNUFQgYmFzZSBkcml2
ZXIKICAqCUBpb2M6IFBvaW50ZXIgdG8gTVBUX0FEQVBURVIgc3RydWN0dXJlCkBAIC0yMTA2LDYg
KzIxNDIsMTEgQEAKIAkJLyogRmlndXJlIG91dCBpZiB0aGlzIHdhcyBBQk9SVF9UQVNLLCBUQVJH
RVRfUkVTRVQsIG9yIEJVU19SRVNFVCEgKi8KIAkJdG1UeXBlID0gcFNjc2lUbVJlcS0+VGFza1R5
cGU7CiAKKwkJaWYgKGlvYy0+ZmFjdHMuTXNnVmVyc2lvbiA+PSBNUElfVkVSU0lPTl8wMV8wNSAm
JgorCQkgICAgcFNjc2lUbVJlcGx5LT5SZXNwb25zZUNvZGUpCisJCQltcHRzY3NpaF90YXNrbWdt
dF9yZXNwb25zZV9jb2RlKGlvYywKKwkJCSAgICBwU2NzaVRtUmVwbHktPlJlc3BvbnNlQ29kZSk7
CisKIAkJZHRtcHJpbnRrKChNWUlPQ19zX1dBUk5fRk1UICIgIFRhc2tUeXBlID0gJWQsIFRlcm1p
bmF0aW9uQ291bnQ9JWRcbiIsCiAJCQkJaW9jLT5uYW1lLCB0bVR5cGUsIGxlMzJfdG9fY3B1KHBT
Y3NpVG1SZXBseS0+VGVybWluYXRpb25Db3VudCkpKTsKIAkJREJHX0RVTVBfVE1fUkVQTFlfRlJB
TUUoKHUzMiAqKXBTY3NpVG1SZXBseSk7Cg==

------_=_NextPart_001_01C61B08.CF1EC843--
