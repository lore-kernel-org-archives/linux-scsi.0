Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF3A179A3;
	Fri, 12 Jun 2026 18:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781288206; cv=none; b=ik/+FwxW7JZ344Qi7/0F9oW3wlYD3/B9vjMU5asTE6eXxDJshL6zxcNH2TcY0EIcwqzyEnY3hesx1M9h2m7hMWw4OdmX/LjV+qRx9ZDBzC8+tntsziAkb82r7drEugETIL/dFoVK7dU08Lmiw/SauRD6QLEab/6Iia0qnr9Sru0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781288206; c=relaxed/simple;
	bh=FnZJgomIQnfslgOX9qkuF1DXFw4GncE9V0klCyYY57M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4HU8x283HNlFd506bSVKsQ2CXTX1bXeXQE217HMws3poX72E12dQTwD2FG8EpDGi3LP+CjP+WMGuLqxUtFZFSU9uF2dw8PmtSPlRhLyjuTwDYIx6HuyDxXNiyrn6Sar3VXjfPFO9e34OEIdIEgzQRfKlRGRsvaaA8OKtnndGfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=e5Sl7qrE; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="e5Sl7qrE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=9430; q=dns/txt;
  s=iport01; t=1781288204; x=1782497804;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R3dKxbBLmStItfd26HohpRfFs5C4nysI6GDshWJHASs=;
  b=e5Sl7qrEBHdfxR1q9Y/lJSaLWrRjzOHc0PsLYzkvr051a+PHbZudDKSA
   XlLieHDF7H+MURjha+7VWxXnV6AsU7lo1WTVkwpZ7hrqOkDNCu+W9jOyZ
   B0wTtAFfWtUjXLcfyLtlfbH975uXJe62Qam29RZLxW3zXAmsmMn/G64ni
   TdSjZuklKErGGzw/+152xyRgbhPwipyaqQQ06fk0LeQ/BKfUPF1V0Apjm
   5Ind8S+hXuQgQwwE829OVXx6998r2c/aBq8PgNUJnDcpee2AuivIn0LhN
   O2oyqVU9kmsfriKW4IcWlA6K5sV0bBeHw0Ne4Sso1rwzp7OYgTvkoe0ea
   A==;
X-CSE-ConnectionGUID: d+o9yATzQ1mpSjgMI/psvQ==
X-CSE-MsgGUID: Xm8lPZK4Q2qWsO5m6B3ONQ==
X-IPAS-Result: =?us-ascii?q?A0BDAgBgTCxq/4v/Ja1aglmCV4FSQxkwlCqCIYEWnQiBf?=
 =?us-ascii?q?g8BAQEPUQQBAYUGAo1DAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4ThlyGWwIBAycLAUYQUVYZgwKCdAO1YIF5M4EB3kOBZgELFAGBOI1ed?=
 =?us-ascii?q?IR8JxUGgUlEgRWCcwdvgVKCSYZtBIMukHdIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQwbBwWBSoEraoEDhQ0jHwM5f4F0gShnaRUwNYEBAREdAwsYD?=
 =?us-ascii?q?UgRLDcUGwQ+bgeMSBcPgjcHgQ4BgTwIZBdjkmMKkB2CIYE1n1qEJ6FbGjOEB?=
 =?us-ascii?q?JQXklGZCKlCgWg8gVkzGggbFYMiUxkPji0WyzMnMj0BAQcCBw4DC4FokAGBf?=
 =?us-ascii?q?AEB?=
IronPort-Data: A9a23:mqs0mq57wKsqq1MxStsYMAxRtMnGchMFZxGqfqrLsTDasY5as4F+v
 mRNCmmHP66CYTH1ettzO9i/9koPvJTcz9YxSQNkrCowZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo/6UzBHf/g2QqajxNsfrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eMc4fq/dePXN3r
 PkAEzICSzHEn/mo+efuIgVsrpxLwMjDJogTvDRkiDreF/tjGcqFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkYeUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIaKK4LSHpoMxC50o
 Er2+jT9OiM5aOXF0AWe1S+p2MWUugXCDdd6+LqQs6QCbEeo7mwaEhA+Vlahp/S9zEmkVLp3K
 UEW8AIqrK4v5AqqRNy7VBq9yFaBtwQAWtwWC+Am5RuWx6z85ByQDWwJCDVGbbQOvcM/Rjsy0
 UKhhd7lBTVz9raSTBq19LKZqz69OSk9N2IOZSYYCwAC5rHLuowtgwjUZsxuHK68kpv+HjSY6
 zSGsS41jrM7ltMQ2uOw+lWvqzatoIXZCw04/APaWkq74Q5jIo2ofYql7R7c9/koBIKYSESR+
 WMPgMm28u8DF9eOmTaLTeFLG6umj8tpKxXGilJpWp1k/DO39jv7J8Zb4Sp1IwFiNcNslSLVX
 XI/cDh5vPd7VEZGp4cuC25tI6zGFZTdKOk=
IronPort-HdrOrdr: A9a23:dKm2val4oJrYLmx3BI01Y+VPYFLpDfLm3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV4hQqyFkFw2cDkp6ACNCBZY/Cd
 6gw/AvnUvHRZzSBf7LfkXsmIP41qT2qK4=
X-Talos-CUID: 9a23:F4e1kWxFOXr2ERovDaneBgUYWcd0Y1Th3k6JJleDC2lMafqNUkGprfY=
X-Talos-MUID: 9a23:lYCcrwvA86BepTOF/s2ntDQyMP9awPiXUlkyirJbvpeubgtWAmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="479603712"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:16:43 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 0D49B18000352;
	Fri, 12 Jun 2026 18:16:41 +0000 (GMT)
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
Subject: [PATCH v4 12/13] scsi: fnic: Expose NVMe transport state in debugfs
Date: Fri, 12 Jun 2026 11:09:17 -0700
Message-ID: <20260612180918.8554-13-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260612180918.8554-1-kartilak@cisco.com>
References: <20260612180918.8554-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.127.244];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.127.244, [10.188.127.244]
X-Outbound-Node: rcdn-l-core-02.cisco.com

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
---
 drivers/scsi/fnic/fnic.h         |  5 ++
 drivers/scsi/fnic/fnic_debugfs.c | 96 ++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_main.c    | 10 ++++
 drivers/scsi/fnic/fnic_nvme.c    | 30 ++++++++++
 drivers/scsi/fnic/fnic_nvme.h    |  1 +
 drivers/scsi/fnic/fnic_stats.h   |  7 +++
 6 files changed, 149 insertions(+)

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
index 2ccbfa0dfa92..b7eaacb7b7fb 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -183,6 +183,36 @@ void nvfnic_release_nvme_ioreq_buf(struct fnic_iport_s *iport,
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

