Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470CC286A9;
	Sat,  7 Dec 2024 16:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.12.242.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733590160; cv=none; b=EVxR4V7F0ZoUtYLoMr4dBc14KgROvdp3sIheZau9yY4VVdFE8CrRFPv4hO9UM0YI/qXkI6IOGqbOdyIaynIzcb8VGC5aQF6/yIoB8aLQ1e54fT2OImosoWNlGePeZrpfgGAboLmSOYexCDMsqkIywMwpmq/b6zPOj9+r3+EDRbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733590160; c=relaxed/simple;
	bh=n1GrpVCuxc4bWANuFeEUE/L+tNU+VyuPErzeLiiXcls=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FlcTn2O++Q//UaYIjUkg2TzpwCkG88UKJLLs/YMjYNiwwkijMZayt8U1pr6KQqvqifkbV/WZVlGJ3LORhRj6Bj92fjrXQYQJcW4wDJkPXp7K2nz1UjspkiadQuCq8C3g0AvNXe3gbZ99aMOFj1XMx1qe/lzfav614mY2HbdqTuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr; spf=pass smtp.mailfrom=wanadoo.fr; dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b=OBx4Tzn6; arc=none smtp.client-ip=80.12.242.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wanadoo.fr header.i=@wanadoo.fr header.b="OBx4Tzn6"
Received: from localhost.localdomain ([90.11.132.44])
	by smtp.orange.fr with ESMTPA
	id JxzFtz6sylGpZJxzFtaBI8; Sat, 07 Dec 2024 17:49:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1733590147;
	bh=iO6Lj3tjFBVS0+oDW8iUX7h6GGQlAfcn1BNrliJn1Kk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=OBx4Tzn6s8y4L6aNrZNVwTMLBe9T1iCuMiP4wcX2mXxc/ef5J9uZxM0fXii277BHl
	 eL1wqctdSo0o4hQh4mQm1Ppbs0PfWOU3b5TwJYuAV/D+iZ6xdhhbKRKmuAeS/SCC2/
	 HFgl5DAOZBrN3S7BBjUZur2aymmPJqAqI6023heztVdcMPcYpQqG2uH1/+GakSj8Rd
	 hdzMSd8KA5yyUJHBQ0ogeTOzMgve/H4r/HyHdBDcMAdfA+VgS4kenBPuVLbndLhUOI
	 asrjXYwsPEkWiLGKUlo6hhlavTvgi6XcXo822HH21JRTx2MJFRb6oYuveW/sQ2B53R
	 uimh24wJ40hCw==
X-ME-Helo: localhost.localdomain
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 07 Dec 2024 17:49:07 +0100
X-ME-IP: 90.11.132.44
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: Adam Radford <aradford@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Khalid Aziz <khalid@gonehiking.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hannes Reinecke <hare@suse.com>,
	"Manoj N. Kumar" <manoj@linux.ibm.com>,
	Uma Krishnan <ukrishn@linux.ibm.com>,
	Oliver Neukum <oliver@neukum.org>,
	Ali Akcaagac <aliakc@web.de>,
	Jamie Lenehan <lenehan@twibble.org>,
	Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	James Smart <james.smart@broadcom.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Brian King <brking@us.ibm.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	GOTO Masanori <gotom@debian.or.jp>,
	YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	Manish Rangankar <mrangankar@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Michael Reed <mdr@sgi.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com
Subject: [PATCH] scsi: Constify struct pci_device_id
Date: Sat,  7 Dec 2024 17:48:28 +0100
Message-ID: <fc61b1946488c1ea8f7a17a06cf40fbd05dcc6de.1733590049.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'struct pci_device_id' is not modified in these drivers.

Constifying this structure moves some data to a read-only section, so
increase overall security.

On a x86_64, with allmodconfig, as an example:
Before:
======
   text	   data	    bss	    dec	    hex	filename
  70237	   9137	    320	  79694	  1374e	drivers/scsi/3w-9xxx.o

