From: domen@coderock.org
Subject: [patch 05/11] drivers/scsi/*: convert to pci_register_driver
Date: Sun, 06 Mar 2005 23:27:04 +0100
Message-ID: <20050306222705.3AADE1EC90@trashy.coderock.org>
Received: from coderock.org ([193.77.147.115]:54702 "EHLO trashy.coderock.org")
	by vger.kernel.org with ESMTP id S261526AbVCFW1e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2005 17:27:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org, domen@coderock.org, c.lucas@ifrance.com


convert from pci_module_init to pci_register_driver
(from:http://kerneljanitors.org/TODO).

Signed-off-by: Christophe Lucas <c.lucas@ifrance.com>
Signed-off-by: Domen Puncer <domen@coderock.org>
---


 kj-domen/drivers/scsi/3w-9xxx.c      |    2 +-
 kj-domen/drivers/scsi/3w-xxxx.c      |    2 +-
 kj-domen/drivers/scsi/a100u2w.c      |    2 +-
 kj-domen/drivers/scsi/ahci.c         |    2 +-
 kj-domen/drivers/scsi/ata_piix.c     |    2 +-
 kj-domen/drivers/scsi/atp870u.c      |    2 +-
 kj-domen/drivers/scsi/dc395x.c       |    2 +-
 kj-domen/drivers/scsi/dmx3191d.c     |    2 +-
 kj-domen/drivers/scsi/ipr.c          |    2 +-
 kj-domen/drivers/scsi/ips.c          |    2 +-
 kj-domen/drivers/scsi/megaraid.c     |    2 +-
 kj-domen/drivers/scsi/nsp32.c        |    2 +-
 kj-domen/drivers/scsi/qla1280.c      |    2 +-
 kj-domen/drivers/scsi/qlogicisp.c    |    2 +-
 kj-domen/drivers/scsi/sata_nv.c      |    2 +-
 kj-domen/drivers/scsi/sata_promise.c |    2 +-
 kj-domen/drivers/scsi/sata_sil.c     |    2 +-
 kj-domen/drivers/scsi/sata_sis.c     |    2 +-
 kj-domen/drivers/scsi/sata_svw.c     |    2 +-
 kj-domen/drivers/scsi/sata_sx4.c     |    2 +-
 kj-domen/drivers/scsi/sata_uli.c     |    2 +-
 kj-domen/drivers/scsi/sata_via.c     |    2 +-
 kj-domen/drivers/scsi/sata_vsc.c     |    2 +-
 kj-domen/drivers/scsi/tmscsim.c      |    2 +-
 24 files changed, 24 insertions(+), 24 deletions(-)

diff -puN drivers/scsi/3w-9xxx.c~pci_register_driver-drivers_scsi drivers/scsi/3w-9xxx.c
--- kj/drivers/scsi/3w-9xxx.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/3w-9xxx.c	2005-03-05 16:12:48.000000000 +0100
@@ -2141,7 +2141,7 @@ static int __init twa_init(void)
 {
 	printk(KERN_WARNING "3ware 9000 Storage Controller device driver for Linux v%s.\n", twa_driver_version);
 
-	return pci_module_init(&twa_driver);
+	return pci_register_driver(&twa_driver);
 } /* End twa_init() */
 
 /* This function is called on driver exit */
diff -puN drivers/scsi/3w-xxxx.c~pci_register_driver-drivers_scsi drivers/scsi/3w-xxxx.c
--- kj/drivers/scsi/3w-xxxx.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/3w-xxxx.c	2005-03-05 16:12:48.000000000 +0100
@@ -2486,7 +2486,7 @@ static int __init tw_init(void)
 {
 	printk(KERN_WARNING "3ware Storage Controller device driver for Linux v%s.\n", TW_DRIVER_VERSION);
 
-	return pci_module_init(&tw_driver);
+	return pci_register_driver(&tw_driver);
 } /* End tw_init() */
 
 /* This function is called on driver exit */
