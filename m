From: akpm@osdl.org
Subject: [patch 12/28] make drivers/scsi/aic7xxx/aic79xx_core.:ahd_set_tags() static
Date: Mon, 25 Sep 2006 16:58:57 -0700
Message-ID: <200609252358.k8PNwviA003485@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:40124 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751804AbWIZACO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 20:02:14 -0400
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
@@ -1427,11 +1427,6 @@ typedef enum {
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
@@ -3879,7 +3879,7 @@ ahd_set_width(struct ahd_softc *ahd, str
 /*
  * Update the current state of tagged queuing for a given target.
  */
-void
+static void
 ahd_set_tags(struct ahd_softc *ahd, struct scsi_cmnd *cmd,
 	     struct ahd_devinfo *devinfo, ahd_queue_alg alg)
 {
_
