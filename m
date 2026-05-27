Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210FB2F3C26;
	Wed, 27 May 2026 19:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911824; cv=none; b=NUo/2CQVyGSBcRGMroi3paBgF6PUXN2YrM4l/vJhBy7iP8PAjrs+2k9VgUcgUeEa43FgkBa1s55eHFyBqpaebxnMGy5Lo72l6WRQHlPUOX8+pbx3f9gU/peF8IAKK9t6H5N7yCUDwtla/yBFZhKmmYk+gKEHDCPvzcqprebTZUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911824; c=relaxed/simple;
	bh=o9nMgombxxitkuQSWSwz5Z5hwS3ra7i1T1DDqsE69/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c0nPk3aLn2c9fqCJg4plwCKHG6ianB8FJsQwxB6E/84wbwcgrka/Hvy481cXJikTL0yPbC7ddIZoyVDZw6P6r1yHBkurbXFrvHlK6/SBQiCg5Sm24xJet8R2daD2IB/q6NGSclWGCzw2qk5RolW3yWPNcgBN9P1dePXhHQ8scZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=KufnM608; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="KufnM608"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=22590; q=dns/txt;
  s=iport01; t=1779911822; x=1781121422;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zXwytYG2rm7AfwXHfh6krACRxkNqns79mO675sfEt0A=;
  b=KufnM608qvuYMuiiw6fdaENxepxjQSh3Fb/aMe1y1kMC5Rx3fHiWhdY4
   9LqcA3tpR0KLCx7mDgDuCqoOZuwXOC5XB4VTqiQk3a+kUw0Q7Ht4GR2G7
   8HfERGujbB4TAhPyw14LTPNeTwC0c9O67svdqx7rrdBg9ujyNtcYwV0Gh
   iPGbnsEA7q1Y5xLe8Sfd+aR57kb8MEfvP4pzQxAS0LvLXkszJ3DluZytL
   Bk0vcGt4UHAVPJ+7zFQPaU3nmCfb79B4G809iSEibG7JM5jVxWoDLINbI
   bzwCTxzPbko091o0rMYlcJyBJWUEekxAfQtY9tFc5FPXbU0m9i8thoPqB
   w==;
X-CSE-ConnectionGUID: 4WaF/uMuSK2PDVHmluXjhw==
X-CSE-MsgGUID: +spi+QwxR0qRgDvsRI495g==
X-IPAS-Result: =?us-ascii?q?A0BDAgDCSxdq/5P/Ja1aglmCV4FQQxkwlCqCIZ4egX4PA?=
 =?us-ascii?q?QEBD1EEAQGFBgKNMgImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMaDQsBRhBRVhAJgwKCdAO0VIF5M4EB3kGBZAELFAGBOI1cd?=
 =?us-ascii?q?IR7JxUGgUlEgRWDaIFSiTUEgiKBDIURgWOIHUiBHgNZLAFVEw0KCwcFgWYDN?=
 =?us-ascii?q?RIqFW4yHYEjPheBCxsHBYFLdnJqgQWFGCMmA06BLYF/XQMLGA1IESw3FBsEP?=
 =?us-ascii?q?m4HinUaD4E5cQcxUwsTOTyBBzAfkwQsAZI+gTWfWYQmoVsaM4QEpmeIR5A/g?=
 =?us-ascii?q?limaIFoPIFZMxoIGxU7gmdTGQ+OLRbOZScyPQIHAgcOAwuTBWABAQ?=
IronPort-Data: A9a23:9paW96hjPubDjAqK5urflEX7X161kREKZh0ujC45NGQN5FlHY01je
 htvX27TPvmNNGPzeN0jaI+zpE9S6sPdz99iSwZvrn8xQyxjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZeDULOZ82QsaDxMtvjc8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqVExe9ZRnxr6
 Mc7cgghUDCGg/+GwrKkH7wEasQLdKEHPasFsX1miDWcBvE8TNWaG+PB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWZgh/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9JozUHZ8OxR/Ez
 o7A1yfiGhBZDcOP82KcyH2AmPT1vH+qBY1HQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc/STUp0
 UeOgvvzCDBvuaHTQnWYnp+WqD60NCcVLEcYaCMERBdD6N7myKkpgwzCVM1LCqO5jtTpXzr3x
 liiqCQjgb4ai+YQyr62u1vAhlqEopnPUx5w5QjNWG+hxh12aZTjZIGy71Xfq/FaI+6xSliHo
 WhBgMOF7cgQApyX0i+AWuMAGPeu/fntDdHHqURkE59k83Gm/GSuONkIpjp/P0xudM0DfFcFf
 XPuhO+Y37cLVFPCUEO9S9jZ5xgCpUQ4KenYaw==
