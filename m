From: Venkatraman S <svenkatr@ti.com>
Subject: [PATCH RESEND 1/3] drivers/scsi/ufs: use module_pci_driver
Date: Tue, 10 Jul 2012 19:39:22 +0530
Message-ID: <1341929364-9122-2-git-send-email-svenkatr@ti.com>
References: <1341929364-9122-1-git-send-email-svenkatr@ti.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:47120 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab2GJOKw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jul 2012 10:10:52 -0400
In-Reply-To: <1341929364-9122-1-git-send-email-svenkatr@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, Venkatraman S <svenkatr@ti.com>, "James E.J. Bottomley" <JBottomley@parallels.com>

Use macro module_pci_driver and get rid of boilerplate code.  No
functional changes.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/scsi/ufs/ufshcd.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a4fd00..40c43bf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1953,24 +1953,7 @@ static struct pci_driver ufshcd_pci_driver = {
 #endif
 };
 
-/**
- * ufshcd_init - Driver registration routine
- */
-static int __init ufshcd_init(void)
-{
-	return pci_register_driver(&ufshcd_pci_driver);
-}
-module_init(ufshcd_init);
-
-/**
- * ufshcd_exit - Driver exit clean-up routine
- */
-static void __exit ufshcd_exit(void)
-{
-	pci_unregister_driver(&ufshcd_pci_driver);
-}
-module_exit(ufshcd_exit);
-
+module_pci_driver(ufshcd_pci_driver);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>, "
 	      "Vinayak Holikatti <h.vinayak@samsung.com>");
-- 
1.7.0.4

