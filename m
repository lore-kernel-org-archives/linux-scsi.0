From: akpm@osdl.org
Subject: [patch 07/45] make drivers/scsi/aic7xxx/aic79xx_core.:ahd_set_tags() static
Date: Fri, 20 Oct 2006 14:48:07 -0700
Message-ID: <200610202148.k9KLm7iw004081@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55431 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S2992863AbWJTVvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Oct 2006 17:51:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

ahd_set_tags() can now become static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/aic7xxx/aic79xx.h      |    5 -----
 drivers/scsi/aic7xxx/aic79xx_core.c |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx.h~make-drivers-scsi-aic7xxx-aic79xx_coreahd_set_tags-static drivers/scsi/aic7xxx/aic79xx.h
--- a/drivers/scsi/aic7xxx/aic79xx.h~make-drivers-scsi-aic7xxx-aic79xx_coreahd_set_tags-static
+++ a/drivers/scsi/aic7xxx/aic79xx.h
@@ -1433,11 +1433,6 @@ typedef enum {
 	AHD_QUEUE_TAGGED
 } ahd_queue_alg;
 
-void			ahd_set_tags(struct ahd_softc *ahd,
-				     struct scsi_cmnd *cmd,
-				     struct ahd_devinfo *devinfo,
-				     ahd_queue_alg alg);
-
 /**************************** Target Mode *************************************/
 #ifdef AHD_TARGET_MODE
 void		ahd_send_lstate_events(struct ahd_softc *,
diff -puN drivers/scsi/aic7xxx/aic79xx_core.c~make-drivers-scsi-aic7xxx-aic79xx_coreahd_set_tags-static drivers/scsi/aic7xxx/aic79xx_core.c
--- a/drivers/scsi/aic7xxx/aic79xx_core.c~make-drivers-scsi-aic7xxx-aic79xx_coreahd_set_tags-static
+++ a/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -3274,7 +3274,7 @@ ahd_set_width(struct ahd_softc *ahd, str
 /*
  * Update the current state of tagged queuing for a given target.
  */
-void
+static void
 ahd_set_tags(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
 	     struct ahd_devinfo *devinfo, ahd_queue_alg alg)
 {
_
