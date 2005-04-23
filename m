From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/ch.c: make a struct static
Date: Sat, 23 Apr 2005 23:24:04 +0200
Message-ID: <20050423212404.GD4355@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:9743 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261877AbVDWVYH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Apr 2005 17:24:07 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Gerd Knorr <kraxel@bytesex.org>, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

This patch makes a needlessly global struct static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 28 Feb 2005

--- linux-2.6.11-rc4-mm1-full/drivers/scsi/ch.c.old	2005-02-28 18:14:48.000000000 +0100
+++ linux-2.6.11-rc4-mm1-full/drivers/scsi/ch.c	2005-02-28 18:14:55.000000000 +0100
@@ -118,7 +118,7 @@
 static spinlock_t ch_devlist_lock = SPIN_LOCK_UNLOCKED;
 static int ch_devcount;
 
-struct scsi_driver ch_template =
+static struct scsi_driver ch_template =
 {
 	.owner     	= THIS_MODULE,
 	.gendrv     	= {


