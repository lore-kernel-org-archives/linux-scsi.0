Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D2D5263C8C;
	Wed, 24 Jun 2026 04:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276624; cv=none; b=OJAryVfYSd7helva5INR4z6oJSN2kso1ZZYTz/t1+jUPC6refIMaLm9yV8S7EU39UMpq1VsYuIe0+88t2Bcw72niOlYRLGOaB9aqO5+h5IQV/OxdifCj08usJqXn2FD+yRCrvCnjivn3jSr3wTEtU6obRaxfDXcgFu9Rs6P+faU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276624; c=relaxed/simple;
	bh=ugV7bJwbdM3w/68TIVfhEb3Ttvinrjo4idVdj72r8kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKDEfyxHNLZPHl7TssAbreZeiBocOQughUIHUWB/eos9ymdA5RvL0PSXKZi+l/2t4HLt5TkD7teOL6zexU/Ri5/cK0tQSb2elVJpF8h3OgygNIeIaLqEgg6nKCvSa4znHeACGGr0nIr9AnuYfN94WIGeZOOUVBBn6i6WJo807k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=DlQSACli; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="DlQSACli"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=23627; q=dns/txt;
  s=iport01; t=1782276622; x=1783486222;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UMkq7qpiyJOXAgKB9Pn8F8z/sSf4+1HBRxQi2pB6aQ4=;
  b=DlQSAClis8HxvVsp5ccgGiEP2UP+3bnRE7mSdMO+b0W8jR5e3S2Wigd2
   dO6uDXFinZ043/I7zqJTIguyIEurdwKrxQQDmC7L8zlUB6WW5qC+hKVZ0
   h8K0MuIsrtxCKitQnIL3bCm25ENfUVLxMD7/bbypZPIGhRpDx58dO4wwZ
   He6pvZDiMD/ZQ1Lh0QENnf0AYDj8WUgSfd5NPu0wvz7ct4chgxEHs79kc
   hNeiE0x56kMwbp2JnZeyjcVYqIjcB6zJkzFAGqmY19Wqx+RMN61BowJLj
   Ik9tdEhca0uToaPEyOQmYpbC6UtV7QipuWJbrBO/2XgZInRhDpCAinxDV
   A==;
X-CSE-ConnectionGUID: JzM0Mio0RWSJMT89+61nAA==
X-CSE-MsgGUID: nlHJa2l8S+2EzBsxSkjQjQ==
X-IPAS-Result: =?us-ascii?q?A0BFAgB4YDtq/4//Ja1aglmCV3ReQxkwBJQmgiGeHoF+D?=
 =?us-ascii?q?wEBAQ9EDQQBAYUGAo1KAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4Thk8NhlsCAQMaDQsBRhBRVhAJgwIBgnMDEbIkgXkzgQHeQ4FmAQUGF?=
 =?us-ascii?q?AGBOI1edIR8JxUGgUlEgRWDaYFSiTYEgiKBDIQcgWKLBEiBHgNZLAFVEw0KC?=
 =?us-ascii?q?wcFgWYDNRIqFW4yHYEjPheBDBsHBYEdgW6BBIUCIx8DOX+BP4EkZGYVMDWBA?=
 =?us-ascii?q?QERHwqBNQMLGA1IESw3FBsEPm4HjF0XD4FFcQcxUwsTGCEBO4E2AR9EkkAsA?=
 =?us-ascii?q?ZI+gTWfWoQnjCGVOhozhASmaIhIkECCWYsxmziBaDyBWTMaCBsVO4JnE0AZD?=
 =?us-ascii?q?44tFohzyUcnMgIBOgIHAgcOAwuTBWABAQ?=
