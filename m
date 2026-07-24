Received: from alln-iport-5.cisco.com (alln-iport-5.cisco.com [173.37.142.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B0EC8CE;
	Fri, 24 Jul 2026 17:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915684; cv=none; b=M/ZdV0Ut8BZdTDlVt6OM6yxRevTW2j0xrTGrHm/z5cHp0yye5OsCcBoUk7r2G62OTQS6M+zuuVuqvXu4xcVN//zmKS2T+1kb1CfAM0PNW8P0ZObieJLzsStpsjJ/8x3ws/bwXl1V1ba248TQ1uuU1++cj8olG+BrDkr85kYOA9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915684; c=relaxed/simple;
	bh=ItzVRVBJlzKSRdxfn6O+ySl+d4bJK/JhTPMkZSi96Pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLSjnjbV360oai17YTbLcRZnRw9xXp08IGwPV2YhLH+lKxWbt9Jkjtm0/Djpj+A1JK01zyoY00JpALyMxhcDdr8ZFFHa8kacJtS0y8iUjMrq5iAN9fc0s5ICmmBR+oBntLmsnHeb9Xp8TBGXEwyE6W7J803bfVi7we/SxiAX9Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=NGnqdjtR; arc=none smtp.client-ip=173.37.142.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="NGnqdjtR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=23617; q=dns/txt;
  s=iport01; t=1784915682; x=1786125282;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YxV8C/bAmatMWTkW+jxNJDdeNRrWDjOZ9SFf4DUXCfE=;
  b=NGnqdjtRK8LR/JO2UcG3RnmbEQaHGCU7Xl9oanGd9HqYcg8kg2W+lrK7
   qSyG9UC4i+ARSUtnVMn4iEIUMb/zXo2zWNhAOEXZYDWDZ0VC2JsIgg69Z
   MG+r2Vmka091srQTmlCGnAhisIIeRWGO0JWHfqPyNHiMLinAZ/ky3817M
   JWPJCPcNT5et1AkkNlHrXDpZlsDatkH7p14Qhw5q9e8aAgAjpWGa/Rs3X
   MJ7ZqefWXN9E6KY9ol7nKgltyUJflzBqfUZ9tQ1flPxKxNcUaiSzutnbW
   muAUHrdtDYJ5XDrSOK9wbmqqE789CjOXuZj45SyueTePVvsDE+EVXr9uJ
   A==;
X-CSE-ConnectionGUID: od1eZww4TYW8D95rmXVvFw==
X-CSE-MsgGUID: gMSr6wSfQTmoe0cmdXzlkg==
X-IPAS-Result: =?us-ascii?q?A0BFAgBZpmNq/5AQJK1aglmCV3ReQxkwBJQlgiGeHoF+D?=
 =?us-ascii?q?wEBAQ9EDQQBAYUFAo1gAiY0CQ4BAgQDAgMBAQEBAQEBAQEBAQsBAQUBAQECA?=
 =?us-ascii?q?QcFgQ4Thk8NhlsCAQMaDQsBRhBRVhAJgwIBgnQDEcIfgXkzgQHeRYFmAQUGF?=
 =?us-ascii?q?AGBOI1fdYR8JxUGgUlEgRWDaYFSiTYEgiKBDINkgWGMe0iBHgNZLAFVEw0KC?=
 =?us-ascii?q?wcFgWYDNRIqFW4yHYEjPheBDBsHBYEdgSx5hFgjHwM5f4EvdUp3LWkBEheBJ?=
 =?us-ascii?q?oNLAoFPAwsYDUgRLDcUGQQ+bgeNdyOBSHEHMVMLExghATuBNgEfRJJALAGSP?=
 =?us-ascii?q?oE1n1qEJ4whlToaM4QEpmiISJBAglmLMZs5gWg8gVkzGggbFTuCZxNAGQ+OL?=
 =?us-ascii?q?RaIc8lHJzICAToBAQcCBw4DC4FokR5gAQE?=
IronPort-Data: A9a23:7HeNTaqCWtZqYsTbnqdnJ0Qp98xeBmKfZBIvgKrLsJaIsI4StFCzt
 garIBmHbqnfM2P3fdF+aN7lp0pUvpDQmNdgQQBvqy9kFHwR9+PIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgLNNwJcaDpOtfrc8k825ZwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0uF7WGx86
 uNEFAEyPjzS2viz8IylZPY506zPLOGzVG8eknhkyTecCbMtRorOBv2Vo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtLYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoPaFZgPxh/C9
 woq+Uz2JyoAasOkxwO593Wh3uTKkRPpXIEdQejQGvlCxQf7KnYoIBkVTXO6p+W0jgi1XNc3A
 0wd4CcGrqUo8kGvCN7nUHWQonOGtDYYWtxNA6s74gTLwa3Riy6cD3IYTzgHcNE6udUtSDoC0
 UWAlNfkQzdotdW9QH6U9bCMqi6aIyUZLWYeIyQDSGMt4dzupow8jhPnVNtvEKepyNbyHFnY2
 T2UoTIlr68egc4Cy+Ow+lWvqzagu57CRwgd/RjMUySu6QYRTIqkYZG4rFvW9/BNKK6HQVSb+
 nsJgc6T6KYJF57lvCiMRvgdWaqi/PetLjLRmxhsEoMn+jDr/GSsFb28+xl3IENvd8JBcjjzb
 QqL5kVa5YRYOz2haqofj5+NNvnGBJPITbzNPs04pPIXCnStXGdrJB1TWHM=
IronPort-HdrOrdr: A9a23:oJFxra37cQxYuwUGf2cXpgqjBHgkLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 tIQuxXFMDwAV9mjczz/QW0V+o7zMLvytHOuQ6n9RdQZDAvTb185AFkDQveOEh3SA5aQacdLv
 Onl6x6T/7KQwVuUix9bUN1JtT+mw==
X-Talos-CUID: =?us-ascii?q?9a23=3Ah8g8HGltUjZBUPOf8kaCFrU29O/XOXrRlXriPFD?=
 =?us-ascii?q?kNVdWGJHEFEWVyJ16vdU7zg=3D=3D?=
X-Talos-MUID: 9a23:FBLWbwSERcTWMHiCRXTjoQp4athT7Z2SDUcAyZ4Dt/mWMS9/bmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="788520129"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:54:41 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id D7B27180001E7;
	Fri, 24 Jul 2026 17:54:34 +0000 (GMT)
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
Subject: [PATCH v6 11/13] scsi: fnic: Track NVMe transport statistics
Date: Fri, 24 Jul 2026 10:48:09 -0700
Message-ID: <20260724174811.5118-12-kartilak@cisco.com>
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
index aa3c935d0815..874139412704 100644
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
@@ -357,7 +439,9 @@ int nvfnic_fcpio_send(struct nvme_fc_local_port *lport,
 	if (io_req->tag == FNIC_NVME_NO_FREE_TAG) {
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "No free tag available. Failing IO\n");
+		atomic64_inc(&fnic_stats->io_stats.alloc_failures);
 		atomic_dec(&fnic->in_flight);
+		atomic64_inc(&fnic_stats->io_stats.nvme_io_rsps_sent);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		return -EBUSY;
 	}
@@ -383,6 +467,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 	struct fcpio_tag ftag;
 	u32 id;
 	struct fnic_io_req *io_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	unsigned long start_time;
 	u64 cmd_trace;
 	char *lba;
@@ -407,6 +492,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "IO req null hdr: %s tag: 0x%x desc: 0x%p\n",
 			      fnic_fcpio_status_to_str(hdr_status), id, desc);
@@ -475,6 +561,7 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 	}
 
 	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		FNIC_NVME_DBG(KERN_INFO, fnic, "hdr status: %s\n",
 			    fnic_fcpio_status_to_str(hdr_status));
 	}
