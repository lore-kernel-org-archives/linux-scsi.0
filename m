From: domen@coderock.org
Subject: [patch 06/11] drivers/scsi/aacraid/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 23:27:08 +0100
Message-ID: <20050306222708.7984B1ED3D@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:56238 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261527AbVCFW1j (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, c.lucas@ifrance.com


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/aacraid/linit.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/aacraid/linit.c~pci_register_driver-drivers_scsi_aacraid drivers/scsi/aacraid/linit.c
--- kj/drivers/scsi/aacraid/linit.c~pci_register_driver-drivers_scsi_aacraid	2005-03-05 16:12:51.000000000 +0100
+++ kj-domen/drivers/scsi/aacraid/linit.c	2005-03-05 16:12:51.000000000 +0100
@@ -690,7 +690,7 @@ static int __init aac_init(void)
 	printk(KERN_INFO "Red Hat/Adaptec aacraid driver (%s %s)\n",
 			AAC_DRIVER_VERSION, AAC_DRIVER_BUILD_DATE);
 
-	error = pci_module_init(&aac_pci_driver);
+	error = pci_register_driver(&aac_pci_driver);
 	if (error)
 		return error;
 
_