After:
=====
   text	   data	    bss	    dec	    hex	filename
  70461	   8913	    320	  79694	  1374e	drivers/scsi/3w-9xxx.o

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Each file has been compile tested only
---
 drivers/scsi/3w-9xxx.c                    | 2 +-
 drivers/scsi/3w-sas.c                     | 2 +-
 drivers/scsi/3w-xxxx.c                    | 2 +-
 drivers/scsi/BusLogic.c                   | 2 +-
 drivers/scsi/a100u2w.c                    | 2 +-
 drivers/scsi/advansys.c                   | 2 +-
 drivers/scsi/am53c974.c                   | 2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          | 2 +-
 drivers/scsi/atp870u.c                    | 2 +-
 drivers/scsi/cxlflash/main.c              | 2 +-
 drivers/scsi/dc395x.c                     | 2 +-
 drivers/scsi/dmx3191d.c                   | 2 +-
 drivers/scsi/elx/efct/efct_driver.c       | 2 +-
 drivers/scsi/fdomain_pci.c                | 2 +-
 drivers/scsi/fnic/fnic_main.c             | 2 +-
 drivers/scsi/hptiop.c                     | 2 +-
 drivers/scsi/initio.c                     | 2 +-
 drivers/scsi/ipr.c                        | 2 +-
 drivers/scsi/megaraid.c                   | 2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 drivers/scsi/mvsas/mv_init.c              | 2 +-
 drivers/scsi/nsp32.c                      | 2 +-
 drivers/scsi/pm8001/pm8001_init.c         | 2 +-
 drivers/scsi/pmcraid.c                    | 2 +-
 drivers/scsi/qedi/qedi_main.c             | 2 +-
 drivers/scsi/qla1280.c                    | 2 +-
 drivers/scsi/qla2xxx/qla_os.c             | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c             | 2 +-
 drivers/scsi/snic/snic_main.c             | 2 +-
 drivers/scsi/stex.c                       | 2 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 2 +-
 32 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 6fb61c88ea11..060a2444f0be 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2260,7 +2260,7 @@ static int __maybe_unused twa_resume(struct device *dev)
 } /* End twa_resume() */
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id twa_pci_tbl[] = {
+static const struct pci_device_id twa_pci_tbl[] = {
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9000,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_9550SX,
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index caa6713a62a4..a32223b28d07 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1821,7 +1821,7 @@ static int __maybe_unused twl_resume(struct device *dev)
 } /* End twl_resume() */
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id twl_pci_tbl[] = {
+static const struct pci_device_id twl_pci_tbl[] = {
 	{ PCI_VDEVICE(3WARE, PCI_DEVICE_ID_3WARE_9750) },
 	{ }
 };
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 2c0fb6da0e60..0cbca5a99f99 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2393,7 +2393,7 @@ static void tw_remove(struct pci_dev *pdev)
 } /* End tw_remove() */
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id tw_pci_tbl[] = {
+static const struct pci_device_id tw_pci_tbl[] = {
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_1000,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_3WARE, PCI_DEVICE_ID_3WARE_7000,
diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index 2135a2b3e2d0..26936854514a 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3715,7 +3715,7 @@ static void __exit blogic_exit(void)
 __setup("BusLogic=", blogic_setup);
 
 #ifdef MODULE
-/*static struct pci_device_id blogic_pci_tbl[] = {
+/*static const struct pci_device_id blogic_pci_tbl[] = {
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ PCI_VENDOR_ID_BUSLOGIC, PCI_DEVICE_ID_BUSLOGIC_MULTIMASTER_NC,
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index b95147fb18b0..a8979f9e30ff 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1206,7 +1206,7 @@ static void inia100_remove_one(struct pci_dev *pdev)
 	scsi_host_put(shost);
 } 
 
-static struct pci_device_id inia100_pci_tbl[] = {
+static const struct pci_device_id inia100_pci_tbl[] = {
 	{PCI_VENDOR_ID_INIT, 0x1060, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0,}
 };
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index fd4fcb37863d..f153c96f7f2c 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -11408,7 +11408,7 @@ static struct eisa_driver advansys_eisa_driver = {
 };
 
 /* PCI Devices supported by this driver */
-static struct pci_device_id advansys_pci_tbl[] = {
+static const struct pci_device_id advansys_pci_tbl[] = {
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_1200A,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_ASP, PCI_DEVICE_ID_ASP_ABP940,
diff --git a/drivers/scsi/am53c974.c b/drivers/scsi/am53c974.c
index fbb29dbb1e50..003e61831e33 100644
--- a/drivers/scsi/am53c974.c
+++ b/drivers/scsi/am53c974.c
@@ -513,7 +513,7 @@ static void pci_esp_remove_one(struct pci_dev *pdev)
 	scsi_host_put(esp->host);
 }
 
-static struct pci_device_id am53c974_pci_tbl[] = {
+static const struct pci_device_id am53c974_pci_tbl[] = {
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_SCSI,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	{ }
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 35860c61468b..1ae81acfbaab 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -171,7 +171,7 @@ static const struct scsi_host_template arcmsr_scsi_host_template = {
 	.no_write_same		= 1,
 };
 
-static struct pci_device_id arcmsr_device_id_table[] = {
+static const struct pci_device_id arcmsr_device_id_table[] = {
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1110),
 		.driver_data = ACB_ADAPTER_TYPE_A},
 	{PCI_DEVICE(PCI_VENDOR_ID_ARECA, PCI_DEVICE_ID_ARECA_1120),
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index 928151ec927a..401242912855 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1743,7 +1743,7 @@ static const struct scsi_host_template atp870u_template = {
      .max_sectors		= ATP870U_MAX_SECTORS,
 };
 
-static struct pci_device_id atp870u_id_table[] = {
+static const struct pci_device_id atp870u_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP885_DEVID)			  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID1)		  },
 	{ PCI_DEVICE(PCI_VENDOR_ID_ARTOP, ATP880_DEVID2)		  },
diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 60d62b93d624..76073a71c028 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -3177,7 +3177,7 @@ static struct dev_dependent_vals dev_briard_vals = { CXLFLASH_MAX_SECTORS,
 /*
  * PCI device binding table
  */
-static struct pci_device_id cxlflash_pci_table[] = {
+static const struct pci_device_id cxlflash_pci_table[] = {
 	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_CORSA,
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, (kernel_ulong_t)&dev_corsa_vals},
 	{PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_IBM_FLASH_GT,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index d108a86e196e..a3b0e143e3bd 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4668,7 +4668,7 @@ static void dc395x_remove_one(struct pci_dev *dev)
 }
 
 
-static struct pci_device_id dc395x_pci_table[] = {
+static const struct pci_device_id dc395x_pci_table[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_TEKRAM,
 		.device		= PCI_DEVICE_ID_TEKRAM_TRMS1040,
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index dfb091d34363..d6d091b2f3c7 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -127,7 +127,7 @@ static void dmx3191d_remove_one(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static struct pci_device_id dmx3191d_pci_tbl[] = {
+static const struct pci_device_id dmx3191d_pci_tbl[] = {
 	{PCI_VENDOR_ID_DOMEX, PCI_DEVICE_ID_DOMEX_DMX3191D,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 4},
 	{ }
diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 55d2301bfd7d..8469c156ab33 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -470,7 +470,7 @@ efct_setup_msix(struct efct *efct, u32 num_intrs)
 	return rc;
 }
 
-static struct pci_device_id efct_pci_table[] = {
+static const struct pci_device_id efct_pci_table[] = {
 	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G6), 0},
 	{PCI_DEVICE(EFCT_VENDOR_ID, EFCT_DEVICE_LANCER_G7), 0},
 	{}	/* terminate list */
diff --git a/drivers/scsi/fdomain_pci.c b/drivers/scsi/fdomain_pci.c
index 3e05ce7b89e5..c15b2ce76e9f 100644
--- a/drivers/scsi/fdomain_pci.c
+++ b/drivers/scsi/fdomain_pci.c
@@ -47,7 +47,7 @@ static void fdomain_pci_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 }
 
-static struct pci_device_id fdomain_pci_table[] = {
+static const struct pci_device_id fdomain_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_FD, PCI_DEVICE_ID_FD_36C70) },
 	{}
 };
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index adec0df24bc4..0b0075e2b49b 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -44,7 +44,7 @@ static DEFINE_SPINLOCK(fnic_list_lock);
 static DEFINE_IDA(fnic_ida);
 
 /* Supported devices by fnic module */
-static struct pci_device_id fnic_id_table[] = {
+static const struct pci_device_id fnic_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_CISCO_FNIC) },
 	{ 0, }
 };
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index e889f268601b..2d9e584e7c55 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1634,7 +1634,7 @@ static struct hptiop_adapter_ops hptiop_mvfrey_ops = {
 	.host_phy_flag     = cpu_to_le64(1),
 };
 
-static struct pci_device_id hptiop_id_table[] = {
+static const struct pci_device_id hptiop_id_table[] = {
 	{ PCI_VDEVICE(TTI, 0x3220), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3320), (kernel_ulong_t)&hptiop_itl_ops },
 	{ PCI_VDEVICE(TTI, 0x3410), (kernel_ulong_t)&hptiop_itl_ops },
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 625fd547ee60..8648bd965287 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2941,7 +2941,7 @@ static void initio_remove_one(struct pci_dev *pdev)
 
 MODULE_LICENSE("GPL");
 
-static struct pci_device_id initio_pci_tbl[] = {
+static const struct pci_device_id initio_pci_tbl[] = {
 	{PCI_VENDOR_ID_INIT, 0x9500, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_INIT, 0x9400, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_INIT, 0x9401, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 31cf2d31cceb..eab6b47a0495 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9844,7 +9844,7 @@ static void ipr_shutdown(struct pci_dev *pdev)
 	}
 }
 
-static struct pci_device_id ipr_pci_table[] = {
+static const struct pci_device_id ipr_pci_table[] = {
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
 		PCI_VENDOR_ID_IBM, IPR_SUBS_DEV_ID_5702, 0, 0, 0 },
 	{ PCI_VENDOR_ID_MYLEX, PCI_DEVICE_ID_IBM_GEMSTONE,
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 38976f94453e..adab151663dd 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4551,7 +4551,7 @@ megaraid_shutdown(struct pci_dev *pdev)
 	__megaraid_shutdown(adapter);
 }
 
-static struct pci_device_id megaraid_pci_tbl[] = {
+static const struct pci_device_id megaraid_pci_tbl[] = {
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_AMI, PCI_DEVICE_ID_AMI_MEGARAID2,
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index bc867da650b6..35d2e48bed64 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -199,7 +199,7 @@ MODULE_PARM_DESC(debug_level, "Debug level for driver (default=0)");
 /*
  * PCI table for all supported controllers.
  */
-static struct pci_device_id pci_id_table_g[] =  {
+static const struct pci_device_id pci_id_table_g[] =  {
 	{
 		PCI_VENDOR_ID_DELL,
 		PCI_DEVICE_ID_PERC4_DI_DISCOVERY,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 50f1dcb6d584..d21587659342 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -147,7 +147,7 @@ megasas_set_ld_removed_by_fw(struct megasas_instance *instance);
 /*
  * PCI ID table for all supported controllers
  */
-static struct pci_device_id megasas_pci_table[] = {
+static const struct pci_device_id megasas_pci_table[] = {
 
 	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_SAS1064R)},
 	/* xscale IOP */
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 020037cbf0d9..2c72da6b8cf0 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -609,7 +609,7 @@ static void mvs_pci_remove(struct pci_dev *pdev)
 	return;
 }
 
-static struct pci_device_id mvs_pci_table[] = {
+static const struct pci_device_id mvs_pci_table[] = {
 	{ PCI_VDEVICE(MARVELL, 0x6320), chip_6320 },
 	{ PCI_VDEVICE(MARVELL, 0x6340), chip_6440 },
 	{
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index b7987019686e..abc4ce9eae74 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -66,7 +66,7 @@ static const char *nsp32_release_version = "1.2";
 /****************************************************************************
  * Supported hardware
  */
-static struct pci_device_id nsp32_pci_table[] = {
+static const struct pci_device_id nsp32_pci_table[] = {
 	{
 		.vendor      = PCI_VENDOR_ID_IODATA,
 		.device      = PCI_DEVICE_ID_NINJASCSI_32BI_CBSC_II,
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index f8c81e53e93f..c32ceeba7ccb 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1435,7 +1435,7 @@ static int __maybe_unused pm8001_pci_resume(struct device *dev)
 /* update of pci device, vendor id and driver data with
  * unique value for each of the controller
  */
-static struct pci_device_id pm8001_pci_table[] = {
+static const struct pci_device_id pm8001_pci_table[] = {
 	{ PCI_VDEVICE(PMC_Sierra, 0x8001), chip_8001 },
 	{ PCI_VDEVICE(PMC_Sierra, 0x8006), chip_8006 },
 	{ PCI_VDEVICE(ADAPTEC2, 0x8006), chip_8006 },
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index 4c5881917d76..83a7708aab80 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -113,7 +113,7 @@ static struct pmcraid_chip_details pmcraid_chip_cfg[] = {
 /*
  * PCI device ids supported by pmcraid driver
  */
-static struct pci_device_id pmcraid_pci_table[] = {
+static const struct pci_device_id pmcraid_pci_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_PMC, PCI_DEVICE_ID_PMC_MAXRAID),
 	  0, 0, (kernel_ulong_t)&pmcraid_chip_cfg[0]
 	},
diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 628d59dda20c..1cab66a1f4f6 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -2869,7 +2869,7 @@ static void qedi_remove(struct pci_dev *pdev)
 	__qedi_remove(pdev, QEDI_MODE_NORMAL);
 }
 
-static struct pci_device_id qedi_pci_tbl[] = {
+static const struct pci_device_id qedi_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, 0x165E) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, 0x8084) },
 	{ 0 },
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 8958547ac111..606a4b890f6b 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -501,7 +501,7 @@ struct qla_boards {
 };
 
 /* NOTE: the last argument in each entry is used to index ql1280_board_tbl */
-static struct pci_device_id qla1280_pci_tbl[] = {
+static const struct pci_device_id qla1280_pci_tbl[] = {
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP12160,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP1020,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 7f980e6141c2..21ddf6d2b4b6 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -8115,7 +8115,7 @@ static const struct pci_error_handlers qla2xxx_err_handler = {
 	.reset_done = qla_pci_reset_done,
 };
 
-static struct pci_device_id qla2xxx_pci_tbl[] = {
+static const struct pci_device_id qla2xxx_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2100) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2200) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_QLOGIC, PCI_DEVICE_ID_QLOGIC_ISP2300) },
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d91f54a6e752..e4aefb44b3a3 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -9846,7 +9846,7 @@ static const struct pci_error_handlers qla4xxx_err_handler = {
 	.resume = qla4xxx_pci_resume,
 };
 
-static struct pci_device_id qla4xxx_pci_tbl[] = {
+static const struct pci_device_id qla4xxx_pci_tbl[] = {
 	{
 		.vendor		= PCI_VENDOR_ID_QLOGIC,
 		.device		= PCI_DEVICE_ID_QLOGIC_ISP4010,
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 9be3f0193145..d35914383b3e 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -21,7 +21,7 @@
 #define PCI_DEVICE_ID_CISCO_SNIC	0x0046
 
 /* Supported devices by snic module */
-static struct pci_device_id snic_id_table[] = {
+static const struct pci_device_id snic_id_table[] = {
 	{PCI_DEVICE(0x1137, PCI_DEVICE_ID_CISCO_SNIC) },
 	{ 0, }	/* end of table */
 };
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 0e81125df8c7..0a7bfaeacf26 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1488,7 +1488,7 @@ static const struct scsi_host_template driver_template = {
 	.dma_boundary			= PAGE_SIZE - 1,
 };
 
-static struct pci_device_id stex_pci_tbl[] = {
+static const struct pci_device_id stex_pci_tbl[] = {
 	/* st_shasta */
 	{ 0x105a, 0x8350, PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		st_shasta }, /* SuperTrak EX8350/8300/16350/16300 */
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index a2560cc807d3..a4fab57764eb 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -2030,7 +2030,7 @@ static struct spi_function_template sym2_transport_functions = {
 	.get_signalling	= sym2_get_signalling,
 };
 
-static struct pci_device_id sym2_id_table[] = {
+static const struct pci_device_id sym2_id_table[] = {
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C810,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C820,
-- 
2.47.1

