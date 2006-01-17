From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 4/8] fusion - increase reply frame size from 0x40 to 0x50 bytes
Date: Mon, 16 Jan 2006 18:53:16 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1AAC80@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C61B08.C8C4C9D3"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:8155 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751329AbWAQBxS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 20:53:18 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k0H1m7NI021597
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:48:07 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k0H1rHiw007125
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2006 17:53:17 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C61B08.C8C4C9D3
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Increasing the reply frame size by 16 bytes, to
be in sync with the other fusion drivers.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C61B08.C8C4C9D3
Content-Type: application/octet-stream;
	name="fusion-4-reply-frame.patch"
Content-Transfer-Encoding: base64
Content-Description: fusion-4-reply-frame.patch
Content-Disposition: attachment;
	filename="fusion-4-reply-frame.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0YmFzZS5oIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmgKLS0tIGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRi
YXNlLmgJMjAwNi0wMS0xNiAxNDoyMTozNi4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmgJMjAwNi0wMS0xNiAxNjo0NzoxMi4wMDAwMDAwMDAgLTA3
MDAKQEAgLTEyMyw3ICsxMjMsNyBAQAogI2RlZmluZSAgTVBUX01BWF9GUkFNRV9TSVpFCQkxMjgK
ICNkZWZpbmUgIE1QVF9ERUZBVUxUX0ZSQU1FX1NJWkUJCTEyOAogCi0jZGVmaW5lICBNUFRfUkVQ
TFlfRlJBTUVfU0laRQkJMHg0MCAgLyogTXVzdCBiZSBhIG11bHRpcGxlIG9mIDggKi8KKyNkZWZp
bmUgIE1QVF9SRVBMWV9GUkFNRV9TSVpFCQkweDUwICAvKiBNdXN0IGJlIGEgbXVsdGlwbGUgb2Yg
OCAqLwogCiAjZGVmaW5lICBNUFRfU0dfUkVRXzEyOF9TQ0FMRQkJMQogI2RlZmluZSAgTVBUX1NH
X1JFUV85Nl9TQ0FMRQkJMgo=

------_=_NextPart_001_01C61B08.C8C4C9D3--
