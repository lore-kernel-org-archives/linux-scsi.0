From: akpm@osdl.org
Subject: [patch 07/31] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status() static
Date: Thu, 08 Jun 2006 22:23:33 -0700
Message-ID: <200606090523.k595NXpE032246@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:11231 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932281AbWFIF0r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jun 2006 01:26:47 -0400
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
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_done_with_status-static drivers/scsi/aic7xxx/aic79xx_core.c
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_done_with_status-static	2006-06-01 20:41:50.000000000 -0700
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-06-01 20:41:50.000000000 -0700
@@ -7352,7 +7352,7 @@ ahd_reset_cmds_pending(struct ahd_softc 
 	ahd->flags &= ~AHD_UPDATE_PEND_CMDS;
 }
 
-void
+static void
 ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_t status)
 {
 	cam_status ostat;
_
