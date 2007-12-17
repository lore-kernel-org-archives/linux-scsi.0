From: Joe Perches <joe@perches.com>
Subject: [PATCH] drivers/scsi/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:14 -0800
Message-ID: <1197920439-5455-8-git-send-email-joe@perches.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from DSL022.labridge.com ([206.117.136.22]:3187 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933866AbXLQTlE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2007 14:41:04 -0500
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918893.git.joe@perches.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Adaptec OEM Raid Solutions <aacraid@adaptec.com>, Andrew Vasquez <linux-driver@qlogic.com>, Brian King <brking@us.ibm.com>, Dave Jeffery <ipslinux@adaptec.com>, Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, James Smart <james.smart@emulex.com>, Mike Christie <michaelc@cs.wisc.edu>, Neela Syam Kolli <megaraidlinux@lsi.com>, linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/NCR53C9x.h               |    2 +-
 drivers/scsi/aic7xxx/aic79xx_inline.h |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c    |    2 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c    |    4 ++--
 drivers/scsi/aic7xxx/aic7xxx_inline.h |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c    |    2 +-
 drivers/scsi/ipr.c                    |    2 +-
 drivers/scsi/ips.c                    |    2 +-
 drivers/scsi/iscsi_tcp.c              |    4 ++--
 drivers/scsi/lpfc/lpfc.h              |    2 +-
 drivers/scsi/lpfc/lpfc_mbox.c         |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c |   10 +++++-----
 drivers/scsi/psi240i.c                |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c         |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h        |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c       |    2 +-
 drivers/scsi/scsi_tgt_lib.c           |    2 +-
 drivers/scsi/scsi_transport_sas.c     |    2 +-
 18 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/NCR53C9x.h b/drivers/scsi/NCR53C9x.h
index d85cb73..00a0ba0 100644
--- a/drivers/scsi/NCR53C9x.h
+++ b/drivers/scsi/NCR53C9x.h
@@ -1,6 +1,6 @@
 /* NCR53C9x.c:  Defines and structures for the NCR53C9x generic driver.
  *
- * Originaly esp.h:  Defines and structures for the Sparc ESP 
+ * Originally esp.h:  Defines and structures for the Sparc ESP 
  *                   (Enhanced SCSI Processor) driver under Linux.
  *
  * Copyright (C) 1995 David S. Miller (davem@caip.rutgers.edu)
diff --git a/drivers/scsi/aic7xxx/aic79xx_inline.h b/drivers/scsi/aic7xxx/aic79xx_inline.h
index 2ceb67f..45e5557 100644
--- a/drivers/scsi/aic7xxx/aic79xx_inline.h
+++ b/drivers/scsi/aic7xxx/aic79xx_inline.h
@@ -417,7 +417,7 @@ ahd_targetcmd_offset(struct ahd_softc *ahd, u_int index)
 	       - (uint8_t *)ahd->qoutfifo);
 }
 
-/*********************** Miscelaneous Support Functions ***********************/
+/*********************** Miscellaneous Support Functions ***********************/
 static __inline struct ahd_initiator_tinfo *
 			ahd_fetch_transinfo(struct ahd_softc *ahd,
 					    char channel, u_int our_id,
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 2d02040..500b0b7 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -325,7 +325,7 @@ MODULE_PARM_DESC(aic79xx,
 "	verbose			Enable verbose/diagnostic logging\n"
 "	allow_memio		Allow device registers to be memory mapped\n"
 "	debug			Bitmask of debug values to enable\n"
-"	no_reset		Supress initial bus resets\n"
+"	no_reset		Suppress initial bus resets\n"
 "	extended		Enable extended geometry on all controllers\n"
 "	periodic_otag		Send an ordered tagged transaction\n"
 "				periodically to prevent tag starvation.\n"
diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 7a203a9..dd71995 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -977,7 +977,7 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 			  |  AHD_FAINT_LED_BUG;
 
 		/*
-		 * IO Cell paramter setup.
+		 * IO Cell parameter setup.
 		 */
 		AHD_SET_PRECOMP(ahd, AHD_PRECOMP_CUTBACK_29);
 
@@ -1004,7 +1004,7 @@ ahd_aic790X_setup(struct ahd_softc *ahd)
 			ahd->bugs |= AHD_INTCOLLISION_BUG|AHD_ABORT_LQI_BUG;
 
 		/*
-		 * IO Cell paramter setup.
+		 * IO Cell parameter setup.
 		 */
 		AHD_SET_PRECOMP(ahd, AHD_PRECOMP_CUTBACK_29);
 		AHD_SET_SLEWRATE(ahd, AHD_SLEWRATE_DEF_REVB);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_inline.h b/drivers/scsi/aic7xxx/aic7xxx_inline.h
index 8e1954c..cba2f23 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_inline.h
+++ b/drivers/scsi/aic7xxx/aic7xxx_inline.h
@@ -229,7 +229,7 @@ ahc_name(struct ahc_softc *ahc)
 	return (ahc->name);
 }
 
-/*********************** Miscelaneous Support Functions ***********************/
+/*********************** Miscellaneous Support Functions ***********************/
 
 static __inline void	ahc_update_residual(struct ahc_softc *ahc,
 					    struct scb *scb);
diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
index 390b0fc..50058e8 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
@@ -347,7 +347,7 @@ MODULE_PARM_DESC(aic7xxx,
 "	debug			Bitmask of debug values to enable\n"
 "	no_probe		Toggle EISA/VLB controller probing\n"
 "	probe_eisa_vl		Toggle EISA/VLB controller probing\n"
-"	no_reset		Supress initial bus resets\n"
+"	no_reset		Suppress initial bus resets\n"
 "	extended		Enable extended geometry on all controllers\n"
 "	periodic_otag		Send an ordered tagged transaction\n"
 "				periodically to prevent tag starvation.\n"
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0841df0..df6f8c9 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -7052,7 +7052,7 @@ static pci_ers_result_t ipr_pci_error_detected(struct pci_dev *pdev,
  * where it can accept new commands.
 
  * Return value:
- * 	0 on sucess / -EIO on failure
+ * 	0 on success / -EIO on failure
  **/
 static int __devinit ipr_probe_ioa_part2(struct ipr_ioa_cfg *ioa_cfg)
 {
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 5c5a9b2..901e14b 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1313,7 +1313,7 @@ ips_intr_copperhead(ips_ha_t * ha)
 			cstatus.value = (*ha->func.statupd) (ha);
 
 		if (cstatus.fields.command_id > (IPS_MAX_CMDS - 1)) {
-			/* Spurious Interupt ? */
+			/* Spurious Interrupt ? */
 			continue;
 		}
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 57ce225..3cc21f5 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1121,7 +1121,7 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
  * iscsi_sendhdr - send PDU Header via tcp_sendpage()
  * @conn: iscsi connection
  * @buf: buffer to write from
- * @datalen: lenght of data to be sent after the header
+ * @datalen: length of data to be sent after the header
  *
  * Notes:
  *	(Tx, Fast Path)
@@ -1724,7 +1724,7 @@ send_hdr:
  *	XMSTATE_BIT_SOL_DATA     - send solicit data
  *
  *iscsi_tcp_ctask_xmit
- *	XMSTATE_BIT_IMM_DATA     - xmit managment data (??)
+ *	XMSTATE_BIT_IMM_DATA     - xmit management data (??)
  **/
 static int
 iscsi_tcp_ctask_xmit(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
diff --git a/drivers/scsi/lpfc/lpfc.h b/drivers/scsi/lpfc/lpfc.h
index ba3ecab..29971ab 100644
--- a/drivers/scsi/lpfc/lpfc.h
+++ b/drivers/scsi/lpfc/lpfc.h
@@ -317,7 +317,7 @@ struct lpfc_vport {
 
 #define WORKER_MBOX_TMO                0x100	/* hba: MBOX timeout */
 #define WORKER_HB_TMO                  0x200	/* hba: Heart beat timeout */
-#define WORKER_FABRIC_BLOCK_TMO        0x400	/* hba: fabric block timout */
+#define WORKER_FABRIC_BLOCK_TMO        0x400	/* hba: fabric block timeout */
 #define WORKER_RAMP_DOWN_QUEUE         0x800	/* hba: Decrease Q depth */
 #define WORKER_RAMP_UP_QUEUE           0x1000	/* hba: Increase Q depth */
 
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index a592733..43f894e 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -858,7 +858,7 @@ lpfc_mbox_get(struct lpfc_hba * phba)
 void
 lpfc_mbox_cmpl_put(struct lpfc_hba * phba, LPFC_MBOXQ_t * mbq)
 {
-	/* This function expects to be called from interupt context */
+	/* This function expects to be called from interrupt context */
 	spin_lock(&phba->hbalock);
 	list_add_tail(&mbq->list, &phba->sli.mboxq_cmpl);
 	spin_unlock(&phba->hbalock);
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index c892310..7117087 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -3465,12 +3465,12 @@ megaraid_mbox_setup_device_map(adapter_t *adapter)
 /*
  * START: Interface for the common management module
  *
- * This is the module, which interfaces with the common mangement module to
+ * This is the module, which interfaces with the common management module to
  * provide support for ioctl and sysfs
  */
 
 /**
- * megaraid_cmm_register - register with the mangement module
+ * megaraid_cmm_register - register with the management module
  * @adapter		: HBA soft state
  *
  * Register with the management module, which allows applications to issue
@@ -3558,7 +3558,7 @@ megaraid_cmm_register(adapter_t *adapter)
 
 
 /**
- * megaraid_cmm_unregister - un-register with the mangement module
+ * megaraid_cmm_unregister - un-register with the management module
  * @adapter		: HBA soft state
  *
  * Un-register with the management module.
@@ -3580,7 +3580,7 @@ megaraid_cmm_unregister(adapter_t *adapter)
  * @kioc		: CMM interface packet
  * @action		: command action
  *
- * This routine is invoked whenever the Common Mangement Module (CMM) has a
+ * This routine is invoked whenever the Common Management Module (CMM) has a
  * command for us. The 'action' parameter specifies if this is a new command
  * or otherwise.
  */
@@ -3945,7 +3945,7 @@ megaraid_sysfs_get_ldmap_timeout(unsigned long data)
  *
  * This routine will be called whenever user reads the logical drive
  * attributes, go get the current logical drive mapping table from the
- * firmware. We use the managment API's to issue commands to the controller.
+ * firmware. We use the management API's to issue commands to the controller.
  *
  * NOTE: The commands issuance functionality is not generalized and
  * implemented in context of "get ld map" command only. If required, the
diff --git a/drivers/scsi/psi240i.c b/drivers/scsi/psi240i.c
index 899e89d..3a8489c 100644
--- a/drivers/scsi/psi240i.c
+++ b/drivers/scsi/psi240i.c
@@ -507,7 +507,7 @@ static int Psi240i_QueueCommand(struct scsi_cmnd *SCpnt,
  *
  *	Parameters:		psetup	- Pointer to memory image of setup information.
  *					base	- base address of memory.
- *					length	- lenght of data space in bytes.
+ *					length	- length of data space in bytes.
  *					port	- I/O address of data port.
  *
  *	Returns:		Nothing.
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index eb0784c..6226d88 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1094,7 +1094,7 @@ qla2x00_sns_rnn_id(scsi_qla_host_t *ha)
 }
 
 /**
- * qla2x00_mgmt_svr_login() - Login to fabric Managment Service.
+ * qla2x00_mgmt_svr_login() - Login to fabric Management Service.
  * @ha: HA context
  *
  * Returns 0 on success.
diff --git a/drivers/scsi/qla4xxx/ql4_def.h b/drivers/scsi/qla4xxx/ql4_def.h
index accaf69..d6be076 100644
--- a/drivers/scsi/qla4xxx/ql4_def.h
+++ b/drivers/scsi/qla4xxx/ql4_def.h
@@ -121,7 +121,7 @@
 #define MAX_REQS_SERVICED_PER_INTR	16
 
 #define ISCSI_IPADDR_SIZE		4	/* IP address size */
-#define ISCSI_ALIAS_SIZE		32	/* ISCSI Alais name size */
+#define ISCSI_ALIAS_SIZE		32	/* ISCSI Alias name size */
 #define ISCSI_NAME_SIZE			0xE0	/* ISCSI Name size */
 
 #define LSDW(x) ((u32)((u64)(x)))
diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index d692c71..8e7dd55 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1097,7 +1097,7 @@ static int qla4xxx_start_firmware(struct scsi_qla_host *ha)
 		}
 		config_chip = 1;
 
-		/* Reset clears the semaphore, so aquire again */
+		/* Reset clears the semaphore, so acquire again */
 		if (ql4xxx_lock_drvr_wait(ha) != QLA_SUCCESS)
 			return QLA_ERROR;
 	}
diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index a91761c..1085c92 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -320,7 +320,7 @@ int scsi_tgt_queue_command(struct scsi_cmnd *cmd, u64 itn_id,
 EXPORT_SYMBOL_GPL(scsi_tgt_queue_command);
 
 /*
- * This is run from a interrpt handler normally and the unmap
+ * This is run from a interrupt handler normally and the unmap
  * needs process context so we must queue
  */
 static void scsi_tgt_cmd_done(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index 3120f4b..64d0fe5 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -6,7 +6,7 @@
  *
  * The SAS transport class contains common code to deal with SAS HBAs,
  * an aproximated representation of SAS topologies in the driver model,
- * and various sysfs attributes to expose these topologies and managment
+ * and various sysfs attributes to expose these topologies and management
  * interfaces to userspace.
  *
  * In addition to the basic SCSI core objects this transport class
-- 
1.5.3.7.949.g2221a6

