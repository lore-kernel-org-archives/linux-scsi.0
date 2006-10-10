From: akpm@osdl.org
Subject: [patch 36/36] drivers/scsi/dpt_i2o.c: remove dead code
Date: Tue, 10 Oct 2006 14:42:06 -0700
Message-ID: <200610102142.k9ALg6Ck025493@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:63651 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1030535AbWJJVxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Oct 2006 17:53:52 -0400
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
 1 files changed, 2 deletions(-)

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
