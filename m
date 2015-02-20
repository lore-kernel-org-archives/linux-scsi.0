From: =?UTF-8?B?SsOhbiDFoGVib8Whw61r?= <sebosik@itm8.sk>
Subject: [PATCH] scsi: mvsas support for Asus P9A-I SAS on-board controller
Date: Fri, 20 Feb 2015 23:38:35 +0100
Message-ID: <CAK+pXF29JUyrZQRO5W4cccZuCSKGUV3i_RvyCOUODqKcAM=qsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:56943 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945AbbBTWig (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Feb 2015 17:38:36 -0500
Received: by mail-ig0-f169.google.com with SMTP id hl2so10217958igb.0
        for <linux-scsi@vger.kernel.org>; Fri, 20 Feb 2015 14:38:35 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add support for ASUS P9A-I SAS controller to 'mvsas' driver (Marvell
88SE9485 based)

Signed-off-by: Jan Sebosik <sebosik@itm8.sk>

---

--- drivers/scsi/mvsas/mv_init.c.orig   2015-02-20 23:16:33.071890099 +0100
+++ drivers/scsi/mvsas/mv_init.c        2015-02-20 23:18:18.298499615 +0100
@@ -728,6 +728,15 @@ static struct pci_device_id mvs_pci_tabl
                .class_mask     = 0,
                .driver_data    = chip_9485,
        },
+       {
+               .vendor         = PCI_VENDOR_ID_MARVELL_EXT, /* ASUS
P9A-I series on-board SAS controller */
+               .device         = 0x9485,
+               .subvendor      = PCI_VENDOR_ID_ASUSTEK,
+               .subdevice      = 0x8635,
+               .class          = 0,
+               .class_mask     = 0,
+               .driver_data    = chip_9485,
+       },
        { PCI_VDEVICE(OCZ, 0x1021), chip_9485}, /* OCZ RevoDrive3 */
        { PCI_VDEVICE(OCZ, 0x1022), chip_9485}, /* OCZ
RevoDrive3/zDriveR4 (exact model unknown) */
        { PCI_VDEVICE(OCZ, 0x1040), chip_9485}, /* OCZ
RevoDrive3/zDriveR4 (exact model unknown) */
