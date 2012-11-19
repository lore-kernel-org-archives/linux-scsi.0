From: Bill Pemberton <wfp5p@virginia.edu>
Subject: =?UTF-8?q?=5BPATCH=20097/493=5D=20scsi=3A=20remove=20use=20of=20=5F=5Fdevexit=5Fp?=
Date: Mon, 19 Nov 2012 13:20:46 -0500
Message-ID: <1353349642-3677-97-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41651 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754459Ab2KSSiA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:38:00 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, osst-users@lists.sourceforge.net

CONFIG_HOTPLUG is going away as an option so __devexit_p is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>=20
Cc: Matthew Wilcox <matthew@wil.cx>=20
Cc: Russell King <linux@arm.linux.org.uk>=20
Cc: Oliver Neukum <oliver@neukum.org>=20
Cc: Ali Akcaagac <aliakc@web.de>=20
Cc: Jamie Lenehan <lenehan@twibble.org>=20
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>=20
Cc: GOTO Masanori <gotom@debian.or.jp>=20
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>=20
Cc: Michael Reed <mdr@sgi.com>=20
Cc: Willem Riede <osst@riede.org>=20
Cc: "Kai M=C3=A4kisara" <Kai.Makisara@kolumbus.fi>=20
Cc: Kurt Garloff <garloff@suse.de>=20
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>=20
Cc: Arvind Kumar <arvindkumar@vmware.com>=20
Cc: VMware PV-Drivers <pv-drivers@vmware.com>=20
Cc: linux-scsi@vger.kernel.org=20
Cc: linux-arm-kernel@lists.infradead.org=20
Cc: dc395x@twibble.org=20
Cc: iss_storagedev@hp.com=20
Cc: osst-users@lists.sourceforge.net=20
---
 drivers/scsi/NCR_D700.c                   | 2 +-
 drivers/scsi/NCR_Q720.c                   | 2 +-
 drivers/scsi/a100u2w.c                    | 2 +-
 drivers/scsi/a2091.c                      | 2 +-
 drivers/scsi/aacraid/linit.c              | 2 +-
 drivers/scsi/advansys.c                   | 8 ++++----
 drivers/scsi/aha1740.c                    | 2 +-
 drivers/scsi/aic94xx/aic94xx_init.c       | 2 +-
 drivers/scsi/arm/acornscsi.c              | 2 +-
 drivers/scsi/arm/arxescsi.c               | 2 +-
 drivers/scsi/arm/cumana_1.c               | 2 +-
 drivers/scsi/arm/cumana_2.c               | 2 +-
 drivers/scsi/arm/eesox.c                  | 2 +-
 drivers/scsi/arm/oak.c                    | 2 +-
 drivers/scsi/arm/powertec.c               | 2 +-
 drivers/scsi/atp870u.c                    | 2 +-
 drivers/scsi/bfa/bfad.c                   | 2 +-
 drivers/scsi/bvme6000_scsi.c              | 2 +-
 drivers/scsi/dc395x.c                     | 2 +-
 drivers/scsi/dmx3191d.c                   | 2 +-
 drivers/scsi/fnic/fnic_main.c             | 2 +-
 drivers/scsi/gvp11.c                      | 2 +-
 drivers/scsi/hpsa.c                       | 2 +-
 drivers/scsi/initio.c                     | 2 +-
 drivers/scsi/ipr.c                        | 2 +-
 drivers/scsi/ips.c                        | 2 +-
 drivers/scsi/isci/init.c                  | 2 +-
 drivers/scsi/jazz_esp.c                   | 2 +-
 drivers/scsi/lasi700.c                    | 2 +-
 drivers/scsi/lpfc/lpfc_init.c             | 2 +-
 drivers/scsi/mac_esp.c                    | 2 +-
 drivers/scsi/megaraid.c                   | 2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 drivers/scsi/mpt2sas/mpt2sas_scsih.c      | 2 +-
 drivers/scsi/mvme16x_scsi.c               | 2 +-
 drivers/scsi/mvsas/mv_init.c              | 2 +-
 drivers/scsi/mvumi.c                      | 2 +-
 drivers/scsi/nsp32.c                      | 2 +-
 drivers/scsi/pm8001/pm8001_init.c         | 2 +-
 drivers/scsi/qla1280.c                    | 2 +-
 drivers/scsi/qlogicpti.c                  | 2 +-
 drivers/scsi/sgiwd93.c                    | 2 +-
 drivers/scsi/sim710.c                     | 2 +-
 drivers/scsi/sni_53c710.c                 | 2 +-
 drivers/scsi/stex.c                       | 2 +-
 drivers/scsi/sun3x_esp.c                  | 2 +-
 drivers/scsi/sun_esp.c                    | 2 +-
 drivers/scsi/tmscsim.c                    | 2 +-
 drivers/scsi/ufs/ufshcd.c                 | 2 +-
 drivers/scsi/virtio_scsi.c                | 2 +-
 drivers/scsi/vmw_pvscsi.c                 | 2 +-
 drivers/scsi/zalon.c                      | 2 +-
 drivers/scsi/zorro7xx.c                   | 2 +-
 54 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 8647256..67da749 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -380,7 +380,7 @@ static struct mca_driver NCR_D700_driver =3D {
 		.name		=3D "NCR_D700",
 		.bus		=3D &mca_bus_type,
 		.probe		=3D NCR_D700_probe,
-		.remove		=3D __devexit_p(NCR_D700_remove),
+		.remove		=3D NCR_D700_remove,
 	},
 };
