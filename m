Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58667380FF9;
	Wed, 24 Jun 2026 04:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276657; cv=none; b=n+jesbGvIVdM7iV3vfBPjjozQieC670njxW9OuFCbAgJBX47QUTaDhbux18xfGRLDA9Xmz5t0udyCEjzFZY2NasTv//sLT8PNTt9bjpux42hzsSNkln+fCn5lj/jx/6v8HeMaEgkLfofgrZMKSE620afvf4MgEqH01DULBqx6u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276657; c=relaxed/simple;
	bh=Lx5zCkOcuNcMJFseV2LgUfLpVv33C9Dw/dQyD3SI5VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYXG9x+QXB1sRiYT6jOMs7JUQBLVUfi1EZldfjsR2nZBub0XMer5mriRx5dvXTzNG1jJT/9P+14vpoZcIaxhKuukXJ9tmSbe+18aYPMSANlRu1wvYv3shMS+/dg4GZZf9r7O4KvunaB8deKDI6mTsBr3bRDpnoz7VMJnS8Oil5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Kq+pPvlg; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Kq+pPvlg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=9670; q=dns/txt;
  s=iport01; t=1782276655; x=1783486255;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7v0bmN1Por0S+L0kcXq5borxz7Q5XFUn+A6Fx/Uv0ZI=;
  b=Kq+pPvlglGPqGVq03H996HUDQKQvonqUqEPibqgEvTjBVajtANosi4A8
   vnA3B1SsQja1yW4EglDIiXEApprR6uCJZYY4LmOoP/ReoxMNCdQ2OSPEi
   4hxc2s3cj39JXf25zZvKgurlW/AcGbluRcjrKGms5D3bq0UZr86PXFNH0
   Tb7DsiAZEixm4qBUehIYOBIRnAs1dE1VUnS6BYKaZt2wnqgM9lCF9Jb1n
   eVGJASF/r8da/ytAlZRrBiJCFYeT8VjXqRMkuyjyppG8rsP+/WImtDI+P
   +V+UBnp/VeOszhHoZyqkb70okZPj92HznIQ91v5fzgvzbHCcsfiDUt0es
   w==;
X-CSE-ConnectionGUID: SpAxWBavSzKhYXBdBcut8Q==
X-CSE-MsgGUID: BoD477U/QhaQjtvQC73Bwg==
X-IPAS-Result: =?us-ascii?q?A0BDAgD1YDtq/4//Ja1aglmCV4FSQxkwlCqCIYEWnQiBf?=
 =?us-ascii?q?g8BAQEPUQQBAYUGAo1KAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdAOyLIF5M4EB3kOBZgELFAGBOI1ed?=
 =?us-ascii?q?IR8JxUGgUlEgRWCcwdvgVKCSYZtBIMukQJIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQwbBwWBHYFugQSFAiMfAzl/gT+BJGRmFTA1gQEBER8KgTUDC?=
 =?us-ascii?q?xgNSBEsNxQbBD5uB4xdFw+CNgeBDgGBPAhkFgFjkm2QHYIhoQ+EJ6FbGjOEB?=
 =?us-ascii?q?JQXklGZCKlCgWg8gVkzGggbFYMiUxkPji0W0jonMj0BAQcCBw4DC4FokAGBf?=
 =?us-ascii?q?AEB?=
IronPort-Data: A9a23:/YGClqIo7GVGEl0nFE+RIJQlxSXFcZb7ZxGr2PjKsXjdYENS0jwEy
 GQcD2zSaPmLYmb2ft1/aoW29EIO7J7WxtdgQAsd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnR0
 T/Oi5eHYgH9hWQvajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1VFGgmAqcR5N1lImF/x
 dYUAjsQckC60rfeLLKTEoGAh+w5J8XteYdasXZ6wHSBU7AtQIvIROPB4towMDUY358VW62BI
 ZBENHw2ME+ojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjOm9bIKFJ4HWLSlTtmyfi
 j6ZoFm+OxETDd6D1wOurSmGmeCayEsXX6pXTtVU7MVCgFSJy0QQBQcQWF/9puO24ma8VtBVA
 0gV/Dc+66k48QqgSdyVdxixumKFuFgEVsZdCfY37imK0KPf5wvfDW8BJhZIZNUls9cxWBQw2
 1OJls+vDjtq2JWXTH+b+7iUrBuoNCQVJHNEbigBJSMf7sfuupoblB/DTt9/VqWyi7XdHT3tx
 TuDqgAlmq4ey8UM0s2T+VHBniLppZXTSAMxzhvYU3jj7Q5jYoOhIYuy5jDz6fdGMZbcVVKav
 VAalMWEquMDF5eAkGqKWuplIV2yz+yOPDuZhRtkGIMssmzzvXWiZotXpjp5IS+FL/o5RNMgW
 2eL0Ss52XOZFCHCgXNfC25pN/kX8A==
