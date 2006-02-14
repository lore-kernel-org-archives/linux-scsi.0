From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status() static
Date: Tue, 14 Feb 2006 16:22:12 +0100
Message-ID: <20060214152212.GH10701@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161076AbWBNPWV@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Hannes Reinecke <hare@suse.de>, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch makes a needlessly global function static.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 3 Feb 2006

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
