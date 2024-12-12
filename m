Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01AB13541B;
	Thu, 12 Dec 2024 02:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969674; cv=none; b=pGtsQveaBJUV6EZM4lJZq/sebfCfxxYsSJSFN00/Oyma+/38ark8LbtUZreodO65Bpl/+Tfdy7dXZ+v+2NNqspjW6CfJk0hEUFF7NfcUkBq+BxCeLslLfQkSDPA7Q8792iKBp/ZgQg/VHwG4+77qO5w8i2nemkPXNAWIHpGOmPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969674; c=relaxed/simple;
	bh=w0WMhjFqNAFJyavqdq/hg78vpzWuy58cf5VwdmmwAUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfjzqbA9Appbx4FCJlNEF94FZc5KGQ/RfuCAvcHCXT90vFr8+xOZ4kWj4zldRHpKRe2qbZXAjjtx2ewP1kce5vGcb2C09f883llQ9aULvHfKzz2C4dqkwFZiVTFRklx8X+OVKEb0+dT+AcwP4AVicOozwOC/BR1tBUw0pIfcoGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=FuErgj8j; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="FuErgj8j"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=10884; q=dns/txt;
  s=iport; t=1733969672; x=1735179272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mIs6aiEKsC5J/j4IxgWiNQ+9Gwp4DNUOxbC1gWuDQGg=;
  b=FuErgj8jRMYcrR2lEKPG5BuYLmgMoIzuN4kKOkohhbRfDz2GjbvBIlh9
   oQbXW6tqqQ4WgJzXvb6l39uUVo7HvAZKx7TkxKGAammQ+1NRf2PbAZegd
   G5Lne2W/4YlZEi0bNcS2wf0tZMCaIAXcZ7hxTtVzLkU1BgZSZ+CPrBbTn
   Q=;
X-CSE-ConnectionGUID: EN93FQinQn6XczWeVDer6A==
X-CSE-MsgGUID: OiR7uWWwQmifmXMtk5BluQ==
X-IPAS-Result: =?us-ascii?q?A0A8AACHRlpn/5T/Ja1aHQEBAQEJARIBBQUBgX8IAQsBg?=
 =?us-ascii?q?hsvgU9DGS+McolRnhsUgREDVg8BAQEPRAQBAYUHAoprAiY0CQ4BAgQBAQEBA?=
 =?us-ascii?q?wIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCAQMnCwFGEFFWGYIpW?=
 =?us-ascii?q?IJlA68UgXkzgQHeM4FtgUgBjUlwhHcnFQaBSUSBFYE7gT5vgVKCWIZdBII8h?=
 =?us-ascii?q?mCdAEiBIQNZIREBVRMNCgsHBYF1AzkMCzEVg2BGPYJJaUk3Ag0CNoIkfIJNh?=
 =?us-ascii?q?RmEaWMvAwMDA4M5hiSCGYFfQAMLGA1IESw3FBsGPm4Hm0tGg2ABexSBeEYBH?=
 =?us-ascii?q?gEKOpJdB0eRX4E0n06EJKFEGjOqUZh7pESEZoFnPIFZMxoIGxU7gmdSGQ+OL?=
 =?us-ascii?q?RbEDyUyPAIHCwEBAwmRTwEB?=
IronPort-Data: A9a23:A+v3i6DvP+EFLxVW/zjiw5YqxClBgxIJ4kV8jS/XYbTApGsihmEAx
 zYeXmvTO6zZYmLwfd8nOdmx/EkCsZOBydZnOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZsCCeB/n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357gWWthh
 fuo+5eDYQX8gmYpWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TE7tM/V28PPIsh/LhHCnNx+
 MI0JSpTR0XW7w626OrTpuhEnM8vKozveYgYoHwllGifBvc9SpeFSKLPjTNa9G5v3YYVQrCEO
 pdfMGY/BPjDS0Un1lM/C5skgOasj3rXeDxDo1XTrq0yi4TW5FYhieCwYIqNJ7RmQ+1yn3zHu
 1354F38Ax8fBPmDymev9m+V07qncSTTHdh6+KeD3vxngle7wm0VFQ1QVFG+5/K+jyaWXttFN
 00SvDIjsaUo70GtZt7nVha8rTiPuRt0c95RFfAqrQKA0KzZ5y6HCWUeCD1MctorsIkxXzNC/
 luImc75QCdkq7y9V32Q7PGXoCm0NCxTKnUNDRLoViMf6NXl5YV2hRXVQ5M6Sei+j8b+Hnf7x
 DXiQDUCuoj/RPUjj82TlW0rSRr1znQVZmbZPjnqY18=
