Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB1030B50F;
	Fri, 12 Jun 2026 18:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781288120; cv=none; b=HbFGfsoVYlt77kvcgyLoXjYYN8kURzUzp45XqyH/0B0z8UorDmzT7sHC8KQmiVmotfvytmKT97qiVwlZpjHoVvWC44pIASrLsxI3YRXm3DxDekXMhvmMNrIE6yeYoIF9iAzncVBDbICPnAuV6JvIEWzD6uRDbBTqTm/3RYGs6eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781288120; c=relaxed/simple;
	bh=jbMkvq+BYjsnGFOlSzqPLLmJoqgFK/BUHHMBGoahy4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hx6xloDnph1bB3qNMewgCoIxSNK6Cxd60gO2D+1X7/NfgwicJ+jN/CcVoJDncz6azmNanDV1Pguq+XeUNAWp1AHZ5FcsCaqd+JjWo4afHPOuMfc96fNKN0WEzKzxqk7U4zvIgIaw4BLIJCRXgGZR+2+WbBnWt20kH4GMhj58hlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=lVtjdBkp; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="lVtjdBkp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7997; q=dns/txt;
  s=iport01; t=1781288118; x=1782497718;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tpm3Y37xMnm1CWvTu0rwzPk60VBCbSikJPjbz6ijzw0=;
  b=lVtjdBkpML28Y+UFTZOXD0U9m5JQNqGtnUubcnYHEIiukxjnKmr0DsmF
   mRpBQXS7vhzADFyOYpuPhU3Vjbv3sCo/TVbBvobxVxPGAweW0xgSvWkCu
   mhpFQ4+TugXPU3rtGSCpUJ8V6/EkY+w4qEw53DjQBE21V0h+E1Y/mpTo2
   eT5dDoROwh8Ji2qg7g/2DbmoEY0/bLzNt6bMcxUM8xxhri7hrFDZ1AhTf
   GkTH3RrjsvUADyinjTmeJ40NPO8LHwmV6nGsXkvVobMHkvd9cod/QKJsA
   /xZMnwo1kHniqmYK5ve4qI+B/BrolUWBwTPKUGVK5JWy/Agojr3xDoXqB
   A==;
X-CSE-ConnectionGUID: 6MpzNDqSRWi1oTPecaFfvA==
X-CSE-MsgGUID: BV1SJLwFTlalhan/Sp2UOw==
X-IPAS-Result: =?us-ascii?q?A0BCAgDoSyxq/4v/Ja1aHgEBCxIMggULgleBUkMZMJQqg?=
 =?us-ascii?q?iGeHoF+DwEBAQ9RBAEBhQYCjUMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7VdgXkzgQHeQ4FmAQsUA?=
 =?us-ascii?q?YE4jV50hHwnFQaBSUSBFYNpgQUBTIk2BIMuhFCBY4pESIEeA1ksAVUTDQoLB?=
 =?us-ascii?q?wWBZgM1EioVbjIdgSM+F4EMGwcFgUqBK2qBA4UNIx8DOX+BdIEoZ2kVMDWBA?=
 =?us-ascii?q?QERHQMLGA1IESwUIxQbBD5uB4xIFw+CPoEECxOCKwEeAZMnkkiBNZ9ahCehW?=
 =?us-ascii?q?xozqmyZCKQKhTiBaDyBWTMaCBsVO4JnUxkPji0LC8szJzI9AgcCBw4DC5NlA?=
 =?us-ascii?q?QE?=
IronPort-Data: A9a23:g6XLzaiIneBWpLXH7/0RiZGNX161kREKZh0ujC45NGQN5FlHY01je
 htvW2rVOfvZN2TyLY0jOtzkoR5SscDTmIRqQFc5/C8yRXljpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOOn9SUgvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZeDULOZ82QsaDxMtfvZ8EkHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqVG3/5lJ01Xz
 sYnKWkKUiiOjOuYzqySH7wEasQLdKEHPasFsX1miDWcBvE8TNWbGePB5MRT23E7gcUm8fT2P
 pVCL2EwKk6dPlsWYQZ/5JEWxI9EglH8eidEqVacpoI84nPYy0p6172F3N/9Jo3WHZ4IwBnIz
 o7A107HWyo4EMOx9T6M9nKlgKj0hXnGf51HQdVU8dYv2jV/3Fc7CBQMWHO4rOO/h0r4XMhQQ
 2QW9ygkhawz8lG7CNj3Wluzp3vslhsVQcZRFasi5R2A0LHZ5S6eHGEPSjMHY9sj3Oc/STUp0
 UeOgvvzCDBvuaHTQnWYnp+WqD60NCcVLEcYaCMERBdD6N7myKkpgwzCVM1LCqO5jtTpXzr3x
 liiqCQjgb4ai+YQyr62u1vAhlqEopnPUx5w5QjNWG+hxh12aZTjZIGy71Xfq/FaI+6xSliHo
 WhBgMOF7cgQApyX0i+AWuMAGPeu/fntDdHHqURkE59k83Gm/GSuONgKpjp/P0xudM0DfFcFf
 XPuhO+Y37cLVFPCUEO9S9jZ5xgCpUQ4KenYaw==