IronPort-HdrOrdr: A9a23:hDP3mKghsVqMmyJi3pxVb2jfSHBQXhAji2hC6mlwRA09TyVXra
 yTdZMgpHvJYVkqNk3I9errBEDEewK+yXcX2/h1AV7BZmjbUQKTRekI0WKh+UyDJ8SUzIFgPM
 lbHpRWOZnZEUV6gcHm4AOxDtoshOWc/LvAv5a4854Ud2FXQpAlyRtlAQCGFUAzbgxHCZ0lUK
 e43KN81lydkbB9VLXCOpHDNNKz3uH2qA==
X-Talos-CUID: =?us-ascii?q?9a23=3Abtf+yGjw8c2N+UAJdUWT4PBOGDJuLkLU4jDNBlK?=
 =?us-ascii?q?DKjxRZIO1TFuNyKFkjJ87?=
X-Talos-MUID: 9a23:0ZzMKgaMo86OmOBT9CT0hXJbK9dSu72UB2wTiq8n55jZOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="486023314"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:57:01 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 6D9F11800024C;
	Wed, 27 May 2026 19:56:59 +0000 (GMT)
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
Subject: [PATCH v2 11/13] scsi: fnic: Track NVMe transport statistics
Date: Wed, 27 May 2026 12:49:58 -0700
Message-ID: <20260527195000.8444-12-kartilak@cisco.com>
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

Add counters for NVMe requests, responses, LS handling, aborts, and
wait-queue activity.

Update NVMe I/O, completion, LS response, LS abort, and abort paths to
maintain the new counters.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fnic_nvme.c  | 186 ++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_stats.h |  21 ++++
 2 files changed, 205 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index dc202f0ae4d8..cf6a0ec963ea 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -59,6 +59,61 @@ static void nvfnic_update_io_bytes(struct fnic *fnic,
 		fnic->fcp_output_bytes += io_req->fcp_req->transferred_length;
 }
 
+static void nvfnic_update_io_stats(struct fnic *fnic, u8 opcode)
+{
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+
+	switch (opcode) {
+	case nvme_cmd_read:
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_input_requests);
+		break;
+	case nvme_cmd_write:
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_output_requests);
+		break;
+	default:
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_control_requests);
+		break;
+	}
+}
+
+static void nvfnic_update_cmpl_stats(struct fnic *fnic,
+				     struct fnic_io_req *io_req)
+{
+	struct io_path_stats *io_stats = &fnic->fnic_stats.io_stats;
+	atomic64_t *duration_stat;
+	unsigned long io_duration_time;
+
+	atomic64_dec(&io_stats->active_ios);
+	if (atomic64_read(&fnic->io_cmpl_skip))
+		atomic64_dec(&fnic->io_cmpl_skip);
+	else
+		atomic64_inc(&io_stats->io_completions);
+
+	io_duration_time = jiffies_to_msecs(jiffies - io_req->start_time);
+
+	if (io_duration_time <= 10)
+		duration_stat = &io_stats->io_btw_0_to_10_msec;
+	else if (io_duration_time <= 100)
+		duration_stat = &io_stats->io_btw_10_to_100_msec;
+	else if (io_duration_time <= 500)
+		duration_stat = &io_stats->io_btw_100_to_500_msec;
+	else if (io_duration_time <= 5000)
+		duration_stat = &io_stats->io_btw_500_to_5000_msec;
+	else if (io_duration_time <= 10000)
+		duration_stat = &io_stats->io_btw_5000_to_10000_msec;
+	else if (io_duration_time <= 30000)
+		duration_stat = &io_stats->io_btw_10000_to_30000_msec;
+	else {
+		duration_stat = &io_stats->io_greater_than_30000_msec;
+		if (io_duration_time >
+		    atomic64_read(&io_stats->current_max_io_time))
+			atomic64_set(&io_stats->current_max_io_time,
+				     io_duration_time);
+	}
+
+	atomic64_inc(duration_stat);
+}
+
 int
 nvfnic_alloc_fcpio_tag(struct fnic_iport_s *iport, struct fnic_io_req *io_req)
 {
@@ -129,6 +184,7 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 	struct scatterlist *sg;
 	struct fnic_tport_s *tport = io_req->tport;
 	struct host_sg_desc *desc;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	unsigned int i;
 	unsigned long intr_flags;
 	int flags;
@@ -165,6 +221,7 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], intr_flags);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "Enqueue failure: No descriptors\n");
+		atomic64_inc(&misc_stats->io_cpwq_alloc_failures);
 		return -EBUSY;
 	}
 
