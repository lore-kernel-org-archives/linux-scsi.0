From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI: aha1542.c: make some code static
Date: Mon, 15 Nov 2004 02:51:17 +0100
Message-ID: <20041115015117.GD2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:4107 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261410AbUKOCEX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:04:23 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes some needlessly gloal code static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/aha1542.c.old	2004-11-13 16:58:35.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/aha1542.c	2004-11-13 16:59:41.000000000 +0100
@@ -129,8 +129,8 @@
  */
 
 #if defined(MODULE)
-int isapnp = 0;
-int aha1542[] = {0x330, 11, 4, -1};
+static int isapnp = 0;
+static int aha1542[] = {0x330, 11, 4, -1};
 MODULE_PARM(aha1542, "1-4i");
 MODULE_PARM(isapnp, "i");
 
@@ -951,7 +951,7 @@
 static char *setup_str[MAXBOARDS] __initdata;
 static int setup_idx = 0;
 
-void __init aha1542_setup(char *str, int *ints)
+static void __init aha1542_setup(char *str, int *ints)
 {
 	const char *ahausage = "aha1542: usage: aha1542=<PORTBASE>[,<BUSON>,<BUSOFF>[,<DMASPEED>]]\n";
 	int setup_portbase;

