From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI ncr53c8xx.c: make a variable static
Date: Mon, 15 Nov 2004 03:16:12 +0100
Message-ID: <20041115021612.GR2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:42756 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261460AbUKOC3D (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:29:03 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes a needlessly global variable static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/ncr53c8xx.c.old	2004-11-13 22:27:21.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/ncr53c8xx.c	2004-11-13 22:28:07.000000000 +0100
@@ -7738,7 +7738,7 @@
 **==========================================================
 */
 #ifdef	MODULE
-char *ncr53c8xx;	/* command line passed by insmod */
+static char *ncr53c8xx;		/* command line passed by insmod */
 module_param(ncr53c8xx, charp, 0);
 #endif
 

