From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 5/9] scsi: megaraid_sas -  report different io sectors for
 ieee support
Date: Fri, 19 Nov 2010 10:23:50 -0700
Message-ID: <4B6A08C587958942AA3002690DD4F8C30106A96213@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804533@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C3DBD67F68@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961BD@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961D6@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961E4@cosmail02.lsi.com>
 <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_4B6A08C587958942AA3002690DD4F8C30106A96213cosmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:39413 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755730Ab0KSRXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 12:23:43 -0500
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C30106A961F2@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, Tomas Henzl <thenzl@redhat.com>

--_002_4B6A08C587958942AA3002690DD4F8C30106A96213cosmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Driver will report different I/O max sectors for ieee sge support=20

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |    4 ++++
drivers/scsi/megaraid/megaraid_sas.h |    1 +
 2 files changed, 5 insertions(+)

--_002_4B6A08C587958942AA3002690DD4F8C30106A96213cosmail02lsic_
Content-Type: application/octet-stream; name="megasas-p5-ieee.patch"
Content-Description: megasas-p5-ieee.patch
Content-Disposition: attachment; filename="megasas-p5-ieee.patch"; size=1136;
	creation-date="Thu, 18 Nov 2010 20:37:02 GMT";
	modification-date="Wed, 17 Nov 2010 13:09:11 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVwTiBvbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5jIG5ldy9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMKLS0tIG9sZC9kcml2ZXJzL3Njc2kv
bWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0xNCAxNTo0OToxNi4wMDAwMDAwMDAgLTA1
MDAKKysrIG5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmMJMjAxMC0xMS0x
NCAxNTo1NDozMi4wMDAwMDAwMDAgLTA1MDAKQEAgLTM2ODYsNiArMzY4NiwxMCBAQCBzdGF0aWMg
aW50IG1lZ2FzYXNfaW9fYXR0YWNoKHN0cnVjdCBtZWdhCiAJCQlpbnN0YW5jZS0+bWF4X2Z3X2Nt
ZHMgLSBNRUdBU0FTX0lOVF9DTURTOwogCWhvc3QtPnRoaXNfaWQgPSBpbnN0YW5jZS0+aW5pdF9p
ZDsKIAlob3N0LT5zZ190YWJsZXNpemUgPSBpbnN0YW5jZS0+bWF4X251bV9zZ2U7CisKKwlpZiAo
aW5zdGFuY2UtPmZ3X3N1cHBvcnRfaWVlZSkKKwkJaW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9y
ZXEgPSBNRUdBU0FTX01BWF9TRUNUT1JTX0lFRUU7CisKIAkvKgogCSAqIENoZWNrIGlmIHRoZSBt
b2R1bGUgcGFyYW1ldGVyIHZhbHVlIGZvciBtYXhfc2VjdG9ycyBjYW4gYmUgdXNlZAogCSAqLwpk
aWZmIC1ydXBOIG9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmggbmV3L2Ry
aXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gb2xkL2RyaXZlcnMvc2NzaS9t
ZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDEwLTExLTE0IDE0OjMxOjI5LjAwMDAwMDAwMCAtMDUw
MAorKysgbmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAkyMDEwLTExLTE0
IDE0OjM1OjI4LjAwMDAwMDAwMCAtMDUwMApAQCAtNzA4LDYgKzcwOCw3IEBAIHN0cnVjdCBtZWdh
c2FzX2N0cmxfaW5mbyB7CiAKICNkZWZpbmUgTUVHQVNBU19NQVhfTkFNRQkJCTMyCiAjZGVmaW5l
IE1FR0FTQVNfTUFYX1NFQ1RPUlMgICAgICAgICAgICAgICAgICAgICgyKjEwMjQpCisjZGVmaW5l
IE1FR0FTQVNfTUFYX1NFQ1RPUlNfSUVFRSAgICAgICAgICAgICAgICgyKjEyOCkKICNkZWZpbmUg
TUVHQVNBU19EQkdfTFZMCQkJCTEKIAogI2RlZmluZSBNRUdBU0FTX0ZXX0JVU1kJCQkJMQo=

--_002_4B6A08C587958942AA3002690DD4F8C30106A96213cosmail02lsic_--
