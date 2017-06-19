From: Minwoo Im <dn3108@gmail.com>
Subject: [PATCH] mpt3sas: Fix error "space prohibited before that ','"
Date: Mon, 19 Jun 2017 23:00:53 +0900
Message-ID: <1497880853-5393-1-git-send-email-dn3108@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:35110 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdFSOB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Jun 2017 10:01:27 -0400
Received: by mail-pg0-f65.google.com with SMTP id f127so16105457pgc.2
        for <linux-scsi@vger.kernel.org>; Mon, 19 Jun 2017 07:01:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, Minwoo Im <dn3108@gmail.com>

It will fix the following error from checkpatch.pl.
ERROR: space prohibited before that ','

Signed-off-by: Minwoo Im <dn3108@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c         |   18 +++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c          |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c        |    2 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c    |    4 ++--
 drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c |    6 +++---
 5 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 18039bb..45ef957 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -307,7 +307,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
  * Return nothing.
  */
 void
-mpt3sas_base_fault_info(struct MPT3SAS_ADAPTER *ioc , u16 fault_code)
+mpt3sas_base_fault_info(struct MPT3SAS_ADAPTER *ioc, u16 fault_code)
 {
 	pr_err(MPT3SAS_FMT "fault_state(0x%04x)!\n",
 	    ioc->name, fault_code);
@@ -334,7 +334,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 
 	doorbell = readl(&ioc->chip->Doorbell);
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT)
-		mpt3sas_base_fault_info(ioc , doorbell);
+		mpt3sas_base_fault_info(ioc, doorbell);
 	else {
 		writel(0xC0FFEE00, &ioc->chip->Doorbell);
 		pr_err(MPT3SAS_FMT "Firmware is halted due to command timeout\n",
@@ -673,7 +673,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
  * Return nothing.
  */
 static void
-_base_sas_log_info(struct MPT3SAS_ADAPTER *ioc , u32 log_info)
+_base_sas_log_info(struct MPT3SAS_ADAPTER *ioc, u32 log_info)
 {
 	union loginfo_type {
 		u32	loginfo;
@@ -749,7 +749,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 
 	if ((ioc_status & MPI2_IOCSTATUS_MASK) &&
 	    (ioc->logging_level & MPT_DEBUG_REPLY)) {
-		_base_sas_ioc_info(ioc , mpi_reply,
+		_base_sas_ioc_info(ioc, mpi_reply,
 		   mpt3sas_base_get_msg_frame(ioc, smid));
 	}
 
@@ -3586,7 +3586,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	}
 	for (i = 0; i < ioc->chain_depth; i++) {
 		ioc->chain_lookup[i].chain_buffer = pci_pool_alloc(
-		    ioc->chain_dma_pool , GFP_KERNEL,
+		    ioc->chain_dma_pool, GFP_KERNEL,
 		    &ioc->chain_lookup[i].chain_buffer_dma);
 		if (!ioc->chain_lookup[i].chain_buffer) {
 			ioc->chain_depth = i;
@@ -3637,7 +3637,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		    ioc->name);
 		goto out;
 	}
-	ioc->sense = pci_pool_alloc(ioc->sense_dma_pool , GFP_KERNEL,
+	ioc->sense = pci_pool_alloc(ioc->sense_dma_pool, GFP_KERNEL,
 	    &ioc->sense_dma);
 	if (!ioc->sense) {
 		pr_err(MPT3SAS_FMT "sense pool: pci_pool_alloc failed\n",
@@ -3661,7 +3661,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		    ioc->name);
 		goto out;
 	}
-	ioc->reply = pci_pool_alloc(ioc->reply_dma_pool , GFP_KERNEL,
+	ioc->reply = pci_pool_alloc(ioc->reply_dma_pool, GFP_KERNEL,
 	    &ioc->reply_dma);
 	if (!ioc->reply) {
 		pr_err(MPT3SAS_FMT "reply pool: pci_pool_alloc failed\n",
@@ -3687,7 +3687,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 			ioc->name);
 		goto out;
 	}
-	ioc->reply_free = pci_pool_alloc(ioc->reply_free_dma_pool , GFP_KERNEL,
+	ioc->reply_free = pci_pool_alloc(ioc->reply_free_dma_pool, GFP_KERNEL,
 	    &ioc->reply_free_dma);
 	if (!ioc->reply_free) {
 		pr_err(MPT3SAS_FMT "reply_free pool: pci_pool_alloc failed\n",
@@ -3877,7 +3877,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 			doorbell = readl(&ioc->chip->Doorbell);
 			if ((doorbell & MPI2_IOC_STATE_MASK) ==
 			    MPI2_IOC_STATE_FAULT) {
-				mpt3sas_base_fault_info(ioc , doorbell);
+				mpt3sas_base_fault_info(ioc, doorbell);
 				return -EFAULT;
 			}
 		} else if (int_status == 0xFFFFFFFF)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index bdffb69..72af956 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -1074,7 +1074,7 @@ enum block_state {
 	dctlprintk(ioc, pr_info(MPT3SAS_FMT "%s: enter\n", ioc->name,
 	    __func__));
 
-	memset(&karg, 0 , sizeof(karg));
+	memset(&karg, 0, sizeof(karg));
 	if (ioc->pfacts)
 		karg.port_number = ioc->pfacts[0].PortNumber;
 	karg.hw_rev = ioc->pdev->revision;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index a5d8726..57bbaef 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4883,7 +4883,7 @@ static int _scsih_set_satl_pending(struct scsi_cmnd *scmd, bool pending)
 	}
 
 	if (scmd->result && (ioc->logging_level & MPT_DEBUG_REPLY))
-		_scsih_scsi_ioc_info(ioc , scmd, mpi_reply, smid);
+		_scsih_scsi_ioc_info(ioc, scmd, mpi_reply, smid);
 
  out:
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_transport.c b/drivers/scsi/mpt3sas/mpt3sas_transport.c
index e7a7a70..5400656 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_transport.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_transport.c
@@ -831,7 +831,7 @@ struct _sas_port *
 
 	for (i = 0; i < sas_node->num_phys; i++) {
 		if (sas_node->phy[i].remote_identify.sas_address == sas_address)
-			memset(&sas_node->phy[i].remote_identify, 0 ,
+			memset(&sas_node->phy[i].remote_identify, 0,
 			    sizeof(struct sas_identify));
 	}
 
@@ -1027,7 +1027,7 @@ struct _sas_port *
 		_transport_add_phy_to_an_existing_port(ioc, sas_node,
 		    mpt3sas_phy, mpt3sas_phy->remote_identify.sas_address);
 	} else
-		memset(&mpt3sas_phy->remote_identify, 0 , sizeof(struct
+		memset(&mpt3sas_phy->remote_identify, 0, sizeof(struct
 		    sas_identify));
 
 	if (mpt3sas_phy->phy)
diff --git a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
index b60fd7a..205be9d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_trigger_diag.c
@@ -251,7 +251,7 @@
 
 	/* check for the trigger condition */
 	event_trigger = ioc->diag_trigger_event.EventTriggerEntry;
-	for (i = 0 , found_match = 0; i < ioc->diag_trigger_event.ValidEntries
+	for (i = 0, found_match = 0; i < ioc->diag_trigger_event.ValidEntries
 	    && !found_match; i++, event_trigger++) {
 		if (event_trigger->EventValue != event)
 			continue;
@@ -331,7 +331,7 @@
 
 	/* check for the trigger condition */
 	scsi_trigger = ioc->diag_trigger_scsi.SCSITriggerEntry;
-	for (i = 0 , found_match = 0; i < ioc->diag_trigger_scsi.ValidEntries
+	for (i = 0, found_match = 0; i < ioc->diag_trigger_scsi.ValidEntries
 	    && !found_match; i++, scsi_trigger++) {
 		if (scsi_trigger->SenseKey != sense_key)
 			continue;
@@ -405,7 +405,7 @@
 
 	/* check for the trigger condition */
 	mpi_trigger = ioc->diag_trigger_mpi.MPITriggerEntry;
-	for (i = 0 , found_match = 0; i < ioc->diag_trigger_mpi.ValidEntries
+	for (i = 0, found_match = 0; i < ioc->diag_trigger_mpi.ValidEntries
 	    && !found_match; i++, mpi_trigger++) {
 		if (mpi_trigger->IOCStatus != ioc_status)
 			continue;
-- 
1.7.9.5
