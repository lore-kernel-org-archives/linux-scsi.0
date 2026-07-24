Received: from alln-iport-4.cisco.com (alln-iport-4.cisco.com [173.37.142.91])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC0B320CD3;
	Fri, 24 Jul 2026 17:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.91
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915722; cv=none; b=pZzVV63b9zPFIq1NYa3MUb4UPpgVVcogWFucgUW6vGnb9OIQxyHpADPJSvlxHfGp9fxQo8L5TfajGA5ouzKr1CCarrVxY4aheIwY614UeacgcXjuPLKizRLp8uoBs8RvWpOaUxExlfwz9M4rfPAwUUT2vOjzW7I/Hw4thrgiKek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915722; c=relaxed/simple;
	bh=VQqeQv26vB76TXYsmoDLORJ2feWFN74InWlUwDBmo7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGH5fe27xrODeL6RgGok0ioL+U/qLcVSxE0h/6rPBJ/wp+DsObeqgD1NSToE16+3doAIvTAGxhzaPgs6jdqqz5Q554yuWRvXY+QgcySlmUYFWAcPfuRGmVZhrskUTwomwp12QnjZdb0LbovdicRWDIo9ohia6AbH9+Y5QcA3h2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=V3s5X1n7; arc=none smtp.client-ip=173.37.142.91
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="V3s5X1n7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=9670; q=dns/txt;
  s=iport01; t=1784915720; x=1786125320;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zXHIeEmWRZuuOVcTTkK7oW+aYBwuCm7zHU48lbFYhwo=;
  b=V3s5X1n70pghzz276jmzxF57iw4cvQK6UPdl0uSjMOAK4Gy2hNNKC7pa
   VxJX2+gGOtDylJ16qFLZTruiJEALI8Q9PqHb8owPQpbLtHzpVde3c23kV
   jxGV3aNL7+SsxuW696mQ0PFsUSEv7A26N/hkI3PbHZ+CsiQmBeRZ3GdmR
   L+gF9qvgdo/0JHcbVlzW22syozMRHiRL48/weDYFLunZqrbeEarRfGZrN
   YOg3w4K2kQb2bvOBKo08Nl7o8OqfL+35qTJJbPt5gVO8SqxhEA0Gm/SfD
   0WbJm9/8r4gUOEbQyXxDEc83V0Zv881Xb9076DvJid4BvUDcbxOB+mqvY
   w==;
X-CSE-ConnectionGUID: lg4zY/WkShusfVVrLGErkg==
X-CSE-MsgGUID: HbPsMOxcShC81P3tJfotgA==
X-IPAS-Result: =?us-ascii?q?A0BDAgBZpmNq/5AQJK1aglmCV4FSQxkwlCmCIYEWnQiBf?=
 =?us-ascii?q?g8BAQEPUQQBAYUFAo1gAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdQPCMIF5M4EB3kWBZgELFAGBOI1fd?=
 =?us-ascii?q?YR8JxUGgUlEgRWCcwdvgVKCSYZtBIMukkBIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQwbBwWBHYEseYRYIx8DOX+BL3VKdy1pARIXgSaDSwKBTwMLG?=
 =?us-ascii?q?A1IESw3FBkEPm4HjXcjgjkHgQ4BgTwIZBYBY5JtkB2CIaEPhCehWxozhASUF?=
 =?us-ascii?q?5JRmQipQ4FoPIFZMxoIGxWDIlMZD44tFtI6JzI9AQEHAgcOAwuBaJABgX0BA?=
 =?us-ascii?q?Q?=
