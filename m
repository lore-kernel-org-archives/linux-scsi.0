From: akpm@osdl.org
Subject: [patch 07/15] drivers/scsi/aic7xxx/aic79xx_core.c: make ahd_done_with_status() static
Date: Mon, 10 Apr 2006 23:26:34 -0700
Message-ID: <200604110727.k3B7RGSS015300@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:23178 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932318AbWDKHaj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 03:30:39 -0400
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
--- devel/drivers/scsi/aic7xxx/aic79xx_core.c~drivers-scsi-aic7xxx-aic79xx_corec-make-ahd_done_with_status-static	2006-03-21 23:05:42.000000000 -0800
+++ devel-akpm/drivers/scsi/aic7xxx/aic79xx_core.c	2006-03-21 23:05:42.000000000 -0800
@@ -7375,7 +7375,7 @@ ahd_reset_cmds_pending(struct ahd_softc 
 	ahd->flags &= ~AHD_UPDATE_PEND_CMDS;
 }
 
-void
+static void
 ahd_done_with_status(struct ahd_softc *ahd, struct scb *scb, uint32_t status)
 {
 	cam_status ostat;
_
