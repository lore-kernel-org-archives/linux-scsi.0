From: Jay Cliburn <jacliburn@bellsouth.net>
Subject: [PATCH] sata_via: Add SATA support for vt8237a
Date: Mon, 7 Aug 2006 22:08:30 -0500
Message-ID: <20060808030830.GA16426@osprey.hogchain.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imf25aec.mail.bellsouth.net ([205.152.59.73]:53731 "EHLO
	imf25aec.mail.bellsouth.net") by vger.kernel.org with ESMTP
	id S1751229AbWHHDIc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Aug 2006 23:08:32 -0400
Received: from ibm69aec.bellsouth.net ([68.222.90.44])
          by imf25aec.mail.bellsouth.net with ESMTP
          id <20060808030831.UMLH2467.imf25aec.mail.bellsouth.net@ibm69aec.bellsouth.net>
          for <linux-scsi@vger.kernel.org>; Mon, 7 Aug 2006 23:08:31 -0400
Received: from osprey.hogchain.net ([68.222.90.44])
          by ibm69aec.bellsouth.net with ESMTP
          id <20060808030831.CVNK14648.ibm69aec.bellsouth.net@osprey.hogchain.net>
          for <linux-scsi@vger.kernel.org>; Mon, 7 Aug 2006 23:08:31 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch adds support for the VIA Technologies VT8237A SATA controller,
used, for example, on the ASUS M2V socket AM2 motherboard.

Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>

--- linux-2.6.17.x86_64/drivers/scsi/sata_via.c.orig	2006-08-06 22:02:44.000000000 -0500
+++ linux-2.6.17.x86_64/drivers/scsi/sata_via.c	2006-08-06 22:03:17.000000000 -0500
@@ -76,6 +76,7 @@
 static void svia_scr_write (struct ata_port *ap, unsigned int sc_reg, u32 val);
 
 static const struct pci_device_id svia_pci_tbl[] = {
+	{ 0x1106, 0x0591, PCI_ANY_ID, PCI_ANY_ID, 0, 0, vt6420 },
 	{ 0x1106, 0x3149, PCI_ANY_ID, PCI_ANY_ID, 0, 0, vt6420 },
 	{ 0x1106, 0x3249, PCI_ANY_ID, PCI_ANY_ID, 0, 0, vt6421 },
 