IronPort-HdrOrdr: A9a23:mtGbbKOiN54Yu8BcTu6jsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVbSO09QYVcemsAJsQiTtENg==
X-Talos-CUID: =?us-ascii?q?9a23=3A9nGEBGs6uFd60J/+6E57L8YB6IsIVCyG4k7RJXa?=
 =?us-ascii?q?+V1ZiWoKYd3Od4v1Nxp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AzoIFjw3v7R1pMWxE1P/PyK9XUTUjxKWUV10yroo?=
 =?us-ascii?q?/vsiKMBxVJzTApjCqe9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,227,1728950400"; 
   d="scan'208";a="281058805"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Dec 2024 02:14:31 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id 7DA2A18000259;
	Thu, 12 Dec 2024 02:14:30 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	aeasi@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v7 14/15] scsi: fnic: Add support to handle port channel RSCN
Date: Wed, 11 Dec 2024 18:03:11 -0800
Message-ID: <20241212020312.4786-15-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241212020312.4786-1-kartilak@cisco.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-11.cisco.com

Add support to handle port channel RSCN.

Port channel RSCN is a Cisco vendor specific RSCN
event. It is applicable only to Cisco UCS fabrics.
If there's a change in the port channel configuration,
an RCSN is sent to fnic. This is used to serially
reset the scsi initiator fnics so that there's no
all paths down scenario. The affected fnics are added
to a list that are reset with a small time gap
between them.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v2 and v3:
    Incorporate review comments from Hannes from other patches:
        Replace redundant definitions with standard definitions.

Changes between v1 and v2:
    Replace pr_err with printk.
    Incorporate review comments from Hannes from other patches:
        Replace pr_err with dev_err.
---
 drivers/scsi/fnic/fdls_disc.c | 56 +++++++++++++++++++++++++++++------
 drivers/scsi/fnic/fnic.h      | 25 ++++++++++++++++
 drivers/scsi/fnic/fnic_fcs.c  | 36 ++++++++++++++++++++++
 drivers/scsi/fnic/fnic_main.c | 30 +++++++++++++++++++
 4 files changed, 138 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 7eb6ac28a0d0..229808e78ba0 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -4405,6 +4405,9 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	int newports = 0;
 	struct fnic_fdls_fabric_s *fdls = &iport->fabric;
 	struct fnic *fnic = iport->fnic;
+	int rscn_type = NOT_PC_RSCN;
+	uint32_t sid = ntoh24(fchdr->fh_s_id);
+	unsigned long reset_fnic_list_lock_flags = 0;
 	uint16_t rscn_payload_len;
 
 	atomic64_inc(&iport->iport_stats.num_rscns);
@@ -4427,16 +4430,24 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 	    || (rscn_payload_len > 1024)
 	    || (rscn->els.rscn_page_len != 4)) {
 		num_ports = 0;
-		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+		if ((rscn_payload_len == 0xFFFF)
+		    && (sid == FC_FID_FCTRL)) {
+			rscn_type = PC_RSCN;
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				     "pcrscn: PCRSCN received. sid: 0x%x payload len: 0x%x",
+				     sid, rscn_payload_len);
+		} else {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 					 "RSCN payload_len: 0x%x page_len: 0x%x",
 				     rscn_payload_len, rscn->els.rscn_page_len);
-		/* if this happens then we need to send ADISC to all the tports. */
-		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
-			if (tport->state == FDLS_TGT_STATE_READY)
-				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
-			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-				 "RSCN for port id: 0x%x", tport->fcid);
-		}
+			/* if this happens then we need to send ADISC to all the tports. */
+			list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+				if (tport->state == FDLS_TGT_STATE_READY)
+					tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					 "RSCN for port id: 0x%x", tport->fcid);
+			}
+		} /* end else */
 	} else {
 		num_ports = (rscn_payload_len - 4) / rscn->els.rscn_page_len;
 		rscn_port = (struct fc_els_rscn_page *)(rscn + 1);
@@ -4483,10 +4494,37 @@ fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
 			tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
 	}
 
