From: "Ed Lin" <ed.lin@promise.com>
Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for console device
Date: Mon, 2 Apr 2007 16:01:53 -0700
Message-ID: <B70A50D07063384EB9BCE3330D18414F0327EBFF@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7757A.E7BBD9BA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 67.111.72.3.ptr.us.xo.net ([67.111.72.3]:23215 "EHLO
	nonameb.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S966030AbXDBXAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 19:00:17 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, jeff <jeff@garzik.org>, Promise_Linux <Promise_Linux@promise.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7757A.E7BBD9BA
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com]=20
> Sent: Monday, April 02, 2007 11:28 AM
> To: Ed Lin
> Cc: linux-scsi; linux-kernel; jeff; Promise_Linux
> Subject: RE: [PATCH 3/4] [SCSI]stex: fix reset recovery for=20
> console device
>=20
>=20
> On Mon, 2007-04-02 at 11:14 -0700, Ed Lin wrote:
> > I just saw the routine name scsi_eh_try_stu, and didn't notice the
> > allow_restart (partly because I thought it was not harmful...).
> > But the TEST_UNIT_READY must stay.
>=20
> Sure ... I was just checking since your change log implied you'd seen
> the problem from the error handler ... however, we can add it ...
> there's a possibility of getting spin up on init from sd anyway.
>=20

You make the decision. But after reconsideration, I think it's better
to remove unused code. It also needs change since the patch about
id mapping is modified in another mail.

How about the attachment here?

------_=_NextPart_001_01C7757A.E7BBD9BA
Content-Type: application/octet-stream;
	name="s3"
Content-Transfer-Encoding: base64
Content-Description: s3
Content-Disposition: attachment;
	filename="s3"

QWZ0ZXIgcmVzZXQgY29tcGxldGVkLCB0aGUgc2NzaSBlcnJvciBoYW5kbGVyIHNlbmRzIG91dCBU
RVNUX1VOSVRfUkVBRFkgdG8KdGhlIGRldmljZS4gRm9yICdub3JtYWwnIGRldmljZXMgdGhpcyBj
b21tYW5kIHdpbGwgYmUgaGFuZGxlZCBieSBmaXJtd2FyZS4KSG93ZXZlciwgYmVjYXVzZSB0aGUg
UkFJRCBjb25zb2xlIG9ubHkgaW50ZXJmYWNlcyB0byBzY3NpIG1pZCBsYXllciwgdGhlCmZpcm13
YXJlIHdpbGwgbm90IHByb2Nlc3MgdGhpcyBjb21tYW5kIGZvciBpdC4gVGhpcyB3aWxsIG1ha2Ug
dGhlIGNvbnNvbGUKdG8gYmUgb2ZmbGluZWQgcmlnaHQgYWZ0ZXIgcmVzZXQuIEFkZCB0aGUgaGFu
ZGxpbmcgaW4gZHJpdmVyIHRvIGZpeCB0aGlzCnByb2JsZW0uCgpTaWduZWQtb2ZmLWJ5OiBFZCBM
aW4gPGVkLmxpbkBwcm9taXNlLmNvbT4KLS0tCmRpZmYgLS1naXQgYS9kcml2ZXJzL3Njc2kvc3Rl
eC5jIGIvZHJpdmVycy9zY3NpL3N0ZXguYwppbmRleCA0YzZjZTZhLi44NWM3NzliIDEwMDY0NAot
LS0gYS9kcml2ZXJzL3Njc2kvc3RleC5jCisrKyBiL2RyaXZlcnMvc2NzaS9zdGV4LmMKQEAgLTYw
MSw2ICs2MDEsMTMgQEAgc3RleF9xdWV1ZWNvbW1hbmQoc3RydWN0IHNjc2lfY21uZCAqY21kLAog
CQkJc3RleF9pbnZhbGlkX2ZpZWxkKGNtZCwgZG9uZSk7CiAJCXJldHVybiAwOwogCX0KKwljYXNl
IFRFU1RfVU5JVF9SRUFEWToKKwkJaWYgKGlkID09IGhvc3QtPm1heF9pZCAtIDEpIHsKKwkJCWNt
ZC0+cmVzdWx0ID0gRElEX09LIDw8IDE2IHwgQ09NTUFORF9DT01QTEVURSA8PCA4OworCQkJZG9u
ZShjbWQpOworCQkJcmV0dXJuIDA7CisJCX0KKwkJYnJlYWs7CiAJY2FzZSBJTlFVSVJZOgogCQlp
ZiAoaWQgIT0gaG9zdC0+bWF4X2lkIC0gMSkKIAkJCWJyZWFrOwo=

------_=_NextPart_001_01C7757A.E7BBD9BA--
