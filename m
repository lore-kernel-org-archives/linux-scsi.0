From: akpm@linux-foundation.org
Subject: [patch 5/5] drivers/scsi/mvumi.c: convert to module_pci_driver
Date: Fri, 13 Sep 2013 14:52:29 -0700
Message-ID: <20130913215230.33DCE5A41B2@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:53392 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756141Ab3IMVwb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 17:52:31 -0400
Received: by mail-yh0-f73.google.com with SMTP id z20so228290yhz.2
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 14:52:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, clbchenlibo.chen@huawei.com

From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/scsi/mvumi.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mvumi.c |   20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff -puN drivers/scsi/mvumi.c~drivers-scsi-mvumi-convert-to-module_pci_driver drivers/scsi/mvumi.c
--- a/drivers/scsi/mvumi.c~drivers-scsi-mvumi-convert-to-module_pci_driver
+++ a/drivers/scsi/mvumi.c
@@ -2735,22 +2735,4 @@ static struct pci_driver mvumi_pci_drive
 #endif
 };
 
-/**
- * mvumi_init - Driver load entry point
- */
-static int __init mvumi_init(void)
-{
-	return pci_register_driver(&mvumi_pci_driver);
-}
-
-/**
- * mvumi_exit - Driver unload entry point
- */
-static void __exit mvumi_exit(void)
-{
-
-	pci_unregister_driver(&mvumi_pci_driver);
-}
-
-module_init(mvumi_init);
-module_exit(mvumi_exit);
+module_pci_driver(mvumi_pci_driver);
_
