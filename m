From: janitor@sternwelten.at
Subject: [patch 08/11]  remove old ifdefs aic79xxx
Date: Wed, 01 Sep 2004 22:46:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <E1C2c06-00074P-Fo@sputnik>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:61398 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S267835AbUIAUqm
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Sep 2004 16:46:42 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, janitor@sternwelten.at



 Patches to remove some old ifdefs.
 remove most of the #include <linux/version.h>
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

Signed-off-by: Maximilian Attems <janitor@sternwelten.at>




---

 linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/cam.h |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/scsi/aic7xxx/cam.h~remove-old-ifdefs-aic7xxx-cam drivers/scsi/aic7xxx/cam.h
--- linux-2.6.9-rc1-bk7/drivers/scsi/aic7xxx/cam.h~remove-old-ifdefs-aic7xxx-cam	2004-08-31 17:41:37.000000000 +0200
+++ linux-2.6.9-rc1-bk7-max/drivers/scsi/aic7xxx/cam.h	2004-08-31 17:41:37.000000000 +0200
@@ -85,12 +85,6 @@ typedef enum {
 	CAM_STATUS_MASK		= 0x3F
 } cam_status;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,3,0)
-#define	SCSI_DATA_READ	1
-#define	SCSI_DATA_WRITE 2
-#define SCSI_DATA_NONE  3
-#endif
-
 /*
  * Definitions for the asynchronous callback CCB fields.
  */

_