IronPort-Data: A9a23:1tan7qOpiCFn1ELvrR0jlsFynXyQoLVcMsEvi/4bfWQNrUp01GcFy
 2MZDDuEbq3cNDPwfNx1PYq190hXvcPXnIdqTHM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCeaphyFTmE+kvF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WV/lV
 e/a+ZWFZgf7gWUsaAr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj69d8KRkTPIpAwNlMI0Ryp
 a1bdmkLRznW0opawJrjIgVtrt4oIM+uOMYUvWttiGmHS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzN3wsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQtgem2a4SJJ4ziqcN9mEK4h
 Guc+zTCQUs3JvaE2QGG8Euuv7qa9c/8cMdIfFGizdZug0W7x2oPBRlQXly+ydG5g1Szc9FSM
 UoZ/mwpt6da3E6mTNPVWxy+vW7CvxQZHdFXFoUS7QiX1qvSpR6UGmUeVTNHQNs8vcQySHoh0
 Vrht9rlDD9oqLqIYWiQ+redsXW5Pi19BW0HaCkJQgsEy8PurIE6klTESdMLOLS4kNDvAhnqz
 jyKpTR4jLIW5eYP27i99lnBqymxvZWPRQkwji3TX2S4/kZ6aZSjaoiA91fW97BDIZyfQ13Hu
 2IL8+Ca7eYTHdSWnzeMaPsCEavv5PufNjDYx1l1EPEcGy+F4XWve8VUpTp5PkosaphCcj7ya
 0iVsgRUjHNOAEaXgWZMS9rZI6wXIWLITLwJiti8ggJyX6VM
IronPort-HdrOrdr: A9a23:ramUD6g9d2zu0eiVWlZ86KwZpnBQXhAji2hC6mlwRA09TyVXra
 yTdZMgpHvJYVkqNk3I9errBEDEewK+yXcX2/h1AV7BZmjbUQKTRekI0WKh+UyDJ8SUzIFgPM
 lbHpRWOZnZEUV6gcHm4AOxDtoshOWc/LvAv5a4854Ud2FXQpAlyRtlAQCGFUAzbgxHCZ0lUK
 e43KN81lydkbB9VLXCOpHDNNKz3uH2qA==
X-Talos-CUID: 9a23:+AE8Z27/2FdoYeIZx9ss1lwxQuUkdSXn80zyBnPoWCU3Ebu8YArF
X-Talos-MUID: =?us-ascii?q?9a23=3AxewSfQ3jmc4S7riL+aCxGoUc2zUj5aCOKklXlcU?=
 =?us-ascii?q?9+JOpJwZrKwyejg21e9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499336458"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:50:21 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id A6706180003A1;
	Wed, 24 Jun 2026 04:50:19 +0000 (GMT)
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
	kernel test robot <lkp@intel.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH v5 11/13] scsi: fnic: Track NVMe transport statistics
Date: Tue, 23 Jun 2026 21:43:32 -0700
Message-ID: <20260624044334.3079-12-kartilak@cisco.com>
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

Add counters for NVMe requests, responses, LS handling, aborts, and
wait-queue activity.

Update NVMe I/O, completion, LS response, LS abort, and abort paths to
maintain the new counters.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605280619.pmobiDWp-lkp@intel.com/
Closes: https://lore.kernel.org/oe-kbuild-all/202605280519.Jd4fmgAZ-lkp@intel.com/
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>

---
Incorporate review comments from Lee Duncan:
        Convert the NVMe opcode stats helper to a switch statement.
        Share NVMe completion stats accounting and compute duration
        once.

Changes between v2 and v3:
Fix issues reported by kernel bot.

Changes between v3 and v4:
Incorporate review comments from Sashiko:
	Decrement NVMe completion wait queue counter when draining completions
	Preserve jiffies wrap when computing NVMe abort stats
---
 drivers/scsi/fnic/fnic_nvme.c  | 188 ++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_stats.h |  21 ++++
 2 files changed, 207 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index c4de6606c0b2..e322dd4dcb78 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -71,6 +71,61 @@ static void nvfnic_update_io_bytes(struct fnic *fnic,
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
@@ -141,6 +196,7 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 	struct scatterlist *sg;
 	struct fnic_tport_s *tport = io_req->tport;
 	struct host_sg_desc *desc;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	unsigned int i;
 	unsigned long intr_flags;
 	int flags;
@@ -177,6 +233,7 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 		spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], intr_flags);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "Enqueue failure: No descriptors\n");
+		atomic64_inc(&misc_stats->io_cpwq_alloc_failures);
 		return -EBUSY;
 	}
 
