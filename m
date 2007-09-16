From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] set supported_mode for lots of llds
Date: Sun, 16 Sep 2007 12:05:34 +0900
Message-ID: <20070914223247M.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52378 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbXIPDFq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Sep 2007 23:05:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, fujita.tomonori@lab.ntt.co.jp

The majority of llds don't set supported_mode in scsi_host_template so
we get:

luce:/sys/class/scsi_host/host0$ cat supported_mode
unknown

It's harmless but it would be better to get:

luce:/sys/class/scsi_host/host0$ cat supported_mode
Initiator


Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/fusion/mptfc.c        |    1 +
 drivers/message/fusion/mptsas.c       |    1 +
 drivers/message/fusion/mptspi.c       |    1 +
 drivers/s390/scsi/zfcp_scsi.c         |    1 +
 drivers/scsi/3w-9xxx.c                |    1 +
 drivers/scsi/3w-xxxx.c                |    1 +
 drivers/scsi/NCR_D700.c               |    1 +
 drivers/scsi/NCR_Q720.c               |    1 +
 drivers/scsi/a100u2w.c                |    1 +
 drivers/scsi/a2091.c                  |    1 +
 drivers/scsi/a3000.c                  |    1 +
 drivers/scsi/a4000t.c                 |    1 +
 drivers/scsi/aacraid/linit.c          |    1 +
 drivers/scsi/advansys.c               |    1 +
 drivers/scsi/aha152x.c                |    1 +
 drivers/scsi/aha1542.c                |    1 +
 drivers/scsi/aha1740.c                |    1 +
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    1 +
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    1 +
 drivers/scsi/aic7xxx_old.c            |    1 +
 drivers/scsi/aic94xx/aic94xx_init.c   |    1 +
 drivers/scsi/arcmsr/arcmsr_hba.c      |    1 +
 drivers/scsi/arm/acornscsi.c          |    1 +
 drivers/scsi/arm/arxescsi.c           |    1 +
 drivers/scsi/arm/cumana_1.c           |    1 +
 drivers/scsi/arm/cumana_2.c           |    1 +
 drivers/scsi/arm/eesox.c              |    1 +
 drivers/scsi/arm/oak.c                |    1 +
 drivers/scsi/arm/powertec.c           |    1 +
 drivers/scsi/atari_scsi.c             |    1 +
 drivers/scsi/atp870u.c                |    1 +
 drivers/scsi/blz1230.c                |    1 +
 drivers/scsi/blz2060.c                |    1 +
 drivers/scsi/cyberstorm.c             |    1 +
 drivers/scsi/cyberstormII.c           |    1 +
 drivers/scsi/dc395x.c                 |    1 +
 drivers/scsi/dec_esp.c                |    1 +
 drivers/scsi/dmx3191d.c               |    1 +
 drivers/scsi/dtc.c                    |    1 +
 drivers/scsi/eata.c                   |    1 +
 drivers/scsi/eata_pio.c               |    1 +
 drivers/scsi/esp_scsi.c               |    1 +
 drivers/scsi/fastlane.c               |    1 +
 drivers/scsi/fcal.c                   |    1 +
 drivers/scsi/fd_mcs.c                 |    1 +
 drivers/scsi/fdomain.c                |    1 +
 drivers/scsi/g_NCR5380.c              |    1 +
 drivers/scsi/gdth.c                   |    1 +
 drivers/scsi/gvp11.c                  |    1 +
 drivers/scsi/hptiop.c                 |    1 +
 drivers/scsi/ibmmca.c                 |    1 +
 drivers/scsi/ibmvscsi/ibmvscsi.c      |    1 +
 drivers/scsi/imm.c                    |    1 +
 drivers/scsi/in2000.c                 |    1 +
 drivers/scsi/ipr.c                    |    1 +
 drivers/scsi/ips.c                    |    1 +
 drivers/scsi/iscsi_tcp.c              |    1 +
 drivers/scsi/lpfc/lpfc_scsi.c         |    2 ++
 drivers/scsi/mac53c94.c               |    1 +
 drivers/scsi/mac_esp.c                |    1 +
 drivers/scsi/mac_scsi.c               |    1 +
 drivers/scsi/mca_53c9x.c              |    1 +
 drivers/scsi/megaraid.c               |    1 +
 drivers/scsi/megaraid/megaraid_mbox.c |    1 +
 drivers/scsi/megaraid/megaraid_sas.c  |    1 +
 drivers/scsi/mesh.c                   |    1 +
 drivers/scsi/mvme147.c                |    1 +
 drivers/scsi/mvme16x_scsi.c           |    1 +
 drivers/scsi/nsp32.c                  |    1 +
 drivers/scsi/oktagon_esp.c            |    1 +
 drivers/scsi/pas16.c                  |    1 +
 drivers/scsi/pcmcia/nsp_cs.c          |    1 +
 drivers/scsi/pcmcia/qlogic_stub.c     |    1 +
 drivers/scsi/pcmcia/sym53c500_cs.c    |    1 +
 drivers/scsi/pluto.c                  |    1 +
 drivers/scsi/ppa.c                    |    1 +
 drivers/scsi/psi240i.c                |    1 +
 drivers/scsi/qla1280.c                |    1 +
 drivers/scsi/qla2xxx/qla_os.c         |    2 ++
 drivers/scsi/qla4xxx/ql4_os.c         |    1 +
 drivers/scsi/qlogicfas.c              |    1 +
 drivers/scsi/qlogicpti.c              |    1 +
 drivers/scsi/seagate.c                |    1 +
 drivers/scsi/sgiwd93.c                |    1 +
 drivers/scsi/sim710.c                 |    1 +
 drivers/scsi/sni_53c710.c             |    1 +
 drivers/scsi/stex.c                   |    1 +
 drivers/scsi/sun3_scsi.c              |    1 +
 drivers/scsi/sun3_scsi_vme.c          |    1 +
 drivers/scsi/sun3x_esp.c              |    1 +
 drivers/scsi/sym53c416.c              |    1 +
 drivers/scsi/t128.c                   |    1 +
 drivers/scsi/tmscsim.c                |    1 +
 drivers/scsi/u14-34f.c                |    1 +
 drivers/scsi/ultrastor.c              |    1 +
 drivers/scsi/wd7000.c                 |    1 +
 drivers/scsi/zalon.c                  |    1 +
 drivers/scsi/zorro7xx.c               |    1 +
 98 files changed, 100 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 19438ec..ba15b60 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -111,6 +111,7 @@ static struct scsi_host_template mptfc_driver_template = {
 	.proc_name			= "mptfc",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT FC Host",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= mptscsih_info,
 	.queuecommand			= mptfc_qcmd,
 	.target_alloc			= mptfc_target_alloc,
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d2f1b8e..5e6f90d 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1013,6 +1013,7 @@ static struct scsi_host_template mptsas_driver_template = {
 	.proc_name			= "mptsas",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= mptscsih_info,
 	.queuecommand			= mptsas_qcmd,
 	.target_alloc			= mptsas_target_alloc,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 02062f1..575deec 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -813,6 +813,7 @@ static struct scsi_host_template mptspi_driver_template = {
 	.proc_name			= "mptspi",
 	.proc_info			= mptscsih_proc_info,
 	.name				= "MPT SPI Host",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= mptscsih_info,
 	.queuecommand			= mptspi_qcmd,
 	.target_alloc			= mptspi_target_alloc,
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index abae202..155bf11 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -45,6 +45,7 @@ struct zfcp_data zfcp_data = {
 		.name			= ZFCP_NAME,
 		.module			= THIS_MODULE,
 		.proc_name		= "zfcp",
+		.supported_mode		= MODE_INITIATOR,
 		.slave_alloc		= zfcp_scsi_slave_alloc,
 		.slave_configure	= zfcp_scsi_slave_configure,
 		.slave_destroy		= zfcp_scsi_slave_destroy,
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index efd9d8d..2b47fe4 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1980,6 +1980,7 @@ static void twa_unmap_scsi_data(TW_Device_Extension *tw_dev, int request_id)
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware 9000 Storage Controller",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= twa_scsi_queue,
 	.eh_host_reset_handler	= twa_scsi_eh_reset,
 	.bios_param		= twa_scsi_biosparam,
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index c7995fc..a909964 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2251,6 +2251,7 @@ static void tw_shutdown(struct pci_dev *pdev)
 static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "3ware Storage Controller",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= tw_scsi_queue,
 	.eh_host_reset_handler	= tw_scsi_eh_reset,
 	.bios_param		= tw_scsi_biosparam,
diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 9e64b21..8df5734 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -161,6 +161,7 @@ static struct scsi_host_template NCR_D700_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "NCR Dual 700 MCA",
 	.proc_name		= "NCR_D700",
+	.supported_mode		= MODE_INITIATOR,
 	.this_id		= 7,
 };
 
diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
index a8bbdc2..4c090df 100644
--- a/drivers/scsi/NCR_Q720.c
+++ b/drivers/scsi/NCR_Q720.c
@@ -51,6 +51,7 @@ struct NCR_Q720_private {
 static struct scsi_host_template NCR_Q720_tpnt = {
 	.module			= THIS_MODULE,
 	.proc_name		= "NCR_Q720",
+	.supported_mode		= MODE_INITIATOR,
 };
 
 static irqreturn_t
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index f608d4a..c7ce681 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1062,6 +1062,7 @@ static irqreturn_t inia100_intr(int irqno, void *devid)
 static struct scsi_host_template inia100_template = {
 	.proc_name		= "inia100",
 	.name			= inia100_REVID,
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= inia100_queue,
 	.eh_abort_handler	= inia100_abort,
 	.eh_bus_reset_handler	= inia100_bus_reset,
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index b7c5385..dce1e14 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -235,6 +235,7 @@ static int a2091_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "A2901",
 	.name			= "Commodore A2091/A590 SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= a2091_detect,
 	.release		= a2091_release,
 	.queuecommand		= wd33c93_queuecommand,
diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index 796f1c4..9e78bbe 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -223,6 +223,7 @@ static int a3000_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "A3000",
 	.name			= "Amiga 3000 built-in SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= a3000_detect,
 	.release		= a3000_release,
 	.queuecommand		= wd33c93_queuecommand,
diff --git a/drivers/scsi/a4000t.c b/drivers/scsi/a4000t.c
index d4bda20..cfaa7b1 100644
--- a/drivers/scsi/a4000t.c
+++ b/drivers/scsi/a4000t.c
@@ -27,6 +27,7 @@ MODULE_LICENSE("GPL");
 static struct scsi_host_template a4000t_scsi_driver_template = {
 	.name		= "A4000T builtin SCSI",
 	.proc_name	= "A4000t",
+	.supported_mode	= MODE_INITIATOR,
 	.this_id	= 7,
 	.module		= THIS_MODULE,
 };
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index a7f42a1..9f38d21 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -922,6 +922,7 @@ static struct scsi_host_template aac_driver_template = {
 	.module				= THIS_MODULE,
 	.name           		= "AAC",
 	.proc_name			= AAC_DRIVERNAME,
+	.supported_mode			= MODE_INITIATOR,
 	.info           		= aac_info,
 	.ioctl          		= aac_ioctl,
 #ifdef CONFIG_COMPAT
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 0303fc7..e0ff15f 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -3219,6 +3219,7 @@ static struct scsi_host_template advansys_template = {
 	.proc_info = advansys_proc_info,
 #endif
 	.name = DRV_NAME,
+	.supported_mode	= MODE_INITIATOR,
 	.info = advansys_info,
 	.queuecommand = advansys_queuecommand,
 	.eh_bus_reset_handler = advansys_reset,
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index d30a307..083f729 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3486,6 +3486,7 @@ static struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
 	.proc_name			= "aha152x",
+	.supported_mode			= MODE_INITIATOR,
 	.proc_info			= aha152x_proc_info,
 	.queuecommand			= aha152x_queue,
 	.eh_abort_handler		= aha152x_abort,
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index cbbfbc9..5dc36c9 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -1785,6 +1785,7 @@ MODULE_LICENSE("GPL");
 static struct scsi_host_template driver_template = {
 	.proc_name		= "aha1542",
 	.name			= "Adaptec 1542",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= aha1542_detect,
 	.release		= aha1542_release,
 	.queuecommand		= aha1542_queuecommand,
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index e4a4f3a..0420c4a 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -556,6 +556,7 @@ static struct scsi_host_template aha1740_template = {
 	.proc_name        = "aha1740",
 	.proc_info        = aha1740_proc_info,
 	.name             = "Adaptec 174x (EISA)",
+	.supported_mode   = MODE_INITIATOR,
 	.queuecommand     = aha1740_queuecommand,
 	.bios_param       = aha1740_biosparam,
 	.can_queue        = AHA1740_ECBS,
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index a055a96..8303575 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -752,6 +752,7 @@ struct scsi_host_template aic79xx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic79xx",
 	.proc_name		= "aic79xx",
+	.supported_mode		= MODE_INITIATOR,
 	.proc_info		= ahd_linux_proc_info,
 	.info			= ahd_linux_info,
 	.queuecommand		= ahd_linux_queue,
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 2e9c38f..1f2d6e8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -733,6 +733,7 @@ struct scsi_host_template aic7xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "aic7xxx",
 	.proc_name		= "aic7xxx",
+	.supported_mode		= MODE_INITIATOR,
 	.proc_info		= ahc_linux_proc_info,
 	.info			= ahc_linux_info,
 	.queuecommand		= ahc_linux_queue,
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index 1a71b02..ba7c3ad 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -11125,6 +11125,7 @@ MODULE_VERSION(AIC7XXX_H_VERSION);
 
 
 static struct scsi_host_template driver_template = {
+	.supported_mode		= MODE_INITIATOR,
 	.proc_info		= aic7xxx_proc_info,
 	.detect			= aic7xxx_detect,
 	.release		= aic7xxx_release,
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 63d1045..170b29d 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -64,6 +64,7 @@ static struct scsi_host_template aic94xx_sht = {
 	.module			= THIS_MODULE,
 	/* .name is initialized */
 	.name			= "aic94xx",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= sas_queuecommand,
 	.target_alloc		= sas_target_alloc,
 	.slave_configure	= sas_slave_configure,
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 50e1310..22fd3bc 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -110,6 +110,7 @@ static struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
 	.name			= "ARCMSR ARECA SATA/SAS RAID HOST Adapter"
 							ARCMSR_DRIVER_VERSION,
+	.supported_mode		= MODE_INITIATOR,
 	.info			= arcmsr_info,
 	.queuecommand		= arcmsr_queue_command,
 	.eh_abort_handler	= arcmsr_abort,
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index eceacf6..8fbad99 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2974,6 +2974,7 @@ static struct scsi_host_template acornscsi_template = {
 	.module			= THIS_MODULE,
 	.proc_info		= acornscsi_proc_info,
 	.name			= "AcornSCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= acornscsi_info,
 	.queuecommand		= acornscsi_queuecmd,
 #warning fixme
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2836fe2..4d44378 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -262,6 +262,7 @@ arxescsi_proc_info(struct Scsi_Host *host, char *buffer, char **start, off_t off
 static struct scsi_host_template arxescsi_template = {
 	.proc_info			= arxescsi_proc_info,
 	.name				= "ARXE SCSI card",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= arxescsi_info,
 	.queuecommand			= fas216_noqueue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 49d838e..33eb60e 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -214,6 +214,7 @@ static void cumanascsi_write(struct Scsi_Host *host, unsigned int reg, unsigned
 static struct scsi_host_template cumanascsi_template = {
 	.module			= THIS_MODULE,
 	.name			= "Cumana 16-bit SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= cumanascsi_info,
 	.queuecommand		= cumanascsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 68a6412..c94a5e9 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -382,6 +382,7 @@ static struct scsi_host_template cumanascsi2_template = {
 	.module				= THIS_MODULE,
 	.proc_info			= cumanascsi_2_proc_info,
 	.name				= "Cumana SCSI II",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= cumanascsi_2_info,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index bb2477b..bbbfc6b 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -500,6 +500,7 @@ static struct scsi_host_template eesox_template = {
 	.module				= THIS_MODULE,
 	.proc_info			= eesoxscsi_proc_info,
 	.name				= "EESOX SCSI",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= eesoxscsi_info,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 849cdf8..8fff640 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -117,6 +117,7 @@ static struct scsi_host_template oakscsi_template = {
 	.module			= THIS_MODULE,
 	.proc_info		= oakscsi_proc_info,
 	.name			= "Oak 16-bit SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= oakscsi_info,
 	.queuecommand		= oakscsi_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index d9a546d..c73a28b 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -293,6 +293,7 @@ static struct scsi_host_template powertecscsi_template = {
 	.module				= THIS_MODULE,
 	.proc_info			= powertecscsi_proc_info,
 	.name				= "PowerTec SCSI",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= powertecscsi_info,
 	.queuecommand			= fas216_queue_command,
 	.eh_host_reset_handler		= fas216_eh_host_reset,
diff --git a/drivers/scsi/atari_scsi.c b/drivers/scsi/atari_scsi.c
index 6f8403b..02f473a 100644
--- a/drivers/scsi/atari_scsi.c
+++ b/drivers/scsi/atari_scsi.c
@@ -1129,6 +1129,7 @@ static void atari_scsi_falcon_reg_write(unsigned char reg, unsigned char value)
 static struct scsi_host_template driver_template = {
 	.proc_info		= atari_scsi_proc_info,
 	.name			= "Atari native SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= atari_scsi_detect,
 	.release		= atari_scsi_release,
 	.info			= atari_scsi_info,
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index fec58cc..34717c5 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3234,6 +3234,7 @@ static struct scsi_host_template atp870u_template = {
      .module			= THIS_MODULE,
      .name              	= "atp870u"		/* name */,
      .proc_name			= "atp870u",
+     .supported_mode		= MODE_INITIATOR,
      .proc_info			= atp870u_proc_info,
      .info              	= atp870u_info		/* info */,
      .queuecommand      	= atp870u_queuecommand	/* queuecommand */,
diff --git a/drivers/scsi/blz1230.c b/drivers/scsi/blz1230.c
index 23f7c24..b69000d 100644
--- a/drivers/scsi/blz1230.c
+++ b/drivers/scsi/blz1230.c
@@ -333,6 +333,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-blz1230",
 	.proc_info		= esp_proc_info,
 	.name			= "Blizzard1230 SCSI IV",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= blz1230_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/blz2060.c b/drivers/scsi/blz2060.c
index b6203ec..029402e 100644
--- a/drivers/scsi/blz2060.c
+++ b/drivers/scsi/blz2060.c
@@ -286,6 +286,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-blz2060",
 	.proc_info		= esp_proc_info,
 	.name			= "Blizzard2060 SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= blz2060_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/cyberstorm.c b/drivers/scsi/cyberstorm.c
index c6b98a4..c63a703 100644
--- a/drivers/scsi/cyberstorm.c
+++ b/drivers/scsi/cyberstorm.c
@@ -357,6 +357,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-cyberstorm",
 	.proc_info		= esp_proc_info,
 	.name			= "CyberStorm SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= cyber_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/cyberstormII.c b/drivers/scsi/cyberstormII.c
index e336e85..9fc44bf 100644
--- a/drivers/scsi/cyberstormII.c
+++ b/drivers/scsi/cyberstormII.c
@@ -294,6 +294,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-cyberstormII",
 	.proc_info		= esp_proc_info,
 	.name			= "CyberStorm Mk II SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= cyberII_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 7b8a345..7c48f1e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4753,6 +4753,7 @@ static struct scsi_host_template dc395x_driver_template = {
 	.proc_name              = DC395X_NAME,
 	.proc_info              = dc395x_proc_info,
 	.name                   = DC395X_BANNER " " DC395X_VERSION,
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand           = dc395x_queue_command,
 	.bios_param             = dc395x_bios_param,
 	.slave_alloc            = dc395x_slave_alloc,
diff --git a/drivers/scsi/dec_esp.c b/drivers/scsi/dec_esp.c
index d42ad66..3c27f4b 100644
--- a/drivers/scsi/dec_esp.c
+++ b/drivers/scsi/dec_esp.c
@@ -101,6 +101,7 @@ static irqreturn_t scsi_dma_int(int, void *);
 static struct scsi_host_template dec_esp_template = {
 	.module			= THIS_MODULE,
 	.name			= "NCR53C94",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= esp_info,
 	.queuecommand		= esp_queue,
 	.eh_abort_handler	= esp_abort,
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index fa738ec..61c5053 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -58,6 +58,7 @@
 static struct scsi_host_template dmx3191d_driver_template = {
 	.proc_name		= DMX3191D_DRIVER_NAME,
 	.name			= "Domex DMX3191D",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= NCR5380_queue_command,
 	.eh_abort_handler	= NCR5380_abort,
 	.eh_bus_reset_handler	= NCR5380_bus_reset,
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index da7409e..3deceb0 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -470,6 +470,7 @@ static int dtc_release(struct Scsi_Host *shost)
 
 static struct scsi_host_template driver_template = {
 	.name				= "DTC 3180/3280 ",
+	.supported_mode			= MODE_INITIATOR,
 	.detect				= dtc_detect,
 	.release			= dtc_release,
 	.queuecommand			= dtc_queue_command,
diff --git a/drivers/scsi/eata.c b/drivers/scsi/eata.c
index a83e9f1..d168a8b 100644
--- a/drivers/scsi/eata.c
+++ b/drivers/scsi/eata.c
@@ -514,6 +514,7 @@ static int eata2x_slave_configure(struct scsi_device *);
 
 static struct scsi_host_template driver_template = {
 	.name = "EATA/DMA 2.0x rev. 8.10.00 ",
+	.supported_mode	= MODE_INITIATOR,
 	.detect = eata2x_detect,
 	.release = eata2x_release,
 	.queuecommand = eata2x_queuecommand,
diff --git a/drivers/scsi/eata_pio.c b/drivers/scsi/eata_pio.c
index f33ad01..7067a6e 100644
--- a/drivers/scsi/eata_pio.c
+++ b/drivers/scsi/eata_pio.c
@@ -1000,6 +1000,7 @@ static int eata_pio_detect(struct scsi_host_template *tpnt)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "eata_pio",
 	.name              	= "EATA (Extended Attachment) PIO driver",
+	.supported_mode		= MODE_INITIATOR,
 	.proc_info         	= eata_pio_proc_info,
 	.detect            	= eata_pio_detect,
 	.release           	= eata_pio_release,
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index 95cf7b6..a44d571 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2593,6 +2593,7 @@ static const char *esp_info(struct Scsi_Host *host)
 struct scsi_host_template scsi_esp_template = {
 	.module			= THIS_MODULE,
 	.name			= "esp",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= esp_info,
 	.queuecommand		= esp_queuecommand,
 	.slave_alloc		= esp_slave_alloc,
diff --git a/drivers/scsi/fastlane.c b/drivers/scsi/fastlane.c
index 4266a21..3eb5d9f 100644
--- a/drivers/scsi/fastlane.c
+++ b/drivers/scsi/fastlane.c
@@ -402,6 +402,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-fastlane",
 	.proc_info		= esp_proc_info,
 	.name			= "Fastlane SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= fastlane_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/fcal.c b/drivers/scsi/fcal.c
index c4e16c0..ddcc809 100644
--- a/drivers/scsi/fcal.c
+++ b/drivers/scsi/fcal.c
@@ -297,6 +297,7 @@ static int fcal_encode_addr(Scsi_Cmnd *SCpnt, u16 *addr, fc_channel *fc, fcp_cmn
 
 static struct scsi_host_template driver_template = {
 	.name			= "Fibre Channel Arbitrated Loop",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= fcal_detect,
 	.release		= fcal_release,	
 	.proc_info		= fcal_proc_info,
diff --git a/drivers/scsi/fd_mcs.c b/drivers/scsi/fd_mcs.c
index 668569e..67bf09b 100644
--- a/drivers/scsi/fd_mcs.c
+++ b/drivers/scsi/fd_mcs.c
@@ -1347,6 +1347,7 @@ static int fd_mcs_biosparam(struct scsi_device * disk, struct block_device *bdev
 
 static struct scsi_host_template driver_template = {
 	.proc_name			= "fd_mcs",
+	.supported_mode			= MODE_INITIATOR,
 	.proc_info			= fd_mcs_proc_info,
 	.detect				= fd_mcs_detect,
 	.release			= fd_mcs_release,
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 36169d5..b1b659d 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1749,6 +1749,7 @@ struct scsi_host_template fdomain_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= "fdomain",
 	.proc_name		= "fdomain",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= fdomain_16x0_detect,
 	.info			= fdomain_16x0_info,
 	.queuecommand		= fdomain_16x0_queue,
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 607336f..6b1495e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -912,6 +912,7 @@ static int generic_NCR5380_proc_info(struct Scsi_Host *scsi_ptr, char *buffer, c
 static struct scsi_host_template driver_template = {
 	.proc_info      	= generic_NCR5380_proc_info,
 	.name           	= "Generic NCR5380/NCR53C400 Scsi Driver",
+	.supported_mode		= MODE_INITIATOR,
 	.detect         	= generic_NCR5380_detect,
 	.release        	= generic_NCR5380_release_resources,
 	.info           	= generic_NCR5380_info,
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b20c188..9e7b03e 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -5645,6 +5645,7 @@ static Scsi_Host_Template driver_template = {
         .proc_name              = "gdth", 
         .proc_info              = gdth_proc_info,
         .name                   = "GDT SCSI Disk Array Controller",
+        .supported_mode         = MODE_INITIATOR,
         .detect                 = gdth_detect, 
         .release                = gdth_release,
         .info                   = gdth_info, 
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 37741e9..0f0d2eb 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -363,6 +363,7 @@ static int gvp11_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "GVP11",
 	.name			= "GVP Series II SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= gvp11_detect,
 	.release		= gvp11_release,
 	.queuecommand		= wd33c93_queuecommand,
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 8b384fa..ff8ace7 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -648,6 +648,7 @@ static struct class_device_attribute *hptiop_attrs[] = {
 static struct scsi_host_template driver_template = {
 	.module                     = THIS_MODULE,
 	.name                       = driver_name,
+	.supported_mode             = MODE_INITIATOR,
 	.queuecommand               = hptiop_queuecommand,
 	.eh_device_reset_handler    = hptiop_reset,
 	.eh_bus_reset_handler       = hptiop_reset,
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 4275d1b..bf421e9 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1499,6 +1499,7 @@ static struct scsi_host_template ibmmca_driver_template = {
           .proc_name      = "ibmmca",
 	  .proc_info	  = ibmmca_proc_info,
           .name           = "IBM SCSI-Subsystem",
+          .supported_mode = MODE_INITIATOR,
           .queuecommand   = ibmmca_queuecommand,
 	  .eh_abort_handler = ibmmca_abort,
 	  .eh_host_reset_handler = ibmmca_host_reset,
diff --git a/drivers/scsi/ibmvscsi/ibmvscsi.c b/drivers/scsi/ibmvscsi/ibmvscsi.c
index 93bd01b..de32e25 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsi.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsi.c
@@ -1534,6 +1534,7 @@ static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IBM POWER Virtual SCSI Adapter " IBMVSCSI_VERSION,
 	.proc_name = "ibmvscsi",
+	.supported_mode	= MODE_INITIATOR,
 	.queuecommand = ibmvscsi_queuecommand,
 	.eh_abort_handler = ibmvscsi_eh_abort_handler,
 	.eh_device_reset_handler = ibmvscsi_eh_device_reset_handler,
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 005d2b0..5ac7d6e 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1128,6 +1128,7 @@ static struct scsi_host_template imm_template = {
 	.proc_name		= "imm",
 	.proc_info		= imm_proc_info,
 	.name			= "Iomega VPI2 (imm) interface",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= imm_queuecommand,
 	.eh_abort_handler	= imm_abort,
 	.eh_bus_reset_handler	= imm_reset,
diff --git a/drivers/scsi/in2000.c b/drivers/scsi/in2000.c
index 312190a..00b378a 100644
--- a/drivers/scsi/in2000.c
+++ b/drivers/scsi/in2000.c
@@ -2321,6 +2321,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name       		= "in2000",
 	.proc_info       		= in2000_proc_info,
 	.name            		= "Always IN2000",
+	.supported_mode			= MODE_INITIATOR,
 	.detect          		= in2000_detect, 
 	.release			= in2000_release,
 	.queuecommand    		= in2000_queuecommand,
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index f142eaf..f59a22d 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4929,6 +4929,7 @@ static const char * ipr_ioa_info(struct Scsi_Host *host)
 static struct scsi_host_template driver_template = {
 	.module = THIS_MODULE,
 	.name = "IPR",
+	.supported_mode	= MODE_INITIATOR,
 	.info = ipr_ioa_info,
 	.ioctl = ipr_ioctl,
 	.queuecommand = ipr_queuecommand,
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index b17771b..805a820 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -368,6 +368,7 @@ static struct scsi_host_template ips_driver_template = {
 	.eh_abort_handler	= ips_eh_abort,
 	.eh_host_reset_handler	= ips_eh_reset,
 	.proc_name		= "ips",
+	.supported_mode		= MODE_INITIATOR,
 	.proc_info		= ips_proc_info,
 	.slave_configure	= ips_slave_configure,
 	.bios_param		= ips_biosparam,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a21455d..4a2ecbc 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2224,6 +2224,7 @@ static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
 static struct scsi_host_template iscsi_sht = {
 	.module			= THIS_MODULE,
 	.name			= "iSCSI Initiator over TCP/IP",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand           = iscsi_queuecommand,
 	.change_queue_depth	= iscsi_change_queue_depth,
 	.can_queue		= ISCSI_DEF_XMIT_CMDS_MAX - 1,
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index cd67493..b82e6f2 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1427,6 +1427,7 @@ lpfc_slave_destroy(struct scsi_device *sdev)
 struct scsi_host_template lpfc_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
@@ -1447,6 +1448,7 @@ struct scsi_host_template lpfc_template = {
 struct scsi_host_template lpfc_vport_template = {
 	.module			= THIS_MODULE,
 	.name			= LPFC_DRIVER_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.info			= lpfc_info,
 	.queuecommand		= lpfc_queuecommand,
 	.eh_abort_handler	= lpfc_abort_handler,
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index b12ad7c..0cc1734 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -395,6 +395,7 @@ static void set_dma_cmds(struct fsc_state *state, struct scsi_cmnd *cmd)
 static struct scsi_host_template mac53c94_template = {
 	.proc_name	= "53c94",
 	.name		= "53C94",
+	.supported_mode	= MODE_INITIATOR,
 	.queuecommand	= mac53c94_queue,
 	.eh_host_reset_handler = mac53c94_host_reset,
 	.can_queue	= 1,
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index bcb4902..725a7e9 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -730,6 +730,7 @@ static void dma_setup_quick(struct NCR_ESP * esp, __u32 addr, int count, int wri
 static struct scsi_host_template driver_template = {
 	.proc_name		= "mac_esp",
 	.name			= "Mac 53C9x SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= mac_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index cdbcaa5..500aeec 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -581,6 +581,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name			= "Mac5380",
 	.proc_info			= macscsi_proc_info,
 	.name				= "Macintosh NCR5380 SCSI",
+	.supported_mode			= MODE_INITIATOR,
 	.detect				= macscsi_detect,
 	.release			= macscsi_release,
 	.info				= macscsi_info,
diff --git a/drivers/scsi/mca_53c9x.c b/drivers/scsi/mca_53c9x.c
index d693d0f..d90ca15 100644
--- a/drivers/scsi/mca_53c9x.c
+++ b/drivers/scsi/mca_53c9x.c
@@ -447,6 +447,7 @@ static void dma_led_off(struct NCR_ESP *esp)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "mca_53c9x",
 	.name			= "NCR 53c9x SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= mca_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 9023ec6..24d4946 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4475,6 +4475,7 @@ static struct scsi_host_template megaraid_template = {
 	.module				= THIS_MODULE,
 	.name				= "MegaRAID",
 	.proc_name			= "megaraid_legacy",
+	.supported_mode			= MODE_INITIATOR,
 	.info				= megaraid_info,
 	.queuecommand			= megaraid_queue,	
 	.bios_param			= megaraid_biosparam,
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index c6a53dc..380038d 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -354,6 +354,7 @@ static struct scsi_host_template megaraid_template_g = {
 	.module				= THIS_MODULE,
 	.name				= "LSI Logic MegaRAID driver",
 	.proc_name			= "megaraid",
+	.supported_mode			= MODE_INITIATOR,
 	.queuecommand			= megaraid_queue_command,
 	.eh_abort_handler		= megaraid_abort_handler,
 	.eh_device_reset_handler	= megaraid_reset_handler,
diff --git a/drivers/scsi/megaraid/megaraid_sas.c b/drivers/scsi/megaraid/megaraid_sas.c
index ebb948c..9ef4e65 100644
--- a/drivers/scsi/megaraid/megaraid_sas.c
+++ b/drivers/scsi/megaraid/megaraid_sas.c
@@ -1102,6 +1102,7 @@ static struct scsi_host_template megasas_template = {
 	.module = THIS_MODULE,
 	.name = "LSI Logic SAS based MegaRAID driver",
 	.proc_name = "megaraid_sas",
+	.supported_mode	= MODE_INITIATOR,
 	.slave_configure = megasas_slave_configure,
 	.queuecommand = megasas_queue_command,
 	.eh_device_reset_handler = megasas_reset_device,
diff --git a/drivers/scsi/mesh.c b/drivers/scsi/mesh.c
index 651d09b..b987b23 100644
--- a/drivers/scsi/mesh.c
+++ b/drivers/scsi/mesh.c
@@ -1835,6 +1835,7 @@ static int mesh_shutdown(struct macio_dev *mdev)
 static struct scsi_host_template mesh_template = {
 	.proc_name			= "mesh",
 	.name				= "MESH",
+	.supported_mode			= MODE_INITIATOR,
 	.queuecommand			= mesh_queue,
 	.eh_abort_handler		= mesh_abort,
 	.eh_host_reset_handler		= mesh_host_reset,
diff --git a/drivers/scsi/mvme147.c b/drivers/scsi/mvme147.c
index be41aad..f044455 100644
--- a/drivers/scsi/mvme147.c
+++ b/drivers/scsi/mvme147.c
@@ -132,6 +132,7 @@ static int mvme147_bus_reset(struct scsi_cmnd *cmd)
 static struct scsi_host_template driver_template = {
 	.proc_name		= "MVME147",
 	.name			= "MVME147 built-in SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= mvme147_detect,
 	.release		= mvme147_release,
 	.queuecommand		= wd33c93_queuecommand,
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index b264b49..f5f5a2c 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -27,6 +27,7 @@ MODULE_LICENSE("GPL");
 static struct scsi_host_template mvme16x_scsi_driver_template = {
 	.name			= "MVME16x NCR53c710 SCSI",
 	.proc_name		= "MVME16x",
+	.supported_mode		= MODE_INITIATOR,
 	.this_id		= 7,
 	.module			= THIS_MODULE,
 };
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 7fed353..736fbb8 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -272,6 +272,7 @@ static void nsp32_dmessage(const char *, int, int,    char *, ...);
 static struct scsi_host_template nsp32_template = {
 	.proc_name			= "nsp32",
 	.name				= "Workbit NinjaSCSI-32Bi/UDE",
+	.supported_mode			= MODE_INITIATOR,
 	.proc_info			= nsp32_proc_info,
 	.info				= nsp32_info,
 	.queuecommand			= nsp32_queuecommand,
diff --git a/drivers/scsi/oktagon_esp.c b/drivers/scsi/oktagon_esp.c
index 26a6d55..f04be51 100644
--- a/drivers/scsi/oktagon_esp.c
+++ b/drivers/scsi/oktagon_esp.c
@@ -588,6 +588,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "esp-oktagon",
 	.proc_info		= &esp_proc_info,
 	.name			= "BSC Oktagon SCSI",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= oktagon_esp_detect,
 	.slave_alloc		= esp_slave_alloc,
 	.slave_destroy		= esp_slave_destroy,
diff --git a/drivers/scsi/pas16.c b/drivers/scsi/pas16.c
index ee59656..e0e18ec 100644
--- a/drivers/scsi/pas16.c
+++ b/drivers/scsi/pas16.c
@@ -616,6 +616,7 @@ static int pas16_release(struct Scsi_Host *shost)
 
 static struct scsi_host_template driver_template = {
 	.name           = "Pro Audio Spectrum-16 SCSI",
+	.supported_mode	= MODE_INITIATOR,
 	.detect         = pas16_detect,
 	.release        = pas16_release,
 	.queuecommand   = pas16_queue_command,
diff --git a/drivers/scsi/pcmcia/nsp_cs.c b/drivers/scsi/pcmcia/nsp_cs.c
index 445cfbb..7cca2bc 100644
--- a/drivers/scsi/pcmcia/nsp_cs.c
+++ b/drivers/scsi/pcmcia/nsp_cs.c
@@ -83,6 +83,7 @@ static struct scsi_host_template nsp_driver_template = {
 	.proc_name	         = "nsp_cs",
 	.proc_info		 = nsp_proc_info,
 	.name			 = "WorkBit NinjaSCSI-3/32Bi(16bit)",
+	.supported_mode		 = MODE_INITIATOR,
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
 	.detect			 = nsp_detect_old,
 	.release		 = nsp_release_old,
diff --git a/drivers/scsi/pcmcia/qlogic_stub.c b/drivers/scsi/pcmcia/qlogic_stub.c
index 67c5a58..9929f7d 100644
--- a/drivers/scsi/pcmcia/qlogic_stub.c
+++ b/drivers/scsi/pcmcia/qlogic_stub.c
@@ -75,6 +75,7 @@ static struct scsi_host_template qlogicfas_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= qlogic_name,
 	.proc_name		= qlogic_name,
+	.supported_mode		= MODE_INITIATOR,
 	.info			= qlogicfas408_info,
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 961839e..9193f9c 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -689,6 +689,7 @@ static struct scsi_host_template sym53c500_driver_template = {
      .eh_host_reset_handler	= SYM53C500_host_reset,
      .bios_param		= SYM53C500_biosparm,
      .proc_name			= "SYM53C500",
+     .supported_mode		= MODE_INITIATOR,
      .can_queue			= 1,
      .this_id			= 7,
      .sg_tablesize		= 32,
diff --git a/drivers/scsi/pluto.c b/drivers/scsi/pluto.c
index e221389..130e2a9 100644
--- a/drivers/scsi/pluto.c
+++ b/drivers/scsi/pluto.c
@@ -329,6 +329,7 @@ static int pluto_encode_addr(Scsi_Cmnd *SCpnt, u16 *addr, fc_channel *fc, fcp_cm
 
 static struct scsi_host_template driver_template = {
 	.name			= "Sparc Storage Array 100/200",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= pluto_detect,
 	.release		= pluto_release,
 	.info			= pluto_info,
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 67b6d76..01dd9f5 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -985,6 +985,7 @@ static struct scsi_host_template ppa_template = {
 	.proc_name		= "ppa",
 	.proc_info		= ppa_proc_info,
 	.name			= "Iomega VPI0 (ppa) interface",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= ppa_queuecommand,
 	.eh_abort_handler	= ppa_abort,
 	.eh_bus_reset_handler	= ppa_reset,
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 899e89d..df52361 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -676,6 +676,7 @@ MODULE_LICENSE("GPL");
 static struct scsi_host_template driver_template = {
 	.proc_name		= "psi240i", 
 	.name			= "PSI-240I EIDE Disk Controller",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= Psi240i_Detect,
 	.release		= Psi240i_Release,
 	.queuecommand		= Psi240i_QueueCommand,
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 54d8bdf..2816b04 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4235,6 +4235,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "qla1280",
 	.name			= "Qlogic ISP 1280/12160",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= qla1280_info,
 	.slave_configure	= qla1280_slave_configure,
 	.queuecommand		= qla1280_queuecommand,
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 93c0c7e..52deef1 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -114,6 +114,7 @@ static int qla2x00_change_queue_type(struct scsi_device *, int);
 struct scsi_host_template qla2x00_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= qla2x00_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
@@ -145,6 +146,7 @@ struct scsi_host_template qla2x00_driver_template = {
 struct scsi_host_template qla24xx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= QLA2XXX_DRIVER_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= qla24xx_queuecommand,
 
 	.eh_abort_handler	= qla2xxx_eh_abort,
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index b1d565c..33f073e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -82,6 +82,7 @@ static struct scsi_host_template qla4xxx_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= DRIVER_NAME,
 	.proc_name		= DRIVER_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= qla4xxx_queuecommand,
 
 	.eh_device_reset_handler = qla4xxx_eh_device_reset,
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 94baca8..f56d2d7 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -187,6 +187,7 @@ static struct scsi_host_template qlogicfas_driver_template = {
 	.module			= THIS_MODULE,
 	.name			= qlogicfas_name,
 	.proc_name		= qlogicfas_name,
+	.supported_mode		= MODE_INITIATOR,
 	.info			= qlogicfas408_info,
 	.queuecommand		= qlogicfas408_queuecommand,
 	.eh_abort_handler	= qlogicfas408_abort,
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 5948872..5dfde1e 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1389,6 +1389,7 @@ static int qlogicpti_reset(struct scsi_cmnd *Cmnd)
 static struct scsi_host_template qpti_template = {
 	.module			= THIS_MODULE,
 	.name			= "qlogicpti",
+	.supported_mode		= MODE_INITIATOR,
 	.info			= qlogicpti_info,
 	.queuecommand		= qlogicpti_queuecommand_slow,
 	.eh_abort_handler	= qlogicpti_abort,
diff --git a/drivers/scsi/seagate.c b/drivers/scsi/seagate.c
index ce80fa9..72ec183 100644
--- a/drivers/scsi/seagate.c
+++ b/drivers/scsi/seagate.c
@@ -1652,6 +1652,7 @@ static int seagate_st0x_release(struct Scsi_Host *shost)
 }
 
 static struct scsi_host_template driver_template = {
+	.supported_mode		= MODE_INITIATOR,
 	.detect         	= seagate_st0x_detect,
 	.release        	= seagate_st0x_release,
 	.info           	= seagate_st0x_info,
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index eef8275..29c3f49 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -201,6 +201,7 @@ static struct scsi_host_template sgiwd93_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "SGIWD93",
 	.name			= "SGI WD93",
+	.supported_mode		= MODE_INITIATOR,
 	.queuecommand		= wd33c93_queuecommand,
 	.eh_abort_handler	= wd33c93_abort,
 	.eh_bus_reset_handler	= sgiwd93_bus_reset,
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index d63d229..79c27ae 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -90,6 +90,7 @@ __setup("sim710=", param_setup);
 static struct scsi_host_template sim710_driver_template = {
 	.name			= "LSI (Symbios) 710 MCA/EISA",
 	.proc_name		= "sim710",
+	.supported_mode		= MODE_INITIATOR,
 	.this_id		= 7,
 	.module			= THIS_MODULE,
 };
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 0a6b45b..21836ed 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -59,6 +59,7 @@ MODULE_LICENSE("GPL");
 static struct scsi_host_template snirm710_template = {
 	.name		= "SNI RM SCSI 53c710",
 	.proc_name	= "snirm_53c710",
+	.supported_mode	= MODE_INITIATOR,
 	.this_id	= 7,
 	.module		= THIS_MODULE,
 };
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 72f6d80..590fc27 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1112,6 +1112,7 @@ static struct scsi_host_template driver_template = {
 	.module				= THIS_MODULE,
 	.name				= DRV_NAME,
 	.proc_name			= DRV_NAME,
+	.supported_mode			= MODE_INITIATOR,
 	.bios_param			= stex_biosparam,
 	.queuecommand			= stex_queuecommand,
 	.slave_alloc			= stex_slave_alloc,
diff --git a/drivers/scsi/sun3_scsi.c b/drivers/scsi/sun3_scsi.c
index 5e46d84..5ca8cbb 100644
--- a/drivers/scsi/sun3_scsi.c
+++ b/drivers/scsi/sun3_scsi.c
@@ -623,6 +623,7 @@ static int sun3scsi_dma_finish(int write_flag)
 
 static struct scsi_host_template driver_template = {
 	.name			= SUN3_SCSI_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
 	.info			= sun3scsi_info,
diff --git a/drivers/scsi/sun3_scsi_vme.c b/drivers/scsi/sun3_scsi_vme.c
index 7cb4a31..b08cca7 100644
--- a/drivers/scsi/sun3_scsi_vme.c
+++ b/drivers/scsi/sun3_scsi_vme.c
@@ -566,6 +566,7 @@ static int sun3scsi_dma_finish(int write_flag)
 
 static struct scsi_host_template driver_template = {
 	.name			= SUN3_SCSI_NAME,
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= sun3scsi_detect,
 	.release		= sun3scsi_release,
 	.info			= sun3scsi_info,
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 80fb3f8..910fdf0 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -371,6 +371,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "sun3x_esp",
 	.proc_info		= &esp_proc_info,
 	.name			= "Sun ESP 100/100a/200",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= sun3x_esp_detect,
 	.release                = sun3x_esp_release,
 	.slave_alloc		= esp_slave_alloc,
diff --git a/drivers/scsi/sym53c416.c b/drivers/scsi/sym53c416.c
index 92bfaea..925d2c9 100644
--- a/drivers/scsi/sym53c416.c
+++ b/drivers/scsi/sym53c416.c
@@ -842,6 +842,7 @@ module_param_array(sym53c416_3, uint, NULL, 0);
 static struct scsi_host_template driver_template = {
 	.proc_name =		"sym53c416",
 	.name =			"Symbios Logic 53c416",
+	.supported_mode	= 	MODE_INITIATOR,
 	.detect =		sym53c416_detect,
 	.info =			sym53c416_info,	
 	.queuecommand =		sym53c416_queuecommand,
diff --git a/drivers/scsi/t128.c b/drivers/scsi/t128.c
index 248d60b..4b32e48 100644
--- a/drivers/scsi/t128.c
+++ b/drivers/scsi/t128.c
@@ -431,6 +431,7 @@ MODULE_LICENSE("GPL");
 
 static struct scsi_host_template driver_template = {
 	.name           = "Trantor T128/T128F/T228",
+	.supported_mode	= MODE_INITIATOR,
 	.detect         = t128_detect,
 	.release        = t128_release,
 	.queuecommand   = t128_queue_command,
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5db1520..7b38e48 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2201,6 +2201,7 @@ static struct scsi_host_template driver_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "tmscsim", 
 	.name			= DC390_BANNER " V" DC390_VERSION,
+	.supported_mode		= MODE_INITIATOR,
 	.slave_alloc		= dc390_slave_alloc,
 	.slave_configure	= dc390_slave_configure,
 	.slave_destroy		= dc390_slave_destroy,
diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 9e8232a..95be04a 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -441,6 +441,7 @@ static int u14_34f_slave_configure(struct scsi_device *);
 
 static struct scsi_host_template driver_template = {
                 .name                    = "UltraStor 14F/34F rev. 8.10.00 ",
+                .supported_mode          = MODE_INITIATOR,
                 .detect                  = u14_34f_detect,
                 .release                 = u14_34f_release,
                 .queuecommand            = u14_34f_queuecommand,
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index c08235d..354b9db 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -1185,6 +1185,7 @@ MODULE_LICENSE("GPL");
 
 static struct scsi_host_template driver_template = {
 	.name              = "UltraStor 14F/24F/34F",
+	.supported_mode    = MODE_INITIATOR,
 	.detect            = ultrastor_detect,
 	.release	   = ultrastor_release,
 	.info              = ultrastor_info,
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index d6fd425..8116f38 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1660,6 +1660,7 @@ static struct scsi_host_template driver_template = {
 	.proc_name		= "wd7000",
 	.proc_info		= wd7000_proc_info,
 	.name			= "Western Digital WD-7000",
+	.supported_mode		= MODE_INITIATOR,
 	.detect			= wd7000_detect,
 	.release		= wd7000_release,
 	.queuecommand		= wd7000_queuecommand,
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 4b5f908..0c980a2 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -80,6 +80,7 @@ lasi_scsi_clock(void * hpa, int defaultclock)
 static struct scsi_host_template zalon7xx_template = {
 	.module		= THIS_MODULE,
 	.proc_name	= "zalon7xx",
+	.supported_mode	= MODE_INITIATOR,
 };
 
 static int __init
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index ac67394..2773f39 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -26,6 +26,7 @@ MODULE_LICENSE("GPL");
 
 static struct scsi_host_template zorro7xx_scsi_driver_template = {
 	.proc_name	= "zorro7xx",
+	.supported_mode	= MODE_INITIATOR,
 	.this_id	= 7,
 	.module		= THIS_MODULE,
 };
-- 
1.5.2.4