=20
diff --git a/drivers/scsi/NCR_Q720.c b/drivers/scsi/NCR_Q720.c
index afdbb9a..05835bf 100644
--- a/drivers/scsi/NCR_Q720.c
+++ b/drivers/scsi/NCR_Q720.c
@@ -351,7 +351,7 @@ static struct mca_driver NCR_Q720_driver =3D {
 		.name		=3D "NCR_Q720",
 		.bus		=3D &mca_bus_type,
 		.probe		=3D NCR_Q720_probe,
-		.remove		=3D __devexit_p(NCR_Q720_remove),
+		.remove		=3D NCR_Q720_remove,
 	},
 };
=20
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index a391090..4a08ac2 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1224,7 +1224,7 @@ static struct pci_driver inia100_pci_driver =3D {
 	.name		=3D "inia100",
 	.id_table	=3D inia100_pci_tbl,
 	.probe		=3D inia100_probe_one,
-	.remove		=3D __devexit_p(inia100_remove_one),
+	.remove		=3D inia100_remove_one,
 };
=20
 static int __init inia100_init(void)
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index 79a3063..fbd01f9 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -262,7 +262,7 @@ static struct zorro_driver a2091_driver =3D {
 	.name		=3D "a2091",
 	.id_table	=3D a2091_zorro_tbl,
 	.probe		=3D a2091_probe,
-	.remove		=3D __devexit_p(a2091_remove),
+	.remove		=3D a2091_remove,
 };
=20
 static int __init a2091_init(void)
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.=
c
index cb7f158..417cf7c 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1341,7 +1341,7 @@ static struct pci_driver aac_pci_driver =3D {
 	.name		=3D AAC_DRIVERNAME,
 	.id_table	=3D aac_pci_tbl,
 	.probe		=3D aac_probe_one,
-	.remove		=3D __devexit_p(aac_remove_one),
+	.remove		=3D aac_remove_one,
 	.shutdown	=3D aac_shutdown,
 };
=20
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 374c4ed..3dfae22 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -12487,7 +12487,7 @@ static int __devexit advansys_isa_remove(struct=
 device *dev, unsigned int id)