-	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+	if (pc_rscn_handling_feature_flag == PC_RSCN_HANDLING_FEATURE_ON &&
+		rscn_type == PC_RSCN && fnic->role == FNIC_ROLE_FCP_INITIATOR) {
+
+		if (fnic->pc_rscn_handling_status == PC_RSCN_HANDLING_IN_PROGRESS) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "PCRSCN handling already in progress. Skip host reset: %d",
+				 iport->fnic->fnic_num);
+			return;
+		}
+
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "Processing PCRSCN. Queuing fnic for host reset: %d",
+			 iport->fnic->fnic_num);
+		fnic->pc_rscn_handling_status = PC_RSCN_HANDLING_IN_PROGRESS;
+
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+
+		spin_lock_irqsave(&reset_fnic_list_lock,
+						  reset_fnic_list_lock_flags);
+		list_add_tail(&fnic->links, &reset_fnic_list);
+		spin_unlock_irqrestore(&reset_fnic_list_lock,
+							   reset_fnic_list_lock_flags);
+
+		queue_work(reset_fnic_work_queue, &reset_fnic_work);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	} else {
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		 "FDLS process RSCN sending GPN_FT: newports: %d", newports);
 		fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
 		fdls_send_rscn_resp(iport, fchdr);
+	}
 }
 
 void fnic_fdls_disc_start(struct fnic_iport_s *iport)
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index b02459b6ec2f..b9b0a4f0b78c 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -211,11 +211,33 @@ enum reset_states {
 	RESET_ERROR
 };
 
+enum rscn_type {
+	NOT_PC_RSCN = 0,
+	PC_RSCN
+};
+
+enum pc_rscn_handling_status {
+	PC_RSCN_HANDLING_NOT_IN_PROGRESS = 0,
+	PC_RSCN_HANDLING_IN_PROGRESS
+};
+
+enum pc_rscn_handling_feature {
+	PC_RSCN_HANDLING_FEATURE_OFF = 0,
+	PC_RSCN_HANDLING_FEATURE_ON
+};
+
 extern unsigned int fnic_fdmi_support;
 extern unsigned int fnic_log_level;
 extern unsigned int io_completions;
 extern struct workqueue_struct *fnic_event_queue;
 
+extern unsigned int pc_rscn_handling_feature_flag;
+extern spinlock_t reset_fnic_list_lock;
+extern struct list_head reset_fnic_list;
+extern struct workqueue_struct *reset_fnic_work_queue;
+extern struct work_struct reset_fnic_work;
+
+
 #define FNIC_MAIN_LOGGING 0x01
 #define FNIC_FCS_LOGGING 0x02
 #define FNIC_SCSI_LOGGING 0x04
@@ -396,6 +418,7 @@ struct fnic {
 	int link_status;
 
 	struct list_head list;
+	struct list_head links;
 	struct pci_dev *pdev;
 	struct vnic_fc_config config;
 	struct vnic_dev *vdev;
@@ -424,6 +447,7 @@ struct fnic {
 
 	char subsys_desc[14];
 	int subsys_desc_len;
+	int pc_rscn_handling_status;
 
 	/*** FIP related data members  -- start ***/
 	void (*set_vlan)(struct fnic *, u16 vlan);
@@ -508,6 +532,7 @@ void fnic_stats_debugfs_remove(struct fnic *fnic);
 int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
 
 void fnic_handle_fip_frame(struct work_struct *work);
+void fnic_reset_work_handler(struct work_struct *work);
 void fnic_handle_fip_event(struct fnic *fnic);
 void fnic_fcoe_reset_vlans(struct fnic *fnic);
 extern void fnic_handle_fip_timer(struct timer_list *t);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 086b92578624..471d4a7553bf 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1071,3 +1071,39 @@ void fnic_flush_tport_event_list(struct fnic *fnic)
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
+
+void fnic_reset_work_handler(struct work_struct *work)
+{
+	struct fnic *cur_fnic, *next_fnic;
+	unsigned long reset_fnic_list_lock_flags;
+	int host_reset_ret_code;
+
+	/*
+	 * This is a single thread. It is per fnic module, not per fnic
+	 * All the fnics that need to be reset
+	 * have been serialized via the reset fnic list.
+	 */
+	spin_lock_irqsave(&reset_fnic_list_lock, reset_fnic_list_lock_flags);
+	list_for_each_entry_safe(cur_fnic, next_fnic, &reset_fnic_list, links) {
+		list_del(&cur_fnic->links);
+		spin_unlock_irqrestore(&reset_fnic_list_lock,
+							   reset_fnic_list_lock_flags);
+
+		dev_err(&cur_fnic->pdev->dev, "fnic: <%d>: issuing a host reset\n",
+			   cur_fnic->fnic_num);
+		host_reset_ret_code = fnic_host_reset(cur_fnic->host);
+		dev_err(&cur_fnic->pdev->dev,
+		   "fnic: <%d>: returned from host reset with status: %d\n",
+		   cur_fnic->fnic_num, host_reset_ret_code);
+
+		spin_lock_irqsave(&cur_fnic->fnic_lock, cur_fnic->lock_flags);
+		cur_fnic->pc_rscn_handling_status =
+			PC_RSCN_HANDLING_NOT_IN_PROGRESS;
+		spin_unlock_irqrestore(&cur_fnic->fnic_lock, cur_fnic->lock_flags);
+
+		spin_lock_irqsave(&reset_fnic_list_lock,
+						  reset_fnic_list_lock_flags);
+	}
+	spin_unlock_irqrestore(&reset_fnic_list_lock,
+						   reset_fnic_list_lock_flags);
+}
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index fe8816feb247..40ed6b2490e2 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -45,6 +45,10 @@ static LIST_HEAD(fnic_list);
 static DEFINE_SPINLOCK(fnic_list_lock);
 static DEFINE_IDA(fnic_ida);
 
+struct work_struct reset_fnic_work;
+LIST_HEAD(reset_fnic_list);
+DEFINE_SPINLOCK(reset_fnic_list_lock);
+
 /* Supported devices by fnic module */
 static struct pci_device_id fnic_id_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_CISCO, PCI_DEVICE_ID_CISCO_FNIC) },
