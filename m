From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI sym53c416.c: make a function static
Date: Mon, 7 Feb 2005 00:33:01 +0100
Message-ID: <20050206233301.GF3129@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:26642 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261325AbVBFXdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 6 Feb 2005 18:33:04 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes a needlessly global function static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 15 Nov 2004

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/sym53c416.c.old	2004-11-14 01:30:23.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/sym53c416.c	2004-11-14 01:30:32.000000000 +0100
@@ -616,7 +616,7 @@
 
 MODULE_DEVICE_TABLE(isapnp, id_table);
 
-void sym53c416_probe(void)
+static void sym53c416_probe(void)
 {
 	int *base = probeaddrs;
 	int ints[2];

