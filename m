From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI sym53c416.c: make a function static
Date: Mon, 15 Nov 2004 03:35:43 +0100
Message-ID: <20041115023543.GC2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49418 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261490AbUKOCrW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:47:22 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/sym53c416.c.old	2004-11-14 01:30:23.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/sym53c416.c	2004-11-14 01:30:32.000000000 +0100
@@ -616,7 +616,7 @@
 
 MODULE_DEVICE_TABLE(isapnp, id_table);
 
-void sym53c416_probe(void)
+static void sym53c416_probe(void)
 {
 	int *base = probeaddrs;
 	int ints[2];

