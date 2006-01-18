From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 3/3] fusion - sanity check
Date: Tue, 17 Jan 2006 17:06:29 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AB0B0@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61BC3.08079E0B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:21994 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932548AbWARAGd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jan 2006 19:06:33 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0I01MNI011591
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 16:01:22 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0I06Sjj016168
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2006 16:06:32 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61BC3.08079E0B
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

This adds a sanity check in the interrupt routine
insures incoming message frames are a valid
message frames.  =20

The code for setting 0xdeadbeaf in the freed message
frames, apparently was already submitted by Christoph
in previous patch submission.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C61BC3.08079E0B
Content-Type: application/octet-stream;
	name="fusion-3-sanity.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-3-sanity.patch
Content-Disposition: attachment;
	filename="fusion-3-sanity.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYyBhL2RyaXZlcnMv
bWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYwotLS0gYi9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21w
dHNjc2loLmMJMjAwNi0wMS0xNyAxNTo1MToxNS4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVy
cy9tZXNzYWdlL2Z1c2lvbi9tcHRzY3NpaC5jCTIwMDYtMDEtMTcgMTY6MDI6NDEuMDAwMDAwMDAw
IC0wNzAwCkBAIC01NjQsMTEgKzU2NCwyNCBAQAogCU1QVF9TQ1NJX0hPU1QJKmhkOwogCVNDU0lJ
T1JlcXVlc3RfdAkqcFNjc2lSZXE7CiAJU0NTSUlPUmVwbHlfdAkqcFNjc2lSZXBseTsKLQl1MTYJ
CSByZXFfaWR4OworCXUxNgkJIHJlcV9pZHgsIHJlcV9pZHhfTVI7CiAKIAloZCA9IChNUFRfU0NT
SV9IT1NUICopIGlvYy0+c2gtPmhvc3RkYXRhOwogCiAJcmVxX2lkeCA9IGxlMTZfdG9fY3B1KG1m
LT51LmZyYW1lLmh3aGRyLm1zZ2N0eHUuZmxkLnJlcV9pZHgpOworCXJlcV9pZHhfTVIgPSAobXIg
IT0gTlVMTCkgPworCSAgICBsZTE2X3RvX2NwdShtci0+dS5mcmFtZS5od2hkci5tc2djdHh1LmZs
ZC5yZXFfaWR4KSA6IHJlcV9pZHg7CisJaWYgKChyZXFfaWR4ICE9IHJlcV9pZHhfTVIpIHx8CisJ
ICAgIChtZi0+dS5mcmFtZS5saW5rYWdlLmFyZzEgPT0gMHhkZWFkYmVhZikpIHsKKwkJcHJpbnRr
KE1ZSU9DX3NfRVJSX0ZNVCAiUmVjZWl2ZWQgYSBtZiB0aGF0IHdhcyBhbHJlYWR5IGZyZWVkXG4i
LAorCQkgICAgaW9jLT5uYW1lKTsKKwkJcHJpbnRrIChNWUlPQ19zX0VSUl9GTVQKKwkJICAgICJy
ZXFfaWR4PSV4IHJlcV9pZHhfTVI9JXggbWY9JXAgbXI9JXAgc2M9JXBcbiIsCisJCSAgICBpb2Mt
Pm5hbWUsIHJlcV9pZHgsIHJlcV9pZHhfTVIsIG1mLCBtciwKKwkJICAgIGhkLT5TY3NpTG9va3Vw
W3JlcV9pZHhfTVJdKTsKKwkJcmV0dXJuIDA7CisJfQorCiAJc2MgPSBoZC0+U2NzaUxvb2t1cFty
ZXFfaWR4XTsKIAlpZiAoc2MgPT0gTlVMTCkgewogCQlNUElIZWFkZXJfdCAqaGRyID0gKE1QSUhl
YWRlcl90ICopbWY7Cg==

------_=_NextPart_001_01C61BC3.08079E0B--
