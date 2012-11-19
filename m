From: Bill Pemberton <wfp5p@virginia.edu>
Subject: =?UTF-8?q?=5BPATCH=20192/493=5D=20scsi=3A=20remove=20use=20of=20=5F=5Fdevinit?=
Date: Mon, 19 Nov 2012 13:22:21 -0500
Message-ID: <1353349642-3677-192-git-send-email-wfp5p@virginia.edu>
References: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from viridian.itc.Virginia.EDU ([128.143.12.139]:41866 "EHLO
	viridian.itc.virginia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754334Ab2KSSnB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 13:43:01 -0500
In-Reply-To: <1353349642-3677-1-git-send-email-wfp5p@virginia.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Matthew Wilcox <matthew@wil.cx>, Russell King <linux@arm.linux.org.uk>, Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>, Neela Syam Kolli <megaraidlinux@lsi.com>, GOTO Masanori <gotom@debian.or.jp>, YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>, Geoff Levand <geoff@infradead.org>, Michael Reed <mdr@sgi.com>, Willem Riede <osst@riede.org>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Kurt Garloff <garloff@suse.de>, Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Arvind Kumar <arvindkumar@vmware.com>, VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, dc395x@twibble.org, iss_storagedev@hp.com, linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org, osst-users@lists.sourceforge.net

CONFIG_HOTPLUG is going away as an option so __devinit is no longer
needed.

Signed-off-by: Bill Pemberton <wfp5p@virginia.edu>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>=20
Cc: Matthew Wilcox <matthew@wil.cx>=20
Cc: Russell King <linux@arm.linux.org.uk>=20
Cc: Oliver Neukum <oliver@neukum.org>=20
Cc: Ali Akcaagac <aliakc@web.de>=20
Cc: Jamie Lenehan <lenehan@twibble.org>=20
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>=20
Cc: GOTO Masanori <gotom@debian.or.jp>=20
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>=20
Cc: Geoff Levand <geoff@infradead.org>=20
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
Cc: linuxppc-dev@lists.ozlabs.org=20
Cc: cbe-oss-dev@lists.ozlabs.org=20
Cc: osst-users@lists.sourceforge.net=20
---
 drivers/scsi/3w-9xxx.c                    |  2 +-
 drivers/scsi/3w-sas.c                     |  2 +-
 drivers/scsi/3w-xxxx.c                    |  2 +-
 drivers/scsi/NCR5380.c                    |  2 +-
 drivers/scsi/NCR_D700.c                   |  4 +-
 drivers/scsi/a100u2w.c                    |  2 +-
 drivers/scsi/a2091.c                      |  2 +-
 drivers/scsi/aacraid/linit.c              |  2 +-
 drivers/scsi/advansys.c                   | 94 +++++++++++++++--------=
--------
 drivers/scsi/aic94xx/aic94xx_init.c       | 14 ++---
 drivers/scsi/arm/acornscsi.c              |  2 +-
 drivers/scsi/arm/arxescsi.c               |  2 +-
 drivers/scsi/arm/cumana_1.c               |  2 +-
 drivers/scsi/arm/cumana_2.c               |  2 +-
 drivers/scsi/arm/eesox.c                  |  2 +-
 drivers/scsi/arm/oak.c                    |  2 +-
 drivers/scsi/arm/powertec.c               |  2 +-
 drivers/scsi/be2iscsi/be_main.c           |  2 +-
 drivers/scsi/bvme6000_scsi.c              |  2 +-
 drivers/scsi/dc395x.c                     | 40 ++++++-------
 drivers/scsi/dmx3191d.c                   |  2 +-
 drivers/scsi/fnic/fnic_main.c             |  2 +-
 drivers/scsi/gdth.c                       | 10 ++--
 drivers/scsi/gvp11.c                      |  4 +-
 drivers/scsi/hpsa.c                       | 60 ++++++++++----------
 drivers/scsi/hptiop.c                     |  2 +-
 drivers/scsi/ipr.c                        | 21 ++++---
 drivers/scsi/ips.c                        |  4 +-
 drivers/scsi/isci/init.c                  |  4 +-
 drivers/scsi/jazz_esp.c                   |  2 +-
 drivers/scsi/lpfc/lpfc_init.c             |  6 +-
 drivers/scsi/mac_esp.c                    |  2 +-
 drivers/scsi/megaraid.c                   |  2 +-
 drivers/scsi/megaraid/megaraid_mbox.c     |  4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 drivers/scsi/mvme16x_scsi.c               |  2 +-
 drivers/scsi/mvsas/mv_64xx.c              |  8 +--
 drivers/scsi/mvsas/mv_94xx.c              |  6 +-
 drivers/scsi/mvsas/mv_chips.h             |  2 +-
 drivers/scsi/mvsas/mv_init.c              | 12 ++--
 drivers/scsi/mvsas/mv_sas.c               |  2 +-
 drivers/scsi/mvsas/mv_sas.h               |  2 +-
 drivers/scsi/mvumi.c                      |  2 +-
 drivers/scsi/nsp32.c                      |  4 +-
 drivers/scsi/pm8001/pm8001_hwi.c          | 22 ++++----
 drivers/scsi/pm8001/pm8001_init.c         | 13 ++---
 drivers/scsi/pmcraid.c                    | 14 ++---
 drivers/scsi/ps3rom.c                     |  2 +-
 drivers/scsi/qla1280.c                    |  4 +-
 drivers/scsi/qla2xxx/qla_os.c             |  2 +-
 drivers/scsi/qla4xxx/ql4_os.c             |  2 +-
 drivers/scsi/qlogicfas.c                  |  2 +-
 drivers/scsi/qlogicpti.c                  | 14 ++---
 drivers/scsi/sgiwd93.c                    |  2 +-
 drivers/scsi/sim710.c                     |  2 +-
 drivers/scsi/sni_53c710.c                 |  2 +-
 drivers/scsi/stex.c                       |  2 +-
 drivers/scsi/sun3x_esp.c                  |  2 +-
 drivers/scsi/sun_esp.c                    | 22 ++++----
 drivers/scsi/sym53c8xx_2/sym_glue.c       | 16 +++---
 drivers/scsi/tmscsim.c                    | 16 +++---
 drivers/scsi/ufs/ufshcd.c                 |  2 +-
 drivers/scsi/virtio_scsi.c                |  2 +-
 drivers/scsi/vmw_pvscsi.c                 |  6 +-
 drivers/scsi/zorro7xx.c                   |  2 +-
 65 files changed, 250 insertions(+), 252 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 3868ab2..78c1fcc 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -2029,7 +2029,7 @@ static struct scsi_host_template driver_template =
=3D {
 };
=20
 /* This function will probe and initialize a card */
-static int __devinit twa_probe(struct pci_dev *pdev, const struct pci_=
device_id *dev_id)
+static int twa_probe(struct pci_dev *pdev, const struct pci_device_id =
*dev_id)
 {
 	struct Scsi_Host *host =3D NULL;
 	TW_Device_Extension *tw_dev;
diff --git a/drivers/scsi/3w-sas.c b/drivers/scsi/3w-sas.c
index 13e39e1..7b97f52 100644
--- a/drivers/scsi/3w-sas.c
+++ b/drivers/scsi/3w-sas.c
@@ -1604,7 +1604,7 @@ static struct scsi_host_template driver_template =
=3D {
 };
=20
 /* This function will probe and initialize a card */
-static int __devinit twl_probe(struct pci_dev *pdev, const struct pci_=
device_id *dev_id)
+static int twl_probe(struct pci_dev *pdev, const struct pci_device_id =
*dev_id)
 {
 	struct Scsi_Host *host =3D NULL;
 	TW_Device_Extension *tw_dev;
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 7fe96ff..601546b 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2281,7 +2281,7 @@ static struct scsi_host_template driver_template =
=3D {
 };
=20
 /* This function will probe and initialize a card */
-static int __devinit tw_probe(struct pci_dev *pdev, const struct pci_d=
evice_id *dev_id)
+static int tw_probe(struct pci_dev *pdev, const struct pci_device_id *=
dev_id)
 {
 	struct Scsi_Host *host =3D NULL;
 	TW_Device_Extension *tw_dev;
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 165e4dd86..450353e 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -814,7 +814,7 @@ static char *lprint_opcode(int opcode, char *pos, c=
har *buffer, int length)
  *	Locks: interrupts must be enabled when we are called=20
  */
=20
-static int __devinit NCR5380_init(struct Scsi_Host *instance, int flag=
s)
+static int NCR5380_init(struct Scsi_Host *instance, int flags)
 {
 	NCR5380_local_declare();
 	int i, pass;
diff --git a/drivers/scsi/NCR_D700.c b/drivers/scsi/NCR_D700.c
index 67da749..37028d3 100644
--- a/drivers/scsi/NCR_D700.c
+++ b/drivers/scsi/NCR_D700.c
@@ -173,7 +173,7 @@ struct NCR_D700_private {
 	char			pad;
 };
=20
-static int __devinit
+static int
 NCR_D700_probe_one(struct NCR_D700_private *p, int siop, int irq,
 		   int slot, u32 region, int differential)
 {
@@ -243,7 +243,7 @@ NCR_D700_intr(int irq, void *data)
  * essentially connectecd to the MCA bus independently, it is easier
  * to set them up as two separate host adapters, rather than one
  * adapter with two channels */
-static int __devinit
+static int
 NCR_D700_probe(struct device *dev)
 {
 	struct NCR_D700_private *p;
diff --git a/drivers/scsi/a100u2w.c b/drivers/scsi/a100u2w.c
index 4a08ac2..9f9193b 100644
--- a/drivers/scsi/a100u2w.c
+++ b/drivers/scsi/a100u2w.c
@@ -1082,7 +1082,7 @@ static struct scsi_host_template inia100_template=
 =3D {
 	.use_clustering		=3D ENABLE_CLUSTERING,
 };
=20
-static int __devinit inia100_probe_one(struct pci_dev *pdev,
+static int inia100_probe_one(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	struct Scsi_Host *shost;
diff --git a/drivers/scsi/a2091.c b/drivers/scsi/a2091.c
index fbd01f9..78f1035 100644
--- a/drivers/scsi/a2091.c
+++ b/drivers/scsi/a2091.c
@@ -179,7 +179,7 @@ static struct scsi_host_template a2091_scsi_templat=
e =3D {
 	.use_clustering		=3D DISABLE_CLUSTERING
 };
=20
-static int __devinit a2091_probe(struct zorro_dev *z,
+static int a2091_probe(struct zorro_dev *z,
 				 const struct zorro_device_id *ent)
 {
 	struct Scsi_Host *instance;
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.=
c
index 417cf7c..f821ac9 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -1107,7 +1107,7 @@ static void __aac_shutdown(struct aac_dev * aac)
 		pci_disable_msi(aac->pdev);
 }
=20
-static int __devinit aac_probe_one(struct pci_dev *pdev,
+static int aac_probe_one(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	unsigned index =3D id->driver_data;
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 3dfae22..286db72 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -9526,7 +9526,7 @@ advansys_queuecommand_lck(struct scsi_cmnd *scp, =
void (*done)(struct scsi_cmnd *
=20
 static DEF_SCSI_QCMD(advansys_queuecommand)
=20
-static ushort __devinit AscGetEisaChipCfg(PortAddr iop_base)
+static ushort AscGetEisaChipCfg(PortAddr iop_base)
 {
 	PortAddr eisa_cfg_iop =3D (PortAddr) ASC_GET_EISA_SLOT(iop_base) |
 	    (PortAddr) (ASC_EISA_CFG_IOP_MASK);
@@ -9537,7 +9537,7 @@ static ushort __devinit AscGetEisaChipCfg(PortAdd=
r iop_base)
  * Return the BIOS address of the adapter at the specified
  * I/O port and with the specified bus type.
  */
-static unsigned short __devinit
+static unsigned short
 AscGetChipBiosAddress(PortAddr iop_base, unsigned short bus_type)
 {
 	unsigned short cfg_lsw;
@@ -9569,7 +9569,7 @@ AscGetChipBiosAddress(PortAddr iop_base, unsigned=
 short bus_type)
 	return bios_addr;
 }
=20
-static uchar __devinit AscSetChipScsiID(PortAddr iop_base, uchar new_h=
ost_id)
+static uchar AscSetChipScsiID(PortAddr iop_base, uchar new_host_id)
 {
 	ushort cfg_lsw;
=20
@@ -9583,7 +9583,7 @@ static uchar __devinit AscSetChipScsiID(PortAddr =
iop_base, uchar new_host_id)
 	return (AscGetChipScsiID(iop_base));
 }
=20
-static unsigned char __devinit AscGetChipScsiCtrl(PortAddr iop_base)
+static unsigned char AscGetChipScsiCtrl(PortAddr iop_base)
 {
 	unsigned char sc;
=20
@@ -9593,7 +9593,7 @@ static unsigned char __devinit AscGetChipScsiCtrl=
(PortAddr iop_base)
 	return sc;
 }
=20
-static unsigned char __devinit
+static unsigned char
 AscGetChipVersion(PortAddr iop_base, unsigned short bus_type)
 {
 	if (bus_type & ASC_IS_EISA) {
@@ -9608,7 +9608,7 @@ AscGetChipVersion(PortAddr iop_base, unsigned sho=
rt bus_type)
 }
=20
 #ifdef CONFIG_ISA
-static void __devinit AscEnableIsaDma(uchar dma_channel)
+static void AscEnableIsaDma(uchar dma_channel)
 {
 	if (dma_channel < 4) {
 		outp(0x000B, (ushort)(0xC0 | dma_channel));
@@ -9638,7 +9638,7 @@ static int AscStopQueueExe(PortAddr iop_base)
 	return (0);
 }
=20
-static ASC_DCNT __devinit AscGetMaxDmaCount(ushort bus_type)
+static ASC_DCNT AscGetMaxDmaCount(ushort bus_type)
 {
 	if (bus_type & ASC_IS_ISA)
 		return ASC_MAX_ISA_DMA_COUNT;
@@ -9648,7 +9648,7 @@ static ASC_DCNT __devinit AscGetMaxDmaCount(ushor=
t bus_type)
 }
=20
 #ifdef CONFIG_ISA
-static ushort __devinit AscGetIsaDmaChannel(PortAddr iop_base)
+static ushort AscGetIsaDmaChannel(PortAddr iop_base)
 {
 	ushort channel;
=20
@@ -9660,7 +9660,7 @@ static ushort __devinit AscGetIsaDmaChannel(PortA=
ddr iop_base)
 	return (channel + 4);
 }
=20
-static ushort __devinit AscSetIsaDmaChannel(PortAddr iop_base, ushort =
dma_channel)
+static ushort AscSetIsaDmaChannel(PortAddr iop_base, ushort dma_channe=
l)
 {
 	ushort cfg_lsw;
 	uchar value;
@@ -9678,7 +9678,7 @@ static ushort __devinit AscSetIsaDmaChannel(PortA=
ddr iop_base, ushort dma_channe
 	return 0;
 }
=20
-static uchar __devinit AscGetIsaDmaSpeed(PortAddr iop_base)
+static uchar AscGetIsaDmaSpeed(PortAddr iop_base)
 {
 	uchar speed_value;
=20
@@ -9689,7 +9689,7 @@ static uchar __devinit AscGetIsaDmaSpeed(PortAddr=
 iop_base)
 	return speed_value;
 }
=20
-static uchar __devinit AscSetIsaDmaSpeed(PortAddr iop_base, uchar spee=
d_value)
+static uchar AscSetIsaDmaSpeed(PortAddr iop_base, uchar speed_value)
 {
 	speed_value &=3D 0x07;
 	AscSetBank(iop_base, 1);
@@ -9699,7 +9699,7 @@ static uchar __devinit AscSetIsaDmaSpeed(PortAddr=
 iop_base, uchar speed_value)
 }
 #endif /* CONFIG_ISA */
=20
-static ushort __devinit AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
+static ushort AscInitAscDvcVar(ASC_DVC_VAR *asc_dvc)
 {
 	int i;
 	PortAddr iop_base;
@@ -9786,7 +9786,7 @@ static ushort __devinit AscInitAscDvcVar(ASC_DVC_=
VAR *asc_dvc)
 	return warn_code;
 }
=20
-static int __devinit AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_re=
g)
+static int AscWriteEEPCmdReg(PortAddr iop_base, uchar cmd_reg)
 {
 	int retry;
=20
@@ -9801,12 +9801,12 @@ static int __devinit AscWriteEEPCmdReg(PortAddr=
 iop_base, uchar cmd_reg)
 	return 0;
 }
=20
-static void __devinit AscWaitEEPRead(void)
+static void AscWaitEEPRead(void)
 {
 	mdelay(1);
 }
=20
-static ushort __devinit AscReadEEPWord(PortAddr iop_base, uchar addr)
+static ushort AscReadEEPWord(PortAddr iop_base, uchar addr)
 {
 	ushort read_wval;
 	uchar cmd_reg;
@@ -9821,7 +9821,7 @@ static ushort __devinit AscReadEEPWord(PortAddr i=
op_base, uchar addr)
 	return read_wval;
 }
=20
-static ushort __devinit
+static ushort
 AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_=
type)
 {
 	ushort wval;
@@ -9868,7 +9868,7 @@ AscGetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG =
*cfg_buf, ushort bus_type)
 	return sum;
 }
=20
-static int __devinit AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
+static int AscTestExternalLram(ASC_DVC_VAR *asc_dvc)
 {
 	PortAddr iop_base;
 	ushort q_addr;
@@ -9890,12 +9890,12 @@ static int __devinit AscTestExternalLram(ASC_DV=
C_VAR *asc_dvc)
 	return (sta);
 }
=20
-static void __devinit AscWaitEEPWrite(void)
+static void AscWaitEEPWrite(void)
 {
 	mdelay(20);
 }
=20
-static int __devinit AscWriteEEPDataReg(PortAddr iop_base, ushort data=
_reg)
+static int AscWriteEEPDataReg(PortAddr iop_base, ushort data_reg)
 {
 	ushort read_back;
 	int retry;
@@ -9914,7 +9914,7 @@ static int __devinit AscWriteEEPDataReg(PortAddr =
iop_base, ushort data_reg)
 	}
 }
=20
-static ushort __devinit
+static ushort
 AscWriteEEPWord(PortAddr iop_base, uchar addr, ushort word_val)
 {
 	ushort read_wval;
@@ -9935,7 +9935,7 @@ AscWriteEEPWord(PortAddr iop_base, uchar addr, us=
hort word_val)
 	return (read_wval);
 }
=20
-static int __devinit
+static int
 AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort =
bus_type)
 {
 	int n_error;
@@ -10031,7 +10031,7 @@ AscSetEEPConfigOnce(PortAddr iop_base, ASCEEP_C=
ONFIG *cfg_buf, ushort bus_type)
 	return n_error;
 }
=20
-static int __devinit
+static int
 AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFIG *cfg_buf, ushort bus_=
type)
 {
 	int retry;
@@ -10050,7 +10050,7 @@ AscSetEEPConfig(PortAddr iop_base, ASCEEP_CONFI=
G *cfg_buf, ushort bus_type)
 	return n_error;
 }
=20
-static ushort __devinit AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
+static ushort AscInitFromEEP(ASC_DVC_VAR *asc_dvc)
 {
 	ASCEEP_CONFIG eep_config_buf;
 	ASCEEP_CONFIG *eep_config;
@@ -10215,7 +10215,7 @@ static ushort __devinit AscInitFromEEP(ASC_DVC_=
VAR *asc_dvc)
 	return (warn_code);
 }
=20
-static int __devinit AscInitGetConfig(struct Scsi_Host *shost)
+static int AscInitGetConfig(struct Scsi_Host *shost)
 {
 	struct asc_board *board =3D shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc =3D &board->dvc_var.asc_dvc_var;
@@ -10269,7 +10269,7 @@ static int __devinit AscInitGetConfig(struct Sc=
si_Host *shost)
 	return asc_dvc->err_code;
 }
=20
-static int __devinit AscInitSetConfig(struct pci_dev *pdev, struct Scs=
i_Host *shost)
+static int AscInitSetConfig(struct pci_dev *pdev, struct Scsi_Host *sh=
ost)
 {
 	struct asc_board *board =3D shost_priv(shost);
 	ASC_DVC_VAR *asc_dvc =3D &board->dvc_var.asc_dvc_var;
@@ -10723,7 +10723,7 @@ static ADVEEP_38C1600_CONFIG ADVEEP_38C1600_Con=
fig_Field_IsChar __devinitdata =3D
 /*
  * Wait for EEPROM command to complete
  */
-static void __devinit AdvWaitEEPCmd(AdvPortAddr iop_base)
+static void AdvWaitEEPCmd(AdvPortAddr iop_base)
 {
 	int eep_delay_ms;
=20
@@ -10742,7 +10742,7 @@ static void __devinit AdvWaitEEPCmd(AdvPortAddr=
 iop_base)
 /*
  * Read the EEPROM from specified location
  */
-static ushort __devinit AdvReadEEPWord(AdvPortAddr iop_base, int eep_w=
ord_addr)
+static ushort AdvReadEEPWord(AdvPortAddr iop_base, int eep_word_addr)
 {
 	AdvWriteWordRegister(iop_base, IOPW_EE_CMD,
 			     ASC_EEP_CMD_READ | eep_word_addr);
@@ -10753,7 +10753,7 @@ static ushort __devinit AdvReadEEPWord(AdvPortA=
ddr iop_base, int eep_word_addr)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-static void __devinit
+static void
 AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort *wbuf;
@@ -10820,7 +10820,7 @@ AdvSet3550EEPConfig(AdvPortAddr iop_base, ADVEE=
P_3550_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-static void __devinit
+static void
 AdvSet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cf=
g_buf)
 {
 	ushort *wbuf;
@@ -10887,7 +10887,7 @@ AdvSet38C0800EEPConfig(AdvPortAddr iop_base, AD=
VEEP_38C0800_CONFIG *cfg_buf)
 /*
  * Write the EEPROM from 'cfg_buf'.
  */
-static void __devinit
+static void
 AdvSet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cf=
g_buf)
 {
 	ushort *wbuf;
@@ -10956,7 +10956,7 @@ AdvSet38C1600EEPConfig(AdvPortAddr iop_base, AD=
VEEP_38C1600_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __devinit
+static ushort
 AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEEP_3550_CONFIG *cfg_buf)
 {
 	ushort wval, chksum;
@@ -10999,7 +10999,7 @@ AdvGet3550EEPConfig(AdvPortAddr iop_base, ADVEE=
P_3550_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __devinit
+static ushort
 AdvGet38C0800EEPConfig(AdvPortAddr iop_base, ADVEEP_38C0800_CONFIG *cf=
g_buf)
 {
 	ushort wval, chksum;
@@ -11042,7 +11042,7 @@ AdvGet38C0800EEPConfig(AdvPortAddr iop_base, AD=
VEEP_38C0800_CONFIG *cfg_buf)
  *
  * Return a checksum based on the EEPROM configuration read.
  */
-static ushort __devinit
+static ushort
 AdvGet38C1600EEPConfig(AdvPortAddr iop_base, ADVEEP_38C1600_CONFIG *cf=
g_buf)
 {
 	ushort wval, chksum;
@@ -11092,7 +11092,7 @@ AdvGet38C1600EEPConfig(AdvPortAddr iop_base, AD=
VEEP_38C1600_CONFIG *cfg_buf)
  *
  * Note: Chip is stopped on entry.
  */
-static int __devinit AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
+static int AdvInitFrom3550EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -11242,7 +11242,7 @@ static int __devinit AdvInitFrom3550EEP(ADV_DVC=
_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __devinit AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
+static int AdvInitFrom38C0800EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -11441,7 +11441,7 @@ static int __devinit AdvInitFrom38C0800EEP(ADV_=
DVC_VAR *asc_dvc)
  *
  * Note: Chip is stopped on entry.
  */
-static int __devinit AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
+static int AdvInitFrom38C1600EEP(ADV_DVC_VAR *asc_dvc)
 {
 	AdvPortAddr iop_base;
 	ushort warn_code;
@@ -11661,7 +11661,7 @@ static int __devinit AdvInitFrom38C1600EEP(ADV_=
DVC_VAR *asc_dvc)
  * For a non-fatal error return a warning code. If there are no warnin=
gs
  * then 0 is returned.
  */
-static int __devinit
+static int
 AdvInitGetConfig(struct pci_dev *pdev, struct Scsi_Host *shost)
 {
 	struct asc_board *board =3D shost_priv(shost);
@@ -11769,7 +11769,7 @@ static struct scsi_host_template advansys_templ=
ate =3D {
 	.use_clustering =3D ENABLE_CLUSTERING,
 };
=20
-static int __devinit advansys_wide_init_chip(struct Scsi_Host *shost)
+static int advansys_wide_init_chip(struct Scsi_Host *shost)
 {
 	struct asc_board *board =3D shost_priv(shost);
 	struct adv_dvc_var *adv_dvc =3D &board->dvc_var.adv_dvc_var;
@@ -11882,7 +11882,7 @@ static void advansys_wide_free_mem(struct asc_b=
oard *board)
 	}
 }
=20
-static int __devinit advansys_board_found(struct Scsi_Host *shost,
+static int advansys_board_found(struct Scsi_Host *shost,
 					  unsigned int iop, int bus_type)
 {
 	struct pci_dev *pdev;
@@ -12428,7 +12428,7 @@ static PortAddr _asc_def_iop_base[ASC_IOADR_TAB=
LE_MAX_IX] =3D {
  * 10: 12
  * 11: 15
  */
-static unsigned int __devinit advansys_isa_irq_no(PortAddr iop_base)
+static unsigned int advansys_isa_irq_no(PortAddr iop_base)
 {
 	unsigned short cfg_lsw =3D AscGetChipCfgLsw(iop_base);
 	unsigned int chip_irq =3D ((cfg_lsw >> 2) & 0x03) + 10;
@@ -12437,7 +12437,7 @@ static unsigned int __devinit advansys_isa_irq_=
no(PortAddr iop_base)
 	return chip_irq;
 }
=20
-static int __devinit advansys_isa_probe(struct device *dev, unsigned i=
nt id)
+static int advansys_isa_probe(struct device *dev, unsigned int id)
 {
 	int err =3D -ENODEV;
 	PortAddr iop_base =3D _asc_def_iop_base[id];
@@ -12505,7 +12505,7 @@ static struct isa_driver advansys_isa_driver =3D=
 {
  * 110: 15
  * 111: invalid
  */
-static unsigned int __devinit advansys_vlb_irq_no(PortAddr iop_base)
+static unsigned int advansys_vlb_irq_no(PortAddr iop_base)
 {
 	unsigned short cfg_lsw =3D AscGetChipCfgLsw(iop_base);
 	unsigned int chip_irq =3D ((cfg_lsw >> 2) & 0x07) + 9;
@@ -12514,7 +12514,7 @@ static unsigned int __devinit advansys_vlb_irq_=
no(PortAddr iop_base)
 	return chip_irq;
 }
=20
-static int __devinit advansys_vlb_probe(struct device *dev, unsigned i=
nt id)
+static int advansys_vlb_probe(struct device *dev, unsigned int id)
 {
 	int err =3D -ENODEV;
 	PortAddr iop_base =3D _asc_def_iop_base[id];
@@ -12595,7 +12595,7 @@ struct eisa_scsi_data {
  * 110: invalid
  * 111: invalid
  */
-static unsigned int __devinit advansys_eisa_irq_no(struct eisa_device =
*edev)
+static unsigned int advansys_eisa_irq_no(struct eisa_device *edev)
 {
 	unsigned short cfg_lsw =3D inw(edev->base_addr + 0xc86);
 	unsigned int chip_irq =3D ((cfg_lsw >> 8) & 0x07) + 10;
@@ -12604,7 +12604,7 @@ static unsigned int __devinit advansys_eisa_irq=
_no(struct eisa_device *edev)
 	return chip_irq;
 }
=20
-static int __devinit advansys_eisa_probe(struct device *dev)
+static int advansys_eisa_probe(struct device *dev)
 {
 	int i, ioport, irq =3D 0;
 	int err;
@@ -12724,7 +12724,7 @@ static struct pci_device_id advansys_pci_tbl[] =
__devinitdata =3D {
=20
 MODULE_DEVICE_TABLE(pci, advansys_pci_tbl);
=20
-static void __devinit advansys_set_latency(struct pci_dev *pdev)
+static void advansys_set_latency(struct pci_dev *pdev)
 {
 	if ((pdev->device =3D=3D PCI_DEVICE_ID_ASP_1200A) ||
 	    (pdev->device =3D=3D PCI_DEVICE_ID_ASP_ABP940)) {
@@ -12737,7 +12737,7 @@ static void __devinit advansys_set_latency(stru=
ct pci_dev *pdev)
 	}
 }
=20
-static int __devinit
+static int
 advansys_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e=
nt)
 {
 	int err, ioport;
diff --git a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx=
/aic94xx_init.c
index 7afe4df..99cba69 100644
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
@@ -85,7 +85,7 @@ static struct scsi_host_template aic94xx_sht =3D {
 	.ioctl			=3D sas_ioctl,
 };
=20
-static int __devinit asd_map_memio(struct asd_ha_struct *asd_ha)
+static int asd_map_memio(struct asd_ha_struct *asd_ha)
 {
 	int err, i;
 	struct asd_ha_addrspace *io_handle;
@@ -146,7 +146,7 @@ static void asd_unmap_memio(struct asd_ha_struct *a=
sd_ha)
 	pci_release_region(asd_ha->pcidev, 0);
 }
=20
-static int __devinit asd_map_ioport(struct asd_ha_struct *asd_ha)
+static int asd_map_ioport(struct asd_ha_struct *asd_ha)
 {
 	int i =3D PCI_IOBAR_OFFSET, err;
 	struct asd_ha_addrspace *io_handle =3D &asd_ha->io_handle[0];
@@ -175,7 +175,7 @@ static void asd_unmap_ioport(struct asd_ha_struct *=
asd_ha)
 	pci_release_region(asd_ha->pcidev, PCI_IOBAR_OFFSET);
 }
=20
-static int __devinit asd_map_ha(struct asd_ha_struct *asd_ha)
+static int asd_map_ha(struct asd_ha_struct *asd_ha)
 {
 	int err;
 	u16 cmd_reg;
@@ -221,7 +221,7 @@ static const char *asd_dev_rev[30] =3D {
 	[8] =3D "B0",
 };
=20
-static int __devinit asd_common_setup(struct asd_ha_struct *asd_ha)
+static int asd_common_setup(struct asd_ha_struct *asd_ha)
 {
 	int err, i;
=20
@@ -257,7 +257,7 @@ Err:
 	return err;
 }
=20
-static int __devinit asd_aic9410_setup(struct asd_ha_struct *asd_ha)
+static int asd_aic9410_setup(struct asd_ha_struct *asd_ha)
 {
 	int err =3D asd_common_setup(asd_ha);
=20
@@ -272,7 +272,7 @@ static int __devinit asd_aic9410_setup(struct asd_h=
a_struct *asd_ha)
 	return 0;
 }
=20
-static int __devinit asd_aic9405_setup(struct asd_ha_struct *asd_ha)
+static int asd_aic9405_setup(struct asd_ha_struct *asd_ha)
 {
 	int err =3D asd_common_setup(asd_ha);
=20
@@ -731,7 +731,7 @@ static int asd_unregister_sas_ha(struct asd_ha_stru=
ct *asd_ha)
 	return err;
 }
=20
-static int __devinit asd_pci_probe(struct pci_dev *dev,
+static int asd_pci_probe(struct pci_dev *dev,
 				   const struct pci_device_id *id)
 {
 	const struct asd_pcidev_struct *asd_dev;
diff --git a/drivers/scsi/arm/acornscsi.c b/drivers/scsi/arm/acornscsi.=
c
index b3f2414..378c37f 100644
--- a/drivers/scsi/arm/acornscsi.c
+++ b/drivers/scsi/arm/acornscsi.c
@@ -2965,7 +2965,7 @@ static struct scsi_host_template acornscsi_templa=
te =3D {
 	.proc_name		=3D "acornscsi",
 };
=20
-static int __devinit
+static int
 acornscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index c5b2247..a9e0501 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -276,7 +276,7 @@ static struct scsi_host_template arxescsi_template =
=3D {
 	.proc_name			=3D "arxescsi",
 };
=20
-static int __devinit
+static int
 arxescsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/arm/cumana_1.c b/drivers/scsi/arm/cumana_1.c
index 18d1016..a2af968 100644
--- a/drivers/scsi/arm/cumana_1.c
+++ b/drivers/scsi/arm/cumana_1.c
@@ -225,7 +225,7 @@ static struct scsi_host_template cumanascsi_templat=
e =3D {
 	.proc_name		=3D "CumanaSCSI-1",
 };
=20
-static int __devinit
+static int
 cumanascsi1_probe(struct expansion_card *ec, const struct ecard_id *id=
)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/arm/cumana_2.c b/drivers/scsi/arm/cumana_2.c
index 20b5c82..59b5d89 100644
--- a/drivers/scsi/arm/cumana_2.c
+++ b/drivers/scsi/arm/cumana_2.c
@@ -397,7 +397,7 @@ static struct scsi_host_template cumanascsi2_templa=
te =3D {
 	.proc_name			=3D "cumanascsi2",
 };
=20
-static int __devinit
+static int
 cumanascsi2_probe(struct expansion_card *ec, const struct ecard_id *id=
)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/arm/eesox.c b/drivers/scsi/arm/eesox.c
index 982e4d7..d70c041 100644
--- a/drivers/scsi/arm/eesox.c
+++ b/drivers/scsi/arm/eesox.c
@@ -515,7 +515,7 @@ static struct scsi_host_template eesox_template =3D=
 {
 	.proc_name			=3D "eesox",
 };
=20
-static int __devinit
+static int
 eesoxscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/arm/oak.c b/drivers/scsi/arm/oak.c
index 9707cc0..676079a 100644
--- a/drivers/scsi/arm/oak.c
+++ b/drivers/scsi/arm/oak.c
@@ -129,7 +129,7 @@ static struct scsi_host_template oakscsi_template =3D=
 {
 	.proc_name		=3D "oakscsi",
 };
=20
-static int __devinit
+static int
 oakscsi_probe(struct expansion_card *ec, const struct ecard_id *id)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/arm/powertec.c b/drivers/scsi/arm/powertec.c
index 23ba200..a164ad1 100644
--- a/drivers/scsi/arm/powertec.c
+++ b/drivers/scsi/arm/powertec.c
@@ -309,7 +309,7 @@ static struct scsi_host_template powertecscsi_templ=
ate =3D {
 	.proc_name			=3D "powertec",
 };
=20
-static int __devinit
+static int
 powertecscsi_probe(struct expansion_card *ec, const struct ecard_id *i=
d)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index ff73f95..2da3c36 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4476,7 +4476,7 @@ static void beiscsi_msix_enable(struct beiscsi_hb=
a *phba)
 	return;
 }
=20
-static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
+static int beiscsi_dev_probe(struct pci_dev *pcidev,
 				const struct pci_device_id *id)
 {
 	struct beiscsi_hba *phba =3D NULL;
diff --git a/drivers/scsi/bvme6000_scsi.c b/drivers/scsi/bvme6000_scsi.=
c
index 08f2d9d..4461df8 100644
--- a/drivers/scsi/bvme6000_scsi.c
+++ b/drivers/scsi/bvme6000_scsi.c
@@ -34,7 +34,7 @@ static struct scsi_host_template bvme6000_scsi_driver=
_template =3D {
=20
 static struct platform_device *bvme6000_scsi_device;
=20
-static __devinit int
+static int
 bvme6000_probe(struct platform_device *dev)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index 3cbcf51..2fdf59c 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -574,7 +574,7 @@ MODULE_PARM_DESC(reset_delay, "Reset delay in secon=
ds. Default 1 (0-180)");
  * set_safe_settings - if the use_safe_settings option is set then
  * set all values to the safe and slow values.
  **/
-static void __devinit set_safe_settings(void)
+static void set_safe_settings(void)
 {
 	if (use_safe_settings)
 	{
@@ -593,7 +593,7 @@ static void __devinit set_safe_settings(void)
  * fix_settings - reset any boot parameters which are out of range
  * back to the default values.
  **/
-static void __devinit fix_settings(void)
+static void fix_settings(void)
 {
 	int i;
=20
@@ -630,7 +630,7 @@ static char __devinitdata eeprom_index_to_delay_map=
[] =3D
  *
  * @eeprom: The eeprom structure in which we find the delay index to m=
ap.
  **/
-static void __devinit eeprom_index_to_delay(struct NvRamType *eeprom)
+static void eeprom_index_to_delay(struct NvRamType *eeprom)
 {
 	eeprom->delay_time =3D eeprom_index_to_delay_map[eeprom->delay_time];
 }
@@ -643,7 +643,7 @@ static void __devinit eeprom_index_to_delay(struct =
NvRamType *eeprom)
  *
  * @delay: The delay, in seconds, to find the eeprom index for.
  **/
-static int __devinit delay_to_eeprom_index(int delay)
+static int delay_to_eeprom_index(int delay)
 {
 	u8 idx =3D 0;
 	while (idx < 7 && eeprom_index_to_delay_map[idx] < delay)
@@ -659,7 +659,7 @@ static int __devinit delay_to_eeprom_index(int dela=
y)
  *
  * @eeprom: The eeprom data to override with command line options.
  **/
-static void __devinit eeprom_override(struct NvRamType *eeprom)
+static void eeprom_override(struct NvRamType *eeprom)
 {
 	u8 id;
=20
@@ -3938,7 +3938,7 @@ static void dc395x_slave_destroy(struct scsi_devi=
ce *scsi_device)
  *
  * @io_port: base I/O address
  **/
-static void __devinit trms1040_wait_30us(unsigned long io_port)
+static void trms1040_wait_30us(unsigned long io_port)
 {
 	/* ScsiPortStallExecution(30); wait 30 us */
 	outb(5, io_port + TRM_S1040_GEN_TIMER);
@@ -3955,7 +3955,7 @@ static void __devinit trms1040_wait_30us(unsigned=
 long io_port)
  * @cmd:	SB + op code (command) to send
  * @addr:	address to send
  **/
-static void __devinit trms1040_write_cmd(unsigned long io_port, u8 cmd=
, u8 addr)
+static void trms1040_write_cmd(unsigned long io_port, u8 cmd, u8 addr)
 {
 	int i;
 	u8 send_data;
@@ -4000,7 +4000,7 @@ static void __devinit trms1040_write_cmd(unsigned=
 long io_port, u8 cmd, u8 addr)
  * @addr:	offset into EEPROM
  * @byte:	bytes to write
  **/
-static void __devinit trms1040_set_data(unsigned long io_port, u8 addr=
, u8 byte)
+static void trms1040_set_data(unsigned long io_port, u8 addr, u8 byte)
 {
 	int i;
 	u8 send_data;
@@ -4054,7 +4054,7 @@ static void __devinit trms1040_set_data(unsigned =
long io_port, u8 addr, u8 byte)
  * @eeprom:	the data to write
  * @io_port:	the base io port
  **/
-static void __devinit trms1040_write_all(struct NvRamType *eeprom, uns=
igned long io_port)
+static void trms1040_write_all(struct NvRamType *eeprom, unsigned long=
 io_port)
 {
 	u8 *b_eeprom =3D (u8 *)eeprom;
 	u8 addr;
@@ -4094,7 +4094,7 @@ static void __devinit trms1040_write_all(struct N=
vRamType *eeprom, unsigned long
  *
  * Returns the byte read.
  **/
-static u8 __devinit trms1040_get_data(unsigned long io_port, u8 addr)
+static u8 trms1040_get_data(unsigned long io_port, u8 addr)
 {
 	int i;
 	u8 read_byte;
@@ -4132,7 +4132,7 @@ static u8 __devinit trms1040_get_data(unsigned lo=
ng io_port, u8 addr)
  * @eeprom:	where to store the data
  * @io_port:	the base io port
  **/
-static void __devinit trms1040_read_all(struct NvRamType *eeprom, unsi=
gned long io_port)
+static void trms1040_read_all(struct NvRamType *eeprom, unsigned long =
io_port)
 {
 	u8 *b_eeprom =3D (u8 *)eeprom;
 	u8 addr;
@@ -4162,7 +4162,7 @@ static void __devinit trms1040_read_all(struct Nv=
RamType *eeprom, unsigned long
  * @eeprom:	caller allocated strcuture to read the eeprom data into
  * @io_port:	io port to read from
  **/
-static void __devinit check_eeprom(struct NvRamType *eeprom, unsigned =
long io_port)
+static void check_eeprom(struct NvRamType *eeprom, unsigned long io_po=
rt)
 {
 	u16 *w_eeprom =3D (u16 *)eeprom;
 	u16 w_addr;
@@ -4232,7 +4232,7 @@ static void __devinit check_eeprom(struct NvRamTy=
pe *eeprom, unsigned long io_po
  *
  * @eeprom: The eeprom data strucutre to show details for.
  **/
-static void __devinit print_eeprom_settings(struct NvRamType *eeprom)
+static void print_eeprom_settings(struct NvRamType *eeprom)
 {
 	dprintkl(KERN_INFO, "Used settings: AdapterID=3D%02i, Speed=3D%i(%02i=
=2E%01iMHz), dev_mode=3D0x%02x\n",
 		eeprom->scsi_id,
@@ -4260,7 +4260,7 @@ static void adapter_sg_tables_free(struct Adapter=
CtlBlk *acb)
 /*
  * Allocate SG tables; as we have to pci_map them, an SG list (struct =
SGentry*)
  * should never cross a page boundary */
-static int __devinit adapter_sg_tables_alloc(struct AdapterCtlBlk *acb=
)
+static int adapter_sg_tables_alloc(struct AdapterCtlBlk *acb)
 {
 	const unsigned mem_needed =3D (DC395x_MAX_SRB_CNT+1)
 	                            *SEGMENTX_LEN;
@@ -4306,7 +4306,7 @@ static int __devinit adapter_sg_tables_alloc(stru=
ct AdapterCtlBlk *acb)
  *
  * @acb: The adapter to print the information for.
  **/
-static void __devinit adapter_print_config(struct AdapterCtlBlk *acb)
+static void adapter_print_config(struct AdapterCtlBlk *acb)
 {
 	u8 bval;
=20
@@ -4350,7 +4350,7 @@ static void __devinit adapter_print_config(struct=
 AdapterCtlBlk *acb)
  *
  * @acb: The adapter to initialize.
  **/
-static void __devinit adapter_init_params(struct AdapterCtlBlk *acb)
+static void adapter_init_params(struct AdapterCtlBlk *acb)
 {
 	struct NvRamType *eeprom =3D &acb->eeprom;
 	int i;
@@ -4412,7 +4412,7 @@ static void __devinit adapter_init_params(struct =
AdapterCtlBlk *acb)
  *
  * @host: The scsi host instance to fill in the values for.
  **/
-static void __devinit adapter_init_scsi_host(struct Scsi_Host *host)
+static void adapter_init_scsi_host(struct Scsi_Host *host)
 {
         struct AdapterCtlBlk *acb =3D (struct AdapterCtlBlk *)host->ho=
stdata;
 	struct NvRamType *eeprom =3D &acb->eeprom;
@@ -4453,7 +4453,7 @@ static void __devinit adapter_init_scsi_host(stru=
ct Scsi_Host *host)
  *
  * @acb: The adapter which we are to init.
  **/
-static void __devinit adapter_init_chip(struct AdapterCtlBlk *acb)
+static void adapter_init_chip(struct AdapterCtlBlk *acb)
 {
         struct NvRamType *eeprom =3D &acb->eeprom;
        =20
@@ -4506,7 +4506,7 @@ static void __devinit adapter_init_chip(struct Ad=
apterCtlBlk *acb)
  * Returns 0 if the initialization succeeds, any other value on
  * failure.
  **/
-static int __devinit adapter_init(struct AdapterCtlBlk *acb,
+static int adapter_init(struct AdapterCtlBlk *acb,
 	unsigned long io_port, u32 io_port_len, unsigned int irq)
 {
 	if (!request_region(io_port, io_port_len, DC395X_NAME)) {
@@ -4794,7 +4794,7 @@ static void banner_display(void)
  *
  * Returns 0 on success, or an error code (-ve) on failure.
  **/
-static int __devinit dc395x_init_one(struct pci_dev *dev,
+static int dc395x_init_one(struct pci_dev *dev,
 		const struct pci_device_id *id)
 {
 	struct Scsi_Host *scsi_host =3D NULL;
diff --git a/drivers/scsi/dmx3191d.c b/drivers/scsi/dmx3191d.c
index b10a4bf..6a1b929 100644
--- a/drivers/scsi/dmx3191d.c
+++ b/drivers/scsi/dmx3191d.c
@@ -68,7 +68,7 @@ static struct scsi_host_template dmx3191d_driver_temp=
late =3D {
 	.use_clustering		=3D DISABLE_CLUSTERING,
 };
=20
-static int __devinit dmx3191d_probe_one(struct pci_dev *pdev,
+static int dmx3191d_probe_one(struct pci_dev *pdev,
 		const struct pci_device_id *id)
 {
 	struct Scsi_Host *shost;
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_mai=
n.c
index b6a2d44..8266575 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -399,7 +399,7 @@ static u8 *fnic_get_mac(struct fc_lport *lport)
 	return fnic->data_src_addr;
 }
=20
-static int __devinit fnic_probe(struct pci_dev *pdev,
+static int fnic_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..af5ee22 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -602,7 +602,7 @@ static void __devexit gdth_pci_remove_one(struct pc=
i_dev *pdev)
 	pci_disable_device(pdev);
 }
=20
-static int __devinit gdth_pci_init_one(struct pci_dev *pdev,
+static int gdth_pci_init_one(struct pci_dev *pdev,
 				       const struct pci_device_id *ent)
 {
 	u16 vendor =3D pdev->vendor;
@@ -855,7 +855,7 @@ static int __init gdth_init_isa(u32 bios_adr,gdth_h=
a_str *ha)
 #endif /* CONFIG_ISA */
=20
 #ifdef CONFIG_PCI
-static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str =
*pcistr,
+static int gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 				   gdth_ha_str *ha)
 {
     register gdt6_dpram_str __iomem *dp6_ptr;
@@ -1239,7 +1239,7 @@ static int __devinit gdth_init_pci(struct pci_dev=
 *pdev, gdth_pci_str *pcistr,
=20
 /* controller protocol functions */
=20
-static void __devinit gdth_enable_int(gdth_ha_str *ha)
+static void gdth_enable_int(gdth_ha_str *ha)
 {
     unsigned long flags;
     gdt2_dpram_str __iomem *dp2_ptr;
@@ -1555,7 +1555,7 @@ static int gdth_internal_cmd(gdth_ha_str *ha, u8 =
service, u16 opcode,
=20
 /* search for devices */
=20
-static int __devinit gdth_search_drives(gdth_ha_str *ha)
+static int gdth_search_drives(gdth_ha_str *ha)
 {
     u16 cdev_cnt, i;
     int ok;
@@ -4959,7 +4959,7 @@ static int __init gdth_eisa_probe_one(u16 eisa_sl=
ot)
 #endif /* CONFIG_EISA */
=20
 #ifdef CONFIG_PCI
-static int __devinit gdth_pci_probe_one(gdth_pci_str *pcistr,
+static int gdth_pci_probe_one(gdth_pci_str *pcistr,
 			     gdth_ha_str **ha_out)
 {
 	struct Scsi_Host *shp;
diff --git a/drivers/scsi/gvp11.c b/drivers/scsi/gvp11.c
index 1499b82..dc29c06 100644
--- a/drivers/scsi/gvp11.c
+++ b/drivers/scsi/gvp11.c
@@ -204,7 +204,7 @@ static struct scsi_host_template gvp11_scsi_templat=
e =3D {
 	.use_clustering		=3D DISABLE_CLUSTERING
 };
=20
-static int __devinit check_wd33c93(struct gvp11_scsiregs *regs)
+static int check_wd33c93(struct gvp11_scsiregs *regs)
 {
 #ifdef CHECK_WD33C93
 	volatile unsigned char *sasr_3393, *scmd_3393;
@@ -284,7 +284,7 @@ static int __devinit check_wd33c93(struct gvp11_scs=
iregs *regs)
 	return 0;
 }
=20
-static int __devinit gvp11_probe(struct zorro_dev *z,
+static int gvp11_probe(struct zorro_dev *z,
 				 const struct zorro_device_id *ent)
 {
 	struct Scsi_Host *instance;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 9e765b1..85891e2 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -189,15 +189,15 @@ static void check_ioctl_unit_attention(struct ctl=
r_info *h,
 /* performant mode helper functions */
 static void calc_bucket_map(int *bucket, int num_buckets,
 	int nsgs, int *bucket_map);
-static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_i=
nfo *h);
+static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h);
 static inline u32 next_command(struct ctlr_info *h, u8 q);
-static int __devinit hpsa_find_cfg_addrs(struct pci_dev *pdev,
+static int hpsa_find_cfg_addrs(struct pci_dev *pdev,
 	void __iomem *vaddr, u32 *cfg_base_addr, u64 *cfg_base_addr_index,
 	u64 *cfg_offset);
-static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
+static int hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar);
-static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *b=
oard_id);
-static int __devinit hpsa_wait_for_board_state(struct pci_dev *pdev,
+static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id);
+static int hpsa_wait_for_board_state(struct pci_dev *pdev,
 	void __iomem *vaddr, int wait_for_ready);
 static inline void finish_cmd(struct CommandList *c);
 #define BOARD_NOT_READY 0
@@ -3182,7 +3182,7 @@ static int hpsa_ioctl(struct scsi_device *dev, in=
t cmd, void *arg)
 	}
 }
=20
-static int __devinit hpsa_send_host_reset(struct ctlr_info *h,
+static int hpsa_send_host_reset(struct ctlr_info *h,
 	unsigned char *scsi3addr, u8 reset_type)
 {
 	struct CommandList *c;
@@ -3606,7 +3606,7 @@ static irqreturn_t do_hpsa_intr_msi(int irq, void=
 *queue)
  * in simple mode, not performant mode due to the tag lookup.
  * We only ever use this immediately after a controller reset.
  */
-static __devinit int hpsa_message(struct pci_dev *pdev, unsigned char =
opcode,
+static int hpsa_message(struct pci_dev *pdev, unsigned char opcode,
 						unsigned char type)
 {
 	struct Command {
@@ -3756,13 +3756,13 @@ static int hpsa_controller_hard_reset(struct pc=
i_dev *pdev,
 	return 0;
 }
=20
-static __devinit void init_driver_version(char *driver_version, int le=
n)
+static void init_driver_version(char *driver_version, int len)
 {
 	memset(driver_version, 0, len);
 	strncpy(driver_version, HPSA " " HPSA_DRIVER_VERSION, len - 1);
 }
=20
-static __devinit int write_driver_ver_to_cfgtable(
+static int write_driver_ver_to_cfgtable(
 	struct CfgTable __iomem *cfgtable)
 {
 	char *driver_version;
@@ -3779,7 +3779,7 @@ static __devinit int write_driver_ver_to_cfgtable=
(
 	return 0;
 }
=20
-static __devinit void read_driver_ver_from_cfgtable(
+static void read_driver_ver_from_cfgtable(
 	struct CfgTable __iomem *cfgtable, unsigned char *driver_ver)
 {
 	int i;
@@ -3788,7 +3788,7 @@ static __devinit void read_driver_ver_from_cfgtab=
le(
 		driver_ver[i] =3D readb(&cfgtable->driver_version[i]);
 }
=20
-static __devinit int controller_reset_failed(
+static int controller_reset_failed(
 	struct CfgTable __iomem *cfgtable)
 {
=20
@@ -3812,7 +3812,7 @@ static __devinit int controller_reset_failed(
 /* This does a hard reset of the controller using PCI power management
  * states or the using the doorbell register.
  */
-static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *=
pdev)
+static int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 {
 	u64 cfg_offset;
 	u32 cfg_base_addr;
@@ -4029,7 +4029,7 @@ static int find_PCI_BAR_index(struct pci_dev *pde=
v, unsigned long pci_bar_addr)
  * controllers that are capable. If not, we use IO-APIC mode.
  */
=20
-static void __devinit hpsa_interrupt_mode(struct ctlr_info *h)
+static void hpsa_interrupt_mode(struct ctlr_info *h)
 {
 #ifdef CONFIG_PCI_MSI
 	int err, i;
@@ -4077,7 +4077,7 @@ default_int_mode:
 	h->intr[h->intr_mode] =3D h->pdev->irq;
 }
=20
-static int __devinit hpsa_lookup_board_id(struct pci_dev *pdev, u32 *b=
oard_id)
+static int hpsa_lookup_board_id(struct pci_dev *pdev, u32 *board_id)
 {
 	int i;
 	u32 subsystem_vendor_id, subsystem_device_id;
@@ -4101,7 +4101,7 @@ static int __devinit hpsa_lookup_board_id(struct =
pci_dev *pdev, u32 *board_id)
 	return ARRAY_SIZE(products) - 1; /* generic unknown smart array */
 }
=20
-static int __devinit hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
+static int hpsa_pci_find_memory_BAR(struct pci_dev *pdev,
 	unsigned long *memory_bar)
 {
 	int i;
@@ -4118,7 +4118,7 @@ static int __devinit hpsa_pci_find_memory_BAR(str=
uct pci_dev *pdev,
 	return -ENODEV;
 }
=20
-static int __devinit hpsa_wait_for_board_state(struct pci_dev *pdev,
+static int hpsa_wait_for_board_state(struct pci_dev *pdev,
 	void __iomem *vaddr, int wait_for_ready)
 {
 	int i, iterations;
@@ -4143,7 +4143,7 @@ static int __devinit hpsa_wait_for_board_state(st=
ruct pci_dev *pdev,
 	return -ENODEV;
 }
=20
-static int __devinit hpsa_find_cfg_addrs(struct pci_dev *pdev,
+static int hpsa_find_cfg_addrs(struct pci_dev *pdev,
 	void __iomem *vaddr, u32 *cfg_base_addr, u64 *cfg_base_addr_index,
 	u64 *cfg_offset)
 {
@@ -4158,7 +4158,7 @@ static int __devinit hpsa_find_cfg_addrs(struct p=
ci_dev *pdev,
 	return 0;
 }
=20
-static int __devinit hpsa_find_cfgtables(struct ctlr_info *h)
+static int hpsa_find_cfgtables(struct ctlr_info *h)
 {
 	u64 cfg_offset;
 	u32 cfg_base_addr;
@@ -4187,7 +4187,7 @@ static int __devinit hpsa_find_cfgtables(struct c=
tlr_info *h)
 	return 0;
 }
=20
-static void __devinit hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
+static void hpsa_get_max_perf_mode_cmds(struct ctlr_info *h)
 {
 	h->max_commands =3D readl(&(h->cfgtable->MaxPerformantModeCommands));
=20
@@ -4208,7 +4208,7 @@ static void __devinit hpsa_get_max_perf_mode_cmds=
(struct ctlr_info *h)
  * max commands, max SG elements without chaining, and with chaining,
  * SG chain block size, etc.
  */
-static void __devinit hpsa_find_board_params(struct ctlr_info *h)
+static void hpsa_find_board_params(struct ctlr_info *h)
 {
 	hpsa_get_max_perf_mode_cmds(h);
 	h->nr_cmds =3D h->max_commands - 4; /* Allow room for some ioctls */
@@ -4266,7 +4266,7 @@ static inline void hpsa_p600_dma_prefetch_quirk(s=
truct ctlr_info *h)
 	writel(dma_prefetch, h->vaddr + I2O_DMA1_CFG);
 }
=20
-static void __devinit hpsa_wait_for_mode_change_ack(struct ctlr_info *=
h)
+static void hpsa_wait_for_mode_change_ack(struct ctlr_info *h)
 {
 	int i;
 	u32 doorbell_value;
@@ -4287,7 +4287,7 @@ static void __devinit hpsa_wait_for_mode_change_a=
ck(struct ctlr_info *h)
 	}
 }
=20
-static int __devinit hpsa_enter_simple_mode(struct ctlr_info *h)
+static int hpsa_enter_simple_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
=20
@@ -4310,7 +4310,7 @@ static int __devinit hpsa_enter_simple_mode(struc=
t ctlr_info *h)
 	return 0;
 }
=20
-static int __devinit hpsa_pci_init(struct ctlr_info *h)
+static int hpsa_pci_init(struct ctlr_info *h)
 {
 	int prod_index, err;
=20
@@ -4378,7 +4378,7 @@ err_out_free_res:
 	return err;
 }
=20
-static void __devinit hpsa_hba_inquiry(struct ctlr_info *h)
+static void hpsa_hba_inquiry(struct ctlr_info *h)
 {
 	int rc;
=20
@@ -4394,7 +4394,7 @@ static void __devinit hpsa_hba_inquiry(struct ctl=
r_info *h)
 	}
 }
=20
-static __devinit int hpsa_init_reset_devices(struct pci_dev *pdev)
+static int hpsa_init_reset_devices(struct pci_dev *pdev)
 {
 	int rc, i;
=20
@@ -4426,7 +4426,7 @@ static __devinit int hpsa_init_reset_devices(stru=
ct pci_dev *pdev)
 	return 0;
 }
=20
-static __devinit int hpsa_allocate_cmd_pool(struct ctlr_info *h)
+static int hpsa_allocate_cmd_pool(struct ctlr_info *h)
 {
 	h->cmd_pool_bits =3D kzalloc(
 		DIV_ROUND_UP(h->nr_cmds, BITS_PER_LONG) *
@@ -4499,7 +4499,7 @@ static int hpsa_request_irq(struct ctlr_info *h,
 	return 0;
 }
=20
-static int __devinit hpsa_kdump_soft_reset(struct ctlr_info *h)
+static int hpsa_kdump_soft_reset(struct ctlr_info *h)
 {
 	if (hpsa_send_host_reset(h, RAID_CTLR_LUNID,
 		HPSA_RESET_TYPE_CONTROLLER)) {
@@ -4713,7 +4713,7 @@ static void stop_controller_lockup_detector(struc=
t ctlr_info *h)
 	spin_unlock_irqrestore(&lockup_detector_lock, flags);
 }
=20
-static int __devinit hpsa_init_one(struct pci_dev *pdev,
+static int hpsa_init_one(struct pci_dev *pdev,
 				    const struct pci_device_id *ent)
 {
 	int dac, rc;
@@ -5010,7 +5010,7 @@ static void  calc_bucket_map(int bucket[], int nu=
m_buckets,
 	}
 }
=20
-static __devinit void hpsa_enter_performant_mode(struct ctlr_info *h,
+static void hpsa_enter_performant_mode(struct ctlr_info *h,
 	u32 use_short_tags)
 {
 	int i;
@@ -5079,7 +5079,7 @@ static __devinit void hpsa_enter_performant_mode(=
struct ctlr_info *h,
 	h->transMethod =3D CFGTBL_Trans_Performant;
 }
=20
-static __devinit void hpsa_put_ctlr_into_performant_mode(struct ctlr_i=
nfo *h)
+static void hpsa_put_ctlr_into_performant_mode(struct ctlr_info *h)
 {
 	u32 trans_support;
 	int i;
diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index 138e573..319c4a8 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1282,7 +1282,7 @@ static int hptiop_internal_memfree_mvfrey(struct =
hptiop_hba *hba)
 		return -1;
 }
=20
-static int __devinit hptiop_probe(struct pci_dev *pcidev,
+static int hptiop_probe(struct pci_dev *pcidev,
 					const struct pci_device_id *id)
 {
 	struct Scsi_Host *host =3D NULL;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b898a93..8ac4a30 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -8296,7 +8296,7 @@ static pci_ers_result_t ipr_pci_error_detected(st=
ruct pci_dev *pdev,
  * Return value:
  * 	0 on success / -EIO on failure
  **/
-static int __devinit ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
+static int ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int rc =3D 0;
 	unsigned long host_lock_flags =3D 0;
@@ -8425,7 +8425,7 @@ static void ipr_free_all_resources(struct ipr_ioa=
_cfg *ioa_cfg)
  * Return value:
  * 	0 on success / -ENOMEM on allocation failure
  **/
-static int __devinit ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
+static int ipr_alloc_cmd_blks(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct ipr_cmnd *ipr_cmd;
 	struct ipr_ioarcb *ioarcb;
@@ -8497,7 +8497,7 @@ static int __devinit ipr_alloc_cmd_blks(struct ip=
r_ioa_cfg *ioa_cfg)
  * Return value:
  * 	0 on success / non-zero for error
  **/
-static int __devinit ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
+static int ipr_alloc_mem(struct ipr_ioa_cfg *ioa_cfg)
 {
 	struct pci_dev *pdev =3D ioa_cfg->pdev;
 	int i, rc =3D -ENOMEM;
@@ -8601,7 +8601,7 @@ out_free_res_entries:
  * Return value:
  * 	none
  **/
-static void __devinit ipr_initialize_bus_attr(struct ipr_ioa_cfg *ioa_=
cfg)
+static void ipr_initialize_bus_attr(struct ipr_ioa_cfg *ioa_cfg)
 {
 	int i;
=20
@@ -8625,7 +8625,7 @@ static void __devinit ipr_initialize_bus_attr(str=
uct ipr_ioa_cfg *ioa_cfg)
  * Return value:
  * 	none
  **/
-static void __devinit ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
+static void ipr_init_ioa_cfg(struct ipr_ioa_cfg *ioa_cfg,
 				       struct Scsi_Host *host, struct pci_dev *pdev)
 {
 	const struct ipr_interrupt_offsets *p;
@@ -8712,8 +8712,7 @@ static void __devinit ipr_init_ioa_cfg(struct ipr=
_ioa_cfg *ioa_cfg,
  * Return value:
  * 	ptr to chip information on success / NULL on failure
  **/
-static const struct ipr_chip_t * __devinit
-ipr_get_chip_info(const struct pci_device_id *dev_id)
+static const struct ipr_chip_t *ipr_get_chip_info(const struct pci_dev=
ice_id *dev_id)
 {
 	int i;
=20
@@ -8734,7 +8733,7 @@ ipr_get_chip_info(const struct pci_device_id *dev=
_id)
  * Return value:
  * 	0 on success / non-zero on failure
  **/
-static irqreturn_t __devinit ipr_test_intr(int irq, void *devp)
+static irqreturn_t ipr_test_intr(int irq, void *devp)
 {
 	struct ipr_ioa_cfg *ioa_cfg =3D (struct ipr_ioa_cfg *)devp;
 	unsigned long lock_flags =3D 0;
@@ -8761,7 +8760,7 @@ static irqreturn_t __devinit ipr_test_intr(int ir=
q, void *devp)
  * Return value:
  * 	0 on success / non-zero on failure
  **/
-static int __devinit ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg,
+static int ipr_test_msi(struct ipr_ioa_cfg *ioa_cfg,
 				  struct pci_dev *pdev)
 {
 	int rc;
@@ -8815,7 +8814,7 @@ static int __devinit ipr_test_msi(struct ipr_ioa_=
cfg *ioa_cfg,
  * Return value:
  * 	0 on success / non-zero on failure
  **/
-static int __devinit ipr_probe_ioa(struct pci_dev *pdev,
+static int ipr_probe_ioa(struct pci_dev *pdev,
 				   const struct pci_device_id *dev_id)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
@@ -9136,7 +9135,7 @@ static void __devexit ipr_remove(struct pci_dev *=
pdev)
  * Return value:
  * 	0 on success / non-zero on failure
  **/
-static int __devinit ipr_probe(struct pci_dev *pdev,
+static int ipr_probe(struct pci_dev *pdev,
 			       const struct pci_device_id *dev_id)
 {
 	struct ipr_ioa_cfg *ioa_cfg;
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index f3d128e..6bea0d8 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -389,7 +389,7 @@ MODULE_DEVICE_TABLE( pci, ips_pci_table );
=20
 static char ips_hot_plug_name[] =3D "ips";
=20
-static int __devinit  ips_insert_device(struct pci_dev *pci_dev, const=
 struct pci_device_id *ent);
+static int  ips_insert_device(struct pci_dev *pci_dev, const struct pc=
i_device_id *ent);
 static void __devexit ips_remove_device(struct pci_dev *pci_dev);
=20
 static struct pci_driver ips_pci_driver =3D {
@@ -6898,7 +6898,7 @@ module_exit(ips_module_exit);
 /*   Return Value:                                                    =
       */
 /*     0 if Successful, else non-zero                                 =
       */
 /*--------------------------------------------------------------------=
-------*/
-static int __devinit
+static int
 ips_insert_device(struct pci_dev *pci_dev, const struct pci_device_id =
*ent)
 {
 	int index =3D -1;
diff --git a/drivers/scsi/isci/init.c b/drivers/scsi/isci/init.c
index 0e15c71..639b0fc 100644
--- a/drivers/scsi/isci/init.c
+++ b/drivers/scsi/isci/init.c
@@ -282,7 +282,7 @@ static void isci_unregister(struct isci_host *isci_=
host)
 	scsi_host_put(shost);
 }
=20
-static int __devinit isci_pci_init(struct pci_dev *pdev)
+static int isci_pci_init(struct pci_dev *pdev)
 {
 	int err, bar_num, bar_mask =3D 0;
 	void __iomem * const *iomap;
@@ -616,7 +616,7 @@ static struct isci_host *isci_host_alloc(struct pci=
_dev *pdev, int id)
 	return NULL;
 }
=20
-static int __devinit isci_pci_probe(struct pci_dev *pdev, const struct=
 pci_device_id *id)
+static int isci_pci_probe(struct pci_dev *pdev, const struct pci_devic=
e_id *id)
 {
 	struct isci_pci_info *pci_info;
 	int err, i;
diff --git a/drivers/scsi/jazz_esp.c b/drivers/scsi/jazz_esp.c
index 91beca1..3326ac4 100644
--- a/drivers/scsi/jazz_esp.c
+++ b/drivers/scsi/jazz_esp.c
@@ -129,7 +129,7 @@ static const struct esp_driver_ops jazz_esp_ops =3D=
 {
 	.dma_error	=3D	jazz_esp_dma_error,
 };
=20
-static int __devinit esp_jazz_probe(struct platform_device *dev)
+static int esp_jazz_probe(struct platform_device *dev)
 {
 	struct scsi_host_template *tpnt =3D &scsi_esp_template;
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_ini=
t.c
index 898fa16..b8ae0d9 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8813,7 +8813,7 @@ lpfc_get_sli4_parameters(struct lpfc_hba *phba, L=
PFC_MBOXQ_t *mboxq)
  * 	0 - driver can claim the device
  * 	negative value - driver can not claim the device
  **/
-static int __devinit
+static int
 lpfc_pci_probe_one_s3(struct pci_dev *pdev, const struct pci_device_id=
 *pid)
 {
 	struct lpfc_hba   *phba;
@@ -9550,7 +9550,7 @@ out:
  * 	0 - driver can claim the device
  * 	negative value - driver can not claim the device
  **/
-static int __devinit
+static int
 lpfc_pci_probe_one_s4(struct pci_dev *pdev, const struct pci_device_id=
 *pid)
 {
 	struct lpfc_hba   *phba;
@@ -10176,7 +10176,7 @@ lpfc_io_resume_s4(struct pci_dev *pdev)
  * 	0 - driver can claim the device
  * 	negative value - driver can not claim the device
  **/
-static int __devinit
+static int
 lpfc_pci_probe_one(struct pci_dev *pdev, const struct pci_device_id *p=
id)
 {
 	int rc;
diff --git a/drivers/scsi/mac_esp.c b/drivers/scsi/mac_esp.c
index 30b1ba1..844ea3c 100644
--- a/drivers/scsi/mac_esp.c
+++ b/drivers/scsi/mac_esp.c
@@ -481,7 +481,7 @@ static struct esp_driver_ops mac_esp_ops =3D {
 	.dma_error        =3D mac_esp_dma_error,
 };
=20
-static int __devinit esp_mac_probe(struct platform_device *dev)
+static int esp_mac_probe(struct platform_device *dev)
 {
 	struct scsi_host_template *tpnt =3D &scsi_esp_template;
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index eab3211..fe962f2 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4522,7 +4522,7 @@ static struct scsi_host_template megaraid_templat=
e =3D {
 	.eh_host_reset_handler		=3D megaraid_reset,
 };
=20
-static int __devinit
+static int
 megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *i=
d)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megar=
aid/megaraid_mbox.c
index ab114ad..e6a1e0b 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -434,7 +434,7 @@ megaraid_exit(void)
  * This routine should be called whenever a new adapter is detected by=
 the
  * PCI hotplug susbsystem.
  */
-static int __devinit
+static int
 megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *i=
d)
 {
 	adapter_t	*adapter;
@@ -735,7 +735,7 @@ megaraid_io_detach(adapter_t *adapter)
  * - Allocate memory required for all the commands
  * - Use internal library of FW routines, build up complete soft state
  */
-static int __devinit
+static int
 megaraid_init_mbox(adapter_t *adapter)
 {
 	struct pci_dev		*pdev;
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/m=
egaraid/megaraid_sas_base.c
index ac18c98..73f9492 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3972,7 +3972,7 @@ fail_set_dma_mask:
  * @pdev:		PCI device structure
  * @id:			PCI ids of supported hotplugged adapter
  */
-static int __devinit
+static int
 megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id=
)
 {
 	int rval, pos, i, j;
diff --git a/drivers/scsi/mvme16x_scsi.c b/drivers/scsi/mvme16x_scsi.c
index 051a13c..bda320b 100644
--- a/drivers/scsi/mvme16x_scsi.c
+++ b/drivers/scsi/mvme16x_scsi.c
@@ -34,7 +34,7 @@ static struct scsi_host_template mvme16x_scsi_driver_=
template =3D {
=20
 static struct platform_device *mvme16x_scsi_device;
=20
-static __devinit int
+static int
 mvme16x_probe(struct platform_device *dev)
 {
 	struct Scsi_Host * host =3D NULL;
diff --git a/drivers/scsi/mvsas/mv_64xx.c b/drivers/scsi/mvsas/mv_64xx.=
c
index 8ba4722..8bb0699 100644
--- a/drivers/scsi/mvsas/mv_64xx.c
+++ b/drivers/scsi/mvsas/mv_64xx.c
@@ -41,7 +41,7 @@ static void mvs_64xx_detect_porttype(struct mvs_info =
*mvi, int i)
 		phy->phy_type |=3D PORT_TYPE_SATA;
 }
=20
-static void __devinit mvs_64xx_enable_xmt(struct mvs_info *mvi, int ph=
y_id)
+static void mvs_64xx_enable_xmt(struct mvs_info *mvi, int phy_id)
 {
 	void __iomem *regs =3D mvi->regs;
 	u32 tmp;
@@ -54,7 +54,7 @@ static void __devinit mvs_64xx_enable_xmt(struct mvs_=
info *mvi, int phy_id)
 	mw32(MVS_PCS, tmp);
 }
=20
-static void __devinit mvs_64xx_phy_hacks(struct mvs_info *mvi)
+static void mvs_64xx_phy_hacks(struct mvs_info *mvi)
 {
 	void __iomem *regs =3D mvi->regs;
 	int i;
@@ -156,7 +156,7 @@ void mvs_64xx_clear_srs_irq(struct mvs_info *mvi, u=
8 reg_set, u8 clear_all)
 	}
 }
=20
-static int __devinit mvs_64xx_chip_reset(struct mvs_info *mvi)
+static int mvs_64xx_chip_reset(struct mvs_info *mvi)
 {
 	void __iomem *regs =3D mvi->regs;
 	u32 tmp;
@@ -250,7 +250,7 @@ static void mvs_64xx_phy_enable(struct mvs_info *mv=
i, u32 phy_id)
 	}
 }
=20
-static int __devinit mvs_64xx_init(struct mvs_info *mvi)
+static int mvs_64xx_init(struct mvs_info *mvi)
 {
 	void __iomem *regs =3D mvi->regs;
 	int i;
diff --git a/drivers/scsi/mvsas/mv_94xx.c b/drivers/scsi/mvsas/mv_94xx.=
c
index 7e423e5..2491703 100644
--- a/drivers/scsi/mvsas/mv_94xx.c
+++ b/drivers/scsi/mvsas/mv_94xx.c
@@ -216,7 +216,7 @@ void set_phy_rate(struct mvs_info *mvi, int phy_id,=
 u8 rate)
 	mvs_write_port_vsr_data(mvi, phy_id, phy_cfg.v);
 }
=20
-static void __devinit
+static void
 mvs_94xx_config_reg_from_hba(struct mvs_info *mvi, int phy_id)
 {
 	u32 temp;
@@ -258,7 +258,7 @@ mvs_94xx_config_reg_from_hba(struct mvs_info *mvi, =
int phy_id)
 		mvi->hba_info_param.phy_rate[phy_id]);
 }
=20
-static void __devinit mvs_94xx_enable_xmt(struct mvs_info *mvi, int ph=
y_id)
+static void mvs_94xx_enable_xmt(struct mvs_info *mvi, int phy_id)
 {
 	void __iomem *regs =3D mvi->regs;
 	u32 tmp;
@@ -331,7 +331,7 @@ static void mvs_94xx_phy_enable(struct mvs_info *mv=
i, u32 phy_id)
 	mvs_write_port_vsr_data(mvi, phy_id, tmp & 0xfd7fffff);
 }
=20
-static int __devinit mvs_94xx_init(struct mvs_info *mvi)
+static int mvs_94xx_init(struct mvs_info *mvi)
 {
 	void __iomem *regs =3D mvi->regs;
 	int i;
diff --git a/drivers/scsi/mvsas/mv_chips.h b/drivers/scsi/mvsas/mv_chip=
s.h
index bcc4080..8c4479a 100644
--- a/drivers/scsi/mvsas/mv_chips.h
+++ b/drivers/scsi/mvsas/mv_chips.h
@@ -160,7 +160,7 @@ static inline void mvs_write_port_irq_mask(struct m=
vs_info *mvi,
 			MVS_P4_INT_MASK, port, val);
 }
=20
-static inline void __devinit mvs_phy_hacks(struct mvs_info *mvi)
+static inline void mvs_phy_hacks(struct mvs_info *mvi)
 {
 	u32 tmp;
=20
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.=
c
index a95adad..efa5f05 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -96,7 +96,7 @@ static struct sas_domain_function_template mvs_transp=
ort_ops =3D {
=20
 };
=20
-static void __devinit mvs_phy_init(struct mvs_info *mvi, int phy_id)
+static void mvs_phy_init(struct mvs_info *mvi, int phy_id)
 {
 	struct mvs_phy *phy =3D &mvi->phy[phy_id];
 	struct asd_sas_phy *sas_phy =3D &phy->sas_phy;
@@ -235,7 +235,7 @@ static irqreturn_t mvs_interrupt(int irq, void *opa=
que)
 	return IRQ_HANDLED;
 }
=20
-static int __devinit mvs_alloc(struct mvs_info *mvi, struct Scsi_Host =
*shost)
+static int mvs_alloc(struct mvs_info *mvi, struct Scsi_Host *shost)
 {
 	int i =3D 0, slot_nr;
 	char pool_name[32];
@@ -373,7 +373,7 @@ void mvs_iounmap(void __iomem *regs)
 	iounmap(regs);
 }
=20
-static struct mvs_info *__devinit mvs_pci_alloc(struct pci_dev *pdev,
+static struct mvs_info *mvs_pci_alloc(struct pci_dev *pdev,
 				const struct pci_device_id *ent,
 				struct Scsi_Host *shost, unsigned int id)
 {
@@ -444,7 +444,7 @@ static int pci_go_64(struct pci_dev *pdev)
 	return rc;
 }
=20
-static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
+static int mvs_prep_sas_ha_init(struct Scsi_Host *shost,
 				const struct mvs_chip_info *chip_info)
 {
 	int phy_nr, port_nr; unsigned short core_nr;
@@ -486,7 +486,7 @@ exit_free:
=20
 }
=20
-static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
+static void  mvs_post_sas_ha_init(struct Scsi_Host *shost,
 			const struct mvs_chip_info *chip_info)
 {
 	int can_queue, i =3D 0, j =3D 0;
@@ -537,7 +537,7 @@ static void mvs_init_sas_add(struct mvs_info *mvi)
 	memcpy(mvi->sas_addr, &mvi->phy[0].dev_sas_addr, SAS_ADDR_SIZE);
 }
=20
-static int __devinit mvs_pci_init(struct pci_dev *pdev,
+static int mvs_pci_init(struct pci_dev *pdev,
 				  const struct pci_device_id *ent)
 {
 	unsigned int rc, nhost =3D 0;
diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index a3776d6..d69af66 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -220,7 +220,7 @@ int mvs_phy_control(struct asd_sas_phy *sas_phy, en=
um phy_func func,
 	return rc;
 }
=20
-void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
+void mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
 				u32 off_lo, u32 off_hi, u64 sas_addr)
 {
 	u32 lo =3D (u32)sas_addr;
diff --git a/drivers/scsi/mvsas/mv_sas.h b/drivers/scsi/mvsas/mv_sas.h
index c04a4f5..c779c85 100644
--- a/drivers/scsi/mvsas/mv_sas.h
+++ b/drivers/scsi/mvsas/mv_sas.h
@@ -456,7 +456,7 @@ int mvs_ioremap(struct mvs_info *mvi, int bar, int =
bar_ex);
 void mvs_phys_reset(struct mvs_info *mvi, u32 phy_mask, int hard);
 int mvs_phy_control(struct asd_sas_phy *sas_phy, enum phy_func func,
 			void *funcdata);
-void __devinit mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
+void mvs_set_sas_addr(struct mvs_info *mvi, int port_id,
 				u32 off_lo, u32 off_hi, u64 sas_addr);
 void mvs_scan_start(struct Scsi_Host *shost);
 int mvs_scan_finished(struct Scsi_Host *shost, unsigned long time);
diff --git a/drivers/scsi/mvumi.c b/drivers/scsi/mvumi.c
index f2e3e49..51e9dcd 100644
--- a/drivers/scsi/mvumi.c
+++ b/drivers/scsi/mvumi.c
@@ -2506,7 +2506,7 @@ fail_add_device:
  * @pdev:		PCI device structure
  * @id:			PCI ids of supported hotplugged adapter
  */
-static int __devinit mvumi_probe_one(struct pci_dev *pdev,
+static int mvumi_probe_one(struct pci_dev *pdev,
 					const struct pci_device_id *id)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index 681294e..0415f04 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -186,7 +186,7 @@ static nsp32_sync_table nsp32_sync_table_pci[] =3D =
{
  * function declaration
  */
 /* module entry point */
-static int  __devinit nsp32_probe (struct pci_dev *, const struct pci_=
device_id *);
+static int  nsp32_probe (struct pci_dev *, const struct pci_device_id =
*);
 static void __devexit nsp32_remove(struct pci_dev *);
 static int  __init    init_nsp32  (void);
 static void __exit    exit_nsp32  (void);
@@ -3382,7 +3382,7 @@ static int nsp32_resume(struct pci_dev *pdev)
 /*********************************************************************=
***
  * PCI/Cardbus probe/remove routine
  */
-static int __devinit nsp32_probe(struct pci_dev *pdev, const struct pc=
i_device_id *id)
+static int nsp32_probe(struct pci_dev *pdev, const struct pci_device_i=
d *id)
 {
 	int ret;
 	nsp32_hw_data *data =3D &nsp32_data_base;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8=
001_hwi.c
index bf54aaf..2a431da 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -47,7 +47,7 @@
  * read_main_config_table - read the configure table and save it.
  * @pm8001_ha: our hba card information
  */
-static void __devinit read_main_config_table(struct pm8001_hba_info *p=
m8001_ha)
+static void read_main_config_table(struct pm8001_hba_info *pm8001_ha)
 {
 	void __iomem *address =3D pm8001_ha->main_cfg_tbl_addr;
 	pm8001_ha->main_cfg_tbl.signature	=3D pm8001_mr32(address, 0x00);
@@ -83,7 +83,7 @@ static void __devinit read_main_config_table(struct p=
m8001_hba_info *pm8001_ha)
  * read_general_status_table - read the general status table and save =
it.
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 read_general_status_table(struct pm8001_hba_info *pm8001_ha)
 {
 	void __iomem *address =3D pm8001_ha->general_stat_tbl_addr;
@@ -118,7 +118,7 @@ read_general_status_table(struct pm8001_hba_info *p=
m8001_ha)
  * read_inbnd_queue_table - read the inbound queue table and save it.
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 read_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha)
 {
 	int inbQ_num =3D 1;
@@ -137,7 +137,7 @@ read_inbnd_queue_table(struct pm8001_hba_info *pm80=
01_ha)
  * read_outbnd_queue_table - read the outbound queue table and save it=
=2E
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 read_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha)
 {
 	int outbQ_num =3D 1;
@@ -156,7 +156,7 @@ read_outbnd_queue_table(struct pm8001_hba_info *pm8=
001_ha)
  * init_default_table_values - init the default table.
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 init_default_table_values(struct pm8001_hba_info *pm8001_ha)
 {
 	int qn =3D 1;
@@ -250,7 +250,7 @@ init_default_table_values(struct pm8001_hba_info *p=
m8001_ha)
  * update_main_config_table - update the main default table to the HBA=
=2E
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 update_main_config_table(struct pm8001_hba_info *pm8001_ha)
 {
 	void __iomem *address =3D pm8001_ha->main_cfg_tbl_addr;
@@ -297,7 +297,7 @@ update_main_config_table(struct pm8001_hba_info *pm=
8001_ha)
  * update_inbnd_queue_table - update the inbound queue table to the HB=
A.
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 update_inbnd_queue_table(struct pm8001_hba_info *pm8001_ha, int number=
)
 {
 	void __iomem *address =3D pm8001_ha->inbnd_q_tbl_addr;
@@ -318,7 +318,7 @@ update_inbnd_queue_table(struct pm8001_hba_info *pm=
8001_ha, int number)
  * update_outbnd_queue_table - update the outbound queue table to the =
HBA.
  * @pm8001_ha: our hba card information
  */
-static void __devinit
+static void
 update_outbnd_queue_table(struct pm8001_hba_info *pm8001_ha, int numbe=
r)
 {
 	void __iomem *address =3D pm8001_ha->outbnd_q_tbl_addr;
@@ -370,7 +370,7 @@ int pm8001_bar4_shift(struct pm8001_hba_info *pm800=
1_ha, u32 shiftValue)
  * @pm8001_ha: our hba card information
  * @SSCbit: set SSCbit to 0 to disable all phys ssc; 1 to enable all p=
hys ssc.
  */
-static void __devinit
+static void
 mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm8001_ha, u32 SSCbit=
)
 {
 	u32 value, offset, i;
@@ -438,7 +438,7 @@ mpi_set_phys_g3_with_ssc(struct pm8001_hba_info *pm=
8001_ha, u32 SSCbit)
  * @pm8001_ha: our hba card information
  * @interval - interval time for each OPEN_REJECT (RETRY). The units a=
re in 1us.
  */
-static void __devinit
+static void
 mpi_set_open_retry_interval_reg(struct pm8001_hba_info *pm8001_ha,
 				u32 interval)
 {
@@ -601,7 +601,7 @@ static void init_pci_device_addresses(struct pm8001=
_hba_info *pm8001_ha)
  * pm8001_chip_init - the main init function that initialize whole PM8=
001 chip.
  * @pm8001_ha: our hba card information
  */
-static int __devinit pm8001_chip_init(struct pm8001_hba_info *pm8001_h=
a)
+static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 {
 	/* check the firmware status */
 	if (-1 =3D=3D check_fw_ready(pm8001_ha)) {
diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm=
8001_init.c
index e2d1e44..32eb98b 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -104,7 +104,7 @@ static struct sas_domain_function_template pm8001_t=
ransport_ops =3D {
  *@pm8001_ha: our hba structure.
  *@phy_id: phy id.
  */
-static void __devinit pm8001_phy_init(struct pm8001_hba_info *pm8001_h=
a,
+static void pm8001_phy_init(struct pm8001_hba_info *pm8001_ha,
 	int phy_id)
 {
 	struct pm8001_phy *phy =3D &pm8001_ha->phy[phy_id];
@@ -195,7 +195,7 @@ static irqreturn_t pm8001_interrupt(int irq, void *=
opaque)
  * @pm8001_ha:our hba structure.
  *
  */
-static int __devinit pm8001_alloc(struct pm8001_hba_info *pm8001_ha)
+static int pm8001_alloc(struct pm8001_hba_info *pm8001_ha)
 {
 	int i;
 	spin_lock_init(&pm8001_ha->lock);
@@ -360,8 +360,7 @@ static int pm8001_ioremap(struct pm8001_hba_info *p=
m8001_ha)
  * @ent: ent
  * @shost: scsi host struct which has been initialized before.
  */
-static struct pm8001_hba_info *__devinit
-pm8001_pci_alloc(struct pci_dev *pdev, u32 chip_id, struct Scsi_Host *=
shost)
+static struct pm8001_hba_info *pm8001_pci_alloc(struct pci_dev *pdev, =
u32 chip_id, struct Scsi_Host *shost)
 {
 	struct pm8001_hba_info *pm8001_ha;
 	struct sas_ha_struct *sha =3D SHOST_TO_SAS_HA(shost);
@@ -433,7 +432,7 @@ static int pci_go_44(struct pci_dev *pdev)
  * @shost: scsi host which has been allocated outside.
  * @chip_info: our ha struct.
  */
-static int __devinit pm8001_prep_sas_ha_init(struct Scsi_Host * shost,
+static int pm8001_prep_sas_ha_init(struct Scsi_Host * shost,
 	const struct pm8001_chip_info *chip_info)
 {
 	int phy_nr, port_nr;
@@ -479,7 +478,7 @@ exit:
  * @shost: scsi host which has been allocated outside
  * @chip_info: our ha struct.
  */
-static void  __devinit pm8001_post_sas_ha_init(struct Scsi_Host *shost=
,
+static void  pm8001_post_sas_ha_init(struct Scsi_Host *shost,
 	const struct pm8001_chip_info *chip_info)
 {
 	int i =3D 0;
@@ -615,7 +614,7 @@ intx:
  * pci driver it is invoked, all struct an hardware initilization shou=
ld be done
  * here, also, register interrupt
  */
-static int __devinit pm8001_pci_probe(struct pci_dev *pdev,
+static int pm8001_pci_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
 	unsigned int rc;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index af763ea..93f764b 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -4818,7 +4818,7 @@ pmcraid_release_control_blocks(
  * Return Value
  *	0 in case of success; -ENOMEM in case of failure
  */
-static int __devinit
+static int
 pmcraid_allocate_cmd_blocks(struct pmcraid_instance *pinstance)
 {
 	int i;
@@ -4855,7 +4855,7 @@ pmcraid_allocate_cmd_blocks(struct pmcraid_instan=
ce *pinstance)
  * Return Value
  *  0 in case it can allocate all control blocks, otherwise -ENOMEM
  */
-static int __devinit
+static int
 pmcraid_allocate_control_blocks(struct pmcraid_instance *pinstance)
 {
 	int i;
@@ -4922,7 +4922,7 @@ pmcraid_release_host_rrqs(struct pmcraid_instance=
 *pinstance, int maxindex)
  * Return value
  *	0 hrrq buffers are allocated, -ENOMEM otherwise.
  */
-static int __devinit
+static int
 pmcraid_allocate_host_rrqs(struct pmcraid_instance *pinstance)
 {
 	int i, buffer_size;
@@ -5062,7 +5062,7 @@ static void pmcraid_release_config_buffers(struct=
 pmcraid_instance *pinstance)
  * Return Value
  *	0 for successful allocation, -ENOMEM for any failure
  */
-static int __devinit
+static int
 pmcraid_allocate_config_buffers(struct pmcraid_instance *pinstance)
 {
 	int i;
@@ -5181,7 +5181,7 @@ static void pmcraid_release_buffers(struct pmcrai=
d_instance *pinstance)
  * Return Value
  *	 0 in case all of the blocks are allocated, -ENOMEM otherwise.
  */
-static int __devinit pmcraid_init_buffers(struct pmcraid_instance *pin=
stance)
+static int pmcraid_init_buffers(struct pmcraid_instance *pinstance)
 {
 	int i;
=20
@@ -5281,7 +5281,7 @@ static void pmcraid_reinit_buffers(struct pmcraid=
_instance *pinstance)
  * Return Value
  *	 0 on success, non-zero in case of any failure
  */
-static int __devinit pmcraid_init_instance(
+static int pmcraid_init_instance(
 	struct pci_dev *pdev,
 	struct Scsi_Host *host,
 	void __iomem *mapped_pci_addr
@@ -5883,7 +5883,7 @@ static void pmcraid_querycfg(struct pmcraid_cmd *=
cmd)
  *	returns 0 if the device is claimed and successfully configured.
  *	returns non-zero error code in case of any failure
  */
-static int __devinit pmcraid_probe(
+static int pmcraid_probe(
 	struct pci_dev *pdev,
 	const struct pci_device_id *dev_id
 )
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 959f100..e6e2a30 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -359,7 +359,7 @@ static struct scsi_host_template ps3rom_host_templa=
te =3D {
 };
=20
=20
-static int __devinit ps3rom_probe(struct ps3_system_bus_device *_dev)
+static int ps3rom_probe(struct ps3_system_bus_device *_dev)
 {
 	struct ps3_storage_device *dev =3D to_ps3_storage_device(&_dev->core)=
;
 	int error;
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 46d138a..434477b 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1438,7 +1438,7 @@ qla1280_return_status(struct response * sts, stru=
ct scsi_cmnd *cp)
  * Returns:
  *      0 =3D success
  */
-static int __devinit
+static int
 qla1280_initialize_adapter(struct scsi_qla_host *ha)
 {
 	struct device_reg __iomem *reg;
@@ -4230,7 +4230,7 @@ static struct scsi_host_template qla1280_driver_t=
emplate =3D {
 };
=20
=20
-static int __devinit
+static int
 qla1280_probe_one(struct pci_dev *pdev, const struct pci_device_id *id=
)
 {
 	int devnum =3D id->driver_data;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_o=
s.c
index d501bf5..aee37ef 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2144,7 +2144,7 @@ qla2xxx_scan_finished(struct Scsi_Host *shost, un=
signed long time)
 /*
  * PCI driver interface
  */
-static int __devinit
+static int
 qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id=
)
 {
 	int	ret =3D -ENODEV;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_o=
s.c
index fbc546e..f8bb98e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5124,7 +5124,7 @@ void qla4xxx_build_ddb_list(struct scsi_qla_host =
*ha, int is_reset)
  * It returns zero if successful. It also initializes all data necessa=
ry for
  * the driver.
  **/
-static int __devinit qla4xxx_probe_adapter(struct pci_dev *pdev,
+static int qla4xxx_probe_adapter(struct pci_dev *pdev,
 					   const struct pci_device_id *ent)
 {
 	int ret =3D -ENODEV, status;
diff --git a/drivers/scsi/qlogicfas.c b/drivers/scsi/qlogicfas.c
index 1e874f1..13d628b 100644
--- a/drivers/scsi/qlogicfas.c
+++ b/drivers/scsi/qlogicfas.c
@@ -142,7 +142,7 @@ module_param_array(irq, int, NULL, 0);
 MODULE_PARM_DESC(iobase, "I/O address");
 MODULE_PARM_DESC(irq, "IRQ");
=20
-static int __devinit qlogicfas_detect(struct scsi_host_template *sht)
+static int qlogicfas_detect(struct scsi_host_template *sht)
 {
 	struct Scsi_Host *shost;
 	struct qlogicfas408_priv *priv;
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 59466ee..71b38a1 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -461,7 +461,7 @@ static int qlogicpti_reset_hardware(struct Scsi_Hos=
t *host)
=20
 #define PTI_RESET_LIMIT 400
=20
-static int __devinit qlogicpti_load_firmware(struct qlogicpti *qpti)
+static int qlogicpti_load_firmware(struct qlogicpti *qpti)
 {
 	const struct firmware *fw;
 	const char fwname[] =3D "qlogic/isp1000.bin";
@@ -670,7 +670,7 @@ static int qlogicpti_verify_tmon(struct qlogicpti *=
qpti)
=20
 static irqreturn_t qpti_intr(int irq, void *dev_id);
=20
-static void __devinit qpti_chain_add(struct qlogicpti *qpti)
+static void qpti_chain_add(struct qlogicpti *qpti)
 {
 	spin_lock_irq(&qptichain_lock);
 	if (qptichain !=3D NULL) {
@@ -701,7 +701,7 @@ static void __devexit qpti_chain_del(struct qlogicp=
ti *qpti)
 	spin_unlock_irq(&qptichain_lock);
 }
=20
-static int __devinit qpti_map_regs(struct qlogicpti *qpti)
+static int qpti_map_regs(struct qlogicpti *qpti)
 {
 	struct platform_device *op =3D qpti->op;
=20
@@ -724,7 +724,7 @@ static int __devinit qpti_map_regs(struct qlogicpti=
 *qpti)
 	return 0;
 }
=20
-static int __devinit qpti_register_irq(struct qlogicpti *qpti)
+static int qpti_register_irq(struct qlogicpti *qpti)
 {
 	struct platform_device *op =3D qpti->op;
=20
@@ -749,7 +749,7 @@ fail:
 	return -1;
 }
=20
-static void __devinit qpti_get_scsi_id(struct qlogicpti *qpti)
+static void qpti_get_scsi_id(struct qlogicpti *qpti)
 {
 	struct platform_device *op =3D qpti->op;
 	struct device_node *dp;
@@ -803,7 +803,7 @@ static void qpti_get_clock(struct qlogicpti *qpti)
 /* The request and response queues must each be aligned
  * on a page boundary.
  */
-static int __devinit qpti_map_queues(struct qlogicpti *qpti)
+static int qpti_map_queues(struct qlogicpti *qpti)
 {
 	struct platform_device *op =3D qpti->op;
=20
@@ -1292,7 +1292,7 @@ static struct scsi_host_template qpti_template =3D=
 {
 };
=20
 static const struct of_device_id qpti_match[];
-static int __devinit qpti_sbus_probe(struct platform_device *op)
+static int qpti_sbus_probe(struct platform_device *op)
 {
 	struct device_node *dp =3D op->dev.of_node;
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 8583e2c..a464d95 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -226,7 +226,7 @@ static struct scsi_host_template sgiwd93_template =3D=
 {
 	.use_clustering		=3D DISABLE_CLUSTERING,
 };
=20
-static int __devinit sgiwd93_probe(struct platform_device *pdev)
+static int sgiwd93_probe(struct platform_device *pdev)
 {
 	struct sgiwd93_platform_data *pd =3D pdev->dev.platform_data;
 	unsigned char *wdregs =3D pd->wdregs;
diff --git a/drivers/scsi/sim710.c b/drivers/scsi/sim710.c
index cd69476..e616bc2 100644
--- a/drivers/scsi/sim710.c
+++ b/drivers/scsi/sim710.c
@@ -94,7 +94,7 @@ static struct scsi_host_template sim710_driver_templa=
te =3D {
 	.module			=3D THIS_MODULE,
 };
=20
-static __devinit int
+static int
 sim710_probe_common(struct device *dev, unsigned long base_addr,
 		    int irq, int clock, int differential, int scsi_id)
 {
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 3f762b9..52d54e7 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -65,7 +65,7 @@ static struct scsi_host_template snirm710_template =3D=
 {
 	.module		=3D THIS_MODULE,
 };
=20
-static int __devinit snirm710_probe(struct platform_device *dev)
+static int snirm710_probe(struct platform_device *dev)
 {
 	unsigned long base;
 	struct NCR_700_Host_Parameters *hostdata;
diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
index a12b3b0..917396e 100644
--- a/drivers/scsi/stex.c
+++ b/drivers/scsi/stex.c
@@ -1540,7 +1540,7 @@ static void stex_free_irq(struct st_hba *hba)
 		pci_disable_msi(pdev);
 }
=20
-static int __devinit
+static int
 stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct st_hba *hba;
diff --git a/drivers/scsi/sun3x_esp.c b/drivers/scsi/sun3x_esp.c
index 90295fb..d8e3a1c 100644
--- a/drivers/scsi/sun3x_esp.c
+++ b/drivers/scsi/sun3x_esp.c
@@ -194,7 +194,7 @@ static const struct esp_driver_ops sun3x_esp_ops =3D=
 {
 	.dma_error	=3D	sun3x_esp_dma_error,
 };
=20
-static int __devinit esp_sun3x_probe(struct platform_device *dev)
+static int esp_sun3x_probe(struct platform_device *dev)
 {
 	struct scsi_host_template *tpnt =3D &scsi_esp_template;
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 4ebd216..707252c 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -43,7 +43,7 @@ enum dvma_rev {
 	dvmahme
 };
=20
-static int __devinit esp_sbus_setup_dma(struct esp *esp,
+static int esp_sbus_setup_dma(struct esp *esp,
 					struct platform_device *dma_of)
 {
 	esp->dma =3D dma_of;
@@ -79,7 +79,7 @@ static int __devinit esp_sbus_setup_dma(struct esp *e=
sp,
=20
 }
=20
-static int __devinit esp_sbus_map_regs(struct esp *esp, int hme)
+static int esp_sbus_map_regs(struct esp *esp, int hme)
 {
 	struct platform_device *op =3D esp->dev;
 	struct resource *res;
@@ -99,7 +99,7 @@ static int __devinit esp_sbus_map_regs(struct esp *es=
p, int hme)
 	return 0;
 }
=20
-static int __devinit esp_sbus_map_command_block(struct esp *esp)
+static int esp_sbus_map_command_block(struct esp *esp)
 {
 	struct platform_device *op =3D esp->dev;
=20
@@ -111,7 +111,7 @@ static int __devinit esp_sbus_map_command_block(str=
uct esp *esp)
 	return 0;
 }
=20
-static int __devinit esp_sbus_register_irq(struct esp *esp)
+static int esp_sbus_register_irq(struct esp *esp)
 {
 	struct Scsi_Host *host =3D esp->host;
 	struct platform_device *op =3D esp->dev;
@@ -120,7 +120,7 @@ static int __devinit esp_sbus_register_irq(struct e=
sp *esp)
 	return request_irq(host->irq, scsi_esp_intr, IRQF_SHARED, "ESP", esp)=
;
 }
=20
-static void __devinit esp_get_scsi_id(struct esp *esp, struct platform=
_device *espdma)
+static void esp_get_scsi_id(struct esp *esp, struct platform_device *e=
spdma)
 {
 	struct platform_device *op =3D esp->dev;
 	struct device_node *dp;
@@ -142,7 +142,7 @@ done:
 	esp->scsi_id_mask =3D (1 << esp->scsi_id);
 }
=20
-static void __devinit esp_get_differential(struct esp *esp)
+static void esp_get_differential(struct esp *esp)
 {
 	struct platform_device *op =3D esp->dev;
 	struct device_node *dp;
@@ -154,7 +154,7 @@ static void __devinit esp_get_differential(struct e=
sp *esp)
 		esp->flags &=3D ~ESP_FLAG_DIFFERENTIAL;
 }
=20
-static void __devinit esp_get_clock_params(struct esp *esp)
+static void esp_get_clock_params(struct esp *esp)
 {
 	struct platform_device *op =3D esp->dev;
 	struct device_node *bus_dp, *dp;
@@ -170,7 +170,7 @@ static void __devinit esp_get_clock_params(struct e=
sp *esp)
 	esp->cfreq =3D fmhz;
 }
=20
-static void __devinit esp_get_bursts(struct esp *esp, struct platform_=
device *dma_of)
+static void esp_get_bursts(struct esp *esp, struct platform_device *dm=
a_of)
 {
 	struct device_node *dma_dp =3D dma_of->dev.of_node;
 	struct platform_device *op =3D esp->dev;
@@ -195,7 +195,7 @@ static void __devinit esp_get_bursts(struct esp *es=
p, struct platform_device *dm
 	esp->bursts =3D bursts;
 }
=20
-static void __devinit esp_sbus_get_props(struct esp *esp, struct platf=
orm_device *espdma)
+static void esp_sbus_get_props(struct esp *esp, struct platform_device=
 *espdma)
 {
 	esp_get_scsi_id(esp, espdma);
 	esp_get_differential(esp);
@@ -487,7 +487,7 @@ static const struct esp_driver_ops sbus_esp_ops =3D=
 {
 	.dma_error	=3D	sbus_esp_dma_error,
 };
=20
-static int __devinit esp_sbus_probe_one(struct platform_device *op,
+static int esp_sbus_probe_one(struct platform_device *op,
 					struct platform_device *espdma,
 					int hme)
 {
@@ -562,7 +562,7 @@ fail:
 	return err;
 }
=20
-static int __devinit esp_sbus_probe(struct platform_device *op)
+static int esp_sbus_probe(struct platform_device *op)
 {
 	struct device_node *dma_node =3D NULL;
 	struct device_node *dp =3D op->dev.of_node;
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8=
xx_2/sym_glue.c
index e2b8e68..03eddfd 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -1284,7 +1284,7 @@ static int sym53c8xx_proc_info(struct Scsi_Host *=
shost, char *buffer,
  * sym_free_resources() should be used instead of this function after =
calling
  * sym_attach().
  */
-static void __devinit
+static void
 sym_iounmap_device(struct sym_device *device)
 {
 	if (device->s.ioaddr)
@@ -1325,7 +1325,7 @@ static void sym_free_resources(struct sym_hcb *np=
, struct pci_dev *pdev,
  *  If all is OK, install interrupt handling and
  *  start the timer daemon.
  */
-static struct Scsi_Host * __devinit sym_attach(struct scsi_host_templa=
te *tpnt,
+static struct Scsi_Host *sym_attach(struct scsi_host_template *tpnt,
 		int unit, struct sym_device *dev)
 {
 	struct sym_data *sym_data;
@@ -1481,7 +1481,7 @@ static struct Scsi_Host * __devinit sym_attach(st=
ruct scsi_host_template *tpnt,
  *    Detect and try to read SYMBIOS and TEKRAM NVRAM.
  */
 #if SYM_CONF_NVRAM_SUPPORT
-static void __devinit sym_get_nvram(struct sym_device *devp, struct sy=
m_nvram *nvp)
+static void sym_get_nvram(struct sym_device *devp, struct sym_nvram *n=
vp)
 {
 	devp->nvram =3D nvp;
 	nvp->type =3D 0;
@@ -1494,7 +1494,7 @@ static inline void sym_get_nvram(struct sym_devic=
e *devp, struct sym_nvram *nvp)
 }
 #endif	/* SYM_CONF_NVRAM_SUPPORT */
=20
-static int __devinit sym_check_supported(struct sym_device *device)
+static int sym_check_supported(struct sym_device *device)
 {
 	struct sym_chip *chip;
 	struct pci_dev *pdev =3D device->pdev;
@@ -1531,7 +1531,7 @@ static int __devinit sym_check_supported(struct s=
ym_device *device)
  * Ignore Symbios chips controlled by various RAID controllers.
  * These controllers set value 0x52414944 at RAM end - 16.
  */
-static int __devinit sym_check_raid(struct sym_device *device)
+static int sym_check_raid(struct sym_device *device)
 {
 	unsigned int ram_size, ram_val;
=20
@@ -1552,7 +1552,7 @@ static int __devinit sym_check_raid(struct sym_de=
vice *device)
 	return -ENODEV;
 }
=20
-static int __devinit sym_set_workarounds(struct sym_device *device)
+static int sym_set_workarounds(struct sym_device *device)
 {
 	struct sym_chip *chip =3D &device->chip;
 	struct pci_dev *pdev =3D device->pdev;
@@ -1602,7 +1602,7 @@ static int __devinit sym_set_workarounds(struct s=
ym_device *device)
 /*
  * Map HBA registers and on-chip SRAM (if present).
  */
-static int __devinit
+static int
 sym_iomap_device(struct sym_device *device)
 {
 	struct pci_dev *pdev =3D device->pdev;
@@ -1751,7 +1751,7 @@ static struct scsi_host_template sym2_template =3D=
 {
=20
 static int attach_count;
=20
-static int __devinit sym2_probe(struct pci_dev *pdev,
+static int sym2_probe(struct pci_dev *pdev,
 				const struct pci_device_id *ent)
 {
 	struct sym_device sym_dev;
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 080ce3d..3da9d9a 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -2219,7 +2219,7 @@ static struct scsi_host_template driver_template =
=3D {
  *
  *********************************************************************=
*/
=20
-static void __devinit dc390_eeprom_prepare_read(struct pci_dev *pdev, =
u8 cmd)
+static void dc390_eeprom_prepare_read(struct pci_dev *pdev, u8 cmd)
 {
 	u8 carryFlag =3D 1, j =3D 0x80, bval;
 	int i;
@@ -2242,7 +2242,7 @@ static void __devinit dc390_eeprom_prepare_read(s=
truct pci_dev *pdev, u8 cmd)
 	}
 }
=20
-static u16 __devinit dc390_eeprom_get_data(struct pci_dev *pdev)
+static u16 dc390_eeprom_get_data(struct pci_dev *pdev)
 {
 	int i;
 	u16 wval =3D 0;
@@ -2264,7 +2264,7 @@ static u16 __devinit dc390_eeprom_get_data(struct=
 pci_dev *pdev)
 	return wval;
 }
=20
-static void __devinit dc390_read_eeprom(struct pci_dev *pdev, u16 *ptr=
)
+static void dc390_read_eeprom(struct pci_dev *pdev, u16 *ptr)
 {
 	u8 cmd =3D EEPROM_READ, i;
=20
@@ -2282,7 +2282,7 @@ static void __devinit dc390_read_eeprom(struct pc=
i_dev *pdev, u16 *ptr)
 }
=20
 /* Override EEprom values with explicitly set values */
-static void __devinit dc390_eeprom_override(u8 index)
+static void dc390_eeprom_override(u8 index)
 {
 	u8 *ptr =3D (u8 *) dc390_eepromBuf[index], id;
=20
@@ -2315,7 +2315,7 @@ static int __devinitdata tmscsim_def[] =3D {
 };
=20
 /* Copy defaults over set values where missing */
-static void __devinit dc390_fill_with_defaults (void)
+static void dc390_fill_with_defaults (void)
 {
 	int i;
=20
@@ -2335,7 +2335,7 @@ static void __devinit dc390_fill_with_defaults (v=
oid)
 		tmscsim[5] =3D 180;
 }
=20
-static void __devinit dc390_check_eeprom(struct pci_dev *pdev, u8 inde=
x)
+static void dc390_check_eeprom(struct pci_dev *pdev, u8 index)
 {
 	u8 interpd[] =3D {1, 3, 5, 10, 16, 30, 60, 120};
 	u8 EEbuf[128];
@@ -2372,7 +2372,7 @@ static void __devinit dc390_check_eeprom(struct p=
ci_dev *pdev, u8 index)
 	}
 }
=20
-static void __devinit dc390_init_hw(struct dc390_acb *pACB, u8 index)
+static void dc390_init_hw(struct dc390_acb *pACB, u8 index)
 {
 	struct Scsi_Host *shost =3D pACB->pScsiHost;
 	u8 dstate;
@@ -2422,7 +2422,7 @@ static void __devinit dc390_init_hw(struct dc390_=
acb *pACB, u8 index)
 	DC390_write8(DMA_Status, dstate);
 }
=20
-static int __devinit dc390_probe_one(struct pci_dev *pdev,
+static int dc390_probe_one(struct pci_dev *pdev,
 				    const struct pci_device_id *id)
 {
 	struct dc390_acb *pACB;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4a370f8..a79ff87 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1811,7 +1811,7 @@ static int ufshcd_set_dma_mask(struct ufs_hba *hb=
a)
  *
  * Returns 0 on success, non-zero value on failure
  */
-static int __devinit
+static int
 ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	struct Scsi_Host *host;
diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index f1c9481..98dcae3 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -677,7 +677,7 @@ out:
 	return err;
 }
=20
-static int __devinit virtscsi_probe(struct virtio_device *vdev)
+static int virtscsi_probe(struct virtio_device *vdev)
 {
 	struct Scsi_Host *shost;
 	struct virtio_scsi *vscsi;
diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
index 180bb7d..eafd88c 100644
--- a/drivers/scsi/vmw_pvscsi.c
+++ b/drivers/scsi/vmw_pvscsi.c
@@ -397,7 +397,7 @@ static void pvscsi_unmap_buffers(const struct pvscs=
i_adapter *adapter,
 				 SCSI_SENSE_BUFFERSIZE, PCI_DMA_FROMDEVICE);
 }
=20
-static int __devinit pvscsi_allocate_rings(struct pvscsi_adapter *adap=
ter)
+static int pvscsi_allocate_rings(struct pvscsi_adapter *adapter)
 {
 	adapter->rings_state =3D pci_alloc_consistent(adapter->dev, PAGE_SIZE=
,
 						    &adapter->ringStatePA);
@@ -1152,7 +1152,7 @@ static void pvscsi_release_resources(struct pvscs=
i_adapter *adapter)
  * just use a statically allocated scatter list.
  *
  */
-static int __devinit pvscsi_allocate_sg(struct pvscsi_adapter *adapter=
)
+static int pvscsi_allocate_sg(struct pvscsi_adapter *adapter)
 {
 	struct pvscsi_ctx *ctx;
 	int i;
@@ -1233,7 +1233,7 @@ exit:
 	return numPhys;
 }
=20
-static int __devinit pvscsi_probe(struct pci_dev *pdev,
+static int pvscsi_probe(struct pci_dev *pdev,
 				  const struct pci_device_id *id)
 {
 	struct pvscsi_adapter *adapter;
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 1ba2450..5520033 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -71,7 +71,7 @@ static struct zorro_device_id zorro7xx_zorro_tbl[] __=
devinitdata =3D {
 };
 MODULE_DEVICE_TABLE(zorro, zorro7xx_zorro_tbl);
=20
-static int __devinit zorro7xx_init_one(struct zorro_dev *z,
+static int zorro7xx_init_one(struct zorro_dev *z,
 				       const struct zorro_device_id *ent)
 {
 	struct Scsi_Host *host;
--=20
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
