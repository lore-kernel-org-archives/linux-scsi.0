Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83D2F3C26;
	Wed, 27 May 2026 19:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911899; cv=none; b=gj9NG6mVigCTUZe+DZ7EasNhqE1C5o+gAUO8YmlAhjtWEd0rKiyx61LL7RbnRyhA+Rg/B98eaazos/QRjppU6shCr17VQnL3dfbjKXAk9FjYhW3cCW4ejjftvLdvYB9NyZEBQFmdmo6PhofQtAQ2Ctu0d2sVY5mZsJvD4/gl7nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911899; c=relaxed/simple;
	bh=Bo+EEV7Vmi16Sl4ZP6DDdBTwtGi++CaNXSqTZ/HWK4I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kf85ijQxlA5OyZBqeQLx9C2c00yUxb1Fd3EvQUL5bB8wPLWQH7pjo2/9+mZqYvid2lJN4MSZTNjGVIHvYBPaj6aeZ1j+aR1gM0P/2A068gtpWhwDx7gOzpetLkZhU6vUQbtzBMmCMzHe9iTwBqVmfO6oNERSFAdUZ5LOvd9MJXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=UeyrQFya; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="UeyrQFya"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=9314; q=dns/txt;
  s=iport01; t=1779911897; x=1781121497;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GzkushsVpJ6l9T9LUN6Vpw9pJvygxRYU3AJe0WJIA+c=;
  b=UeyrQFya9YIUSmMhqe8YUb1DT/DTQTabrEtcjo2au4m8oXIF1ZnAXBrN
   66e0bjO3ZensxzQ7cuNe7gbiatoadklgXMrR1lQE/7WIybE+C76HKgT30
   KWYSkPsWoHA/YZJ6Zxl+c5nC7GVJMrhf6NquScTdh6a9HV8u15mdQag6c
   KP9ile83etkaa5gvM0jDINWryweXM1aXRlx70tNpkgOw81lCGRunn/hSu
   L+R348yITdHY4JCF9A6BFs17rTGu+3VX2U6cc9PLlYWA22BwWsM67QsgZ
   Ftk0PturAsqmkR2jYQiQGJ/9ciPCE7ovSKggsG+qlDgKvcioJqQLhv8wF
   Q==;
X-CSE-ConnectionGUID: aVbZ0NFqQR6mA9XBesWVFQ==
X-CSE-MsgGUID: Jzk9MWBlQpqqjOy+Gy+wCg==
X-IPAS-Result: =?us-ascii?q?A0BDAgA7TBdq/5P/Ja1aglmCV4FQQxkwlCqCIYEWnQiBf?=
 =?us-ascii?q?g8BAQEPUQQBAYUGAo0yAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdAO0X4F5M4EB3kGBZAELFAGBOI1cd?=
 =?us-ascii?q?IR7JxUGgUlEgRWCcgdvgVKJNQSDLo8RSIEeA1ksAVUTDQoLBwWBZgM1EioVb?=
 =?us-ascii?q?jIdgSM+F4ELGwcFgUt2cmqBBYUYIyYDToEtgX9dAwsYDUgRLDcUGwQ+bgeKd?=
 =?us-ascii?q?RoPgioHgQ4BgTwIZBdjkmMKkB2CIYE1n1mEJqFbGjOEBJQWklGZBqlAgWg8g?=
 =?us-ascii?q?VkzGggbFYMiUxkPji0WzmUnMj0BAQcCBw4DC4FokX0BAQ?=
IronPort-Data: A9a23:fYhx06JOFe/ChBGhFE+RIJQlxSXFcZb7ZxGr2PjKsXjdYENS0DVWn
 WQXXzqBP/uOZWP3etsjOtzlpxkAuMTQydc1TQEd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCSa/kvxWlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVnR0
 T/Oi5eHYgH9hmQrajh8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1nMksEZas2499NX2Rnp
 MwyJSsyUD660rfeLLKTEoGAh+w5J8XteYdasXZ6wHSAVbAtQIvIROPB4towMDUY358VW62BI
 ZBENHw2MEuojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZjOe3bIaLJI3WLSlTtmSKp
 TPjwE79OwkDLd642Hmq4zGzreCayEsXX6pXTtVU7MVCgFSJy0QQBQcQWF/9puO24ma8VtBVA
 0gV/Dc+66k48QqgSdyVdxixumKFuFgEVsZdCfY37imK0KPf5wvfDW8BJhZIZNUls9cxWBQw2
 1OJls+vDjtq2JWXTH+b+7iUrBuoNCQVJHNEbigBJSMf7sfuupoblB/DTt9/VqWyi7XdHT3tx
 TuDqgAlmq4ey8UM0s2T+VHBniLppZXTSAMxzhvYU3jj7Q5jYoOhIYuy5jDz6fdGMZbcVVKav
 VAalMWEquMDF5eAkGqKWuplIV2yz+yOPDuZhRtkGIMssm31vXWiZotXpjp5IS+FL/o5RNMgW
 2eL0Ss52XOZFCfCgXNfC25pN/kX8A==
IronPort-HdrOrdr: A9a23:allYMa2mMy6BvS9dPVyZ4QqjBHgkLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 tIQuxXFMDwAV9mjczz/QW0V+o7zMLvytHOuQ6n9RdQZDAvTb185AFkDQveOEh3SA5aQacdLv
 Onl6x6T/7KQwVuUix9bUN1JtT+mw==