IronPort-HdrOrdr: A9a23:MNc4s6pGQCc5qp/5DHjl7r4aV5rheYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McShaL4d98gx+FgGXVmdyRAVAGN4FMa
 D03Lsgm9JlEk5nFvhSwRI+LpH+m+E=
X-Talos-CUID: 9a23:ycAs4Wy0J1YdyLIqqkZ8BgVKP9g3VFHE903vIha/NV5kQ7S7R0G5rfY=
X-Talos-MUID: 9a23:b3d23QaTsKnsfuBTnQG1vxNGK+lU562qCEkL1q4e4fSjKnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="494035678"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:15:11 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 60F1A18000350;
	Fri, 12 Jun 2026 18:15:10 +0000 (GMT)
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
Subject: [PATCH v4 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Date: Fri, 12 Jun 2026 11:09:15 -0700
Message-ID: <20260612180918.8554-11-kartilak@cisco.com>
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

Add an FDLS helper that sends ABTS frames for outstanding NVMe LS
requests.

Use the active LS request OXID when building the ABTS frame, send it
through the FCoE transmit path, and call it from LS timeout and abort
handling.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>

---
Changes between v3 and v4:
Incorporate review comments from Sashiko:
	Free LS ABTS frame when send fails
	Reuse NVMe LS request cleanup for abort failure
---
 drivers/scsi/fnic/fdls_disc.c | 44 ++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |  2 ++
 drivers/scsi/fnic/fnic_nvme.c | 65 +++++++++++++++++++++++++++++------
 3 files changed, 100 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 5b4087f1247a..873dbd22ada8 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -654,6 +654,50 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
 	fnic_send_fcoe_frame(iport, frame, frame_size);
 }
 
+int fdls_send_ls_req_abts(struct fnic_iport_s *iport,
+		struct fnic_tport_s *tport, unsigned int oxid)
+{
+	uint8_t *frame;
+	uint8_t s_id[3];
+	uint8_t d_id[3];
+	struct fnic *fnic = iport->fnic;
+	struct fc_frame_header *pls_req_abts;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_frame_header);
+	int ret;
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic,
+				"Failed to allocate frame to send ls req ABTS");
+		return -ENOMEM;
+	}
+
+	pls_req_abts = (struct fc_frame_header *) (frame +
+			FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_fabric_abts_frame(frame, iport);
+
+	hton24(s_id, iport->fcid);
+	hton24(d_id, tport->fcid);
+	FNIC_STD_SET_S_ID(*pls_req_abts, s_id);
+	FNIC_STD_SET_D_ID(*pls_req_abts, d_id);
+
+	FNIC_STD_SET_OX_ID(*pls_req_abts, oxid);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic,
+		"iport 0x%x: tport: 0x%x FDLS sending ls req abts with oxid: 0x%x",
+		iport->fcid, tport->fcid, oxid);
+
+	ret = fnic_send_fcoe_frame(iport, frame, frame_size);
+	if (ret) {
+		mempool_free(frame, fnic->frame_pool);
+		return ret;
+	}
+
+	return 0;
+}
+
+
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index 0a68d0fb11b1..ce4b3aae77e3 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -407,6 +407,8 @@ uint16_t fdls_alloc_oxid(struct fnic_iport_s *iport, int oxid_frame_type,
 	uint16_t *active_oxid);
 void fdls_free_oxid(struct fnic_iport_s *iport,
 	uint16_t oxid, uint16_t *active_oxid);