@@ -186,6 +243,11 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 					tport->max_payload_size, tport->r_a_tov,
 					tport->e_d_tov);
 
+	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
+	if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
+	    atomic64_read(&fnic->fnic_stats.fw_stats.max_fw_reqs))
+		atomic64_set(&fnic->fnic_stats.fw_stats.max_fw_reqs,
+		     atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs));
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], intr_flags);
 	return 0;
@@ -195,20 +257,24 @@ bool
 nvfnic_transport_ready(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 {
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	if (tport == NULL)
 		return false;
 
 	if (fdls_get_state(&iport->fabric) == FDLS_STATE_LINKDOWN ||
 	    iport->state != FNIC_IPORT_STATE_READY) {
+		atomic64_inc(&fnic_stats->misc_stats.iport_not_ready);
 		return false;
 	}
 
 	if (unlikely(fnic_chk_state_flags_locked(fnic, FNIC_FLAGS_IO_BLOCKED)))
 		return false;
 
-	if (fdls_tport_is_offline(tport))
+	if (fdls_tport_is_offline(tport)) {
+		atomic64_inc(&fnic_stats->misc_stats.tport_not_ready);
 		return false;
+	}
 
 	return true;
 }
@@ -218,6 +284,7 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 	struct fnic_iport_s *iport = io_req->iport;
 	struct fnic *fnic = iport->fnic;
 	struct fnic_tport_s *tport = io_req->tport;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct vnic_wq_copy *wq = io_req->wq;
 	int ret = 0;
 	int sg_count = 0;
@@ -251,6 +318,7 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 		    mempool_alloc(fnic->io_sgl_pool[io_req->sgl_type],
 				  GFP_ATOMIC);
 		if (!io_req->sgl_list) {
+			atomic64_inc(&fnic_stats->io_stats.alloc_failures);
 			FNIC_NVME_DBG(KERN_INFO, fnic,
 				      "Unable to alloc SGLs\n");
 			ret = -ENOMEM;
@@ -274,6 +342,7 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 
 	/* create copy wq desc and enqueue it */
 	idx = wq - &fnic->hw_copy_wq[0];
+	atomic64_inc(&fnic_stats->io_stats.ios[idx]);
 	ret = nvfnic_queue_wq_nvme_copy_desc(fnic, io_req->wq, io_req, sg_count);
 	if (ret) {
 		FNIC_NVME_DBG(KERN_ERR, fnic, "Unable to queue frame\n");
@@ -287,6 +356,13 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 			   (((u64)io_req->cmd_flags << 32) | io_req->cmd_state));
 		return ret;
 	}
+
+	atomic64_inc(&fnic_stats->io_stats.active_ios);
+	atomic64_inc(&fnic_stats->io_stats.num_ios);
+	if (atomic64_read(&fnic_stats->io_stats.active_ios) >
+	    atomic64_read(&fnic_stats->io_stats.max_active_ios))
+		atomic64_set(&fnic_stats->io_stats.max_active_ios,
+		     atomic64_read(&fnic_stats->io_stats.active_ios));
 	io_req->cmd_flags |= FNIC_IO_ISSUED;
  out:
 	lba = (char *)&cmdiu->sqe.rw.slba;
@@ -313,11 +389,14 @@ int nvfnic_fcpio_send(struct nvme_fc_local_port *lport,
 	struct fnic *fnic = iport->fnic;
 	unsigned long flags = 0;
 	struct fnic_tport_s *tport;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 	tport = (struct fnic_tport_s *)rport->private;
+	atomic64_inc(&fnic_stats->io_stats.nvme_io_reqs_rcvd);
 	if (!nvfnic_transport_ready(iport, tport)) {
+		atomic64_inc(&fnic_stats->io_stats.nvme_io_rsps_sent);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		FNIC_NVME_DBG(KERN_INFO, fnic,
 			      "iport: 0x%x tport: 0x%x not ready\n",
@@ -339,7 +418,9 @@ int nvfnic_fcpio_send(struct nvme_fc_local_port *lport,
 	if (io_req->tag == FNIC_NVME_NO_FREE_TAG) {
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "No free tag available. Failing IO\n");
+		atomic64_inc(&fnic_stats->io_stats.alloc_failures);
 		atomic_dec(&fnic->in_flight);
+		atomic64_inc(&fnic_stats->io_stats.nvme_io_rsps_sent);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return -EBUSY;
 	}
@@ -365,6 +446,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 	struct fcpio_tag ftag;
 	u32 id;
 	struct fnic_io_req *io_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	unsigned long start_time;
 	u64 cmd_trace;
 	char *lba;
@@ -390,6 +472,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "IO req null hdr: %s tag: 0x%x desc: 0x%p\n",
 			      fnic_fcpio_status_to_str(hdr_status), id, desc);
@@ -459,6 +542,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 	}
 
 	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		FNIC_NVME_DBG(KERN_INFO, fnic, "hdr status: %s\n",
 			    fnic_fcpio_status_to_str(hdr_status));
 	}
@@ -479,7 +563,9 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 		   (((u64) io_req->cmd_flags << 32) |
 		    io_req->cmd_state));
 
