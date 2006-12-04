From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [2.4 PATCH] scsi 53c7,8xx parenthesis fix
Date: Mon, 4 Dec 2006 10:22:40 +0100
Message-ID: <200612041022.40958.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:15365 "EHLO
	tuxland.pl") by vger.kernel.org with ESMTP id S1759886AbWLDJW7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 04:22:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, Willy Tarreau <wtarreau@hera.kernel.org>

Hello,

=A0=A0=A0=A0=A0=A0=A0=A0This patch removes an extra parenthesis in debu=
gger_fn_bs() code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

=A0drivers/scsi/53c7,8xx.c | =A0 =A02 +-
=A01 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.4.34-pre6-a/drivers/scsi/53c7,8xx.c	2004-11-17 12:54:21.000=
000000 +0100
+++ linux-2.4.34-pre6-b/drivers/scsi/53c7,8xx.c	2006-12-01 12:21:50.000=
000000 +0100
@@ -3197,7 +3197,7 @@ debugger_fn_bs (struct Scsi_Host *host,=20
=20
     bp->address =3D (u32 *) args[0];
     memcpy ((void *) bp->old_instruction, (void *) bp->address, 8);
-    bp->old_size =3D (((bp->old_instruction[0] >> 24) & DCMD_TYPE_MASK=
) =3D=3D
+    bp->old_size =3D ((bp->old_instruction[0] >> 24) & DCMD_TYPE_MASK)=
 =3D=3D
 	DCMD_TYPE_MMI ? 3 : 2;
     bp->next =3D hostdata->breakpoints;
     hostdata->breakpoints =3D bp->next;


--=20
Regards,

	Mariusz Kozlowski
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