diff -puN drivers/scsi/a100u2w.c~pci_register_driver-drivers_scsi drivers/scsi/a100u2w.c
--- kj/drivers/scsi/a100u2w.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/a100u2w.c	2005-03-05 16:12:48.000000000 +0100
@@ -1186,7 +1186,7 @@ static struct pci_driver inia100_pci_dri
 
 static int __init inia100_init(void)
 {
-	return pci_module_init(&inia100_pci_driver);
+	return pci_register_driver(&inia100_pci_driver);
 }
 
 static void __exit inia100_exit(void)
diff -puN drivers/scsi/ahci.c~pci_register_driver-drivers_scsi drivers/scsi/ahci.c
--- kj/drivers/scsi/ahci.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/ahci.c	2005-03-05 16:12:48.000000000 +0100
@@ -1036,7 +1036,7 @@ err_out:
 
 static int __init ahci_init(void)
 {
-	return pci_module_init(&ahci_pci_driver);
+	return pci_register_driver(&ahci_pci_driver);
 }
 
 
diff -puN drivers/scsi/ata_piix.c~pci_register_driver-drivers_scsi drivers/scsi/ata_piix.c
--- kj/drivers/scsi/ata_piix.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/ata_piix.c	2005-03-05 16:12:48.000000000 +0100
@@ -662,7 +662,7 @@ static int __init piix_init(void)
 	int rc;
 
 	DPRINTK("pci_module_init\n");
-	rc = pci_module_init(&piix_pci_driver);
+	rc = pci_register_driver(&piix_pci_driver);
 	if (rc)
 		return rc;
 
diff -puN drivers/scsi/atp870u.c~pci_register_driver-drivers_scsi drivers/scsi/atp870u.c
--- kj/drivers/scsi/atp870u.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/atp870u.c	2005-03-05 16:12:48.000000000 +0100
@@ -2721,7 +2721,7 @@ static struct pci_driver atp870u_driver 
 
 static int __init atp870u_init(void)
 {
-	return pci_module_init(&atp870u_driver);
+	return pci_register_driver(&atp870u_driver);
 }
 
 static void __exit atp870u_exit(void)
diff -puN drivers/scsi/dc395x.c~pci_register_driver-drivers_scsi drivers/scsi/dc395x.c
--- kj/drivers/scsi/dc395x.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/dc395x.c	2005-03-05 16:12:48.000000000 +0100
@@ -4898,7 +4898,7 @@ static struct pci_driver dc395x_driver =
  **/
 static int __init dc395x_module_init(void)
 {
-	return pci_module_init(&dc395x_driver);
+	return pci_register_driver(&dc395x_driver);
 }
 
 
diff -puN drivers/scsi/dmx3191d.c~pci_register_driver-drivers_scsi drivers/scsi/dmx3191d.c
--- kj/drivers/scsi/dmx3191d.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/dmx3191d.c	2005-03-05 16:12:48.000000000 +0100
@@ -157,7 +157,7 @@ static struct pci_driver dmx3191d_pci_dr
 
 static int __init dmx3191d_init(void)
 {
-	return pci_module_init(&dmx3191d_pci_driver);
+	return pci_register_driver(&dmx3191d_pci_driver);
 }
 
 static void __exit dmx3191d_exit(void)
diff -puN drivers/scsi/ipr.c~pci_register_driver-drivers_scsi drivers/scsi/ipr.c
--- kj/drivers/scsi/ipr.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/ipr.c	2005-03-05 16:12:48.000000000 +0100
@@ -6031,7 +6031,7 @@ static int __init ipr_init(void)
 	ipr_info("IBM Power RAID SCSI Device Driver version: %s %s\n",
 		 IPR_DRIVER_VERSION, IPR_DRIVER_DATE);
 