=20
 static struct isa_driver advansys_isa_driver =3D {
 	.probe		=3D advansys_isa_probe,
-	.remove		=3D __devexit_p(advansys_isa_remove),
+	.remove		=3D advansys_isa_remove,
 	.driver =3D {
 		.owner	=3D THIS_MODULE,
 		.name	=3D DRV_NAME,
@@ -12561,7 +12561,7 @@ static int __devinit advansys_vlb_probe(struct =
device *dev, unsigned int id)
=20
 static struct isa_driver advansys_vlb_driver =3D {
 	.probe		=3D advansys_vlb_probe,
-	.remove		=3D __devexit_p(advansys_isa_remove),
+	.remove		=3D advansys_isa_remove,
 	.driver =3D {
 		.owner	=3D THIS_MODULE,
 		.name	=3D "advansys_vlb",
@@ -12701,7 +12701,7 @@ static struct eisa_driver advansys_eisa_driver =
=3D {
 	.driver =3D {
 		.name =3D		DRV_NAME,
 		.probe =3D	advansys_eisa_probe,
-		.remove =3D	__devexit_p(advansys_eisa_remove),
+		.remove =3D	advansys_eisa_remove,
 	}
 };
=20
@@ -12802,7 +12802,7 @@ static struct pci_driver advansys_pci_driver =3D=
 {
 	.name =3D		DRV_NAME,
 	.id_table =3D	advansys_pci_tbl,
 	.probe =3D	advansys_pci_probe,
-	.remove =3D	__devexit_p(advansys_pci_remove),
+	.remove =3D	advansys_pci_remove,
 };
=20
 static int __init advansys_init(void)
diff --git a/drivers/scsi/aha1740.c b/drivers/scsi/aha1740.c
index a3e6ed3..f69e89a 100644
--- a/drivers/scsi/aha1740.c
+++ b/drivers/scsi/aha1740.c
@@ -677,7 +677,7 @@ static struct eisa_driver aha1740_driver =3D {
 	.driver   =3D {
 		.name    =3D "aha1740",
 		.probe   =3D aha1740_probe,
-		.remove  =3D __devexit_p (aha1740_remove),
+		.remove  =3D aha1740_remove,
 	},
 };
=20
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx=
/aic94xx_init.c
index 1c4120c..7afe4df 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -1031,7 +1031,7 @@ static struct pci_driver aic94xx_pci_driver =3D {
 	.name		=3D ASD_DRIVER_NAME,
 	.id_table	=3D aic94xx_pci_table,
 	.probe		=3D asd_pci_probe,
-	.remove		=3D __devexit_p(asd_pci_remove),
+	.remove		=3D asd_pci_remove,
 };
=20
 static int __init aic94xx_init(void)
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.=
c
index b330438..b3f2414 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -3063,7 +3063,7 @@ static const struct ecard_id acornscsi_cids[] =3D=
 {
=20
 static struct ecard_driver acornscsi_driver =3D {
 	.probe		=3D acornscsi_probe,
-	.remove		=3D __devexit_p(acornscsi_remove),
+	.remove		=3D acornscsi_remove,
 	.id_table	=3D acornscsi_cids,
 	.drv =3D {
 		.name		=3D "acornscsi",
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index 2a28b4a..c5b2247 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -359,7 +359,7 @@ static const struct ecard_id arxescsi_cids[] =3D {
=20
 static struct ecard_driver arxescsi_driver =3D {
 	.probe		=3D arxescsi_probe,
-	.remove		=3D __devexit_p(arxescsi_remove),
+	.remove		=3D arxescsi_remove,
 	.id_table	=3D arxescsi_cids,
 	.drv =3D {
 		.name		=3D "arxescsi",
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index c3b99c9..18d1016 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -320,7 +320,7 @@ static const struct ecard_id cumanascsi1_cids[] =3D=
 {
=20
 static struct ecard_driver cumanascsi1_driver =3D {
 	.probe		=3D cumanascsi1_probe,
-	.remove		=3D __devexit_p(cumanascsi1_remove),
+	.remove		=3D cumanascsi1_remove,
 	.id_table	=3D cumanascsi1_cids,
 	.drv =3D {
 		.name		=3D "cumanascsi1",
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 547987b..20b5c82 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -519,7 +519,7 @@ static const struct ecard_id cumanascsi2_cids[] =3D=
 {
=20
 static struct ecard_driver cumanascsi2_driver =3D {
 	.probe		=3D cumanascsi2_probe,
-	.remove		=3D __devexit_p(cumanascsi2_remove),
+	.remove		=3D cumanascsi2_remove,
 	.id_table	=3D cumanascsi2_cids,
 	.drv =3D {
 		.name		=3D "cumanascsi2",
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 968d083..982e4d7 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -643,7 +643,7 @@ static const struct ecard_id eesoxscsi_cids[] =3D {
=20
 static struct ecard_driver eesoxscsi_driver =3D {
 	.probe		=3D eesoxscsi_probe,
-	.remove		=3D __devexit_p(eesoxscsi_remove),
+	.remove		=3D eesoxscsi_remove,
 	.id_table	=3D eesoxscsi_cids,
 	.drv =3D {
 		.name		=3D "eesoxscsi",
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index fc6a5aa..9707cc0 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -202,7 +202,7 @@ static const struct ecard_id oakscsi_cids[] =3D {
=20
 static struct ecard_driver oakscsi_driver =3D {
 	.probe		=3D oakscsi_probe,
-	.remove		=3D __devexit_p(oakscsi_remove),
+	.remove		=3D oakscsi_remove,
 	.id_table	=3D oakscsi_cids,
 	.drv =3D {
 		.name		=3D "oakscsi",
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 9274c06..23ba200 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -435,7 +435,7 @@ static const struct ecard_id powertecscsi_cids[] =3D=
 {
=20
 static struct ecard_driver powertecscsi_driver =3D {
 	.probe		=3D powertecscsi_probe,
-	.remove		=3D __devexit_p(powertecscsi_remove),
+	.remove		=3D powertecscsi_remove,
 	.id_table	=3D powertecscsi_cids,
 	.drv =3D {
 		.name		=3D "powertecscsi",
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index a540162..cfc7304 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -3210,7 +3210,7 @@ static struct pci_driver atp870u_driver =3D {
 	.id_table	=3D atp870u_id_table,
 	.name		=3D "atp870u",
 	.probe		=3D atp870u_probe,
-	.remove		=3D __devexit_p(atp870u_remove),
+	.remove		=3D atp870u_remove,
 };
=20
 static int __init atp870u_init(void)
diff --git a/drivers/scsi/bfa/bfad.c b/drivers/scsi/bfa/bfad.c
index 895b0e5..e6bf126 100644
--- a/drivers/scsi/bfa/bfad.c
+++ b/drivers/scsi/bfa/bfad.c
@@ -1739,7 +1739,7 @@ static struct pci_driver bfad_pci_driver =3D {
 	.name =3D BFAD_DRIVER_NAME,
 	.id_table =3D bfad_id_table,
 	.probe =3D bfad_pci_probe,
-	.remove =3D __devexit_p(bfad_pci_remove),
+	.remove =3D bfad_pci_remove,
 	.err_handler =3D &bfad_err_handler,
 };
=20
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.=
c
index d40ea2f..08f2d9d 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -108,7 +108,7 @@ static struct platform_driver bvme6000_scsi_driver =
=3D {
 		.owner		=3D THIS_MODULE,
 	},
 	.probe		=3D bvme6000_probe,
-	.remove		=3D __devexit_p(bvme6000_device_remove),
+	.remove		=3D bvme6000_device_remove,
 };
=20
 static int __init bvme6000_scsi_init(void)
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 13aeca3..3cbcf51 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -4892,7 +4892,7 @@ static struct pci_driver dc395x_driver =3D {
 	.name           =3D DC395X_NAME,
 	.id_table       =3D dc395x_pci_table,
 	.probe          =3D dc395x_init_one,
-	.remove         =3D __devexit_p(dc395x_remove_one),
+	.remove         =3D dc395x_remove_one,
 };
=20
=20
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index 207352cc..b10a4bf 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -150,7 +150,7 @@ static struct pci_driver dmx3191d_pci_driver =3D {
 	.name		=3D DMX3191D_DRIVER_NAME,
 	.id_table	=3D dmx3191d_pci_tbl,
 	.probe		=3D dmx3191d_probe_one,
-	.remove		=3D __devexit_p(dmx3191d_remove_one),
+	.remove		=3D dmx3191d_remove_one,
 };
=20
 static int __init dmx3191d_init(void)
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_mai=
n.c
index fc98eb6..b6a2d44 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -849,7 +849,7 @@ static struct pci_driver fnic_driver =3D {
 	.name =3D DRV_NAME,
 	.id_table =3D fnic_id_table,
 	.probe =3D fnic_probe,
-	.remove =3D __devexit_p(fnic_remove),
+	.remove =3D fnic_remove,
 };
=20
 static int __init fnic_init_module(void)
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 488fbc6..1499b82 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -414,7 +414,7 @@ static struct zorro_driver gvp11_driver =3D {
 	.name		=3D "gvp11",
 	.id_table	=3D gvp11_zorro_tbl,
 	.probe		=3D gvp11_probe,
-	.remove		=3D __devexit_p(gvp11_remove),
+	.remove		=3D gvp11_remove,
 };
=20
 static int __init gvp11_init(void)
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4217e49..9e765b1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4966,7 +4966,7 @@ static int hpsa_resume(__attribute__((unused)) st=
ruct pci_dev *pdev)
 static struct pci_driver hpsa_pci_driver =3D {
 	.name =3D HPSA,
 	.probe =3D hpsa_init_one,
-	.remove =3D __devexit_p(hpsa_remove_one),
+	.remove =3D hpsa_remove_one,
 	.id_table =3D hpsa_pci_device_id,	/* id_table */
 	.shutdown =3D hpsa_shutdown,
 	.suspend =3D hpsa_suspend,
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index dd741bc..280d5af 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2992,7 +2992,7 @@ static struct pci_driver initio_pci_driver =3D {
 	.name		=3D "initio",
 	.id_table	=3D initio_pci_tbl,
 	.probe		=3D initio_probe_one,
-	.remove		=3D __devexit_p(initio_remove_one),
+	.remove		=3D initio_remove_one,
 };
=20
 static int __init initio_init_driver(void)
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fe6029f..b898a93 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -9305,7 +9305,7 @@ static struct pci_driver ipr_driver =3D {
 	.name =3D IPR_NAME,
 	.id_table =3D ipr_pci_table,
 	.probe =3D ipr_probe,
-	.remove =3D __devexit_p(ipr_remove),
+	.remove =3D ipr_remove,
 	.shutdown =3D ipr_shutdown,
 	.err_handler =3D &ipr_err_handler,
 };
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index b6d7a5c..f3d128e 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -396,7 +396,7 @@ static struct pci_driver ips_pci_driver =3D {
 	.name		=3D ips_hot_plug_name,
 	.id_table	=3D ips_pci_table,
 	.probe		=3D ips_insert_device,
-	.remove		=3D __devexit_p(ips_remove_device),
+	.remove		=3D ips_remove_device,
 };
=20
=20
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index b74050b..0e15c71 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -778,7 +778,7 @@ static struct pci_driver isci_pci_driver =3D {
 	.name		=3D DRV_NAME,
 	.id_table	=3D isci_id_table,
 	.probe		=3D isci_pci_probe,
-	.remove		=3D __devexit_p(isci_pci_remove),
+	.remove		=3D isci_pci_remove,
 #ifdef CONFIG_PM
 	.driver.pm      =3D &isci_pm_ops,
 #endif
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 27cfb0c..91beca1 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -223,7 +223,7 @@ MODULE_ALIAS("platform:jazz_esp");
=20
 static struct platform_driver esp_jazz_driver =3D {
 	.probe		=3D esp_jazz_probe,
-	.remove		=3D __devexit_p(esp_jazz_remove),
+	.remove		=3D esp_jazz_remove,
 	.driver	=3D {
 		.name	=3D "jazz_esp",
 		.owner	=3D THIS_MODULE,
diff --git a/drivers/scsi/lasi700.c b/drivers/scsi/lasi700.c
index 23880f8..5c4ded9 100644
--- a/drivers/scsi/lasi700.c
+++ b/drivers/scsi/lasi700.c
@@ -168,7 +168,7 @@ static struct parisc_driver lasi700_driver =3D {
 	.name =3D		"lasi_scsi",
 	.id_table =3D	lasi700_ids,
 	.probe =3D	lasi700_probe,
-	.remove =3D	__devexit_p(lasi700_driver_remove),
+	.remove =3D	lasi700_driver_remove,
 };
=20
 static int __init
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_ini=
t.c
index 7dc4218..898fa16 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10546,7 +10546,7 @@ static struct pci_driver lpfc_driver =3D {
 	.name		=3D LPFC_DRIVER_NAME,
 	.id_table	=3D lpfc_id_table,
 	.probe		=3D lpfc_pci_probe_one,
-	.remove		=3D __devexit_p(lpfc_pci_remove_one),
+	.remove		=3D lpfc_pci_remove_one,
 	.suspend        =3D lpfc_pci_suspend_one,
 	.resume		=3D lpfc_pci_resume_one,
 	.err_handler    =3D &lpfc_err_handler,
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 70eb1f7..30b1ba1 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -614,7 +614,7 @@ static int __devexit esp_mac_remove(struct platform=
_device *dev)
=20
 static struct platform_driver esp_mac_driver =3D {
 	.probe    =3D esp_mac_probe,
-	.remove   =3D __devexit_p(esp_mac_remove),
+	.remove   =3D esp_mac_remove,
 	.driver   =3D {
 		.name	=3D DRV_MODULE_NAME,
 		.owner	=3D THIS_MODULE,
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 76ad72d..eab3211 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -5008,7 +5008,7 @@ static struct pci_driver megaraid_pci_driver =3D =
{
 	.name		=3D "megaraid_legacy",
 	.id_table	=3D megaraid_pci_tbl,
 	.probe		=3D megaraid_probe_one,
-	.remove		=3D __devexit_p(megaraid_remove_one),
+	.remove		=3D megaraid_remove_one,
 	.shutdown	=3D megaraid_shutdown,
 };
=20
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megar=
aid/megaraid_mbox.c
index 54b1c5b..ab114ad 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -305,7 +305,7 @@ static struct pci_driver megaraid_pci_driver =3D {
 	.name		=3D "megaraid",
 	.id_table	=3D pci_id_table_g,
 	.probe		=3D megaraid_probe_one,
-	.remove		=3D __devexit_p(megaraid_detach_one),
+	.remove		=3D megaraid_detach_one,
 	.shutdown	=3D megaraid_mbox_shutdown,
 };
=20
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
index d2c5366..ac18c98 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -5121,7 +5121,7 @@ static struct pci_driver megasas_pci_driver =3D {
 	.name =3D "megaraid_sas",
 	.id_table =3D megasas_pci_table,
 	.probe =3D megasas_probe_one,
-	.remove =3D __devexit_p(megasas_detach_one),
+	.remove =3D megasas_detach_one,
 	.suspend =3D megasas_suspend,
 	.resume =3D megasas_resume,
 	.shutdown =3D megasas_shutdown,
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sa=
s/mpt2sas_scsih.c
index af4e6c4..794c397 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8338,7 +8338,7 @@ static struct pci_driver scsih_driver =3D {
 	.name		=3D MPT2SAS_DRIVER_NAME,
 	.id_table	=3D scsih_pci_table,
 	.probe		=3D _scsih_probe,
-	.remove		=3D __devexit_p(_scsih_remove),
+	.remove		=3D _scsih_remove,
 	.shutdown	=3D _scsih_shutdown,
 	.err_handler	=3D &_scsih_err_handler,
 #ifdef CONFIG_PM
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index 39f554f..051a13c 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -131,7 +131,7 @@ static struct platform_driver mvme16x_scsi_driver =3D=
 {
 		.owner          =3D THIS_MODULE,
 	},
 	.probe          =3D mvme16x_probe,
-	.remove         =3D __devexit_p(mvme16x_device_remove),
+	.remove         =3D mvme16x_device_remove,
 };
=20
 static int __init mvme16x_scsi_init(void)
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.=
c
index cc59dff..a95adad 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -748,7 +748,7 @@ static struct pci_driver mvs_pci_driver =3D {
 	.name		=3D DRV_NAME,
 	.id_table	=3D mvs_pci_table,
 	.probe		=3D mvs_pci_init,
-	.remove		=3D __devexit_p(mvs_pci_remove),
+	.remove		=3D mvs_pci_remove,
 };
=20
 static ssize_t
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index c585a92..f2e3e49 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2728,7 +2728,7 @@ static struct pci_driver mvumi_pci_driver =3D {
 	.name =3D MV_DRIVER_NAME,
 	.id_table =3D mvumi_pci_table,
 	.probe =3D mvumi_probe_one,
-	.remove =3D __devexit_p(mvumi_detach_one),
+	.remove =3D mvumi_detach_one,
 	.shutdown =3D mvumi_shutdown,
 #ifdef CONFIG_PM
 	.suspend =3D mvumi_suspend,
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 62b6168..681294e 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -3435,7 +3435,7 @@ static struct pci_driver nsp32_driver =3D {
 	.name		=3D "nsp32",
 	.id_table	=3D nsp32_pci_table,
 	.probe		=3D nsp32_probe,
-	.remove		=3D __devexit_p(nsp32_remove),
+	.remove		=3D nsp32_remove,
 #ifdef CONFIG_PM
 	.suspend	=3D nsp32_suspend,=20
 	.resume		=3D nsp32_resume,=20
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm=
8001_init.c
index 0267c22..e2d1e44 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -857,7 +857,7 @@ static struct pci_driver pm8001_pci_driver =3D {
 	.name		=3D DRV_NAME,
 	.id_table	=3D pm8001_pci_table,
 	.probe		=3D pm8001_pci_probe,
-	.remove		=3D __devexit_p(pm8001_pci_remove),
+	.remove		=3D pm8001_pci_remove,
 	.suspend	=3D pm8001_pci_suspend,
 	.resume		=3D pm8001_pci_resume,
 };
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 538230b..46d138a 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4433,7 +4433,7 @@ static struct pci_driver qla1280_pci_driver =3D {
 	.name		=3D "qla1280",
 	.id_table	=3D qla1280_pci_tbl,
 	.probe		=3D qla1280_probe_one,
-	.remove		=3D __devexit_p(qla1280_remove_one),
+	.remove		=3D qla1280_remove_one,
 };
=20
 static int __init
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 71fddbc..59466ee 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1459,7 +1459,7 @@ static struct platform_driver qpti_sbus_driver =3D=
 {
 		.of_match_table =3D qpti_match,
 	},
 	.probe		=3D qpti_sbus_probe,
-	.remove		=3D __devexit_p(qpti_sbus_remove),
+	.remove		=3D qpti_sbus_remove,
 };
=20
 static int __init qpti_init(void)
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 3a9d85c..8583e2c 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -312,7 +312,7 @@ static int __exit sgiwd93_remove(struct platform_de=
vice *pdev)
=20
 static struct platform_driver sgiwd93_driver =3D {
 	.probe  =3D sgiwd93_probe,
-	.remove =3D __devexit_p(sgiwd93_remove),
+	.remove =3D sgiwd93_remove,
 	.driver =3D {
 		.name   =3D "sgiwd93",
 		.owner	=3D THIS_MODULE,
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index a318264..cd69476 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -221,7 +221,7 @@ static struct eisa_driver sim710_eisa_driver =3D {
 	.driver =3D {
 		.name		=3D "sim710",
 		.probe		=3D sim710_eisa_probe,
-		.remove		=3D __devexit_p(sim710_device_remove),
+		.remove		=3D sim710_device_remove,
 	},
 };
 #endif /* CONFIG_EISA */
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index cf51432..3f762b9 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -134,7 +134,7 @@ static int __exit snirm710_driver_remove(struct pla=
tform_device *dev)
=20
 static struct platform_driver snirm710_driver =3D {
 	.probe	=3D snirm710_probe,
-	.remove	=3D __devexit_p(snirm710_driver_remove),
+	.remove	=3D snirm710_driver_remove,
 	.driver	=3D {
 		.name	=3D "snirm_53c710",
 		.owner	=3D THIS_MODULE,
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index 606215e..a12b3b0 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1815,7 +1815,7 @@ static struct pci_driver stex_pci_driver =3D {
 	.name		=3D DRV_NAME,
 	.id_table	=3D stex_pci_tbl,
 	.probe		=3D stex_probe,
-	.remove		=3D __devexit_p(stex_remove),
+	.remove		=3D stex_remove,
 	.shutdown	=3D stex_shutdown,
 };
=20
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 0621037..90295fb 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -292,7 +292,7 @@ static int __devexit esp_sun3x_remove(struct platfo=
rm_device *dev)
=20
 static struct platform_driver esp_sun3x_driver =3D {
 	.probe          =3D esp_sun3x_probe,
-	.remove         =3D __devexit_p(esp_sun3x_remove),
+	.remove         =3D esp_sun3x_remove,
 	.driver =3D {
 		.name   =3D "sun3x_esp",
 		.owner	=3D THIS_MODULE,
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 676fe9a..4ebd216 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -639,7 +639,7 @@ static struct platform_driver esp_sbus_driver =3D {
 		.of_match_table =3D esp_match,
 	},
 	.probe		=3D esp_sbus_probe,
-	.remove		=3D __devexit_p(esp_sbus_remove),
+	.remove		=3D esp_sbus_remove,
 };
=20
 static int __init sunesp_init(void)
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index a1baccc..080ce3d 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2568,7 +2568,7 @@ static struct pci_driver dc390_driver =3D {
 	.name           =3D "tmscsim",
 	.id_table       =3D tmscsim_pci_tbl,
 	.probe          =3D dc390_probe_one,
-	.remove         =3D __devexit_p(dc390_remove_one),
+	.remove         =3D dc390_remove_one,
 };
=20
 static int __init dc390_module_init(void)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 58f4ba6..4a370f8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1947,7 +1947,7 @@ static struct pci_driver ufshcd_pci_driver =3D {
 	.name =3D UFSHCD,
 	.id_table =3D ufshcd_pci_tbl,
 	.probe =3D ufshcd_probe,
-	.remove =3D __devexit_p(ufshcd_remove),
+	.remove =3D ufshcd_remove,
 	.shutdown =3D ufshcd_shutdown,
 #ifdef CONFIG_PM
 	.suspend =3D ufshcd_suspend,
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index d5f9f45..f1c9481 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -783,7 +783,7 @@ static struct virtio_driver virtio_scsi_driver =3D =
{
 	.freeze =3D virtscsi_freeze,
 	.restore =3D virtscsi_restore,
 #endif
-	.remove =3D __devexit_p(virtscsi_remove),
+	.remove =3D virtscsi_remove,
 };
=20
 static int __init init(void)
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 20b3a48..180bb7d 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -1454,7 +1454,7 @@ static struct pci_driver pvscsi_pci_driver =3D {
 	.name		=3D "vmw_pvscsi",
 	.id_table	=3D pvscsi_pci_tbl,
 	.probe		=3D pvscsi_probe,
-	.remove		=3D __devexit_p(pvscsi_remove),
+	.remove		=3D pvscsi_remove,
 	.shutdown       =3D pvscsi_shutdown,
 };
=20
diff --git a/drivers/scsi/zalon.c b/drivers/scsi/zalon.c
index 27e84e4..97ccb03 100644
--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -182,7 +182,7 @@ static struct parisc_driver zalon_driver =3D {
 	.name =3D		"zalon",
 	.id_table =3D	zalon_tbl,
 	.probe =3D	zalon_probe,
-	.remove =3D	__devexit_p(zalon_remove),
+	.remove =3D	zalon_remove,
 };
=20
 static int __init zalon7xx_init(void)
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index e17764d..1ba2450 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -167,7 +167,7 @@ static struct zorro_driver zorro7xx_driver =3D {
 	.name	  =3D "zorro7xx-scsi",
 	.id_table =3D zorro7xx_zorro_tbl,
 	.probe	  =3D zorro7xx_init_one,
-	.remove	  =3D __devexit_p(zorro7xx_remove_one),
+	.remove	  =3D zorro7xx_remove_one,
 };
=20
 static int __init zorro7xx_scsi_init(void)
--=20
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