@@ -198,6 +255,11 @@ inline int nvfnic_queue_wq_nvme_copy_desc(struct fnic *fnic,
 					tport->max_payload_size, tport->r_a_tov,
 					tport->e_d_tov);
 
+	atomic64_inc(&fnic->fnic_stats.fw_stats.active_fw_reqs);
+	if (atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs) >
+	    atomic64_read(&fnic->fnic_stats.fw_stats.max_fw_reqs))
+		atomic64_set(&fnic->fnic_stats.fw_stats.max_fw_reqs,
+		     atomic64_read(&fnic->fnic_stats.fw_stats.active_fw_reqs));
 
 	spin_unlock_irqrestore(&fnic->wq_copy_lock[idx], intr_flags);
 	return 0;
@@ -207,20 +269,24 @@ bool
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
@@ -230,11 +296,14 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 	struct fnic_iport_s *iport = io_req->iport;
 	struct fnic *fnic = iport->fnic;
 	struct fnic_tport_s *tport = io_req->tport;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	struct vnic_wq_copy *wq = io_req->wq;
 	int ret = 0;
 	int sg_count = 0;
 	unsigned long ptr;
 	unsigned char *lba;
 	u64 cmd_trace;
+	int idx;
 	struct nvme_fc_cmd_iu *cmdiu = io_req->fcp_req->cmdaddr;
 
 	io_req->cmd_state = FNIC_IOREQ_NOT_INITED;
@@ -261,6 +330,7 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 		    mempool_alloc(fnic->io_sgl_pool[io_req->sgl_type],
 				  GFP_ATOMIC);
 		if (!io_req->sgl_list) {
+			atomic64_inc(&fnic_stats->io_stats.alloc_failures);
 			FNIC_NVME_DBG(KERN_INFO, fnic,
 				      "Unable to alloc SGLs\n");
 			ret = -ENOMEM;
@@ -283,6 +353,8 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
 	io_req->cmd_flags = FNIC_IO_INITIALIZED;
 
 	/* create copy wq desc and enqueue it */
+	idx = wq - &fnic->hw_copy_wq[0];
+	atomic64_inc(&fnic_stats->io_stats.ios[idx]);
 	ret = nvfnic_queue_wq_nvme_copy_desc(fnic, io_req->wq, io_req, sg_count);
 	if (ret) {
 		FNIC_NVME_DBG(KERN_ERR, fnic, "Unable to queue frame\n");
@@ -296,6 +368,13 @@ int nvfnic_queuecommand(struct fnic_io_req *io_req)
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
@@ -322,11 +401,14 @@ int nvfnic_fcpio_send(struct nvme_fc_local_port *lport,
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
 		if (tport != NULL)
 			FNIC_NVME_DBG(KERN_INFO, fnic,
@@ -353,7 +435,9 @@ int nvfnic_fcpio_send(struct nvme_fc_local_port *lport,
 	if (io_req->tag == FNIC_NVME_NO_FREE_TAG) {
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "No free tag available. Failing IO\n");
+		atomic64_inc(&fnic_stats->io_stats.alloc_failures);
 		atomic_dec(&fnic->in_flight);
+		atomic64_inc(&fnic_stats->io_stats.nvme_io_rsps_sent);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return -EBUSY;
 	}
@@ -379,6 +463,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 	struct fcpio_tag ftag;
 	u32 id;
 	struct fnic_io_req *io_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	unsigned long start_time;
 	u64 cmd_trace;
 	char *lba;
@@ -403,6 +488,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "IO req null hdr: %s tag: 0x%x desc: 0x%p\n",
 			      fnic_fcpio_status_to_str(hdr_status), id, desc);
@@ -471,6 +557,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 	}
 
 	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		FNIC_NVME_DBG(KERN_INFO, fnic, "hdr status: %s\n",
 			    fnic_fcpio_status_to_str(hdr_status));
 	}
@@ -491,7 +578,9 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 		   (((u64) io_req->cmd_flags << 32) |
 		    io_req->cmd_state));
 
+	nvfnic_update_io_stats(fnic, cmdiu->sqe.rw.opcode);
 	nvfnic_update_io_bytes(fnic, io_req, cmdiu->sqe.rw.opcode);
