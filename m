From: akpm@osdl.org
Subject: [patch 24/28] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status() static
Date: Wed, 08 Mar 2006 00:14:40 -0800
Message-ID: <200603080816.k288GTWh002243@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:53932 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932501AbWCHIQ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2006 03:16:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de


From: Adrian Bunk <bunk@stusta.de>

This patch makes a needlessly global function static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_done_with_status-static drivers/scsi/aic7xxx/aic79xx_core.c
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_done_with_status-static	2006-03-08 00:13:07.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-03-08 00:13:07.000000000 -0800
@@ -7372,7 +7372,7 @@ ahd_reset_cmds_pending(struct ahd_softc 
 	ahd->flags &= ~AHD_UPDATE_PEND_CMDS;
 }
 
-void
+static void
 ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_t status)
 {
 	cam_status ostat;
_
