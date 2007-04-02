From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: Panics during init time reset (Was: [PATCH] aacraid: [Fastboot] Panics for AACRAID driver during 'insmod' for kexec test)
Date: Mon, 2 Apr 2007 14:34:36 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF017AA106@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01400B76@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C77555.915A76B0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:52888 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965661AbXDBSej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Apr 2007 14:34:39 -0400
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01400B76@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Judith Lebzelter <judith@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Duane Cox <dcox@conxxus.com>

This is a multi-part message in MIME format.

------_=_NextPart_001_01C77555.915A76B0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Duane discovered in the scsi-misc-2.6 code that the reset handler could
be called without the sync command handler set up resulting in a panic.
Judith discovered this issue within minutes and has recently reported
it. Here is a fix.

IMHO, this needs to be applied immediately regardless of the status of
the kexec patch as this issue is present in the scsi-misc-2.6 driver for
all existing init-time recovery actions. This patch in principal would
not be different w/o the kexec patch.

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patches.

This attached patch is against current scsi-misc-2.6
=20
Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

---

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C77555.915A76B0
Content-Type: application/octet-stream;
	name="aacraid_kexec_2.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_kexec_2.patch
Content-Disposition: attachment;
	filename="aacraid_kexec_2.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jIGIvZHJpdmVycy9zY3NpL2FhY3Jh
aWQvcnguYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9yeC5jCTIwMDctMDQtMDIgMTQ6MTM6
MDkuNDMwMTk4NzMyIC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL3J4LmMJMjAwNy0w
NC0wMiAxNDoxMzowOS4wMDAwMDAwMDAgLTA0MDAKQEAgLTUzOSw2ICs1NDMsNyBAQAogCX0KIAog
CS8qIEZhaWx1cmUgdG8gcmVzZXQgaGVyZSBpcyBhbiBvcHRpb24gLi4uICovCisJZGV2LT5hX29w
cy5hZGFwdGVyX3N5bmNfY21kID0gcnhfc3luY19jbWQ7CiAJZGV2LT5PSU1SID0gc3RhdHVzID0g
cnhfcmVhZGIgKGRldiwgTVVuaXQuT0lNUik7CiAJaWYgKCgoKHN0YXR1cyAmIDB4ZmYpICE9IDB4
ZmYpIHx8IHJlc2V0X2RldmljZXMpICYmCiAJICAhYWFjX3J4X3Jlc3RhcnRfYWRhcHRlcihkZXYs
IDApKQo=

------_=_NextPart_001_01C77555.915A76B0--