-	return pci_module_init(&ipr_driver);
+	return pci_register_driver(&ipr_driver);
 }
 
 /**
diff -puN drivers/scsi/ips.c~pci_register_driver-drivers_scsi drivers/scsi/ips.c
--- kj/drivers/scsi/ips.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/ips.c	2005-03-05 16:12:49.000000000 +0100
@@ -7084,7 +7084,7 @@ ips_remove_device(struct pci_dev *pci_de
 static int __init
 ips_module_init(void)
 {
-	if (pci_module_init(&ips_pci_driver) < 0)
+	if (pci_register_driver(&ips_pci_driver) < 0)
 		return -ENODEV;
 	ips_driver_template.module = THIS_MODULE;
 	ips_order_controllers();
diff -puN drivers/scsi/megaraid.c~pci_register_driver-drivers_scsi drivers/scsi/megaraid.c
--- kj/drivers/scsi/megaraid.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/megaraid.c	2005-03-05 16:12:49.000000000 +0100
@@ -5079,7 +5079,7 @@ static int __init megaraid_init(void)
 				"megaraid: failed to create megaraid root\n");
 	}
 #endif
-	error = pci_module_init(&megaraid_pci_driver);
+	error = pci_register_driver(&megaraid_pci_driver);
 	if (error) {
 #ifdef CONFIG_PROC_FS
 		remove_proc_entry("megaraid", &proc_root);
diff -puN drivers/scsi/nsp32.c~pci_register_driver-drivers_scsi drivers/scsi/nsp32.c
--- kj/drivers/scsi/nsp32.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/nsp32.c	2005-03-05 16:12:49.000000000 +0100
@@ -3571,7 +3571,7 @@ static struct pci_driver nsp32_driver = 
  */
 static int __init init_nsp32(void) {
 	nsp32_msg(KERN_INFO, "loading...");
-	return pci_module_init(&nsp32_driver);
+	return pci_register_driver(&nsp32_driver);
 }
 
 static void __exit exit_nsp32(void) {
diff -puN drivers/scsi/qla1280.c~pci_register_driver-drivers_scsi drivers/scsi/qla1280.c
--- kj/drivers/scsi/qla1280.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/qla1280.c	2005-03-05 16:12:49.000000000 +0100
@@ -4944,7 +4944,7 @@ qla1280_init(void)
 		qla1280_setup(qla1280);
 #endif
 
-	return pci_module_init(&qla1280_pci_driver);
+	return pci_register_driver(&qla1280_pci_driver);
 }
 
 static void __exit
