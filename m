From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [2.4 PATCH] scsi 53c7xx parenthesis fix
Date: Mon, 4 Dec 2006 10:23:53 +0100
Message-ID: <200612041023.53940.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:16133 "EHLO
	tuxland.pl") by vger.kernel.org with ESMTP id S1759892AbWLDJYL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 04:24:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, Willy Tarreau <wtarreau@hera.kernel.org>

Hello,

=A0=A0=A0=A0=A0=A0=A0=A0Tis patch removes an extra parenthesis in abort=
_connected() code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

=A0drivers/scsi/53c7xx.c | =A0 =A02 +-
=A01 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.4.34-pre6-a/drivers/scsi/53c7xx.c	2004-02-18 14:36:31.00000=
0000 +0100
+++ linux-2.4.34-pre6-b/drivers/scsi/53c7xx.c	2006-12-01 12:22:28.00000=
0000 +0100
@@ -4409,7 +4409,7 @@ abort_connected (struct Scsi_Host *host)
  * account the current synchronous offset)=20
  */
=20
-    sstat =3D (NCR53c8x0_read8 (SSTAT2_REG);
+    sstat =3D NCR53c8x0_read8 (SSTAT2_REG);
     offset =3D OFFSET (sstat & SSTAT2_FF_MASK) >> SSTAT2_FF_SHIFT;
     phase =3D sstat & SSTAT2_PHASE_MASK;
=20

--=20
Regards,

	Mariusz Kozlowski
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
