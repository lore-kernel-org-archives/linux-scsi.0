From: akpm@linux-foundation.org
Subject: [patch 1/5] drivers/scsi/ufs: use module_pci_driver
Date: Fri, 04 May 2012 14:35:08 -0700
Message-ID: <20120504213509.00704A0367@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:60476 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759933Ab2EDVfL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 May 2012 17:35:11 -0400
Received: by eaaq10 with SMTP id q10so173101eaa.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 May 2012 14:35:09 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, svenkatr@ti.com, JBottomley@parallels.com, santoshsy@gmail.com

From: Venkatraman S <svenkatr@ti.com>
Subject: drivers/scsi/ufs: use module_pci_driver

Use macro module_pci_driver and get rid of boilerplate code.  No
functional changes.

Signed-off-by: Venkatraman S <svenkatr@ti.com>
Acked-by: Santosh Y <santoshsy@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ufs/ufshcd.c |   19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff -puN drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-use-module_pci_driver drivers/scsi/ufs/ufshcd.c
--- a/drivers/scsi/ufs/ufshcd.c~drivers-scsi-ufs-use-module_pci_driver
+++ a/drivers/scsi/ufs/ufshcd.c
@@ -1952,24 +1952,7 @@ static struct pci_driver ufshcd_pci_driv
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
_