@@ -495,7 +582,9 @@ void nvfnic_fcpio_nvme_fast_cmpl_handler(struct fnic *fnic,
 		   (((u64) io_req->cmd_flags << 32) |
 		    io_req->cmd_state));
 
+	nvfnic_update_io_stats(fnic, cmdiu->sqe.rw.opcode);
 	nvfnic_update_io_bytes(fnic, io_req, cmdiu->sqe.rw.opcode);
+	nvfnic_update_cmpl_stats(fnic, io_req);
 
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 	if (io_req->done)
@@ -513,6 +602,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 	u32 id;
 	struct fcpio_nvme_cmpl *nvme_cmpl;
 	struct fnic_io_req *io_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	unsigned long start_time;
 	uint32_t rsplen;
 	struct nvme_fc_ersp_iu *ersp;
@@ -543,6 +633,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 
 	io_req = nvfnic_find_io_req_by_tag(fnic, tag);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			    "IOREQ is null hdr status: %s tag: 0x%x desc: %p\n",
 			    fnic_fcpio_status_to_str(hdr_status), tag, desc);
@@ -635,6 +726,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 			}
 			memcpy(io_req->fcp_req->rspaddr, ersp, rsplen);
 		}
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_ersps);
 		io_req->fcp_req->rcv_rsplen = rsplen;
 		break;
 
