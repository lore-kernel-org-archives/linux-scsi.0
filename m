From: akpm@linux-foundation.org
Subject: [patch 3/5] drivers/scsi/dmx3191d.c: convert to module_pci_driver
Date: Fri, 13 Sep 2013 14:52:28 -0700
Message-ID: <20130913215228.5D5BE31C1EA@corp2gmr1-1.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:52077 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab3IMVw3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Sep 2013 17:52:29 -0400
Received: by mail-yh0-f74.google.com with SMTP id c41so227580yho.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2013 14:52:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, clbchenlibo.chen@huawei.com

From: Libo Chen <clbchenlibo.chen@huawei.com>
Subject: drivers/scsi/dmx3191d.c: convert to module_pci_driver

Signed-off-by: Libo Chen <libo.chen@huawei.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/dmx3191d.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff -puN drivers/scsi/dmx3191d.c~drivers-scsi-dmx3191d-convert-to-module_pci_driver drivers/scsi/dmx3191d.c
--- a/drivers/scsi/dmx3191d.c~drivers-scsi-dmx3191d-convert-to-module_pci_driver
+++ a/drivers/scsi/dmx3191d.c
@@ -153,18 +153,7 @@ static struct pci_driver dmx3191d_pci_dr
 	.remove		= dmx3191d_remove_one,
 };
 
-static int __init dmx3191d_init(void)
-{
-	return pci_register_driver(&dmx3191d_pci_driver);
-}
-
-static void __exit dmx3191d_exit(void)
-{
-	pci_unregister_driver(&dmx3191d_pci_driver);
-}
-
-module_init(dmx3191d_init);
-module_exit(dmx3191d_exit);
+module_pci_driver(dmx3191d_pci_driver);
 
 MODULE_AUTHOR("Massimo Piccioni <dafastidio@libero.it>");
 MODULE_DESCRIPTION("Domex DMX3191D SCSI driver");
_