IronPort-HdrOrdr: A9a23:SpKch67Wupgmv1sdsAPXwALXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fj5kYoax12YKd96Ao8IAOaHkpqADRiP/MCZf
 yhDg4tnUvZRZzRBf7Lf0U4Yw==
X-Talos-CUID: =?us-ascii?q?9a23=3Am9JGYWjutzeJs63nVaV6J6FYdDJuSWX03Ej6KlG?=
 =?us-ascii?q?DG0VpeY2/RXWb5b80qp87?=
X-Talos-MUID: 9a23:u4726gp9qnGO7oF52SAezxtlGJs3vJnpMUAEqJcapfCvandaJDjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="498408554"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:50:54 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id AD21718000277;
	Wed, 24 Jun 2026 04:50:52 +0000 (GMT)
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
	jmeneghi@redhat.com,
	revers@redhat.com,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v5 12/13] scsi: fnic: Expose NVMe transport state in debugfs
Date: Tue, 23 Jun 2026 21:43:33 -0700
Message-ID: <20260624044334.3079-13-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260624044334.3079-1-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.122.232];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.122.232, [10.188.122.232]
X-Outbound-Node: rcdn-l-core-06.cisco.com

Create an NVMe debugfs directory with a per-host nvmef_info file.

Report local-port and target-port identifiers for NVMe initiator
instances, and initialize and remove the debugfs entries with the NVMe
probe and teardown paths.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>

---
Changes between v2 and v3:
Limit nvmef_info debugfs output to the allocated buffer.

Changes between v4 and v5:
Incorporate review comments from Sashiko:
	Clean up NVMe debugfs on probe errors
---
 drivers/scsi/fnic/fnic.h         |  5 ++
 drivers/scsi/fnic/fnic_debugfs.c | 94 ++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_main.c    |  4 ++
 drivers/scsi/fnic/fnic_nvme.c    | 30 ++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  1 +
 drivers/scsi/fnic/fnic_stats.h   |  7 +++
 6 files changed, 141 insertions(+)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 86293e112b34..507c22d21882 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -478,6 +478,8 @@ struct fnic {
 	/*** FIP related data members  -- end ***/
 
 	/* NVME data members */
+	struct dentry *fnic_nvmef_debugfs_host;
+	struct dentry *fnic_nvmef_debugfs_file;
 	struct sbitmap nvfnic_tag_map;
 	struct work_struct nvme_io_cmpl_work;
 	atomic_t nvme_io_event_queued;
@@ -551,6 +553,9 @@ void fnic_log_q_error(struct fnic *fnic);
 void fnic_handle_link_event(struct fnic *fnic);
 int fnic_stats_debugfs_init(struct fnic *fnic);
 void fnic_stats_debugfs_remove(struct fnic *fnic);
+void fnic_nvmef_debugfs_init(struct fnic *fnic);
+void fnic_nvmef_debugfs_remove(struct fnic *fnic);
+int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *info);
 int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
 
 void fnic_handle_fip_frame(struct work_struct *work);
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 467fba29ea5f..61f167e20574 100644
--- a/drivers/scsi/fnic/fnic_debugfs.c
+++ b/drivers/scsi/fnic/fnic_debugfs.c
@@ -10,10 +10,19 @@
 extern int fnic_get_debug_info(struct stats_debug_info *debug_buffer,
 							   struct fnic *fnic);
 