@@ -646,6 +738,7 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 	}
 
 	if (hdr_status != FCPIO_SUCCESS) {
+		atomic64_inc(&fnic_stats->io_stats.io_failures);
 		FNIC_NVME_DBG(KERN_ERR, fnic, "hdr status: %s tag: 0x%x\n",
 			    fnic_fcpio_status_to_str(hdr_status), tag);
 	}
@@ -668,7 +761,9 @@ void nvfnic_fcpio_ersp_cmpl_handler(struct fnic *fnic,
 		   (((u64) io_req->cmd_flags << 32) |
 		    io_req->cmd_state));
 
+	nvfnic_update_io_stats(fnic, cmdiu->sqe.rw.opcode);
 	nvfnic_update_io_bytes(fnic, io_req, cmdiu->sqe.rw.opcode);
+	nvfnic_update_cmpl_stats(fnic, io_req);
 
 	nvfnic_release_nvme_ioreq_buf(iport, io_req);
 
@@ -689,6 +784,10 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	unsigned int tag;
 	struct fnic_io_req *io_req;
 	struct nvme_fc_cmd_iu *cmd_iu;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
+	struct abort_stats *abts_stats = &fnic->fnic_stats.abts_stats;
+	struct terminate_stats *term_stats = &fnic->fnic_stats.term_stats;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 	struct fnic_iport_s *iport;
 
 	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &ftag);
@@ -706,6 +805,7 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 	io_req = nvfnic_find_io_req_by_tag(fnic, tag);
 	WARN_ON_ONCE(!io_req);
 	if (!io_req) {
+		atomic64_inc(&fnic_stats->io_stats.ioreq_null);
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "IOREQ null hdr:%s tag:0x%x desc:%p\n",
 			      fnic_fcpio_status_to_str(hdr_status), tag, desc);
@@ -734,6 +834,10 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
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
@@ -745,11 +849,19 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
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
 
@@ -775,6 +887,8 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
 
 	io_req->cmd_flags |= FNIC_IO_ABT_TERM_DONE;
 
+	if (!(io_req->cmd_flags & (FNIC_IO_ABORTED | FNIC_IO_DONE)))
+		atomic64_inc(&misc_stats->no_icmnd_itmf_cmpls);
 
 	io_req->fcp_req->transferred_length = 0;
 	io_req->fcp_req->rcv_rsplen = 0;
