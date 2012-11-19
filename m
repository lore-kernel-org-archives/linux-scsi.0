From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 319/493] scsi: remove use of __devinitdata
Date: Mon, 19 Nov 2012 13:24:28 -0500
Message-ID: <1353349642-3677-319-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:42028 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab2KSSsB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:48:01 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, "Juergen E. Fischer" <fischer@norbit.de>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, dc395x@twibble.org

CONFIG_HOTPLUG is going away as an option so __devinitdata is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com> 
Cc: Matthew Wilcox <matthew@wil.cx> 
Cc: "Juergen E. Fischer" <fischer@norbit.de> 
Cc: Oliver Neukum <oliver@neukum.org> 
Cc: Ali Akcaagac <aliakc@web.de> 
Cc: Jamie Lenehan <lenehan@twibble.org> 
Cc: GOTO Masanori <gotom@debian.or.jp> 
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp> 
Cc: Kurt Garloff <garloff@suse.de> 
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de> 
Cc: linux-scsi@vger.kernel.org 
Cc: dc395x@twibble.org 
---
 drivers/scsi/3w-9xxx.c              |  2 +-
 drivers/scsi/3w-sas.c               |  2 +-
 drivers/scsi/3w-xxxx.c              |  2 +-
 drivers/scsi/BusLogic.c             |  2 +-
 drivers/scsi/NCR_D700.c             |  2 +-
 drivers/scsi/a2091.c                |  2 +-
 drivers/scsi/advansys.c             | 16 ++++++++--------
 drivers/scsi/aha152x.c              |  2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c   |  2 +-
 drivers/scsi/bnx2i/bnx2i_init.c     |  2 +-
 drivers/scsi/dc395x.c               |  4 ++--
 drivers/scsi/fdomain.c              |  2 +-
 drivers/scsi/g_NCR5380.c            |  2 +-
 drivers/scsi/gvp11.c                |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c      |  2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.c    |  2 +-
 drivers/scsi/ibmvscsi/ibmvstgt.c    |  2 +-
 drivers/scsi/ipr.c                  |  2 +-
 drivers/scsi/mvsas/mv_init.c        |  2 +-
 drivers/scsi/nsp32.c                |  2 +-
 drivers/scsi/pm8001/pm8001_init.c   |  2 +-
 drivers/scsi/pmcraid.c              |  2 +-
 drivers/scsi/sym53c416.c            |  2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |  2 +-
 drivers/scsi/tmscsim.c              |  2 +-
 drivers/scsi/zorro7xx.c             |  4 ++--
 26 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 78c1fcc..d1f0120 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2305,7 +2305,7 @@ out_disable_device:
 #endif
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id twa_pci_tbl[] __devinitdata = {
+static struct pci_device_id twa_pci_tbl[] = {
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 7b97f52..52a2f058 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1893,7 +1893,7 @@ out_disable_device:
 #endif
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id twl_pci_tbl[] __devinitdata = {
+static struct pci_device_id twl_pci_tbl[] = {
 	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9750) },
 	{ }
 };
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 601546b..62071d2 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2422,7 +2422,7 @@ static void tw_remove(struct pci_dev *pdev)
 } /* End tw_remove() */
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id tw_pci_tbl[] __devinitdata = {
+static struct pci_device_id tw_pci_tbl[] = {
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_1000,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_7000,
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index d4da370..d7ca247 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3615,7 +3615,7 @@ static void __exit BusLogic_exit(void)
 __setup("BusLogic=", BusLogic_Setup);
 
 #ifdef MODULE
-static struct pci_device_id BusLogic_pci_tbl[] __devinitdata = {
+static struct pci_device_id BusLogic_pci_tbl[] = {
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC,
diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 37028d3..86b3533 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -114,7 +114,7 @@ MODULE_DESCRIPTION("NCR Dual700 SCSI Driver");
 MODULE_LICENSE("GPL");
 module_param(NCR_D700, charp, 0);
 
-static __u8 __devinitdata id_array[2*(MCA_MAX_SLOT_NR + 1)] =
+static __u8 id_array[2*(MCA_MAX_SLOT_NR + 1)] =
 	{ [0 ... 2*(MCA_MAX_SLOT_NR + 1)-1] = 7 };
 
 #ifdef MODULE
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 78f1035..7c6e9aa 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -251,7 +251,7 @@ static void __devexit a2091_remove(struct zorro_dev *z)
 	release_mem_region(z->resource.start, 256);
 }
 
-static struct zorro_device_id a2091_zorro_tbl[] __devinitdata = {
+static struct zorro_device_id a2091_zorro_tbl[] = {
 	{ ZORRO_PROD_CBM_A590_A2091_1 },
 	{ ZORRO_PROD_CBM_A590_A2091_2 },
 	{ 0 }
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 286db72..409e2a4 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -10383,7 +10383,7 @@ static int AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
  * on big-endian platforms so char fields read as words are actually being
  * unswapped on big-endian platforms.
  */
-static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __devinitdata = {
+static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config = {
 	ADV_EEPROM_BIOS_ENABLE,	/* cfg_lsw */
 	0x0000,			/* cfg_msw */
 	0xFFFF,			/* disc_enable */
@@ -10421,7 +10421,7 @@ static ADVEEP_3550_CONFIG Default_3550_EEPROM_Config __devinitdata = {
 	0			/* num_of_err */
 };
 
-static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __devinitdata = {
+static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar = {
 	0,			/* cfg_lsw */
 	0,			/* cfg_msw */
 	0,			/* -disc_enable */
@@ -10459,7 +10459,7 @@ static ADVEEP_3550_CONFIG ADVEEP_3550_Config_Field_IsChar __devinitdata = {
 	0			/* num_of_err */
 };
 
-static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __devinitdata = {
+static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config = {
 	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
 	0x0000,			/* 01 cfg_msw */
 	0xFFFF,			/* 02 disc_enable */
@@ -10524,7 +10524,7 @@ static ADVEEP_38C0800_CONFIG Default_38C0800_EEPROM_Config __devinitdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __devinitdata = {
+static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar = {
 	0,			/* 00 cfg_lsw */
 	0,			/* 01 cfg_msw */
 	0,			/* 02 disc_enable */
@@ -10589,7 +10589,7 @@ static ADVEEP_38C0800_CONFIG ADVEEP_38C0800_Config_Field_IsChar __devinitdata =
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __devinitdata = {
+static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config = {
 	ADV_EEPROM_BIOS_ENABLE,	/* 00 cfg_lsw */
 	0x0000,			/* 01 cfg_msw */
 	0xFFFF,			/* 02 disc_enable */
@@ -10654,7 +10654,7 @@ static ADVEEP_38C1600_CONFIG Default_38C1600_EEPROM_Config __devinitdata = {
 	0			/* 63 reserved */
 };
 
-static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar __devinitdata = {
+static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Config_Field_IsChar = {
 	0,			/* 00 cfg_lsw */
 	0,			/* 01 cfg_msw */
 	0,			/* 02 disc_enable */
@@ -12568,7 +12568,7 @@ static struct isa_driver advansys_vlb_driver = {
 	},
 };
 
-static struct eisa_device_id advansys_eisa_table[] __devinitdata = {
+static struct eisa_device_id advansys_eisa_table[] = {
 	{ "ABP7401" },
 	{ "ABP7501" },
 	{ "" }
@@ -12706,7 +12706,7 @@ static struct eisa_driver advansys_eisa_driver = {
 };
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id advansys_pci_tbl[] __devinitdata = {
+static struct pci_device_id advansys_pci_tbl[] = {
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_ABP940,
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index dd4547b..a284be1 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -420,7 +420,7 @@ MODULE_PARM_DESC(aha152x1, "parameters for second controller");
 #endif /* MODULE */
 
 #ifdef __ISAPNP__
-static struct isapnp_device_id id_table[] __devinitdata = {
+static struct isapnp_device_id id_table[] = {
 	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1502), 0 },
 	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1505), 0 },
 	{ ISAPNP_ANY_ID, ISAPNP_ANY_ID,	ISAPNP_VENDOR('A', 'D', 'P'), ISAPNP_FUNCTION(0x1510), 0 },
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e055865..70ecd95 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -25,7 +25,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 #define DRV_MODULE_RELDATE	"Jun 04, 2012"
 
 
-static char version[] __devinitdata =
+static char version[] =
 		"Broadcom NetXtreme II FCoE Driver " DRV_MODULE_NAME \
 		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index b17637a..c7fc1ed0 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -21,7 +21,7 @@ static u32 adapter_count;
 #define DRV_MODULE_VERSION	"2.7.2.2"
 #define DRV_MODULE_RELDATE	"Apr 25, 2012"
 
-static char version[] __devinitdata =
+static char version[] =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
 		" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 2fdf59c..643c568 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -489,7 +489,7 @@ struct ParameterData {
 	int def;		/* default value */
 	int safe;		/* safe value */
 };
-static struct ParameterData __devinitdata cfg_data[] = {
+static struct ParameterData cfg_data[] = {
 	{ /* adapter id */
 		CFG_PARAM_UNSET,
 		0,
@@ -620,7 +620,7 @@ static void fix_settings(void)
  * Mapping from the eeprom delay index value (index into this array)
  * to the number of actual seconds that the delay should be for.
  */
-static char __devinitdata eeprom_index_to_delay_map[] = 
+static char eeprom_index_to_delay_map[] =
 	{ 1, 3, 5, 10, 16, 30, 60, 120 };
 
 
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 1a2a1e5..fff6829 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1771,7 +1771,7 @@ struct scsi_host_template fdomain_driver_template = {
 #ifndef PCMCIA
 #ifdef CONFIG_PCI
 
-static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
+static struct pci_device_id fdomain_pci_tbl[] = {
 	{ PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ }
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 1a5954f..5041f92 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -939,7 +939,7 @@ module_param(dtc_3181e, int, 0);
 MODULE_LICENSE("GPL");
 
 #ifndef SCSI_G_NCR5380_MEM
-static struct isapnp_device_id id_table[] __devinitdata = {
+static struct isapnp_device_id id_table[] = {
 	{
 	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
 	 ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e),
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index dc29c06..ee30759 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -398,7 +398,7 @@ static void __devexit gvp11_remove(struct zorro_dev *z)
 	 * SERIES I though).
 	 */
 
-static struct zorro_device_id gvp11_zorro_tbl[] __devinitdata = {
+static struct zorro_device_id gvp11_zorro_tbl[] = {
 	{ ZORRO_PROD_GVP_COMBO_030_R3_SCSI,	~0x00ffffff },
 	{ ZORRO_PROD_GVP_SERIES_II,		~0x00ffffff },
 	{ ZORRO_PROD_GVP_GFORCE_030_SCSI,	~0x01ffffff },
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 5e8d51b..cc82d0f 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4905,7 +4905,7 @@ static unsigned long ibmvfc_get_desired_dma(struct vio_dev *vdev)
 	return pool_dma + ((512 * 1024) * driver_template.cmd_per_lun);
 }
 
-static struct vio_device_id ibmvfc_device_table[] __devinitdata = {
+static struct vio_device_id ibmvfc_device_table[] = {
 	{"fcp", "IBM,vfc-client"},
 	{ "", "" }
 };
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index ef9a54c..a044f59 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -2362,7 +2362,7 @@ static int ibmvscsi_resume(struct device *dev)
  * ibmvscsi_device_table: Used by vio.c to match devices in the device tree we 
  * support.
  */
-static struct vio_device_id ibmvscsi_device_table[] __devinitdata = {
+static struct vio_device_id ibmvscsi_device_table[] = {
 	{"vscsi", "IBM,v-scsi"},
 	{ "", "" }
 };
diff --git a/drivers/scsi/ibmvscsi/ibmvstgt.c b/drivers/scsi/ibmvscsi/ibmvstgt.c
index aa7ed81..bf9eca8 100644
--- a/drivers/scsi/ibmvscsi/ibmvstgt.c
+++ b/drivers/scsi/ibmvscsi/ibmvstgt.c
@@ -907,7 +907,7 @@ static int ibmvstgt_remove(struct vio_dev *dev)
 	return 0;
 }
 
-static struct vio_device_id ibmvstgt_device_table[] __devinitdata = {
+static struct vio_device_id ibmvstgt_device_table[] = {
 	{"v-scsi-host", "IBM,v-scsi-host"},
 	{"",""}
 };
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 8ac4a30..255ad48 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9217,7 +9217,7 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	wait_event(ioa_cfg->reset_wait_q, !ioa_cfg->in_reset_reload);
 }
 
-static struct pci_device_id ipr_pci_table[] __devinitdata = {
+static struct pci_device_id ipr_pci_table[] = {
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702, 0, 0, 0 },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index efa5f05..830a7da 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -677,7 +677,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	return;
 }
 
-static struct pci_device_id __devinitdata mvs_pci_table[] = {
+static struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
 	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
 	{
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0415f04..0a7500d 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -76,7 +76,7 @@ static const char *nsp32_release_version = "1.2";
 /****************************************************************************
  * Supported hardware
  */
-static struct pci_device_id nsp32_pci_table[] __devinitdata = {
+static struct pci_device_id nsp32_pci_table[] = {
 	{
 		.vendor      = PCI_VENDOR_ID_IODATA,
 		.device      = PCI_DEVICE_ID_NINJASCSI_32BI_CBSC_II,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 32eb98b..c0e1c18 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -841,7 +841,7 @@ err_out_enable:
 	return rc;
 }
 
-static struct pci_device_id __devinitdata pm8001_pci_table[] = {
+static struct pci_device_id pm8001_pci_table[] = {
 	{
 		PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001
 	},
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 93f764b..f46ec1b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -125,7 +125,7 @@ static struct pmcraid_chip_details pmcraid_chip_cfg[] = {
 /*
  * PCI device ids supported by pmcraid driver
  */
-static struct pci_device_id pmcraid_pci_table[] __devinitdata = {
+static struct pci_device_id pmcraid_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_MAXRAID),
 	  0, 0, (kernel_ulong_t)&pmcraid_chip_cfg[0]
 	},
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index ac4eca6..0b7819f 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -581,7 +581,7 @@ static int sym53c416_test(int base)
 }
 
 
-static struct isapnp_device_id id_table[] __devinitdata = {
+static struct isapnp_device_id id_table[] = {
 	{	ISAPNP_ANY_ID, ISAPNP_ANY_ID,
 		ISAPNP_VENDOR('S','L','I'), ISAPNP_FUNCTION(0x4161), 0 },
 	{	ISAPNP_ANY_ID, ISAPNP_ANY_ID,
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 03eddfd..ed76e86 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2077,7 +2077,7 @@ static struct spi_function_template sym2_transport_functions = {
 	.get_signalling	= sym2_get_signalling,
 };
 
-static struct pci_device_id sym2_id_table[] __devinitdata = {
+static struct pci_device_id sym2_id_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820,
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 3da9d9a..56a8697 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2305,7 +2305,7 @@ static void dc390_eeprom_override(u8 index)
 	}
 }
 
-static int __devinitdata tmscsim_def[] = {
+static int tmscsim_def[] = {
 	7,
 	0 /* 10MHz */,
 	PARITY_CHK_ | SEND_START_ | EN_DISCONNECT_ | SYNC_NEGO_ | TAG_QUEUEING_,
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 5520033..0ebfdc1 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -38,7 +38,7 @@ static struct zorro_driver_data {
 	const char *name;
 	unsigned long offset;
 	int absolute;	/* offset is absolute address */
-} zorro7xx_driver_data[] __devinitdata = {
+} zorro7xx_driver_data[] = {
 	{ .name = "PowerUP 603e+", .offset = 0xf40000, .absolute = 1 },
 	{ .name = "WarpEngine 40xx", .offset = 0x40000 },
 	{ .name = "A4091", .offset = 0x800000 },
@@ -46,7 +46,7 @@ static struct zorro_driver_data {
 	{ 0 }
 };
 
-static struct zorro_device_id zorro7xx_zorro_tbl[] __devinitdata = {
+static struct zorro_device_id zorro7xx_zorro_tbl[] = {
 	{
 		.id = ZORRO_PROD_PHASE5_BLIZZARD_603E_PLUS,
 		.driver_data = (unsigned long)&zorro7xx_driver_data[0],
-- 
1.8.0