@@ -89,6 +93,12 @@ static unsigned int fnic_max_qdepth = FNIC_DFLT_QUEUE_DEPTH;
 module_param(fnic_max_qdepth, uint, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(fnic_max_qdepth, "Queue depth to report for each LUN");
 
+unsigned int pc_rscn_handling_feature_flag = PC_RSCN_HANDLING_FEATURE_ON;
+module_param(pc_rscn_handling_feature_flag, uint, 0644);
+MODULE_PARM_DESC(pc_rscn_handling_feature_flag,
+		 "PCRSCN handling (0 for none. 1 to handle PCRSCN (default))");
+
+struct workqueue_struct *reset_fnic_work_queue;
 struct workqueue_struct *fnic_fip_queue;
 
 static int fnic_slave_alloc(struct scsi_device *sdev)
@@ -1275,6 +1285,19 @@ static int __init fnic_init_module(void)
 		goto err_create_fip_workq;
 	}
 
+	if (pc_rscn_handling_feature_flag == PC_RSCN_HANDLING_FEATURE_ON) {
+		reset_fnic_work_queue =
+			create_singlethread_workqueue("reset_fnic_work_queue");
+		if (!reset_fnic_work_queue) {
+			pr_err("reset fnic work queue create failed\n");
+			err = -ENOMEM;
+			goto err_create_reset_fnic_workq;
+		}
+		spin_lock_init(&reset_fnic_list_lock);
+		INIT_LIST_HEAD(&reset_fnic_list);
+		INIT_WORK(&reset_fnic_work, fnic_reset_work_handler);
+	}
+
 	fnic_fc_transport = fc_attach_transport(&fnic_fc_functions);
 	if (!fnic_fc_transport) {
 		printk(KERN_ERR PFX "fc_attach_transport error\n");
@@ -1295,6 +1318,9 @@ static int __init fnic_init_module(void)
 err_fc_transport:
 	destroy_workqueue(fnic_fip_queue);
 err_create_fip_workq:
+	if (pc_rscn_handling_feature_flag == PC_RSCN_HANDLING_FEATURE_ON)
+		destroy_workqueue(reset_fnic_work_queue);
+err_create_reset_fnic_workq:
 	destroy_workqueue(fnic_event_queue);
 err_create_fnic_workq:
 	kmem_cache_destroy(fdls_frame_elem_cache);
@@ -1317,6 +1343,10 @@ static void __exit fnic_cleanup_module(void)
 {
 	pci_unregister_driver(&fnic_driver);
 	destroy_workqueue(fnic_event_queue);
+
+	if (pc_rscn_handling_feature_flag == PC_RSCN_HANDLING_FEATURE_ON)
+		destroy_workqueue(reset_fnic_work_queue);
+
 	if (fnic_fip_queue) {
 		flush_workqueue(fnic_fip_queue);
 		destroy_workqueue(fnic_fip_queue);
-- 
2.47.0

