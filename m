From: akpm@linux-foundation.org
Subject: [patch 4/5] drivers/scsi/initio.c: convert to module_pci_driver
Date: Fri, 13 Sep 2013 14:52:28 -0700
Message-ID: <20130913215229.47AAF5A427E@corp2gmr1-2.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f73.google.com ([209.85.213.73]:43296 "EHLO
	mail-yh0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137Ab3IMVwa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 17:52:30 -0400
Received: by mail-yh0-f73.google.com with SMTP id z20so227993yhz.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 14:52:29 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, clbchenlibo.chen@huawei.com

From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/scsi/initio.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/initio.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/scsi/initio.c~drivers-scsi-initio-convert-to-module_pci_driver drivers/scsi/initio.c
--- a/drivers/scsi/initio.c~drivers-scsi-initio-convert-to-module_pci_driver
+++ a/drivers/scsi/initio.c
@@ -2995,19 +2995,8 @@ static struct pci_driver initio_pci_driv
 	.remove		= initio_remove_one,
 };
 
-static int __init initio_init_driver(void)
-{
-	return pci_register_driver(&initio_pci_driver);
-}
-
-static void __exit initio_exit_driver(void)
-{
-	pci_unregister_driver(&initio_pci_driver);
-}
+module_pci_driver(initio_pci_driver);
 
 MODULE_DESCRIPTION("Initio INI-9X00U/UW SCSI device driver");
 MODULE_AUTHOR("Initio Corporation");
 MODULE_LICENSE("GPL");
-
-module_init(initio_init_driver);
-module_exit(initio_exit_driver);
_