X-Talos-CUID: 9a23:xZjue2xmEFKgxWuAlsS7BgUdJMoXKlvz1U7qfUqRWFZDRaaqd3GprfY=
X-Talos-MUID: 9a23:qE4kwAkIBomQe6+erVIddnpAJsQ5xpuEDHkViIwEnNjHGj0zJByS2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="472446694"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:57:53 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id CC82318000241;
	Wed, 27 May 2026 19:57:51 +0000 (GMT)
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
Subject: [PATCH v2 12/13] scsi: fnic: Expose NVMe transport state in debugfs
Date: Wed, 27 May 2026 12:49:59 -0700
Message-ID: <20260527195000.8444-13-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260527195000.8444-1-kartilak@cisco.com>
References: <20260527195000.8444-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.14.55];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.14.55, [10.188.14.55]
X-Outbound-Node: rcdn-l-core-10.cisco.com

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
 drivers/scsi/fnic/fnic.h         |  5 ++
 drivers/scsi/fnic/fnic_debugfs.c | 96 ++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_main.c    | 10 ++++
 drivers/scsi/fnic/fnic_nvme.c    | 24 ++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  1 +
 drivers/scsi/fnic/fnic_stats.h   |  7 +++
 6 files changed, 143 insertions(+)

diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 86293e112b34..951549aff521 100644
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
+int fnic_nvmef_debugfs_init(struct fnic *fnic);
+void fnic_nvmef_debugfs_remove(struct fnic *fnic);
+int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *info);
 int fnic_is_abts_pending(struct fnic *, struct scsi_cmnd *);
 
 void fnic_handle_fip_frame(struct work_struct *work);
diff --git a/drivers/scsi/fnic/fnic_debugfs.c b/drivers/scsi/fnic/fnic_debugfs.c
index 467fba29ea5f..690b1c6ecf01 100644
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
@@ -722,3 +744,77 @@ void fnic_stats_debugfs_remove(struct fnic *fnic)
 	debugfs_remove(fnic->fnic_stats_debugfs_host);
 	fnic->fnic_stats_debugfs_host = NULL;
 }
+
+int fnic_nvmef_debugfs_init(struct fnic *fnic)
+{
+	char name[16];
+
+	snprintf(name, sizeof(name), "host%d", fnic->fnic_num);
+
+	fnic->fnic_nvmef_debugfs_host = debugfs_create_dir(name,
+							   fnic_nvmef_debugfs_root);
+	fnic->fnic_nvmef_debugfs_file = debugfs_create_file("nvmef_info",
+							    S_IFREG | 0444 |
+							    0200,
+							    fnic->fnic_nvmef_debugfs_host,
+							    fnic,
+							    &fnic_nvmef_debugfs_fops);
+	return 0;
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
index cd5483aac462..da5f9d53ad10 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -933,6 +933,15 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = -EOPNOTSUPP;
 		goto err_out_fnic_role;
 	case VFCF_FC_NVME_INITIATOR:
+		err = fnic_nvmef_debugfs_init(fnic);
+		if (err) {
+			dev_info(&fnic->pdev->dev,
+			       "fnic(%d) Failed to initialize debugfs for nvmef\n",
+			       fnic->fnic_num);
+			fnic_nvmef_debugfs_remove(fnic);
+			goto err_out_fnic_role;
+		}
+
 		fnic->role = FNIC_ROLE_NVME_INITIATOR;
 		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
 			fnic->fnic_num);
@@ -1277,6 +1286,7 @@ static void fnic_remove(struct pci_dev *pdev)
 	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
 		timer_delete_sync(&fnic->iport.fabric.fdmi_timer);
 
+	fnic_nvmef_debugfs_remove(fnic);
 	fnic_stats_debugfs_remove(fnic);
 
 	/*
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index cf6a0ec963ea..5ae9d31c6070 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -176,6 +176,30 @@ void nvfnic_release_nvme_ioreq_buf(struct fnic_iport_s *iport,
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
+	len += snprintf(info->info_buffer + len, buf_size - len,
+			"lport wwpn 0x%llx wwnn 0x%llx fcid 0x%06x\n",
+			iport->wwpn, iport->wwnn, iport->fcid);
+
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+		len += snprintf(info->info_buffer + len, buf_size - len,
+				"tport wwpn 0x%llx wwnn 0x%llx fcid 0x%06x\n",
+				tport->wwpn, tport->wwnn, tport->fcid);
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
index 8cf9beb8c997..642747b6d7c1 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -131,6 +131,7 @@ void nvfnic_terminate_tport_admin_ios(struct fnic *fnic,
 				      struct fnic_tport_s *tport);
 void nvfnic_cleanup_tport_io(struct fnic *fnic, struct fnic_tport_s *tport);
 void nvfnic_nvme_unload(struct fnic *fnic);
+int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *info);
 void nvfnic_exch_reset(struct fnic_iport_s *iport, struct fnic_tport_s *tport);
 extern const char *fnic_fcpio_status_to_str(unsigned int status);
 void nvfnic_nvme_iodone_work(struct work_struct *work);
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

