From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: [PATCH] aacraid: sysfs adapter reset/status format change.
Date: Mon, 23 Jul 2007 10:13:48 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01C5A9E1@otce2k301.adaptec.com>
References: <AE4F746F2AECFC4DA4AADD66A1DFEF01B8E0AF@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C7CD33.B0AD74F7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:57186 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbXGWONu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2007 10:13:50 -0400
Received: from otce2k301.adaptec.com (otce2k301.adaptec.com [10.12.1.97])
	by mail-gw3.adaptec.com (Spam Firewall) with ESMTP id 0645D1C984E
	for <linux-scsi@vger.kernel.org>; Mon, 23 Jul 2007 07:13:49 -0700 (PDT)
Content-class: urn:content-classes:message
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01B8E0AF@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C7CD33.B0AD74F7
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

We need to newline terminate responses from nodes within the sysfs tree,
the Adapter status value reported by the reset adapter node is adjusted.

This attached patch is against current scsi-misc-2.6

ObligatoryDisclaimer: Please accept my condolences regarding Outlook's
handling of patch attachments.

Signed-off-by: Mark Salyzyn <aacraid@adaptec.com>

 drivers/scsi/aacraid/linit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Sincerely -- Mark Salyzyn

------_=_NextPart_001_01C7CD33.B0AD74F7
Content-Type: application/octet-stream;
	name="aacraid_adapter_status_format_change.patch"
Content-Transfer-Encoding: base64
Content-Description: aacraid_adapter_status_format_change.patch
Content-Disposition: attachment;
	filename="aacraid_adapter_status_format_change.patch"

ZGlmZiAtcnUgYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jIGIvZHJpdmVycy9zY3NpL2Fh
Y3JhaWQvbGluaXQuYwotLS0gYS9kcml2ZXJzL3Njc2kvYWFjcmFpZC9saW5pdC5jCTIwMDctMDct
MjMgMDk6NTM6MDYuODUyOTI5MjM5IC0wNDAwCisrKyBiL2RyaXZlcnMvc2NzaS9hYWNyYWlkL2xp
bml0LmMJMjAwNy0wNy0yMyAxMDowODoxMC4zNDczOTA5MzkgLTA0MDAKQEAgLTgyMiw3ICs4MjIs
NyBAQAogCXRtcCA9IGFhY19hZGFwdGVyX2NoZWNrX2hlYWx0aChkZXYpOwogCWlmICgodG1wID09
IDApICYmIGRldi0+aW5fcmVzZXQpCiAJCXRtcCA9IC1FQlVTWTsKLQlsZW4gPSBzbnByaW50Zihi
dWYsIFBBR0VfU0laRSwgIjB4JXgiLCB0bXApOworCWxlbiA9IHNucHJpbnRmKGJ1ZiwgUEFHRV9T
SVpFLCAiMHgleFxuIiwgdG1wKTsKIAlyZXR1cm4gbGVuOwogfQogCg==

------_=_NextPart_001_01C7CD33.B0AD74F7--