+	nvfnic_update_cmpl_stats(fnic, io_req);
 
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 	if (io_req->done)
@@ -509,6 +598,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 	u32 id;
 	struct fcpio_nvme_cmpl *nvme_cmpl;
 	struct fnic_io_req *io_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	unsigned long start_time;
 	uint32_t rsplen;
 	struct nvme_fc_ersp_iu *ersp;
@@ -539,6 +629,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 
 	io_req = nvfnic_find_io_req_by_tag(fnic, tag);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "IOREQ is null hdr status: %s tag: 0x%x desc: %p\n",
 			    fnic_fcpio_status_to_str(hdr_status), tag, desc);
@@ -631,6 +722,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 			}
 			memcpy(io_req->fcp_req->rspaddr, ersp, rsplen);
 		}
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_ersps);
 		io_req->fcp_req->rcv_rsplen = rsplen;
 		break;
 
@@ -642,6 +734,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 	}
 
 	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		FNIC_NVME_DBG(KERN_ERR, fnic, "hdr status: %s tag: 0x%x\n",
 			    fnic_fcpio_status_to_str(hdr_status), tag);
 	}
@@ -664,7 +757,9 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 		   (((u64) io_req->cmd_flags << 32) |
 		    io_req->cmd_state));
 
+	nvfnic_update_io_stats(fnic, cmdiu->sqe.rw.opcode);
 	nvfnic_update_io_bytes(fnic, io_req, cmdiu->sqe.rw.opcode);
+	nvfnic_update_cmpl_stats(fnic, io_req);
 
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 
@@ -685,6 +780,10 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	unsigned int tag;
 	struct fnic_io_req *io_req;
 	struct nvme_fc_cmd_iu *cmd_iu;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	struct abort_stats *abts_stats = &fnic->fnic_stats.abts_stats;
+	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	struct fnic_iport_s *iport;
 
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &ftag);
@@ -702,6 +801,7 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	io_req = nvfnic_find_io_req_by_tag(fnic, tag);
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "IOREQ null hdr:%s tag:0x%x desc:%p\n",
 			      fnic_fcpio_status_to_str(hdr_status), tag, desc);
@@ -730,6 +830,10 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
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
@@ -741,11 +845,19 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
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
 
@@ -771,6 +883,8 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 
 	io_req->cmd_flags |= FNIC_IO_ABT_TERM_DONE;
 
+	if (!(io_req->cmd_flags & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
+		atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
 
 	io_req->fcp_req->transferred_length = 0;
 	io_req->fcp_req->rcv_rsplen = 0;
@@ -779,6 +893,12 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	else
 		io_req->fcp_req->status = NVME_SC_INTERNAL;
 
+	atomic64_dec(&fnic_stats->io_stats.active_ios);
+	if (atomic64_read(&fnic->io_cmpl_skip))
+		atomic64_dec(&fnic->io_cmpl_skip);
+	else
+		atomic64_inc(&fnic_stats->io_stats.io_completions);
+
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 	if (io_req->done)
 		io_req->done(io_req);
@@ -951,9 +1071,14 @@ bool _terminate_tport_ios(struct sbitmap *map, unsigned int tag,
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
@@ -1083,12 +1208,15 @@ nvfnic_find_ls_req(struct fnic_tport_s *tport, uint16_t oxid)
 void nvfnic_fcpio_cmpl(struct fnic_io_req *io_req)
 {
 	struct fnic *fnic = io_req->iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	nvfnic_free_fcpio_tag(io_req->iport, io_req);
+	atomic64_inc(&fnic_stats->io_stats.nvme_ios_queued_for_rsp);
 	io_req->waitq_start_time = jiffies;
 
 	llist_add(&io_req->nvfnic_io_cmpl, &fnic->nvme_io_event_llist);
 	atomic_inc(&fnic->nvme_io_event_queued);
+	atomic64_inc(&fnic_stats->io_stats.nvme_num_ios_in_waitq);
 
 	queue_work(fnic_cmpl_queue, &fnic->nvme_io_cmpl_work);
 }
@@ -1103,6 +1231,7 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
 	uint8_t *fcid;
 	uint16_t oxid = FNIC_STD_GET_OX_ID(fchdr);
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tport_fcid = ntoh24(fcid);
@@ -1130,8 +1259,12 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
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
@@ -1166,6 +1299,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 		      sizeof(fchdr->fh_s_id);
 	int status = 0;
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	if (len < (int)sizeof(*fchdr)) {
 		if (len >= sid_len) {
@@ -1231,6 +1365,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 	}
 
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_responses);
 
 	list_del_init(&nvfnic_ls_req->list);
 	lsreq->private = NULL;
@@ -1277,6 +1412,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct nvmefc_ls_req *ls_req = nvfnic_ls_req->ls_req;
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t oxid = nvfnic_ls_req->oxid;
 	int timeout;
 
@@ -1311,6 +1447,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 			      "tport: 0x%x lsreq: 0x%x sending abort\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
 		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_aborts);
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 
 		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) == 0) {
@@ -1363,6 +1500,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 	uint8_t *ls_req_payload;
 	struct fnic *fnic = iport->fnic;
 	struct fc_frame_header *fchdr;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct nvfnic_ls_req *nvfnic_ls_req = ls_req->private;
 	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
 			sizeof(struct fc_frame_header) + ls_req->rqstlen;
@@ -1405,6 +1543,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 		return -EAGAIN;
 	}
 
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_requests);
 	timer_setup(&nvfnic_ls_req->ls_req_timer, nvfnic_ls_req_timeout,
 		     0UL);
 
