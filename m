From: domen@coderock.org
Subject: [patch 07/11] drivers/scsi/aic7xxx/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 23:27:11 +0100
Message-ID: <20050306222711.A56F91F201@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:57774 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261531AbVCFW1m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, c.lucas@ifrance.com


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/aic7xxx/aic79xx_osm_pci.c |    2 +-
 kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN drivers/scsi/aic7xxx/aic79xx_osm_pci.c~pci_register_driver-drivers_scsi_aic7xxx drivers/scsi/aic7xxx/aic79xx_osm_pci.c
--- kj/drivers/scsi/aic7xxx/aic79xx_osm_pci.c~pci_register_driver-drivers_scsi_aic7xxx	2005-03-05 16:12:51.000000000 +0100
+++ kj-domen/drivers/scsi/aic7xxx/aic79xx_osm_pci.c	2005-03-05 16:12:52.000000000 +0100
@@ -209,7 +209,7 @@ ahd_linux_pci_dev_probe(struct pci_dev *
 int
 ahd_linux_pci_init(void)
 {
-	return (pci_module_init(&aic79xx_pci_driver));
+	return (pci_register_driver(&aic79xx_pci_driver));
 }
 
 void
diff -puN drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~pci_register_driver-drivers_scsi_aic7xxx drivers/scsi/aic7xxx/aic7xxx_osm_pci.c
--- kj/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c~pci_register_driver-drivers_scsi_aic7xxx	2005-03-05 16:12:51.000000000 +0100
+++ kj-domen/drivers/scsi/aic7xxx/aic7xxx_osm_pci.c	2005-03-05 16:12:52.000000000 +0100
@@ -252,7 +252,7 @@ int
 ahc_linux_pci_init(void)
 {
 	/* Translate error or zero return into zero or one */
-	return pci_module_init(&aic7xxx_pci_driver) ? 0 : 1;
+	return pci_register_driver(&aic7xxx_pci_driver) ? 0 : 1;
 }
 
 void
_
