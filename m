From: akpm@osdl.org
Subject: [patch 06/22] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status() static
Date: Fri, 30 Jun 2006 02:33:07 -0700
Message-ID: <200606300933.k5U9X7O2001692@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:59795 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932194AbWF3JhZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 05:37:25 -0400
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
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_done_with_status-static
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -7354,7 +7354,7 @@ ahd_reset_cmds_pending(struct ahd_softc 
 	ahd->flags &= ~AHD_UPDATE_PEND_CMDS;
 }
 
-void
+static void
 ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_t status)
 {
 	cam_status ostat;
_
