From: James.Smart@Emulex.Com
Subject: [Patch] [Repost] Add basic infrastructure for transport host statistics
Date: Tue, 30 Nov 2004 23:35:43 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C12E7DC@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C4D75F.37D1BA85"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:4512 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261237AbULAEfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 30 Nov 2004 23:35:46 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id iB14Zhni027156
	for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2004 20:35:44 -0800 (PST)
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C4D75F.37D1BA85
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

This patch has been updated so that it backs against scsi-misc-2.6 as of =
2004/11/27

-- James S

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org
> [mailto:linux-scsi-owner@vger.kernel.org]On Behalf Of Smart, James
> Sent: Thursday, October 14, 2004 10:43 AM
> To: linux-scsi@vger.kernel.org
> Subject: [Patch] Add basic infrastructure for host statistics
>=20
>=20
> This patch adds the basic hooks to the scsi subsystem to=20
> support transport-specific statistics to be added to a host.=20
> Its basic nature follows the way in which net devices showed=20
> their statistics.
>=20
> -- James
>=20
>=20


------_=_NextPart_001_01C4D75F.37D1BA85
Content-Type: application/octet-stream;
	name="patch.host_stats"
Content-Transfer-Encoding: base64
Content-Description: patch.host_stats
Content-Disposition: attachment;
	filename="patch.host_stats"

ZGlmZiAtdU5yIHNjc2ktbWlzYy0yLjYtMjAwNDExMjcvZHJpdmVycy9zY3NpL2hvc3RzLmMgc2Nz
aS1taXNjLTIuNi0yMDA0MTEyNy5wYXRjaC9kcml2ZXJzL3Njc2kvaG9zdHMuYwotLS0gc2NzaS1t
aXNjLTIuNi0yMDA0MTEyNy9kcml2ZXJzL3Njc2kvaG9zdHMuYwkyMDA0LTExLTI4IDA4OjAxOjEz
LjAwMDAwMDAwMCAtMDUwMAorKysgc2NzaS1taXNjLTIuNi0yMDA0MTEyNy5wYXRjaC9kcml2ZXJz
L3Njc2kvaG9zdHMuYwkyMDA0LTExLTMwIDEzOjU3OjM1LjE5MjEzNzQ0MCAtMDUwMApAQCAtODIs
OCArODIsMTIgQEAKIAlpZiAoc2hvc3QtPnRyYW5zcG9ydHQtPmhvc3RfZGVzdHJveSkKIAkJc2hv
c3QtPnRyYW5zcG9ydHQtPmhvc3RfZGVzdHJveShzaG9zdCk7CiAJY2xhc3NfZGV2aWNlX3VucmVn
aXN0ZXIoJnNob3N0LT5zaG9zdF9jbGFzc2Rldik7Ci0JaWYgKHNob3N0LT50cmFuc3BvcnRfY2xh
c3NkZXYuY2xhc3MpCi0JCWNsYXNzX2RldmljZV91bnJlZ2lzdGVyKCZzaG9zdC0+dHJhbnNwb3J0
X2NsYXNzZGV2KTsKKwlpZiAoc2hvc3QtPnRyYW5zcG9ydF9jbGFzc2Rldi5jbGFzcykgeworCQlp
ZiAoc2hvc3QtPnRyYW5zcG9ydHQtPmhvc3Rfc3RhdGlzdGljcykKKwkJCXN5c2ZzX3JlbW92ZV9n
cm91cCgmc2hvc3QtPnRyYW5zcG9ydF9jbGFzc2Rldi5rb2JqLAorCQkJCXNob3N0LT50cmFuc3Bv
cnR0LT5ob3N0X3N0YXRpc3RpY3MpOworIAkJY2xhc3NfZGV2aWNlX3VucmVnaXN0ZXIoJnNob3N0
LT50cmFuc3BvcnRfY2xhc3NkZXYpOworCX0KIAlkZXZpY2VfZGVsKCZzaG9zdC0+c2hvc3RfZ2Vu
ZGV2KTsKIH0KIEVYUE9SVF9TWU1CT0woc2NzaV9yZW1vdmVfaG9zdCk7CmRpZmYgLXVOciBzY3Np
LW1pc2MtMi42LTIwMDQxMTI3L2RyaXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMgc2NzaS1taXNjLTIu
Ni0yMDA0MTEyNy5wYXRjaC9kcml2ZXJzL3Njc2kvc2NzaV9zeXNmcy5jCi0tLSBzY3NpLW1pc2Mt
Mi42LTIwMDQxMTI3L2RyaXZlcnMvc2NzaS9zY3NpX3N5c2ZzLmMJMjAwNC0xMS0yOCAwODowMTox
NC4wMDAwMDAwMDAgLTA1MDAKKysrIHNjc2ktbWlzYy0yLjYtMjAwNDExMjcucGF0Y2gvZHJpdmVy
cy9zY3NpL3Njc2lfc3lzZnMuYwkyMDA0LTExLTMwIDEzOjU4OjExLjA5NjY3OTEyMCAtMDUwMApA
QCAtNzE2LDYgKzcxNiwxNCBAQAogIAkJCWlmIChlcnJvcikKIAkJCQlyZXR1cm4gZXJyb3I7CiAg
CQl9CisKKwkJaWYgKHNob3N0LT50cmFuc3BvcnR0LT5ob3N0X3N0YXRpc3RpY3MpIHsKKwkJCWVy
cm9yID0gc3lzZnNfY3JlYXRlX2dyb3VwKAorCQkJCQkmc2hvc3QtPnRyYW5zcG9ydF9jbGFzc2Rl
di5rb2JqLAorCQkJCQlzaG9zdC0+dHJhbnNwb3J0dC0+aG9zdF9zdGF0aXN0aWNzKTsKKwkJCWlm
IChlcnJvcikKKwkJCQlyZXR1cm4gZXJyb3I7CisJCX0KICAJfQogCiAJcmV0dXJuIDA7CmRpZmYg
LXVOciBzY3NpLW1pc2MtMi42LTIwMDQxMTI3L2luY2x1ZGUvc2NzaS9zY3NpX3RyYW5zcG9ydC5o
IHNjc2ktbWlzYy0yLjYtMjAwNDExMjcucGF0Y2gvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0
LmgKLS0tIHNjc2ktbWlzYy0yLjYtMjAwNDExMjcvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0
LmgJMjAwNC0xMS0yOCAwODowMjowNy4wMDAwMDAwMDAgLTA1MDAKKysrIHNjc2ktbWlzYy0yLjYt
MjAwNDExMjcucGF0Y2gvaW5jbHVkZS9zY3NpL3Njc2lfdHJhbnNwb3J0LmgJMjAwNC0xMS0zMCAx
Mzo1ODozMy41ODAyNjEwOTYgLTA1MDAKQEAgLTMzLDYgKzMzLDcgQEAKIAlzdHJ1Y3QgY2xhc3Mg
KmRldmljZV9jbGFzczsKIAlzdHJ1Y3QgY2xhc3MgKnRhcmdldF9jbGFzczsKIAlzdHJ1Y3QgY2xh
c3MgKmhvc3RfY2xhc3M7CisJc3RydWN0IGF0dHJpYnV0ZV9ncm91cCAqaG9zdF9zdGF0aXN0aWNz
OwogCiAJLyogQ29uc3RydWN0b3IgZnVuY3Rpb25zICovCiAJaW50ICgqZGV2aWNlX3NldHVwKShz
dHJ1Y3Qgc2NzaV9kZXZpY2UgKik7Cg==

------_=_NextPart_001_01C4D75F.37D1BA85--
