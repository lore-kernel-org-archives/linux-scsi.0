From: "Anil Veerabhadrappa" <anilgv@broadcom.com>
Subject: [PATCH 5/5] BNX2I - minor code cleanup and update driver
 version
Date: Mon, 7 Dec 2009 11:40:39 -0800
Message-ID: <1260214839.31468.100.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3577 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932721AbZLGTke (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Dec 2009 14:40:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com, michaelc@cs.wisc.edu, mchan@broadcom.com, poswald@novell.com


    * Removed duplicate function call and not-so-useful comment line

Signed-off-by: Anil Veerabhadrappa <anilgv@broadcom.com>
---
 drivers/scsi/bnx2i/bnx2i_init.c  |    4 ++--
 drivers/scsi/bnx2i/bnx2i_iscsi.c |    2 --
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/bnx2i/bnx2i_init.c b/drivers/scsi/bnx2i/bnx2i_init.c
index ad551c5..1e111ac 100644
--- a/drivers/scsi/bnx2i/bnx2i_init.c
+++ b/drivers/scsi/bnx2i/bnx2i_init.c
@@ -17,8 +17,8 @@ static struct list_head adapter_list = LIST_HEAD_INIT(adapter_list);
 static u32 adapter_count;
 
 #define DRV_MODULE_NAME		"bnx2i"
-#define DRV_MODULE_VERSION	"2.0.1e"
-#define DRV_MODULE_RELDATE	"June 22, 2009"
+#define DRV_MODULE_VERSION	"2.1.0"
+#define DRV_MODULE_RELDATE	"Dec 06, 2009"
 
 static char version[] __devinitdata =
 		"Broadcom NetXtreme II iSCSI Driver " DRV_MODULE_NAME \
diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
index 070118a..54dc251 100644
--- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
+++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
@@ -485,7 +485,6 @@ static int bnx2i_setup_cmd_pool(struct bnx2i_hba *hba,
 		struct iscsi_task *task = session->cmds[i];
 		struct bnx2i_cmd *cmd = task->dd_data;
 
-		/* Anil */
 		task->hdr = &cmd->hdr;
 		task->hdr_max = sizeof(struct iscsi_hdr);
 
@@ -765,7 +764,6 @@ struct bnx2i_hba *bnx2i_alloc_hba(struct cnic_dev *cnic)
 	hba->pci_svid = hba->pcidev->subsystem_vendor;
 	hba->pci_func = PCI_FUNC(hba->pcidev->devfn);
 	hba->pci_devno = PCI_SLOT(hba->pcidev->devfn);
-	bnx2i_identify_device(hba);
 
 	bnx2i_identify_device(hba);
 	bnx2i_setup_host_queue_size(hba, shost);
-- 
1.6.5.1




