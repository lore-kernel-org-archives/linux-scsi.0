From: maximilian attems <janitor@sternwelten.at>
Subject: [patch-kj] remove old ifdef'd code from cam.h
Date: Mon, 21 Jun 2004 20:12:42 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040621181242.GQ1545@sputnik.stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baikonur.stro.at ([213.239.196.228]:33995 "EHLO
	baikonur.stro.at") by vger.kernel.org with ESMTP id S266369AbUFUSMk
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Jun 2004 14:12:40 -0400
Received: from localhost (localhost [127.0.0.1])
	by baikonur.stro.at (Postfix) with ESMTP id 21B895C064
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:12:40 +0200 (CEST)
Received: from baikonur.stro.at ([127.0.0.1])
	by localhost (baikonur [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 22325-09 for <linux-scsi@vger.kernel.org>;
	Mon, 21 Jun 2004 20:12:39 +0200 (CEST)
Received: from sputnik (unknown [62.47.144.54])
	by baikonur.stro.at (Postfix) with ESMTP id 7488D5C002
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jun 2004 20:12:39 +0200 (CEST)
Received: from max by sputnik with local (Exim 4.32)
	id 1BcTHe-0004Ie-V7
	for linux-scsi@vger.kernel.org; Mon, 21 Jun 2004 20:12:43 +0200
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


 From: Domen Puncer <domen@coderock.org>
 Patches to remove some old ifdefs.
 kill compat cruft like #define ahd_pci_set_dma_mask pci_set_dma_mask

 Signed-off-by: Maximilian Attems <janitor@sternwelten.at>

---

 linux-2.6.7-max/drivers/scsi/aic7xxx/cam.h |    6 ------
 1 files changed, 6 deletions(-)

diff -puN drivers/scsi/aic7xxx/cam.h~remove-old-ifdefs-aic7xxx-cam drivers/scsi/aic7xxx/cam.h
--- linux-2.6.7/drivers/scsi/aic7xxx/cam.h~remove-old-ifdefs-aic7xxx-cam	2004-06-18 09:14:18.000000000 +0200
+++ linux-2.6.7-max/drivers/scsi/aic7xxx/cam.h	2004-06-18 09:14:18.000000000 +0200
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
