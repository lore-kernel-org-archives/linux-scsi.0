From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] SCSI atp870u.c: make a needlessly global function static
Date: Mon, 15 Nov 2004 02:54:30 +0100
Message-ID: <20041115015430.GF2249@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:12044 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261416AbUKOCHb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Nov 2004 21:07:31 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Red Hat <alan@redhat.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

The patch below makes the function is870 which has no external users 
static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.10-rc1-mm5-full/drivers/scsi/atp870u.c.old	2004-11-13 17:17:15.000000000 +0100
+++ linux-2.6.10-rc1-mm5-full/drivers/scsi/atp870u.c	2004-11-13 17:17:41.000000000 +0100
@@ -1085,7 +1085,7 @@
 
 }
 
-void is870(struct Scsi_Host *host, unsigned int wkport)
+static void is870(struct Scsi_Host *host, unsigned int wkport)
 {
 	unsigned int tmport;
 	unsigned char i, j, k, rmb, n;