+	nvfnic_update_io_stats(fnic, cmdiu->sqe.rw.opcode);
 	nvfnic_update_io_bytes(fnic, io_req, cmdiu->sqe.rw.opcode);
+	nvfnic_update_cmpl_stats(fnic, io_req);
 
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 	if (io_req->done)
@@ -497,6 +583,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 	u32 id;
 	struct fcpio_nvme_cmpl *nvme_cmpl;
 	struct fnic_io_req *io_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	unsigned long start_time;
 	uint32_t rsplen;
 	struct nvme_fc_ersp_iu *ersp;
@@ -527,6 +614,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 
 	io_req = nvfnic_find_io_req_by_tag(fnic, tag);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "IOREQ is null hdr status: %s tag: 0x%x desc: %p\n",
 			    fnic_fcpio_status_to_str(hdr_status), tag, desc);
@@ -607,6 +695,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 			rsplen = be16_to_cpu(ersp->iu_len * 4);
 			memcpy(io_req->fcp_req->rspaddr, ersp, rsplen);
 		}
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_ersps);
 		io_req->fcp_req->rcv_rsplen = rsplen;
 		break;
 
@@ -618,6 +707,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 	}
 
 	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		FNIC_NVME_DBG(KERN_ERR, fnic, "hdr status: %s tag: 0x%x\n",
 			    fnic_fcpio_status_to_str(hdr_status), tag);
 	}
@@ -640,7 +730,9 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 		   (((u64) io_req->cmd_flags << 32) |
 		    io_req->cmd_state));
 
+	nvfnic_update_io_stats(fnic, cmdiu->sqe.rw.opcode);
 	nvfnic_update_io_bytes(fnic, io_req, cmdiu->sqe.rw.opcode);
+	nvfnic_update_cmpl_stats(fnic, io_req);
 
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 
@@ -661,6 +753,10 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	unsigned int tag;
 	struct fnic_io_req *io_req;
 	struct nvme_fc_cmd_iu *cmd_iu;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	struct abort_stats *abts_stats = &fnic->fnic_stats.abts_stats;
+	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	unsigned long start_time;
 	struct fnic_iport_s *iport;
 	struct fnic_tport_s *tport;
@@ -680,6 +776,7 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	io_req = nvfnic_find_io_req_by_tag(fnic, tag);
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "IOREQ null hdr:%s tag:0x%x desc:%p\n",
 			      fnic_fcpio_status_to_str(hdr_status), tag, desc);
@@ -711,6 +808,10 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 				"Abort timeout received tag: 0x%x id: 0x%x\n",
 			      tag, id);