+int fdls_send_ls_req_abts(struct fnic_iport_s *iport,
+		struct fnic_tport_s *tport, unsigned int oxid);
 void fdls_tgt_logout(struct fnic_iport_s *iport,
 		     struct fnic_tport_s *tport);
 void fnic_del_fabric_timer_sync(struct fnic *fnic);
diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
index 014660725373..9cc8f0baf09c 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -24,6 +24,10 @@
 
 #if IS_ENABLED(CONFIG_NVME_FC)
 
+static bool nvfnic_ls_req_cleanup(struct fnic_iport_s *iport,
+				  struct nvmefc_ls_req *lsreq,
+				  uint16_t oxid);
+
 int nvfnic_get_sg_count(struct fnic_io_req *io_req)
 {
 	return io_req->fcp_req->sg_cnt;
@@ -1232,6 +1236,23 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 }
 
+static bool nvfnic_ls_req_cleanup(struct fnic_iport_s *iport,
+				  struct nvmefc_ls_req *lsreq,
+				  uint16_t oxid)
+{
+	struct nvfnic_ls_req *nvfnic_ls_req = lsreq->private;
+
+	if (!nvfnic_ls_req)
+		return false;
+
+	lsreq->private = NULL;
+	list_del(&nvfnic_ls_req->list);
+	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
+	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
+
+	return true;
+}
+
 void nvfnic_ls_req_timeout(struct timer_list *t)
 {
 	struct nvfnic_ls_req *nvfnic_ls_req = timer_container_of(nvfnic_ls_req,
@@ -1241,6 +1262,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
 	uint16_t oxid = nvfnic_ls_req->oxid;
+	int timeout;
 
 	FNIC_NVME_DBG(KERN_INFO, fnic,
 		      "tport: 0x%x lsreq: 0x%x state: %d timeout\n",
@@ -1262,10 +1284,8 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 			      "tport: 0x%x lsreq: 0x%x abort timeout\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
 
-		list_del(&nvfnic_ls_req->list);
 		ls_req = nvfnic_ls_req->ls_req;
-		fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
-		ls_req->private = NULL;
+		nvfnic_ls_req_cleanup(iport, ls_req, oxid);
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		ls_req->done(ls_req, -ETIMEDOUT);
 		return;
@@ -1274,6 +1294,19 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "tport: 0x%x lsreq: 0x%x sending abort\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
+		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+
+		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) == 0) {
+			timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
+			mod_timer(&nvfnic_ls_req->ls_req_timer,
+				  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+			return;
+		}
+		FNIC_NVME_DBG(KERN_ERR, fnic,
+			      "tport: 0x%x lsreq: 0x%x cannot send abort\n",
+			      tport->fcid, oxid);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	}
 
 	if (ls_req->private == NULL) {
@@ -1281,10 +1314,8 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 		return;
 	}
 
-	list_del(&nvfnic_ls_req->list);
 	ls_req = nvfnic_ls_req->ls_req;
-	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
-	ls_req->private = NULL;
+	nvfnic_ls_req_cleanup(iport, ls_req, oxid);
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 	ls_req->done(ls_req, -ETIMEDOUT);
@@ -1403,11 +1434,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 	if (ret) {
 		timer_delete_sync(&nvfnic_ls_req->ls_req_timer);
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		list_del(&nvfnic_ls_req->list);
-		fdls_free_oxid(iport, nvfnic_ls_req->oxid,
-			       &nvfnic_ls_req->oxid);
-		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
-		ls_req->private = NULL;
+		nvfnic_ls_req_cleanup(iport, ls_req, nvfnic_ls_req->oxid);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		mempool_free(frame, fnic->frame_pool);
 		return ret;
@@ -1521,6 +1548,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	struct nvfnic_ls_req *nvfnic_ls_req;
 	uint16_t oxid;
 	int timeout;
+	int ret;
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
@@ -1579,10 +1607,25 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 
 	/* Mark the state and flags */
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+	oxid = nvfnic_ls_req->oxid;
 	timeout = FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
 	mod_timer(&nvfnic_ls_req->ls_req_timer,
 		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+
+	ret = fdls_send_ls_req_abts(iport, tport, oxid);
+	if (!ret)
+		return;
+
+	timer_delete_sync(&nvfnic_ls_req->ls_req_timer);
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	if (!nvfnic_ls_req_cleanup(iport, lsreq, oxid)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		return;
+	}
+
+	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+	lsreq->done(lsreq, -EAGAIN);
 }
 
 bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
-- 
2.47.1

