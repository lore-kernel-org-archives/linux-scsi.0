From: Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH 425/493] scsi: remove use of __devexit
Date: Mon, 19 Nov 2012 13:26:14 -0500
Message-ID: <1353349642-3677-425-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41504 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab2KSSfF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:35:05 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com

CONFIG_HOTPLUG is going away as an option so __devexit is no
longer needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com> 
Cc: Matthew Wilcox <matthew@wil.cx> 
Cc: Russell King <linux@arm.linux.org.uk> 
Cc: Oliver Neukum <oliver@neukum.org> 
Cc: Ali Akcaagac <aliakc@web.de> 
Cc: Jamie Lenehan <lenehan@twibble.org> 
Cc: Neela Syam Kolli <megaraidlinux@lsi.com> 
Cc: GOTO Masanori <gotom@debian.or.jp> 
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp> 
Cc: Michael Reed <mdr@sgi.com> 
Cc: Kurt Garloff <garloff@suse.de> 
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de> 
Cc: linux-scsi@vger.kernel.org 
Cc: linux-arm-kernel@lists.infradead.org 
Cc: dc395x@twibble.org 
Cc: iss_storagedev@hp.com 
---
 drivers/scsi/NCR_D700.c                   | 4 ++--
 drivers/scsi/a100u2w.c                    | 2 +-
 drivers/scsi/a2091.c                      | 2 +-
 drivers/scsi/aacraid/linit.c              | 2 +-
 drivers/scsi/advansys.c                   | 6 +++---
 drivers/scsi/aha1740.c                    | 2 +-
 drivers/scsi/aic94xx/aic94xx_init.c       | 2 +-
 drivers/scsi/arm/acornscsi.c              | 2 +-
 drivers/scsi/arm/arxescsi.c               | 2 +-
 drivers/scsi/arm/cumana_1.c               | 2 +-
 drivers/scsi/arm/cumana_2.c               | 2 +-
 drivers/scsi/arm/eesox.c                  | 2 +-
 drivers/scsi/arm/oak.c                    | 2 +-
 drivers/scsi/arm/powertec.c               | 2 +-
 drivers/scsi/bvme6000_scsi.c              | 2 +-
 drivers/scsi/dc395x.c                     | 2 +-
 drivers/scsi/dmx3191d.c                   | 2 +-
 drivers/scsi/fnic/fnic_main.c             | 2 +-
 drivers/scsi/gdth.c                       | 2 +-
 drivers/scsi/gvp11.c                      | 2 +-
 drivers/scsi/hpsa.c                       | 4 ++--
 drivers/scsi/ipr.c                        | 2 +-
 drivers/scsi/ips.c                        | 4 ++--
 drivers/scsi/isci/init.c                  | 2 +-
 drivers/scsi/jazz_esp.c                   | 2 +-
 drivers/scsi/lpfc/lpfc_init.c             | 6 +++---
 drivers/scsi/mac_esp.c                    | 2 +-
 drivers/scsi/megaraid.c                   | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      | 2 +-
 drivers/scsi/mvme16x_scsi.c               | 2 +-
 drivers/scsi/mvsas/mv_init.c              | 2 +-
 drivers/scsi/nsp32.c                      | 4 ++--
 drivers/scsi/pm8001/pm8001_init.c         | 2 +-
 drivers/scsi/pmcraid.c                    | 2 +-
 drivers/scsi/qla1280.c                    | 2 +-
 drivers/scsi/qla4xxx/ql4_os.c             | 2 +-
 drivers/scsi/qlogicpti.c                  | 4 ++--
 drivers/scsi/sim710.c                     | 2 +-
 drivers/scsi/sun3x_esp.c                  | 2 +-
 drivers/scsi/sun_esp.c                    | 2 +-
 drivers/scsi/tmscsim.c                    | 2 +-
 drivers/scsi/virtio_scsi.c                | 2 +-
 drivers/scsi/zorro7xx.c                   | 2 +-
 44 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 86b3533..b39a240 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -349,7 +349,7 @@ NCR_D700_probe(struct device *dev)
 	return 0;
 }
 
-static void __devexit
+static void
 NCR_D700_remove_one(struct Scsi_Host *host)
 {
 	scsi_remove_host(host);
@@ -359,7 +359,7 @@ NCR_D700_remove_one(struct Scsi_Host *host)
 	release_region(host->base, 64);
 }
 
