From: domen@coderock.org
Subject: [patch 09/11] drivers/scsi/sym53c8xx_2/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 23:27:17 +0100
Message-ID: <20050306222717.C0F441F205@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:59566 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261532AbVCFW1q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, c.lucas@ifrance.com


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/sym53c8xx_2/sym_glue.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~pci_register_driver-drivers_scsi_sym53c8xx_2 drivers/scsi/sym53c8xx_2/sym_glue.c
--- kj/drivers/scsi/sym53c8xx_2/sym_glue.c~pci_register_driver-drivers_scsi_sym53c8xx_2	2005-03-05 16:12:54.000000000 +0100
+++ kj-domen/drivers/scsi/sym53c8xx_2/sym_glue.c	2005-03-05 16:12:55.000000000 +0100
@@ -2370,7 +2370,7 @@ static int __init sym2_init(void)
 	if (!sym2_transport_template)
 		return -ENODEV;
 
-	error = pci_module_init(&sym2_driver);
+	error = pci_register_driver(&sym2_driver);
 	if (error)
 		spi_release_transport(sym2_transport_template);
 	return error;
_
