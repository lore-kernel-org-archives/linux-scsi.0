From: "Moore, Eric" <Eric.Moore@lsil.com>
Subject: [PATCH 4/8]  fusion - mptctl - Event Log Fix
Date: Thu, 2 Feb 2006 17:19:40 -0700
Message-ID: <F331B95B72AFFB4B87467BE1C8E9CF5F243698@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C62857.865B71FB"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:7832 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1751197AbWBCATq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Feb 2006 19:19:46 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k130ERNI021738
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:14:27 -0800 (PST)
Received: from namail.ad.lsil.com (namail.co.lsil.com [172.21.36.18])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k130JeQQ026640
	for <linux-scsi@vger.kernel.org>; Thu, 2 Feb 2006 16:19:45 -0800
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C62857.865B71FB
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable

Use the hard coded value MPTCTL_EVENT_LOG_SIZE to fix
bug where in certain cases, the ioc->eventLogSize was=20
initialized.

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


------_=_NextPart_001_01C62857.865B71FB
Content-Type: application/octet-stream;
	name="4-event_log.patch"
Content-Transfer-Encoding: base64
Content-Description: 4-event_log.patch
Content-Disposition: attachment;
	filename="4-event_log.patch"

ZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0YmFzZS5jIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMKLS0tIGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRi
YXNlLmMJMjAwNi0wMi0wMiAxNToxNjo0Ny4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRiYXNlLmMJMjAwNi0wMi0wMiAxNToxODo1Ny4wMDAwMDAwMDAgLTA3
MDAKQEAgLTYxNDIsNyArNjE0Miw3IEBACiAJaWYgKGlvYy0+ZXZlbnRzICYmIChpb2MtPmV2ZW50
VHlwZXMgJiAoIDEgPDwgZXZlbnQpKSkgewogCQlpbnQgaWR4OwogCi0JCWlkeCA9IGlvYy0+ZXZl
bnRDb250ZXh0ICUgaW9jLT5ldmVudExvZ1NpemU7CisJCWlkeCA9IGlvYy0+ZXZlbnRDb250ZXh0
ICUgTVBUQ1RMX0VWRU5UX0xPR19TSVpFOwogCiAJCWlvYy0+ZXZlbnRzW2lkeF0uZXZlbnQgPSBl
dmVudDsKIAkJaW9jLT5ldmVudHNbaWR4XS5ldmVudENvbnRleHQgPSBpb2MtPmV2ZW50Q29udGV4
dDsKZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0Y3RsLmMgYS9kcml2ZXJz
L21lc3NhZ2UvZnVzaW9uL21wdGN0bC5jCi0tLSBiL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0
Y3RsLmMJMjAwNi0wMi0wMiAxNTo0NDo0NC4wMDAwMDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9t
ZXNzYWdlL2Z1c2lvbi9tcHRjdGwuYwkyMDA2LTAyLTAyIDE1OjQ5OjUxLjAwMDAwMDAwMCAtMDcw
MApAQCAtMTUwMSw3ICsxNTAxLDcgQEAKIAkJcmV0dXJuIC1FTk9ERVY7CiAJfQogCi0Ja2FyZy5l
dmVudEVudHJpZXMgPSBpb2MtPmV2ZW50TG9nU2l6ZTsKKwlrYXJnLmV2ZW50RW50cmllcyA9IE1Q
VENUTF9FVkVOVF9MT0dfU0laRTsKIAlrYXJnLmV2ZW50VHlwZXMgPSBpb2MtPmV2ZW50VHlwZXM7
CiAKIAkvKiBDb3B5IHRoZSBkYXRhIGZyb20ga2VybmVsIG1lbW9yeSB0byB1c2VyIG1lbW9yeQpA
QCAtMTU1MSw3ICsxNTUxLDYgQEAKIAkJbWVtc2V0KGlvYy0+ZXZlbnRzLCAwLCBzeik7CiAJCWlv
Yy0+YWxsb2NfdG90YWwgKz0gc3o7CiAKLQkJaW9jLT5ldmVudExvZ1NpemUgPSBNUFRDVExfRVZF
TlRfTE9HX1NJWkU7CiAJCWlvYy0+ZXZlbnRDb250ZXh0ID0gMDsKICAgICAgICAgfQogCkBAIC0x
NTkxLDcgKzE1OTAsNyBAQAogCW1heEV2ZW50cyA9IG51bUJ5dGVzL3NpemVvZihNUFRfSU9DVExf
RVZFTlRTKTsKIAogCi0JbWF4ID0gaW9jLT5ldmVudExvZ1NpemUgPCBtYXhFdmVudHMgPyBpb2Mt
PmV2ZW50TG9nU2l6ZSA6IG1heEV2ZW50czsKKwltYXggPSBNUFRDVExfRVZFTlRfTE9HX1NJWkUg
PCBtYXhFdmVudHMgPyBNUFRDVExfRVZFTlRfTE9HX1NJWkUgOiBtYXhFdmVudHM7CiAKIAkvKiBJ
ZiBmZXdlciB0aGFuIDEgZXZlbnQgaXMgcmVxdWVzdGVkLCB0aGVyZSBtdXN0IGhhdmUKIAkgKiBi
ZWVuIHNvbWUgdHlwZSBvZiBlcnJvci4KZGlmZiAtdWFyTiBiL2RyaXZlcnMvbWVzc2FnZS9mdXNp
b24vbXB0c2NzaWguYyBhL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2NzaWguYwotLS0gYi9k
cml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdHNjc2loLmMJMjAwNi0wMi0wMiAxNDo1MjoyMi4wMDAw
MDAwMDAgLTA3MDAKKysrIGEvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRzY3NpaC5jCTIwMDYt
MDItMDIgMTU6MjE6MDMuMDAwMDAwMDAwIC0wNzAwCkBAIC0yNDg5LDcgKzI0ODksNyBAQAogCQkJ
CWludCBpZHg7CiAJCQkJTVBUX0FEQVBURVIgKmlvYyA9IGhkLT5pb2M7CiAKLQkJCQlpZHggPSBp
b2MtPmV2ZW50Q29udGV4dCAlIGlvYy0+ZXZlbnRMb2dTaXplOworCQkJCWlkeCA9IGlvYy0+ZXZl
bnRDb250ZXh0ICUgTVBUQ1RMX0VWRU5UX0xPR19TSVpFOwogCQkJCWlvYy0+ZXZlbnRzW2lkeF0u
ZXZlbnQgPSBNUElfRVZFTlRfU0NTSV9ERVZJQ0VfU1RBVFVTX0NIQU5HRTsKIAkJCQlpb2MtPmV2
ZW50c1tpZHhdLmV2ZW50Q29udGV4dCA9IGlvYy0+ZXZlbnRDb250ZXh0OwogCg==

------_=_NextPart_001_01C62857.865B71FB--