+		if (io_req->cmd_flags & FNIC_IO_ABTS_ISSUED)
+			atomic64_inc(&abts_stats->abort_fw_timeouts);
+		else
+			atomic64_inc(&term_stats->terminate_fw_timeouts);
 		break;
 	case FCPIO_ITMF_REJECTED:
 		FNIC_NVME_DBG(KERN_ERR, fnic,
@@ -722,11 +823,19 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "Abort IO not found tag:0x%x id:0x%x\n",
 			      tag, id);
+		if (io_req->cmd_flags & FNIC_IO_ABTS_ISSUED)
+			atomic64_inc(&abts_stats->abort_io_not_found);
+		else
+			atomic64_inc(&term_stats->terminate_io_not_found);
 		break;
 	default:
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 				"Abort unknown received tag: 0x%x id: 0x%x\n",
 			    tag, id);
+		if (io_req->cmd_flags & FNIC_IO_ABTS_ISSUED)
+			atomic64_inc(&abts_stats->abort_failures);
+		else
+			atomic64_inc(&term_stats->terminate_failures);
 		break;
 	}
 
@@ -752,11 +861,18 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 
 	io_req->cmd_flags |= FNIC_IO_ABT_TERM_DONE;
 
+	if (!(io_req->cmd_flags & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
+		atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
 
 	if (io_req->abts_state == FCPIO_SUCCESS) {
 		io_req->fcp_req->transferred_length = 0;
 		io_req->fcp_req->rcv_rsplen = 0;
 		io_req->fcp_req->status = NVME_SC_ABORT_REQ;
+		atomic64_dec(&fnic_stats->io_stats.active_ios);
+		if (atomic64_read(&fnic->io_cmpl_skip))
+			atomic64_dec(&fnic->io_cmpl_skip);
+		else
+			atomic64_inc(&fnic_stats->io_stats.io_completions);
 
 		nvfnic_release_nvme_ioreq_buf(iport, io_req);
 		if (io_req->done)
@@ -913,9 +1029,14 @@ bool _terminate_tport_ios(struct sbitmap *map, unsigned int tag,
 void nvfnic_terminate_tport_ios(struct fnic *fnic,
 				     struct fnic_tport_s *tport)
 {
+	struct abort_stats *abts_stats = &fnic->fnic_stats.abts_stats;
 
 	sbitmap_for_each_set(&fnic->nvfnic_tag_map, _terminate_tport_ios, tport);
 
+	FNIC_NVME_DBG(KERN_INFO, fnic,
+		      "tport: 0x%x aborted %lld in_flight %d\n",
+		      tport->fcid, atomic64_read(&abts_stats->aborts),
+		      atomic_read(&fnic->in_flight));
 }
 
 bool _cleanup_all_nvme_io(struct sbitmap *map, unsigned int tag,
@@ -1044,11 +1165,14 @@ nvfnic_find_ls_req(struct fnic_tport_s *tport, uint16_t oxid)
 void nvfnic_fcpio_cmpl(struct fnic_io_req *io_req)
 {
 	struct fnic *fnic = io_req->iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	nvfnic_free_fcpio_tag(io_req->iport, io_req);
+	atomic64_inc(&fnic_stats->io_stats.nvme_ios_queued_for_rsp);
 
 	llist_add(&io_req->nvfnic_io_cmpl, &fnic->nvme_io_event_llist);
 	atomic_inc(&fnic->nvme_io_event_queued);
+	atomic64_inc(&fnic_stats->io_stats.nvme_num_ios_in_waitq);
 
 	io_req->waitq_start_time = jiffies;
 	queue_work(fnic_cmpl_queue, &fnic->nvme_io_cmpl_work);
@@ -1064,6 +1188,7 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
 	uint8_t *fcid;
 	uint16_t oxid = FNIC_STD_GET_OX_ID(fchdr);
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tport_fcid = ntoh24(fcid);
@@ -1091,8 +1216,12 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
 		return;
 	}
 
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_abort_responses);
 	nvfnic_ls_req->state = FNIC_LS_REQ_ABTS_COMPLETE;
 
+	FNIC_NVME_DBG(KERN_DEBUG, fnic, "nvme_ls_requests: %lld\n",
+		      (u64) atomic64_read(&fnic_stats->nvme_stats.nvme_ls_requests));
+
 	list_del(&nvfnic_ls_req->list);
 	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
 	lsreq->private = NULL;
@@ -1123,6 +1252,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 	struct nvmefc_ls_req *lsreq;
 	uint16_t oxid;
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tport_fcid = ntoh24(fcid);
@@ -1166,6 +1296,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 	}
 
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_responses);
 
 	list_del_init(&nvfnic_ls_req->list);
 	lsreq->private = NULL;
@@ -1194,6 +1325,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct nvmefc_ls_req *ls_req = nvfnic_ls_req->ls_req;
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t oxid = nvfnic_ls_req->oxid;
 	int timeout;
 
@@ -1230,6 +1362,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 			      "tport: 0x%x lsreq: 0x%x sending abort\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
 		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_aborts);
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 
 		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) == 0) {
@@ -1284,6 +1417,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 	struct nvmefc_ls_req *pls_req;
 	struct fnic *fnic = iport->fnic;
 	struct fc_std_ls_req *pfc_std_ls_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct nvfnic_ls_req *nvfnic_ls_req = ls_req->private;
 	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
 			sizeof(struct fc_frame_header) + ls_req->rqstlen;
@@ -1320,6 +1454,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 		return -EAGAIN;
 	}
 
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_requests);
 	timer_setup(&nvfnic_ls_req->ls_req_timer, nvfnic_ls_req_timeout,
 		     0UL);
 
