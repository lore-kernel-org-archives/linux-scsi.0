From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Subject: [2.4 PATCH] scsi aic7xxx parenthesis fix
Date: Mon, 4 Dec 2006 10:26:09 +0100
Message-ID: <200612041026.09501.m.kozlowski@tuxland.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:54544 "EHLO
	tuxland.pl") by vger.kernel.org with ESMTP id S1759885AbWLDJ01 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Dec 2006 04:26:27 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Willy Tarreau <wtarreau@hera.kernel.org>

Hello,

=A0=A0=A0=A0=A0=A0=A0=A0This patch adds missing parenthesis in SUBID_90=
05_SEEPTYPE() macro code.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

=A0drivers/scsi/aic7xxx/aic79xx_pci.c | =A0 =A02 +-
=A01 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.4.34-pre6-a/drivers/scsi/aic7xxx/aic79xx_pci.c	2005-04-04 0=
3:42:19.000000000 +0200
+++ linux-2.4.34-pre6-b/drivers/scsi/aic7xxx/aic79xx_pci.c	2006-12-01 1=
2:23:02.000000000 +0100
@@ -110,7 +110,7 @@ ahd_compose_id(u_int device, u_int vendo
=20
 #define SUBID_9005_LEGACYCONN_FUNC(id) ((id) & 0x20)
=20
-#define SUBID_9005_SEEPTYPE(id) ((id) & 0x0C0) >> 6)
+#define SUBID_9005_SEEPTYPE(id) (((id) & 0x0C0) >> 6)
 #define		SUBID_9005_SEEPTYPE_NONE	0x0
 #define		SUBID_9005_SEEPTYPE_4K		0x1
=20

--=20
Regards,

	Mariusz Kozlowski
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