IronPort-Data: A9a23:W5PMxaDkpjUCHRVW/9/iw5YqxClBgxIJ4kV8jS/XYbTApDhz1TUEy
 jYeCGHVO/eKYWSjfIt2Oo/i9UgBuMOEmt4xOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jXmthh
 fuo+5eBYAD/h2ctWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEx/oyHnBxAo4j+vtsD19w7
 9g3BSoOYUXW7w626OrTpuhEj8AnKozveYgYoHwllW6fBvc9SpeFSKLPjTNa9G5v3YYVQ7CHO
 YxANWYHgBfoO3WjPn8UAYgineOhhVH0ciZTrxSeoq9fD237k1wuiuWyaIuPEjCMbeVfpl29g
 XLNxGTSUkgib8C9xz2Z/Vv504cjmgu+Aur+DoaQ9vdwjXWQy3YVBRlQUkG0ydG7h0y0c9ZeL
 VEEvCskqO4580nDZtz0RQG5pjicswIRQcFdFcU98giGzqeS6AGcbkANQjdCb8QhqecsSDAq3
 0PPlNTsbRRttbCTRH2d95+OoD+yMDRTJmgHDQceQBUI+cLLuow/jhvTCN1kFcaditHoHzr5x
 RiRsTMzwb4UiKYj06S94ECCgD+2oJXNZhA66x+RXW+/6A59Iom/aOSA7Vnd8OYFN42CT3Gfs
 3Ue3cuT9uYDCdeKjiPlfQkWNLit4/DANHjXhkRiWsF+sT+s4HWkO4tX5VmSOXtUDyrNQhexC
 Ge7hO+bzMY70KeCBUOvX7+MNg==
IronPort-HdrOrdr: A9a23:DEZioK9mkIaTXR5E1/duk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: =?us-ascii?q?9a23=3Am3wkCmrqxguSO6IowyEiUBjmUcQqLm/si0jTGE+?=
 =?us-ascii?q?lEmhXdqexZnKK+6wxxg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AxwvD1gwgOUEiV1dn26msoT97R9KaqISkMFsotoU?=
 =?us-ascii?q?NgMmvZXVIYCu/gjOrTaZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="787257092"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:55:19 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id A3E76180001C6;
	Fri, 24 Jul 2026 17:55:12 +0000 (GMT)
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
Subject: [PATCH v6 12/13] scsi: fnic: Expose NVMe transport state in debugfs
Date: Fri, 24 Jul 2026 10:48:10 -0700
Message-ID: <20260724174811.5118-13-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260724174811.5118-1-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.189.81];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.189.81, [10.189.189.81]
X-Outbound-Node: alln-l-core-07.cisco.com

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
index 774de0b6d61c..9b3025007075 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -936,6 +936,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		err = -EOPNOTSUPP;
 		goto err_out_fnic_role;
 	case VFCF_FC_NVME_INITIATOR:
+		fnic_nvmef_debugfs_init(fnic);
 		fnic->role = FNIC_ROLE_NVME_INITIATOR;
 		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
 			fnic->fnic_num);
@@ -1210,6 +1211,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_fnic_alloc_vnic_res:
 	fnic_clear_intr_mode(fnic);
 err_out_fnic_set_intr_mode:
+	if (IS_FNIC_NVME_INITIATOR(fnic))
+		fnic_nvmef_debugfs_remove(fnic);
 	if (IS_FNIC_FCP_INITIATOR(fnic))
 		scsi_host_put(fnic->host);
 err_out_fnic_role:
@@ -1280,6 +1283,7 @@ static void fnic_remove(struct pci_dev *pdev)
 	if ((fnic_fdmi_support == 1) && (fnic->iport.fabric.fdmi_pending > 0))
 		timer_delete_sync(&fnic->iport.fabric.fdmi_timer);
 
+	fnic_nvmef_debugfs_remove(fnic);
 	fnic_stats_debugfs_remove(fnic);
 
 	/*
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index 874139412704..8794360f2adf 100644
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
index 7d95d0e5aa28..5e897908337c 100644
--- a/drivers/scsi/fnic/fnic_nvme.h
+++ b/drivers/scsi/fnic/fnic_nvme.h
@@ -134,6 +134,7 @@ void nvfnic_terminate_tport_admin_ios(struct fnic *fnic,
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