@@ -1354,6 +1489,11 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 		 iport->fcid, nvfnic_ls_req->oxid, *((uint8_t *) ls_req->rqstaddr),
 		 ls_req->rqstlen);
 
+	FNIC_NVME_DBG(KERN_INFO, fnic,
+		 "0x%x: ls_reqs count: %lld",
+		 iport->fcid,
+		 (u64) atomic64_read(&fnic_stats->nvme_stats.nvme_ls_requests));
+
 	list_add_tail(&nvfnic_ls_req->list, &tport->ls_req_list);
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_PENDING;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -1469,6 +1609,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	struct fnic *fnic = iport->fnic;
 	struct fnic_tport_s *tport;
 	struct nvfnic_ls_req *nvfnic_ls_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t oxid;
 	int timeout;
 
@@ -1529,6 +1670,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 
 	/* Mark the state and flags */
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_aborts);
 	timeout = FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
 	mod_timer(&nvfnic_ls_req->ls_req_timer,
 		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
@@ -1542,6 +1684,7 @@ bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
 {
 	int idx;
 	unsigned long flags;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 
 	idx = io_req->wq - &fnic->hw_copy_wq[0];
 
@@ -1557,12 +1700,18 @@ bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
 		atomic_dec(&fnic->in_flight);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 				"tag 0x%x failure: no descriptors\n", tag);
+		atomic64_inc(&misc_stats->abts_cpwq_alloc_failures);
 		return false;
 	}
 	fnic_queue_wq_copy_desc_itmf(io_req->wq, tag | FNIC_TAG_ABORT,
 				     0, task_req, tag, NULL, io_req->port_id,
 				     fnic->config.ra_tov, fnic->config.ed_tov);
 
+	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
+	if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
+	    atomic64_read(&fnic->fnic_stats.fw_stats.max_fw_reqs))
+		atomic64_set(&fnic->fnic_stats.fw_stats.max_fw_reqs,
+			     atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs));
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], flags);
 	atomic_dec(&fnic->in_flight);
@@ -1579,9 +1728,14 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
 	struct nvme_fc_cmd_iu *cmd_iu = fcp_req->cmdaddr;
 	struct fnic_io_req *io_req = (struct fnic_io_req *)fcp_req->private;
 	unsigned int tag = io_req->tag;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	struct abort_stats *abts_stats;
+	struct terminate_stats *term_stats;
 	unsigned long flags = 0;
+	unsigned long abt_issued_time;
 	unsigned int task_req;
 	enum fnic_ioreq_state old_ioreq_state;
+	unsigned long num_ios_waitq, waitq_2sec, waitq_max_time;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
@@ -1597,6 +1751,15 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
 		FNIC_NVME_DBG(KERN_INFO, fnic,
 			      "cmd tag freed or not issued:0x%x sn:0x%08x\n",
 			      io_req->tag, be32_to_cpu(cmd_iu->csn));