-static int __devexit
+static int
 NCR_D700_remove(struct device *dev)
 {
 	struct NCR_D700_private *p = dev_get_drvdata(dev);
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 9f9193b..7624a1f 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1197,7 +1197,7 @@ out:
 	return error;
 }
 
-static void __devexit inia100_remove_one(struct pci_dev *pdev)
+static void inia100_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct orc_host *host = (struct orc_host *)shost->hostdata;
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 7c6e9aa..3ec409e 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -239,7 +239,7 @@ fail_alloc:
 	return error;
 }
 
-static void __devexit a2091_remove(struct zorro_dev *z)
+static void a2091_remove(struct zorro_dev *z)
 {
 	struct Scsi_Host *instance = zorro_get_drvdata(z);
 	struct a2091_hostdata *hdata = shost_priv(instance);
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index ac8fcfa..5394b98 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1308,7 +1308,7 @@ static void aac_shutdown(struct pci_dev *dev)
 	__aac_shutdown((struct aac_dev *)shost->hostdata);
 }
 
-static void __devexit aac_remove_one(struct pci_dev *pdev)
+static void aac_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 	struct aac_dev *aac = (struct aac_dev *)shost->hostdata;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 409e2a4..d8b0379 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -12477,7 +12477,7 @@ static int advansys_isa_probe(struct device *dev, unsigned int id)
 	return err;
 }
 
-static int __devexit advansys_isa_remove(struct device *dev, unsigned int id)
+static int advansys_isa_remove(struct device *dev, unsigned int id)
 {
 	int ioport = _asc_def_iop_base[id];
 	advansys_release(dev_get_drvdata(dev));
@@ -12677,7 +12677,7 @@ static int advansys_eisa_probe(struct device *dev)
 	return err;
 }
 
-static __devexit int advansys_eisa_remove(struct device *dev)
+static int advansys_eisa_remove(struct device *dev)
 {
 	int i;
 	struct eisa_scsi_data *data = dev_get_drvdata(dev);
@@ -12791,7 +12791,7 @@ advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return err;
 }
 
-static void __devexit advansys_pci_remove(struct pci_dev *pdev)
+static void advansys_pci_remove(struct pci_dev *pdev)
 {
 	advansys_release(pci_get_drvdata(pdev));
 	pci_release_regions(pdev);
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index f69e89a..df775e6 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -646,7 +646,7 @@ static int aha1740_probe (struct device *dev)
 	return -ENODEV;
 }
 
-static __devexit int aha1740_remove (struct device *dev)
+static int aha1740_remove (struct device *dev)
 {
 	struct Scsi_Host *shpnt = dev_get_drvdata(dev);
 	struct aha1740_hostdata *host = HOSTDATA (shpnt);
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
index 2dcf914..2bdc4a71 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -924,7 +924,7 @@ static void asd_turn_off_leds(struct asd_ha_struct *asd_ha)
 	}
 }
 
-static void __devexit asd_pci_remove(struct pci_dev *dev)
+static void asd_pci_remove(struct pci_dev *dev)
 {
 	struct asd_ha_struct *asd_ha = pci_get_drvdata(dev);
 
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.c
index 378c37f..7da1b65 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -3032,7 +3032,7 @@ acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit acornscsi_remove(struct expansion_card *ec)
+static void acornscsi_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 	AS_Host *ashost = (AS_Host *)host->hostdata;
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index a9e0501..b3b8768 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -340,7 +340,7 @@ arxescsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit arxescsi_remove(struct expansion_card *ec)
+static void arxescsi_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index a2af968..2064094 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -298,7 +298,7 @@ cumanascsi1_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit cumanascsi1_remove(struct expansion_card *ec)
+static void cumanascsi1_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 59b5d89..e5b1438 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -495,7 +495,7 @@ cumanascsi2_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit cumanascsi2_remove(struct expansion_card *ec)
+static void cumanascsi2_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 	struct cumanascsi2_info *info = (struct cumanascsi2_info *)host->hostdata;
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index d70c041..25efc76 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -617,7 +617,7 @@ eesoxscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit eesoxscsi_remove(struct expansion_card *ec)
+static void eesoxscsi_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 	struct eesoxscsi_info *info = (struct eesoxscsi_info *)host->hostdata;
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 676079a..9e6c096 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -182,7 +182,7 @@ oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit oakscsi_remove(struct expansion_card *ec)
+static void oakscsi_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index a164ad1..a40d720 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -409,7 +409,7 @@ powertecscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 	return ret;
 }
 
