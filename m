From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/ch.c: make a struct static
Date: Mon, 28 Feb 2005 19:07:33 +0100
Message-ID: <20050228180733.GF4021@stusta.de>
References: <20050223014233.6710fd73.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:26629 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261655AbVB1SHe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2005 13:07:34 -0500
Content-Disposition: inline
In-Reply-To: <20050223014233.6710fd73.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>, Gerd Knorr <kraxel@bytesex.org>
Cc: linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

This patch makes a needlessly global struct static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

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

