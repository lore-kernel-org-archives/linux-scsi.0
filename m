From: akpm@linux-foundation.org
Subject: [patch 2/5] drivers/scsi/dc395x.c: convert to module_pci_driver
Date: Fri, 13 Sep 2013 14:52:27 -0700
Message-ID: <20130913215227.71B325A41B2@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:47864 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852Ab3IMWAR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 18:00:17 -0400
Received: by mail-yh0-f74.google.com with SMTP id c41so228657yho.5
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 15:00:17 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, clbchenlibo.chen@huawei.com

From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/scsi/dc395x.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dc395x.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff -puN drivers/scsi/dc395x.c~drivers-scsi-dc395x-convert-to-module_pci_driver drivers/scsi/dc395x.c
--- a/drivers/scsi/dc395x.c~drivers-scsi-dc395x-convert-to-module_pci_driver
+++ a/drivers/scsi/dc395x.c
@@ -4882,29 +4882,7 @@ static struct pci_driver dc395x_driver =
 	.remove         = dc395x_remove_one,
 };
 
-
-/**
- * dc395x_module_init - Module initialization function
- *
- * Used by both module and built-in driver to initialise this driver.
- **/
-static int __init dc395x_module_init(void)
-{
-	return pci_register_driver(&dc395x_driver);
-}
-
-
-/**
- * dc395x_module_exit - Module cleanup function.
- **/
-static void __exit dc395x_module_exit(void)
-{
-	pci_unregister_driver(&dc395x_driver);
-}
-
-
-module_init(dc395x_module_init);
-module_exit(dc395x_module_exit);
+module_pci_driver(dc395x_driver);
 
 MODULE_AUTHOR("C.L. Huang / Erich Chen / Kurt Garloff");
 MODULE_DESCRIPTION("SCSI host adapter driver for Tekram TRM-S1040 based adapters: Tekram DC395 and DC315 series");
_