@@ -1437,6 +1576,11 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 		 iport->fcid, nvfnic_ls_req->oxid, *((uint8_t *) ls_req->rqstaddr),
 		 ls_req->rqstlen);
 
+	FNIC_NVME_DBG(KERN_INFO, fnic,
+		 "0x%x: ls_reqs count: %lld",
+		 iport->fcid,
+		 (u64) atomic64_read(&fnic_stats->nvme_stats.nvme_ls_requests));
+
 	list_add_tail(&nvfnic_ls_req->list, &tport->ls_req_list);
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_PENDING;
 
@@ -1559,6 +1703,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	struct fnic *fnic = iport->fnic;
 	struct fnic_tport_s *tport;
 	struct nvfnic_ls_req *nvfnic_ls_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t oxid;
 	int timeout;
 	int ret;
@@ -1620,6 +1765,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 
 	/* Mark the state and flags */
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_aborts);
 	oxid = nvfnic_ls_req->oxid;
 
 	ret = fdls_send_ls_req_abts(iport, tport, oxid);
@@ -1645,6 +1791,7 @@ bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
 {
 	int idx;
 	unsigned long flags;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 
 	idx = io_req->wq - &fnic->hw_copy_wq[0];
 
@@ -1660,12 +1807,18 @@ bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
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
@@ -1682,9 +1835,13 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
 	struct nvme_fc_cmd_iu *cmd_iu = fcp_req->cmdaddr;
 	struct fnic_io_req *io_req = (struct fnic_io_req *)fcp_req->private;
 	unsigned int tag = io_req->tag;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	struct abort_stats *abts_stats;
 	unsigned long flags = 0;
+	unsigned long abt_issued_time;
 	unsigned int task_req;
 	enum fnic_ioreq_state old_ioreq_state;
+	unsigned long num_ios_waitq, waitq_2sec, waitq_max_time;
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
@@ -1700,6 +1857,15 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
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
@@ -1747,7 +1913,24 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
 		task_req = FCPIO_ITMF_ABT_TASK;
 	}
 
-
+	abts_stats = &fnic->fnic_stats.abts_stats;
+	atomic64_inc(&abts_stats->aborts);
+
+	abt_issued_time = jiffies_to_msecs(jiffies - io_req->start_time);
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
@@ -1800,6 +1983,7 @@ void nvfnic_nvme_iodone_work(struct work_struct *work)
 	llnode = llist_del_all(&fnic->nvme_io_event_llist);
 	llist_for_each_entry_safe(io_req, tmp, llnode, nvfnic_io_cmpl) {
 		atomic_dec(&fnic->nvme_io_event_queued);
+		atomic64_dec(&fnic->fnic_stats.io_stats.nvme_num_ios_in_waitq);
 		io_req->fcp_req->done(io_req->fcp_req);
 	}
 }
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

