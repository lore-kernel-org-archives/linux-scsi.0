From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI sr.c: make a struct static
Date: Mon, 15 Nov 2004 03:34:30 +0100
Message-ID: <20041115023430.GB2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:18186 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261496AbUKOCpt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:45:49 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes a needlessly global struct static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/sr.c.old	2004-11-14 01:29:29.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/sr.c	2004-11-14 01:29:39.000000000 +0100
@@ -512,7 +512,7 @@
 	return cdrom_media_changed(&cd->cdi);
 }
 
-struct block_device_operations sr_bdops =
+static struct block_device_operations sr_bdops =
 {
 	.owner		= THIS_MODULE,
 	.open		= sr_block_open,