diff -puN drivers/scsi/qlogicisp.c~pci_register_driver-drivers_scsi drivers/scsi/qlogicisp.c
--- kj/drivers/scsi/qlogicisp.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/qlogicisp.c	2005-03-05 16:12:49.000000000 +0100
@@ -666,7 +666,7 @@ int isp1020_detect(Scsi_Host_Template *t
 
 	tmpt->proc_name = "isp1020";
 
-	while ((pdev = pci_find_device(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020, pdev)))
+	while ((pdev = pci_get_device(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020, pdev)))
 	{
 		if (pci_enable_device(pdev))
 			continue;
diff -puN drivers/scsi/sata_nv.c~pci_register_driver-drivers_scsi drivers/scsi/sata_nv.c
--- kj/drivers/scsi/sata_nv.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_nv.c	2005-03-05 16:12:49.000000000 +0100
@@ -555,7 +555,7 @@ static void nv_check_hotplug_ck804(struc
 
 static int __init nv_init(void)
 {
-	return pci_module_init(&nv_pci_driver);
+	return pci_register_driver(&nv_pci_driver);
 }
 
 static void __exit nv_exit(void)
diff -puN drivers/scsi/sata_promise.c~pci_register_driver-drivers_scsi drivers/scsi/sata_promise.c
--- kj/drivers/scsi/sata_promise.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_promise.c	2005-03-05 16:12:49.000000000 +0100
@@ -661,7 +661,7 @@ err_out:
 
 static int __init pdc_ata_init(void)
 {
-	return pci_module_init(&pdc_ata_pci_driver);
+	return pci_register_driver(&pdc_ata_pci_driver);
 }
 
 
diff -puN drivers/scsi/sata_sil.c~pci_register_driver-drivers_scsi drivers/scsi/sata_sil.c
--- kj/drivers/scsi/sata_sil.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_sil.c	2005-03-05 16:12:49.000000000 +0100
@@ -450,7 +450,7 @@ err_out:
 
 static int __init sil_init(void)
 {
-	return pci_module_init(&sil_pci_driver);
+	return pci_register_driver(&sil_pci_driver);
 }
 
 static void __exit sil_exit(void)
diff -puN drivers/scsi/sata_sis.c~pci_register_driver-drivers_scsi drivers/scsi/sata_sis.c
--- kj/drivers/scsi/sata_sis.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_sis.c	2005-03-05 16:12:49.000000000 +0100
@@ -272,7 +272,7 @@ err_out:
 
 static int __init sis_init(void)
 {
-	return pci_module_init(&sis_pci_driver);
+	return pci_register_driver(&sis_pci_driver);
 }
 
 static void __exit sis_exit(void)
diff -puN drivers/scsi/sata_svw.c~pci_register_driver-drivers_scsi drivers/scsi/sata_svw.c
--- kj/drivers/scsi/sata_svw.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_svw.c	2005-03-05 16:12:49.000000000 +0100
@@ -462,7 +462,7 @@ static struct pci_driver k2_sata_pci_dri
 
 static int __init k2_sata_init(void)
 {
-	return pci_module_init(&k2_sata_pci_driver);
+	return pci_register_driver(&k2_sata_pci_driver);
 }
 
 
diff -puN drivers/scsi/sata_sx4.c~pci_register_driver-drivers_scsi drivers/scsi/sata_sx4.c
--- kj/drivers/scsi/sata_sx4.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_sx4.c	2005-03-05 16:12:49.000000000 +0100
@@ -1482,7 +1482,7 @@ err_out:
 
 static int __init pdc_sata_init(void)
 {
-	return pci_module_init(&pdc_sata_pci_driver);
+	return pci_register_driver(&pdc_sata_pci_driver);
 }
 
 
diff -puN drivers/scsi/sata_uli.c~pci_register_driver-drivers_scsi drivers/scsi/sata_uli.c
--- kj/drivers/scsi/sata_uli.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_uli.c	2005-03-05 16:12:49.000000000 +0100
@@ -273,7 +273,7 @@ err_out:
 
 static int __init uli_init(void)
 {
-	return pci_module_init(&uli_pci_driver);
+	return pci_register_driver(&uli_pci_driver);
 }
 
 static void __exit uli_exit(void)
diff -puN drivers/scsi/sata_via.c~pci_register_driver-drivers_scsi drivers/scsi/sata_via.c
--- kj/drivers/scsi/sata_via.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_via.c	2005-03-05 16:12:49.000000000 +0100
@@ -373,7 +373,7 @@ err_out:
 
 static int __init svia_init(void)
 {
-	return pci_module_init(&svia_pci_driver);
+	return pci_register_driver(&svia_pci_driver);
 }
 
 static void __exit svia_exit(void)
diff -puN drivers/scsi/sata_vsc.c~pci_register_driver-drivers_scsi drivers/scsi/sata_vsc.c
--- kj/drivers/scsi/sata_vsc.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/sata_vsc.c	2005-03-05 16:12:49.000000000 +0100
@@ -385,7 +385,7 @@ static struct pci_driver vsc_sata_pci_dr
 
 static int __init vsc_sata_init(void)
 {
-	return pci_module_init(&vsc_sata_pci_driver);
+	return pci_register_driver(&vsc_sata_pci_driver);
 }
 
 
diff -puN drivers/scsi/tmscsim.c~pci_register_driver-drivers_scsi drivers/scsi/tmscsim.c
--- kj/drivers/scsi/tmscsim.c~pci_register_driver-drivers_scsi	2005-03-05 16:12:48.000000000 +0100
+++ kj-domen/drivers/scsi/tmscsim.c	2005-03-05 16:12:49.000000000 +0100
@@ -2659,7 +2659,7 @@ static int __init dc390_module_init(void
 		printk (KERN_INFO "DC390: Using safe settings.\n");
 	}
 
-	return pci_module_init(&dc390_driver);
+	return pci_register_driver(&dc390_driver);
 }
 
 static void __exit dc390_module_exit(void)
_
