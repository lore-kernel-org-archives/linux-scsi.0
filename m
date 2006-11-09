From: akpm@osdl.org
Subject: [patch 13/26] drivers/scsi/dpt_i2o.c: remove dead code
Date: Wed, 08 Nov 2006 19:56:16 -0800
Message-ID: <200611090356.kA93uGYF003951@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:28339 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1424026AbWKID7d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Nov 2006 22:59:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

The Coverity checker spotted this dead code introduced by
commit a07f353701acae77e023f6270e8af353b37af7c4.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/dpt_i2o.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-remove-dead-code drivers/scsi/dpt_i2o.c
--- a/drivers/scsi/dpt_i2o.c~drivers-scsi-dpt_i2oc-remove-dead-code
+++ a/drivers/scsi/dpt_i2o.c
@@ -195,8 +195,6 @@ static int adpt_detect(struct scsi_host_
 			pci_dev_get(pDev);
 		}
 	}
-	if (pDev)
-		pci_dev_put(pDev);
 
 	/* In INIT state, Activate IOPs */
 	for (pHba = hba_chain; pHba; pHba = pHba->next) {
_
