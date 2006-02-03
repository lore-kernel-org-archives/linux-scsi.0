From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 5/8]  fusion - mptctl -sense width fix
Date: Thu, 2 Feb 2006 17:19:44 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F243699@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62857.889ECB83"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8088 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751199AbWBCATq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 19:19:46 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k130ERNI021741
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:14:27 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k130JeQS026640
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:19:45 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62857.889ECB83
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Bug fix for correctly setting sense width
for the MPTCOMMAND ioctl.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C62857.889ECB83
Content-Type: application/octet-stream;
	name="5-sense-width.patch"
Content-Transfer-Encoding: base64
Content-Description: 5-sense-width.patch
Content-Disposition: attachment;
	filename="5-sense-width.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3RsLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdGN0bC5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3Rs
LmMJMjAwNi0wMi0wMiAxNTo0OTo1MS4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRjdGwuYwkyMDA2LTAyLTAyIDE1OjU0OjA4LjAwMDAwMDAwMCAtMDcwMApA
QCAtMTgzOSw3ICsxODM5LDkgQEAKIAkJCQlnb3RvIGRvbmVfZnJlZV9tZW07CiAJCQl9CiAKLQkJ
CXBTY3NpUmVxLT5Nc2dGbGFncyA9IG1wdF9tc2dfZmxhZ3MoKTsKKwkJCXBTY3NpUmVxLT5Nc2dG
bGFncyAmPSB+TVBJX1NDU0lJT19NU0dGTEdTX1NFTlNFX1dJRFRIOworCQkJcFNjc2lSZXEtPk1z
Z0ZsYWdzIHw9IG1wdF9tc2dfZmxhZ3MoKTsKKwogCiAJCQkvKiB2ZXJpZnkgdGhhdCBhcHAgaGFz
IG5vdCByZXF1ZXN0ZWQKIAkJCSAqCW1vcmUgc2Vuc2UgZGF0YSB0aGFuIGRyaXZlcgpAQCAtMTky
MSw3ICsxOTIzLDkgQEAKIAkJCWludCBzY3NpZGlyID0gTVBJX1NDU0lJT19DT05UUk9MX1JFQUQ7
CiAJCQlpbnQgZGF0YVNpemU7CiAKLQkJCXBTY3NpUmVxLT5Nc2dGbGFncyA9IG1wdF9tc2dfZmxh
Z3MoKTsKKwkJCXBTY3NpUmVxLT5Nc2dGbGFncyAmPSB+TVBJX1NDU0lJT19NU0dGTEdTX1NFTlNF
X1dJRFRIOworCQkJcFNjc2lSZXEtPk1zZ0ZsYWdzIHw9IG1wdF9tc2dfZmxhZ3MoKTsKKwogCiAJ
CQkvKiB2ZXJpZnkgdGhhdCBhcHAgaGFzIG5vdCByZXF1ZXN0ZWQKIAkJCSAqCW1vcmUgc2Vuc2Ug
ZGF0YSB0aGFuIGRyaXZlcgo=

------_=_NextPart_001_01C62857.889ECB83--
