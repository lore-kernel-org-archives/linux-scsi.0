From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 6/7] fusion - overrun tape fix
Date: Mon, 16 Jan 2006 18:53:21 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC83@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61B08.CBD9F19B"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:9179 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751331AbWAQBxX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 20:53:23 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0H1mCNI021609
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:48:12 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0H1rMEp007145
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:53:22 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61B08.CBD9F19B
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

A customer requested fix for tape problem.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C61B08.CBD9F19B
Content-Type: application/octet-stream;
	name="fusion-6-overrun.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-6-overrun.patch
Content-Disposition: attachment;
	filename="fusion-6-overrun.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYyBhL2RyaXZlcnMv
bWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYwotLS0gYi9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21w
dHNjc2loLmMJMjAwNi0wMS0xNiAxODoxNDoxNS4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVy
cy9tZXNzYWdlL2Z1c2lvbi9tcHRzY3NpaC5jCTIwMDYtMDEtMTYgMTg6MTA6NTcuMDAwMDAwMDAw
IC0wNzAwCkBAIC03MzEsNiArNzMxLDggQEAKIAogCQkJYnJlYWs7CiAKKwkJY2FzZSBNUElfSU9D
U1RBVFVTX1NDU0lfREFUQV9PVkVSUlVOOgkJLyogMHgwMDQ0ICovCisJCQlzYy0+cmVzaWQ9MDsK
IAkJY2FzZSBNUElfSU9DU1RBVFVTX1NDU0lfUkVDT1ZFUkVEX0VSUk9SOgkvKiAweDAwNDAgKi8K
IAkJY2FzZSBNUElfSU9DU1RBVFVTX1NVQ0NFU1M6CQkJLyogMHgwMDAwICovCiAJCQlpZiAoc2Nz
aV9zdGF0dXMgPT0gTVBJX1NDU0lfU1RBVFVTX0JVU1kpCkBAIC03OTAsNyArNzkyLDYgQEAKIAkJ
Y2FzZSBNUElfSU9DU1RBVFVTX0lOU1VGRklDSUVOVF9SRVNPVVJDRVM6CS8qIDB4MDAwNiAqLwog
CQljYXNlIE1QSV9JT0NTVEFUVVNfSU5WQUxJRF9GSUVMRDoJCS8qIDB4MDAwNyAqLwogCQljYXNl
IE1QSV9JT0NTVEFUVVNfSU5WQUxJRF9TVEFURToJCS8qIDB4MDAwOCAqLwotCQljYXNlIE1QSV9J
T0NTVEFUVVNfU0NTSV9EQVRBX09WRVJSVU46CQkvKiAweDAwNDQgKi8KIAkJY2FzZSBNUElfSU9D
U1RBVFVTX1NDU0lfSU9fREFUQV9FUlJPUjoJCS8qIDB4MDA0NiAqLwogCQljYXNlIE1QSV9JT0NT
VEFUVVNfU0NTSV9UQVNLX01HTVRfRkFJTEVEOgkvKiAweDAwNEEgKi8KIAkJZGVmYXVsdDoK

------_=_NextPart_001_01C61B08.CBD9F19B--
