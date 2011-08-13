From: Alexander Kurtz <kurtz.alex@googlemail.com>
Subject: [PATCH] [SCSI] mvsas: Add support for Marvell's 88SE9480 chip.
Date: Sat, 13 Aug 2011 12:11:31 +0200
Message-ID: <1313231597.6786.0.camel@alexander>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49662 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1HMKfx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2011 06:35:53 -0400
Received: by fxh19 with SMTP id 19so2753742fxh.19
        for <linux-scsi@vger.kernel.org>; Sat, 13 Aug 2011 03:35:52 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Xiangliang Yu <yuxiangl@marvell.com>, James Bottomley <James.Bottomley@suse.de>

This patch adds the missing pci id for Marvell's 88SE9480 SAS/SATA=C2=A0=
HBA
which is also sold with a vendor id of 0x1B4B instead of 0x11AB.

Signed-off-by: Alexander Kurtz <kurtz.alex@googlemail.com>
---
 drivers/scsi/mvsas/mv_init.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.=
c
index 4e9af66..bd5b8e1 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -723,6 +723,15 @@ static struct pci_device_id __devinitdata mvs_pci_=
table[] =3D {
 		.class_mask	=3D 0,
 		.driver_data	=3D chip_9485,
 	},
+	{
+		.vendor		=3D 0x1b4b,
+		.device		=3D 0x9480,
+		.subvendor	=3D PCI_ANY_ID,
+		.subdevice	=3D PCI_ANY_ID,
+		.class		=3D 0,
+		.class_mask	=3D 0,
+		.driver_data	=3D chip_9480,
+	},
=20
 	{ }	/* terminate list */
 };
--=20
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