+		num_ios_waitq =
+		    atomic64_read(&fnic_stats->io_stats.nvme_num_ios_in_waitq);
+		waitq_2sec =
+		    atomic64_read(&fnic_stats->io_stats.nvme_ios_in_waitq_3000_msec);
+		waitq_max_time =
+		    atomic64_read(&fnic_stats->io_stats.nvme_ios_in_waitq_max_time);
+		FNIC_NVME_DBG(KERN_INFO, fnic,
+			      "waitq:%ld waitq_2sec:%ld max_wait:%ld\n",
+			      num_ios_waitq, waitq_2sec, waitq_max_time);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return;
 	}
@@ -1644,7 +1807,26 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
 		task_req = FCPIO_ITMF_ABT_TASK;
 	}
 
-
+	abts_stats = &fnic->fnic_stats.abts_stats;
+	term_stats = &fnic->fnic_stats.term_stats;
+	atomic64_inc(&abts_stats->aborts);
+
+	abt_issued_time = jiffies_to_msecs(jiffies) -
+			jiffies_to_msecs(io_req->start_time);
+	if (abt_issued_time <= 6000)
+		atomic64_inc(&abts_stats->abort_issued_btw_0_to_6_sec);
+	else if (abt_issued_time > 6000 && abt_issued_time <= 20000)
+		atomic64_inc(&abts_stats->abort_issued_btw_6_to_20_sec);
+	else if (abt_issued_time > 20000 && abt_issued_time <= 30000)
+		atomic64_inc(&abts_stats->abort_issued_btw_20_to_30_sec);
+	else if (abt_issued_time > 30000 && abt_issued_time <= 40000)
+		atomic64_inc(&abts_stats->abort_issued_btw_30_to_40_sec);
+	else if (abt_issued_time > 40000 && abt_issued_time <= 50000)
+		atomic64_inc(&abts_stats->abort_issued_btw_40_to_50_sec);
+	else if (abt_issued_time > 50000 && abt_issued_time <= 60000)
+		atomic64_inc(&abts_stats->abort_issued_btw_50_to_60_sec);
+	else
+		atomic64_inc(&abts_stats->abort_issued_greater_than_60_sec);
 
 	old_ioreq_state = io_req->cmd_state;
 	io_req->cmd_state = FNIC_IOREQ_ABTS_PENDING;
diff --git a/drivers/scsi/fnic/fnic_stats.h b/drivers/scsi/fnic/fnic_stats.h
index 8ddd20401a59..fc81e4a7e29e 100644
--- a/drivers/scsi/fnic/fnic_stats.h
+++ b/drivers/scsi/fnic/fnic_stats.h
@@ -29,6 +29,15 @@ struct io_path_stats {
 	atomic64_t io_greater_than_30000_msec;
 	atomic64_t current_max_io_time;
 	atomic64_t ios[FNIC_MQ_MAX_QUEUES];
+
+	atomic64_t nvme_io_reqs_rcvd;
+	atomic64_t nvme_ios_queued_for_rsp;
+	atomic64_t nvme_io_rsps_unqueued;
+	atomic64_t nvme_io_rsps_sending;
+	atomic64_t nvme_io_rsps_sent;
+	atomic64_t nvme_num_ios_in_waitq;
+	atomic64_t nvme_ios_in_waitq_3000_msec;
+	atomic64_t nvme_ios_in_waitq_max_time;
 };
 
 struct abort_stats {
@@ -151,6 +160,17 @@ struct fnic_iport_stats {
 	atomic64_t unsupported_frames_dropped;
 };
 
+struct nvme_host_statistics {
+	atomic64_t nvme_input_requests;
+	atomic64_t nvme_output_requests;
+	atomic64_t nvme_control_requests;
+	atomic64_t nvme_ersps;
+	atomic64_t nvme_ls_requests;
+	atomic64_t nvme_ls_responses;
+	atomic64_t nvme_ls_aborts;
+	atomic64_t nvme_ls_abort_responses;
+};
+
 struct fnic_stats {
 	struct stats_timestamps stats_timestamps;
 	struct io_path_stats io_stats;
@@ -161,6 +181,7 @@ struct fnic_stats {
 	struct vlan_stats vlan_stats;
 	struct fc_host_statistics host_stats;
 	struct misc_stats misc_stats;
+	struct nvme_host_statistics nvme_stats;
 };
 
 struct stats_debug_info {
-- 
2.47.1

