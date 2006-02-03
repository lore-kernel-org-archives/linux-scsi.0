From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status() static
Date: Fri, 3 Feb 2006 21:26:11 +0100
Message-ID: <20060203202611.GH4408@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:39693 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1751397AbWBCU0N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Feb 2006 15:26:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.16-rc1-mm5-full/drivers/scsi/aic7xxx/aic79xx_core.c.old	2006-02-03 16:41:13.000000000 +0100
+++ linux-2.6.16-rc1-mm5-full/drivers/scsi/aic7xxx/aic79xx_core.c	2006-02-03 16:41:28.000000000 +0100
@@ -7382,7 +7382,7 @@
 	ahd->flags &= ~AHD_UPDATE_PEND_CMDS;
 }
 
-void
+static void
 ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_t status)
 {
 	cam_status ostat;