-static void __devexit powertecscsi_remove(struct expansion_card *ec)
+static void powertecscsi_remove(struct expansion_card *ec)
 {
 	struct Scsi_Host *host = ecard_get_drvdata(ec);
 	struct powertec_info *info = (struct powertec_info *)host->hostdata;
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.c
index 4461df8..1e3f96a 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -88,7 +88,7 @@ bvme6000_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static __devexit int
+static int
 bvme6000_device_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(dev);
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 643c568..dc098b7 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4861,7 +4861,7 @@ fail:
  *
  * @dev: The PCI device to initialize.
  **/
-static void __devexit dc395x_remove_one(struct pci_dev *dev)
+static void dc395x_remove_one(struct pci_dev *dev)
 {
 	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
 	struct AdapterCtlBlk *acb = (struct AdapterCtlBlk *)(scsi_host->hostdata);
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 6a1b929..64216d8 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -123,7 +123,7 @@ static int dmx3191d_probe_one(struct pci_dev *pdev,
 	return error;
 }
 
-static void __devexit dmx3191d_remove_one(struct pci_dev *pdev)
+static void dmx3191d_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
 
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 8266575..ca57966 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -774,7 +774,7 @@ err_out:
 	return err;
 }
 
-static void __devexit fnic_remove(struct pci_dev *pdev)
+static void fnic_remove(struct pci_dev *pdev)
 {
 	struct fnic *fnic = pci_get_drvdata(pdev);
 	struct fc_lport *lp = fnic->lport;
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index af5ee22..e452236 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -590,7 +590,7 @@ static struct pci_driver gdth_pci_driver = {
 	.remove		= gdth_pci_remove_one,
 };
 
-static void __devexit gdth_pci_remove_one(struct pci_dev *pdev)
+static void gdth_pci_remove_one(struct pci_dev *pdev)
 {
 	gdth_ha_str *ha = pci_get_drvdata(pdev);
 
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index ee30759..0c63876 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -380,7 +380,7 @@ fail_check_or_alloc:
 	return error;
 }
 
-static void __devexit gvp11_remove(struct zorro_dev *z)
+static void gvp11_remove(struct zorro_dev *z)
 {
 	struct Scsi_Host *instance = zorro_get_drvdata(z);
 	struct gvp11_hostdata *hdata = shost_priv(instance);
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 85891e2..45231ab 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4910,7 +4910,7 @@ static void hpsa_shutdown(struct pci_dev *pdev)
 	hpsa_free_irqs_and_disable_msix(h);
 }
 
-static void __devexit hpsa_free_device_info(struct ctlr_info *h)
+static void hpsa_free_device_info(struct ctlr_info *h)
 {
 	int i;
 
@@ -4918,7 +4918,7 @@ static void __devexit hpsa_free_device_info(struct ctlr_info *h)
 		kfree(h->dev[i]);
 }
 
-static void __devexit hpsa_remove_one(struct pci_dev *pdev)
+static void hpsa_remove_one(struct pci_dev *pdev)
 {
 	struct ctlr_info *h;
 
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 255ad48..8b4718c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9112,7 +9112,7 @@ static void __ipr_remove(struct pci_dev *pdev)
  * Return value:
  * 	none
  **/
-static void __devexit ipr_remove(struct pci_dev *pdev)
+static void ipr_remove(struct pci_dev *pdev)
 {
 	struct ipr_ioa_cfg *ioa_cfg = pci_get_drvdata(pdev);
 
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 6bea0d8..9aa86a3 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -390,7 +390,7 @@ MODULE_DEVICE_TABLE( pci, ips_pci_table );
 static char ips_hot_plug_name[] = "ips";
 
 static int  ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id *ent);
-static void __devexit ips_remove_device(struct pci_dev *pci_dev);
+static void ips_remove_device(struct pci_dev *pci_dev);
 
 static struct pci_driver ips_pci_driver = {
 	.name		= ips_hot_plug_name,
@@ -6837,7 +6837,7 @@ err_out_sh:
 /*   Routine Description:                                                    */
 /*     Remove one Adapter ( Hot Plugging )                                   */
 /*---------------------------------------------------------------------------*/
-static void __devexit
+static void
 ips_remove_device(struct pci_dev *pci_dev)
 {
 	struct Scsi_Host *sh = pci_get_drvdata(pci_dev);
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 639b0fc..d73fdcf 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -709,7 +709,7 @@ static int isci_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return err;
 }
 
-static void __devexit isci_pci_remove(struct pci_dev *pdev)
+static void isci_pci_remove(struct pci_dev *pdev)
 {
 	struct isci_host *ihost;
 	int i;
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 3326ac4..69efbf1 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -201,7 +201,7 @@ fail:
 	return err;
 }
 
-static int __devexit esp_jazz_remove(struct platform_device *dev)
+static int esp_jazz_remove(struct platform_device *dev)
 {
 	struct esp *esp = dev_get_drvdata(&dev->dev);
 	unsigned int irq = esp->host->irq;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index b8ae0d9..d49874d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8980,7 +8980,7 @@ out_free_phba:
  * removed from PCI bus, it performs all the necessary cleanup for the HBA
  * device to be removed from the PCI subsystem properly.
  **/
-static void __devexit
+static void
 lpfc_pci_remove_one_s3(struct pci_dev *pdev)
 {
 	struct Scsi_Host  *shost = pci_get_drvdata(pdev);
@@ -9750,7 +9750,7 @@ out_free_phba:
  * removed from PCI bus, it performs all the necessary cleanup for the HBA
  * device to be removed from the PCI subsystem properly.
  **/
-static void __devexit
+static void
 lpfc_pci_remove_one_s4(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
@@ -10204,7 +10204,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *pid)
  * remove routine, which will perform all the necessary cleanup for the
  * device to be removed from the PCI subsystem properly.
  **/
-static void __devexit
+static void
 lpfc_pci_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 844ea3c..994fc5c 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -591,7 +591,7 @@ fail:
 	return err;
 }
 
-static int __devexit esp_mac_remove(struct platform_device *dev)
+static int esp_mac_remove(struct platform_device *dev)
 {
 	struct mac_esp_priv *mep = platform_get_drvdata(dev);
 	struct esp *esp = mep->esp;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index fe962f2..9504ec0 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4914,7 +4914,7 @@ __megaraid_shutdown(adapter_t *adapter)
 		mdelay(1000);
 }
 
-static void __devexit
+static void
 megaraid_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 73f9492..84d2156 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4526,7 +4526,7 @@ fail_ready_state:
  * megasas_detach_one -	PCI hot"un"plug entry point
  * @pdev:		PCI device structure
  */
-static void __devexit megasas_detach_one(struct pci_dev *pdev)
+static void megasas_detach_one(struct pci_dev *pdev)
 {
 	int i;
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 794c397..c6bdc92 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7686,7 +7686,7 @@ _scsih_shutdown(struct pci_dev *pdev)
  * Routine called when unloading the driver.
  * Return nothing.
  */
-static void __devexit
+static void
 _scsih_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *shost = pci_get_drvdata(pdev);
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index bda320b..f07ef74 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -103,7 +103,7 @@ mvme16x_probe(struct platform_device *dev)
 	return -ENODEV;
 }
 
-static __devexit int
+static int
 mvme16x_device_remove(struct platform_device *dev)
 {
 	struct Scsi_Host *host = platform_get_drvdata(dev);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 830a7da..b0fdd75 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -645,7 +645,7 @@ err_out_enable:
 	return rc;
 }
 
-static void __devexit mvs_pci_remove(struct pci_dev *pdev)
+static void mvs_pci_remove(struct pci_dev *pdev)
 {
 	unsigned short core_nr, i = 0;
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 0a7500d..18449c7 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -187,7 +187,7 @@ static nsp32_sync_table nsp32_sync_table_pci[] = {
  */
 /* module entry point */
 static int  nsp32_probe (struct pci_dev *, const struct pci_device_id *);
-static void __devexit nsp32_remove(struct pci_dev *);
+static void nsp32_remove(struct pci_dev *);
 static int  __init    init_nsp32  (void);
 static void __exit    exit_nsp32  (void);
 
@@ -3418,7 +3418,7 @@ static int nsp32_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return ret;
 }
 
-static void __devexit nsp32_remove(struct pci_dev *pdev)
+static void nsp32_remove(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
 
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index c0e1c18..b02625f 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -706,7 +706,7 @@ err_out_enable:
 	return rc;
 }
 
-static void __devexit pm8001_pci_remove(struct pci_dev *pdev)
+static void pm8001_pci_remove(struct pci_dev *pdev)
 {
 	struct sas_ha_struct *sha = pci_get_drvdata(pdev);
 	struct pm8001_hba_info *pm8001_ha;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index f46ec1b..b389855 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -5442,7 +5442,7 @@ static void pmcraid_release_chrdev(struct pmcraid_instance *pinstance)
  * Return value
  *	  none
  */
-static void __devexit pmcraid_remove(struct pci_dev *pdev)
+static void pmcraid_remove(struct pci_dev *pdev)
 {
 	struct pmcraid_instance *pinstance = pci_get_drvdata(pdev);
 
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 434477b..5a522c5 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4399,7 +4399,7 @@ qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 }
 
 
-static void __devexit
+static void
 qla1280_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index f8bb98e..51323a7 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5464,7 +5464,7 @@ static void qla4xxx_destroy_fw_ddb_session(struct scsi_qla_host *ha)
  * qla4xxx_remove_adapter - callback function to remove adapter.
  * @pci_dev: PCI device pointer
  **/
-static void __devexit qla4xxx_remove_adapter(struct pci_dev *pdev)
+static void qla4xxx_remove_adapter(struct pci_dev *pdev)
 {
 	struct scsi_qla_host *ha;
 
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 71b38a1..6d48d30 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -686,7 +686,7 @@ static void qpti_chain_add(struct qlogicpti *qpti)
 	spin_unlock_irq(&qptichain_lock);
 }
 
-static void __devexit qpti_chain_del(struct qlogicpti *qpti)
+static void qpti_chain_del(struct qlogicpti *qpti)
 {
 	spin_lock_irq(&qptichain_lock);
 	if (qptichain == qpti) {
@@ -1402,7 +1402,7 @@ fail_unlink:
 	return -ENODEV;
 }
 
-static int __devexit qpti_sbus_remove(struct platform_device *op)
+static int qpti_sbus_remove(struct platform_device *op)
 {
 	struct qlogicpti *qpti = dev_get_drvdata(&op->dev);
 
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index e616bc2..92f92c6 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -153,7 +153,7 @@ sim710_probe_common(struct device *dev, unsigned long base_addr,
 	return -ENODEV;
 }
 
-static __devexit int
+static int
 sim710_device_remove(struct device *dev)
 {
 	struct Scsi_Host *host = dev_get_drvdata(dev);
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index d8e3a1c..534eb96 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -268,7 +268,7 @@ fail:
 	return err;
 }
 
-static int __devexit esp_sun3x_remove(struct platform_device *dev)
+static int esp_sun3x_remove(struct platform_device *dev)
 {
 	struct esp *esp = dev_get_drvdata(&dev->dev);
 	unsigned int irq = esp->host->irq;
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 707252c..43247e9 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -585,7 +585,7 @@ static int esp_sbus_probe(struct platform_device *op)
 	return esp_sbus_probe_one(op, dma_of, hme);
 }
 
-static int __devexit esp_sbus_remove(struct platform_device *op)
+static int esp_sbus_remove(struct platform_device *op)
 {
 	struct esp *esp = dev_get_drvdata(&op->dev);
 	struct platform_device *dma_of = esp->dma;
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 56a8697..4f9ed49 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2532,7 +2532,7 @@ static int dc390_probe_one(struct pci_dev *pdev,
  *
  * @dev: The PCI device to remove.
  */
-static void __devexit dc390_remove_one(struct pci_dev *dev)
+static void dc390_remove_one(struct pci_dev *dev)
 {
 	struct Scsi_Host *scsi_host = pci_get_drvdata(dev);
 	unsigned long iflags;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 98dcae3..ebc6fd4 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -731,7 +731,7 @@ virtscsi_init_failed:
 	return err;
 }
 
-static void __devexit virtscsi_remove(struct virtio_device *vdev)
+static void virtscsi_remove(struct virtio_device *vdev)
 {
 	struct Scsi_Host *shost = virtio_scsi_host(vdev);
 	struct virtio_scsi *vscsi = shost_priv(shost);
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 0ebfdc1..f0cb32c 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -150,7 +150,7 @@ static int zorro7xx_init_one(struct zorro_dev *z,
 	return -ENODEV;
 }
 
-static __devexit void zorro7xx_remove_one(struct zorro_dev *z)
+static void zorro7xx_remove_one(struct zorro_dev *z)
 {
 	struct Scsi_Host *host = zorro_get_drvdata(z);
 	struct NCR_700_Host_Parameters *hostdata = shost_priv(host);
-- 
1.8.0

