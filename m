From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 2/5] - fusion - target reset when drive is being removed
Date: Wed, 25 Jan 2006 18:05:12 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F1FED50@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62214.8FC8BBDB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:11773 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932245AbWAZBFl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Jan 2006 20:05:41 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: akpm@osdl.org, James.Bottomley@SteelEye.com, hch@infradead.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62214.8FC8BBDB
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

The issuing of the target reset=20
used in device hot removal case so the
firmware queue is flushed out off outstanding
commands.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>

------_=_NextPart_001_01C62214.8FC8BBDB
Content-Type: application/octet-stream;
	name="3-tid.patch"
Content-Transfer-Encoding: base64
Content-Description: 3-tid.patch
Content-Disposition: attachment;
	filename="3-tid.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2FzLmMgYS9kcml2ZXJzL21l
c3NhZ2UvZnVzaW9uL21wdHNhcy5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2Fz
LmMJMjAwNi0wMS0yNSAxNjoyMTo0NC4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9tZXNz
YWdlL2Z1c2lvbi9tcHRzYXMuYwkyMDA2LTAxLTI1IDE2OjM2OjMwLjAwMDAwMDAwMCAtMDcwMApA
QCAtMzI0LDYgKzMyNCw3IEBACiAJc3RydWN0IHNhc19ycGh5ICpycGh5OwogCXN0cnVjdCBtcHRz
YXNfcG9ydGluZm8gKnA7CiAJaW50IGk7CisJVmlydERldmljZSAqdmRldjsKIAogCS8qCiAJICog
SGFuZGxlIGhvdHBsdWcgcmVtb3ZhbCBjYXNlLgpAQCAtMzQ3LDggKzM0OCwyOSBAQAogIG91dDoK
IAltdXRleF91bmxvY2soJmhkLT5pb2MtPnNhc190b3BvbG9neV9tdXRleCk7CiAJLyoKLQkgKiBU
T0RPOiBJc3N1ZSB0YXJnZXQgcmVzZXQgdG8gZmx1c2ggZmlybXdhcmUgb3V0c3RhbmRpbmcgY29t
bWFuZHMuCisJICogSXNzdWUgdGFyZ2V0IHJlc2V0IHRvIGZsdXNoIGZpcm13YXJlIG91dHN0YW5k
aW5nIGNvbW1hbmRzLgogCSAqLworCXZkZXYgPSBzZGV2LT5ob3N0ZGF0YTsKKwlpZiAodmRldi0+
Y29uZmlndXJlZF9sdW4peworCQlpZiAobXB0c2NzaWhfVE1IYW5kbGVyKGhkLAorCQkgICAgIE1Q
SV9TQ1NJVEFTS01HTVRfVEFTS1RZUEVfVEFSR0VUX1JFU0VULAorCQkgICAgIHZkZXYtPmJ1c19p
ZCwKKwkJICAgICB2ZGV2LT50YXJnZXRfaWQsCisJCSAgICAgMCwgMCwgNSAvKiA1IHNlY29uZCB0
aW1lb3V0ICovKQorCQkgICAgIDwgMCl7CisKKwkJCS8qIFRoZSBUTSByZXF1ZXN0IGZhaWxlZCEK
KwkJCSAqIEZhdGFsIGVycm9yIGNhc2UuCisJCQkgKi8KKwkJCXByaW50ayhNWUlPQ19zX1dBUk5f
Rk1UCisJCSAgICAgICAiRXJyb3IgcHJvY2Vzc2luZyBUYXNrTWdtdCBpZD0lZCBUQVJHRVRfUkVT
RVRcbiIsCisJCQkJaGQtPmlvYy0+bmFtZSwKKwkJCQl2ZGV2LT50YXJnZXRfaWQpOworCisJCQlo
ZC0+dG1QZW5kaW5nID0gMDsKKwkJCWhkLT50bVN0YXRlID0gVE1fU1RBVEVfTk9ORTsKKwkJfQor
CX0KIAltcHRzY3NpaF9zbGF2ZV9kZXN0cm95KHNkZXYpOwogfQogCg==

------_=_NextPart_001_01C62214.8FC8BBDB--
