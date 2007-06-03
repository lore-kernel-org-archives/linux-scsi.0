From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] IDE: Remove references to the non-existent CONFIG_SCSI_EATA_DMA
 variable.
Date: Sun, 3 Jun 2007 13:55:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706031353540.24889@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:55019 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbXFCR51 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Jun 2007 13:57:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bzolnier@gmail.com
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 3cebed7..969e385 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -144,7 +144,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 	local_irq_enable();
 	ide_fix_driveid(id);

-#if defined (CONFIG_SCSI_EATA_DMA) || defined (CONFIG_SCSI_EATA_PIO) || defined (CONFIG_SCSI_EATA)
+#if defined (CONFIG_SCSI_EATA_PIO) || defined (CONFIG_SCSI_EATA)
 	/*
 	 * EATA SCSI controllers do a hardware ATA emulation:
 	 * Ignore them if there is a driver for them available.
@@ -154,7 +154,7 @@ static inline void do_identify (ide_drive_t *drive, u8 cmd)
 		printk("%s: EATA SCSI HBA %.10s\n", drive->name, id->model);
 		goto err_misc;
 	}
-#endif /* CONFIG_SCSI_EATA_DMA || CONFIG_SCSI_EATA_PIO */
+#endif /* CONFIG_SCSI_EATA || CONFIG_SCSI_EATA_PIO */

 	/*
 	 *  WIN_IDENTIFY returns little-endian info,
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