+static int fnic_nvmef_debugfs_open(struct inode *inode,
+			struct file *file);
+static ssize_t fnic_nvmef_debugfs_read(struct file *file,
+			char __user *ubuf,
+			size_t nbytes, loff_t *pos);
+static int fnic_nvmef_debugfs_release(struct inode *inode,
+			struct file *file);
+
 static struct dentry *fnic_trace_debugfs_root;
 static struct dentry *fnic_trace_debugfs_file;
 static struct dentry *fnic_trace_enable;
 static struct dentry *fnic_stats_debugfs_root;
+static struct dentry *fnic_nvmef_debugfs_root;
 
 static struct dentry *fnic_fc_trace_debugfs_file;
 static struct dentry *fnic_fc_rdata_trace_debugfs_file;
@@ -46,6 +55,9 @@ int fnic_debugfs_init(void)
 	fnic_stats_debugfs_root = debugfs_create_dir("statistics",
 						fnic_trace_debugfs_root);
 
+	fnic_nvmef_debugfs_root = debugfs_create_dir("nvme_info",
+						     fnic_trace_debugfs_root);
+
 	/* Allocate memory to structure */
 	fc_trc_flag = vmalloc(sizeof(struct fc_trace_flag_type));
 
@@ -70,6 +82,9 @@ int fnic_debugfs_init(void)
  */
 void fnic_debugfs_terminate(void)
 {
+	debugfs_remove(fnic_nvmef_debugfs_root);
+	fnic_nvmef_debugfs_root = NULL;
+
 	debugfs_remove(fnic_stats_debugfs_root);
 	fnic_stats_debugfs_root = NULL;
 
@@ -669,6 +684,13 @@ static const struct file_operations fnic_reset_debugfs_fops = {
 	.release = fnic_reset_stats_release,
 };
 
+static const struct file_operations fnic_nvmef_debugfs_fops = {
+	.owner = THIS_MODULE,
+	.open = fnic_nvmef_debugfs_open,
+	.read = fnic_nvmef_debugfs_read,
+	.release = fnic_nvmef_debugfs_release,
+};
+
 /*
  * fnic_stats_init - Initialize stats struct and create stats file per fnic
  *
@@ -722,3 +744,75 @@ void fnic_stats_debugfs_remove(struct fnic *fnic)
 	debugfs_remove(fnic->fnic_stats_debugfs_host);
 	fnic->fnic_stats_debugfs_host = NULL;
 }
+
+void fnic_nvmef_debugfs_init(struct fnic *fnic)
+{
+	char name[16];
+
+	snprintf(name, sizeof(name), "host%d", fnic->fnic_num);
+
+	fnic->fnic_nvmef_debugfs_host = debugfs_create_dir(name,
+							   fnic_nvmef_debugfs_root);
+	fnic->fnic_nvmef_debugfs_file = debugfs_create_file("nvmef_info",
+							    S_IFREG | 0444,
+							    fnic->fnic_nvmef_debugfs_host,
+							    fnic,
+							    &fnic_nvmef_debugfs_fops);
+}
+
+static int fnic_nvmef_debugfs_open(struct inode *inode, struct file *file)
+{
+
+	struct fnic *fnic = inode->i_private;
+	struct fnic_nvmef_info *info;
+	int buf_size = 2 * PAGE_SIZE;
+
+	info = kzalloc_obj(struct fnic_nvmef_info, GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info->info_buffer = vmalloc(buf_size);
+	if (!info->info_buffer) {
+		kfree(info);
+		return -ENOMEM;
+	}
+
+	info->buf_size = buf_size;
+	memset((void *)info->info_buffer, 0, buf_size);
+	info->buffer_len = nvfnic_get_nvmef_info(fnic, info);
+
+	file->private_data = info;
+
+	return 0;
+}
+
+static ssize_t fnic_nvmef_debugfs_read(struct file *file,
+				       char __user *ubuf,
+				       size_t nbytes, loff_t *pos)
+{
+	struct fnic_nvmef_info *info = file->private_data;
+
+	return simple_read_from_buffer(ubuf, nbytes, pos,
+				     info->info_buffer, info->buffer_len);
+}
+
+static int fnic_nvmef_debugfs_release(struct inode *inode, struct file *file)
+{
+	struct fnic_nvmef_info *info = file->private_data;
+
+	vfree(info->info_buffer);
+	kfree(info);
+	return 0;
+}
+
+void fnic_nvmef_debugfs_remove(struct fnic *fnic)
+{
+	if (!fnic)
+		return;
+
+	debugfs_remove(fnic->fnic_nvmef_debugfs_file);
+	fnic->fnic_nvmef_debugfs_file = NULL;
+
+	debugfs_remove(fnic->fnic_nvmef_debugfs_host);
+	fnic->fnic_nvmef_debugfs_host = NULL;
+}
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index df8c8ebbc32b..245db1b992b5 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -933,6 +933,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = -EOPNOTSUPP;
 		goto err_out_fnic_role;
 	case VFCF_FC_NVME_INITIATOR:
+		fnic_nvmef_debugfs_init(fnic);
 		fnic->role = FNIC_ROLE_NVME_INITIATOR;
 		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
 			fnic->fnic_num);
@@ -1207,6 +1208,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_fnic_alloc_vnic_res:
 	fnic_clear_intr_mode(fnic);
 err_out_fnic_set_intr_mode:
+	if (IS_FNIC_NVME_INITIATOR(fnic))
+		fnic_nvmef_debugfs_remove(fnic);
 	if (IS_FNIC_FCP_INITIATOR(fnic))
 		scsi_host_put(fnic->host);
 err_out_fnic_role:
@@ -1277,6 +1280,7 @@ static void fnic_remove(struct pci_dev *pdev)
 	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
 		timer_delete_sync(&fnic->iport.fabric.fdmi_timer);
 
+	fnic_nvmef_debugfs_remove(fnic);
 	fnic_stats_debugfs_remove(fnic);
 
 	/*
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index e322dd4dcb78..a19dd9cf76cf 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -188,6 +188,36 @@ void nvfnic_release_nvme_ioreq_buf(struct fnic_iport_s *iport,
 			     fnic->io_sgl_pool[io_req->sgl_type]);
 }
 
+int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *info)
+{
+	int len = 0;
+	struct fnic_iport_s *iport = &fnic->iport;
+	int buf_size = info->buf_size;
+	struct fnic_tport_s *tport;
+	struct fnic_tport_s *next;
+	unsigned long flags;
+
+	if (buf_size <= 0)
+		return 0;
+
+	len += scnprintf(info->info_buffer + len, buf_size - len,
+			 "lport wwpn 0x%llx wwnn 0x%llx fcid 0x%06x\n",
+			 iport->wwpn, iport->wwnn, iport->fcid);
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+		if (len >= buf_size - 1)
+			break;
+
+		len += scnprintf(info->info_buffer + len, buf_size - len,
+				 "tport wwpn 0x%llx wwnn 0x%llx fcid 0x%06x\n",
+				 tport->wwpn, tport->wwnn, tport->fcid);
+	}
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	return len;
+}
+
 inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 					       struct vnic_wq_copy *wq,
 					       struct fnic_io_req *io_req,
diff --git a/drivers/scsi/fnic/fnic_nvme.h b/drivers/scsi/fnic/fnic_nvme.h
index ebdaf6930f8e..62e2a3e68449 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -133,6 +133,7 @@ void nvfnic_terminate_tport_admin_ios(struct fnic *fnic,
 				      struct fnic_tport_s *tport);
 void nvfnic_cleanup_tport_io(struct fnic *fnic, struct fnic_tport_s *tport);
 void nvfnic_nvme_unload(struct fnic *fnic);
+int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *info);
 void nvfnic_exch_reset(struct fnic_iport_s *iport, struct fnic_tport_s *tport);
 void nvfnic_nvme_iodone_work(struct work_struct *work);
 #else
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index fc81e4a7e29e..a3ddd7b55729 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -191,6 +191,13 @@ struct stats_debug_info {
 	int buffer_len;
 };
 
+struct fnic_nvmef_info {
+	char *info_buffer;
+	void *i_private;
+	int buf_size;
+	int buffer_len;
+};
+
 int fnic_get_stats_data(struct stats_debug_info *, struct fnic_stats *);
 const char *fnic_role_to_str(unsigned int role);
 #endif /* _FNIC_STATS_H_ */
-- 
2.47.1

