From: domen@coderock.org
Subject: [patch 08/11] drivers/scsi/megaraid/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 23:27:14 +0100
Message-ID: <20050306222714.B10981F203@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:60334 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261533AbVCFW1r (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:47 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, c.lucas@ifrance.com


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/megaraid/megaraid_mbox.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/megaraid/megaraid_mbox.c~pci_register_driver-drivers_scsi_megaraid drivers/scsi/megaraid/megaraid_mbox.c
--- kj/drivers/scsi/megaraid/megaraid_mbox.c~pci_register_driver-drivers_scsi_megaraid	2005-03-05 16:12:52.000000000 +0100
+++ kj-domen/drivers/scsi/megaraid/megaraid_mbox.c	2005-03-05 16:12:52.000000000 +0100
@@ -539,7 +539,7 @@ megaraid_init(void)
 
 
 	// register as a PCI hot-plug driver module
-	if ((rval = pci_module_init(&megaraid_pci_driver_g))) {
+	if ((rval = pci_register_driver(&megaraid_pci_driver_g))) {
 		con_log(CL_ANN, (KERN_WARNING
 			"megaraid: could not register hotplug support.\n"));
 	}
_