@@ -783,6 +897,12 @@ void nvfnic_fcpio_nvme_itmf_cmpl_handler(struct fnic *fnic,
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
@@ -982,9 +1102,14 @@ bool _terminate_tport_ios(struct sbitmap *map, unsigned int tag,
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
@@ -1114,12 +1239,15 @@ nvfnic_find_ls_req(struct fnic_tport_s *tport, uint16_t oxid)
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
@@ -1134,6 +1262,7 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
 	uint8_t *fcid;
 	uint16_t oxid = FNIC_STD_GET_OX_ID(fchdr);
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	fcid = FNIC_STD_GET_S_ID(fchdr);
 	tport_fcid = ntoh24(fcid);
@@ -1161,8 +1290,12 @@ void nvfnic_process_ls_abts_rsp(struct fnic_iport_s *iport,
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
@@ -1197,6 +1330,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 		      sizeof(fchdr->fh_s_id);
 	int status = 0;
 	struct fnic *fnic = iport->fnic;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 
 	if (len < (int)sizeof(*fchdr)) {
 		if (len >= sid_len) {
@@ -1262,6 +1396,7 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 	}
 
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_responses);
 
 	list_del_init(&nvfnic_ls_req->list);
 	lsreq->private = NULL;
@@ -1308,6 +1443,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct nvmefc_ls_req *ls_req = nvfnic_ls_req->ls_req;
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t oxid = nvfnic_ls_req->oxid;
 	int timeout;
 
@@ -1342,6 +1478,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 			      "tport: 0x%x lsreq: 0x%x sending abort\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
 		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+		atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_aborts);
 
 		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) == 0) {
 			timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
@@ -1393,6 +1530,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 	uint8_t *ls_req_payload;
 	struct fnic *fnic = iport->fnic;
 	struct fc_frame_header *fchdr;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	struct nvfnic_ls_req *nvfnic_ls_req = ls_req->private;
 	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
 			sizeof(struct fc_frame_header) + ls_req->rqstlen;
@@ -1435,6 +1573,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 		return -EAGAIN;
 	}
 
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_requests);
 	timer_setup(&nvfnic_ls_req->ls_req_timer, nvfnic_ls_req_timeout,
 		     0UL);
 
@@ -1467,6 +1606,11 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 		 iport->fcid, nvfnic_ls_req->oxid, *((uint8_t *) ls_req->rqstaddr),
 		 ls_req->rqstlen);
 
+	FNIC_NVME_DBG(KERN_INFO, fnic,
+		 "0x%x: ls_reqs count: %lld",
+		 iport->fcid,
+		 (u64) atomic64_read(&fnic_stats->nvme_stats.nvme_ls_requests));
+
 	list_add_tail(&nvfnic_ls_req->list, &tport->ls_req_list);
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_PENDING;
 
@@ -1614,6 +1758,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	struct fnic *fnic = iport->fnic;
 	struct fnic_tport_s *tport;
 	struct nvfnic_ls_req *nvfnic_ls_req;
+	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
 	uint16_t oxid;
 	int timeout;
 	int ret;
@@ -1675,6 +1820,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 
 	/* Mark the state and flags */
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+	atomic64_inc(&fnic_stats->nvme_stats.nvme_ls_aborts);
 	oxid = nvfnic_ls_req->oxid;
 
 	ret = fdls_send_ls_req_abts(iport, tport, oxid);
@@ -1700,6 +1846,7 @@ bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
 {
 	int idx;
 	unsigned long flags;
+	struct misc_stats *misc_stats = &fnic->fnic_stats.misc_stats;
 
 	idx = io_req->wq - &fnic->hw_copy_wq[0];
 
@@ -1715,12 +1862,18 @@ bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
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
@@ -1737,9 +1890,13 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
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
 
@@ -1755,6 +1912,15 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
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
@@ -1802,7 +1968,24 @@ void nvfnic_fcpio_abort(struct nvme_fc_local_port *lport,
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
@@ -1855,6 +2038,7 @@ void nvfnic_nvme_iodone_work(struct work_struct *work)
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

