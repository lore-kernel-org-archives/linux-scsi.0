Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6DC37E2EB;
	Fri, 12 Jun 2026 18:14:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781288044; cv=none; b=YqDHjt5duq7r+WH1d32MlXkFjkCe1BCKh6HJCvRGv82wPzAXAxFKDESYUpxqS5UQu3FYdJVxUJXBem2ksCmVMZcA/EdpI3T/aXzu6NqmKmVhDHlhLK4qpF1R21dmQUR6NHbfGSea+g+xvbDSF1XwCuYGvm788Y6XDO30Vr8NI2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781288044; c=relaxed/simple;
	bh=Ao2je04cN9013QVSGFxEG1tbD334D05l3r7UcrQo2ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9K/uKGmuVAd+NblQzFZZuyR1qD8/MF261Vhh4vwVP6ErbVKik2vuNr0UGspQ288EXKw2v5YUU3IJm7754dB572g1/WdQEfeK/BPLYXbcbszAdmA1BjDp5W1F2cHVBPomAUlfHf+ICd6mdxzljGan3FzsXg4jKM7FJlhqqmd74c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=SK4O2ON1; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="SK4O2ON1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7895; q=dns/txt;
  s=iport01; t=1781288042; x=1782497642;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bBU5DYLzPpM7KiVOi0I1USED2iWcBeWcZHtazme7gNw=;
  b=SK4O2ON1cBZ5CN4kHYHLQuS63TE1VWtRkjBjOIt/K8ucLTXo3z2x5xGE
   nXLW4yKteh19tFYBO8htnUVWtdg3y3x9CFR5yqlHAf1J9jfLKB52HfcKP
   5IfyVpfuVZbWp9/hZSWXhYldIw1A2JUcCd8SN1HqP22Sz9iVztvLUg/PF
   CNKLfeiHgt7gBCM4l9b1vyXzOs0a5jxog+6CrVIkzx1Z35vQof5A3Nyyv
   TQ8qUMMjnNz+m7JJ/YUeRD7s8J3inY7ek6S9t6PZnHgaVjVao5uvRZdb8
   8ZWaDYiC3Vqi97dw/VU3ToBXSz7kJI152KBPgGn5LDNLDknc8vRrgd4E5
   w==;
X-CSE-ConnectionGUID: 8LbdTrtdSoCjgmIve+2yLA==
X-CSE-MsgGUID: BL+sYdLNQISWNMRswV4X5w==
X-IPAS-Result: =?us-ascii?q?A0BDAgDoSyxq/4v/Ja1aglmCV4FSQxkwlCqCIYEWnQgUg?=
 =?us-ascii?q?WoPAQEBD1EEAQGFBgKNQwImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDtV2BeTOBAd5DgWYBCxQBgTiNX?=
 =?us-ascii?q?nSEfCcVBoFJRIEVgnMHb4FSgliGXgSDLoZNiipIgR4DWSwBVRMNCgsHBYFmA?=
 =?us-ascii?q?zUSKhVuMh2BIz4XgQwbBwWBSoEraoEDhQ0jHwM5f4F0gShnaRUwNYEBAREdA?=
 =?us-ascii?q?wsYDUgRLDcUGwQ+bgeMSBcPgUxrBwFXNwd0gRgrAWOSagIBkj6hD4QnoVsaM?=
 =?us-ascii?q?6psmQikCoU4gWg8gVkzGggbFYMiUxkPji0WyzMnMj0CBwIHDgMLk2UBAQ?=
IronPort-Data: A9a23:FEWb2avnSu//dZBxnQ9A+himcOfnVKdfMUV32f8akzHdYApBsoF/q
 tZmKT+EOKyKNmL8fdhwOtnlpEkB6seBy4BgHgY9r3pgFXkagMeUXt7xwmUckM+xwmwvaGo9s
 q3yv/GZdJhcokf0/0nrav666yEgiclkf5KkYMbcICd9WAR4fykojBNnioYRj5Vh6TSDK1vlV
 eja/YuFZDdJ5xYuajhKs/za8ks11BjPkGpwUmIWNKgjUGD2zxH5PLpHTYmtIn3xRJVjH+LSb
 47r0LGj82rFyAwmA9Wjn6yTWhVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0NS+7vw60c+VZk
 72hg3AfpTABZcUgkMxFO/VR/roX0aduoNcrKlDn2SCfItGvn3bEm51T4E8K0YIwqsJ9DV1U6
 fAjLxsPYRWime/1mqOfY7w57igjBJGD0II3oHpsy3TdSP0hW52GG/+M7t5D1zB2jcdLdRrcT
 5NGMnw0M1KaPkAJYwxGYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUoDbHpUExR/B9
 goq+UzTJlIBBdC77wOkyU2Ko9XUgh2naN8NQejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceTDAj1
 ViRmM7BHzFjsLSJD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCwymrMYhMgjzLig8BbMhDfEjpzISBMlowbaRGSo6itna4O/IY+l817W6bBHNonxZl2Au
 mUU3tOV9+EmE56AjmqOTf8LEbXv4OyKWAAwmnZ1FJUnsjDo8Hm5cMUIund1JVxiNYAPfjqBj
 FLvhD69LaR7ZBOCBZKbqaroYyj25cAMzejYa80=
IronPort-HdrOrdr: A9a23:WUNVg6jVCYBoMw4ZVqVzkMrWVHBQXhAji2hC6mlwRA09TyVXra
 yTdZMgpHvJYVkqNk3I9errBEDEewK+yXcX2/h1AV7BZmjbUQKTRekI0WKh+UyDJ8SUzIFgPM
 lbHpRWOZnZEUV6gcHm4AOxDtoshOWc/LvAv5a4854Ud2FXQpAlyRtlAQCGFUAzbgxHCZ0lUK
 e43KN81lydkbB9VLXCOpHDNNKz3uH2qA==
X-Talos-CUID: 9a23:81MKBm9sa2mz3MIK+HCVvx4wEMwZaGHR93D7IUC9KHhkC+eEbXbFrQ==
X-Talos-MUID: 9a23:R/Lq9QhOi5YuQn8kVJpDUMMpHuMr+JWiLGY0sK45ney+LjNOZwfAk2Hi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,201,1774310400"; 
   d="scan'208";a="493893118"
Received: from rcdn-l-core-02.cisco.com ([173.37.255.139])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2026 18:14:01 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.127.244])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-02.cisco.com (Postfix) with ESMTPSA id 3EC0C18000350;
	Fri, 12 Jun 2026 18:14:00 +0000 (GMT)
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
Subject: [PATCH v4 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Date: Fri, 12 Jun 2026 11:09:13 -0700
Message-ID: <20260612180918.8554-9-kartilak@cisco.com>
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

Classify NVMe LS request OXIDs, route NVMe LS responses and ABTS frames
through the FCS receive path, and reset NVMe exchanges when FDLS tears
down target ports.

Extend FDLS link-down and frame-processing paths so NVMe LS traffic
follows the same discovery and cleanup state machine as FCP traffic.

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
	Replace the NVMe LS OXID switch with a direct frame-type check.
	Rename the NVMe frame helper to follow fnic function naming style.
---
 drivers/scsi/fnic/fdls_disc.c | 30 ++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fcs.c  | 31 +++++++++++++++++++++++++------
 2 files changed, 55 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 90bb1a39972d..5b4087f1247a 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -387,10 +387,16 @@ static bool fdls_is_oxid_tgt_req(uint16_t oxid)
 	return true;
 }
 
+static inline bool fdls_is_oxid_nvme_req(uint16_t oxid)
+{
+	return FNIC_FRAME_TYPE(oxid) == FNIC_FRAME_TYPE_NVME_LS;
+}
+
 static void fdls_reset_oxid_pool(struct fnic_iport_s *iport)
 {
 	struct fnic_oxid_pool_s *oxid_pool = &iport->oxid_pool;
 
+	bitmap_clear(oxid_pool->bitmap, 0, FNIC_OXID_POOL_SZ);
 	oxid_pool->next_idx = 0;
 }
 
@@ -1288,6 +1294,10 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		fnic_rport_exch_reset(iport->fnic, tport->fcid);
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		nvfnic_exch_reset(iport, tport);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	}
 
 	if ((tport->flags & FNIC_FDLS_SCSI_REGISTERED) ||
@@ -1828,6 +1838,7 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 	tport->fcid = fcid;
 	tport->wwpn = wwpn;
 	tport->iport = iport;
+	INIT_LIST_HEAD(&tport->ls_req_list);
 
 	FNIC_FCS_DBG(KERN_DEBUG, fnic,
 				 "Need to setup tport timer callback");
@@ -2439,6 +2450,8 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 	struct fnic *fnic = iport->fnic;
 	uint16_t oxid;
 	unsigned long flags;
+	struct fc_frame_header fchdr = {0};
+	uint8_t fcid[3];
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (!tport->timer_pending) {
@@ -2531,6 +2544,12 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			"0x%x timeout tport 0x%x oxid 0x%x state %d\n",
 			iport->fcid, tport->fcid, oxid, tport->state);
+		if (IS_FNIC_NVME_INITIATOR(fnic)) {
+			hton24(fcid, tport->fcid);
+			FNIC_STD_SET_S_ID(fchdr, fcid);
+			FNIC_STD_SET_OX_ID(fchdr, oxid);
+			nvfnic_process_ls_abts_rsp(iport, &fchdr);
+		}
 		break;
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -2841,6 +2860,12 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 				 "mismatched target zoned with FC SCSI initiator: 0x%x",
 				 tgt_fcid);
 			mismatched_tgt = true;
+		} else if (IS_FNIC_NVME_INITIATOR(fnic) &&
+			   prli_rsp->sp.spp_type != FC_TYPE_NVME) {
+			FNIC_FCS_DBG(KERN_ERR, fnic,
+				 "mismatched target zoned with NVME initiator: 0x%x",
+				 tgt_fcid);
+			mismatched_tgt = true;
 		}
 		if (mismatched_tgt) {
 			fdls_tgt_logout(iport, tport);
@@ -4852,6 +4877,8 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			return FNIC_FDMI_BLS_ABTS_RSP;
 		} else if (fdls_is_oxid_tgt_req(oxid)) {
 			return FNIC_TPORT_BLS_ABTS_RSP;
+		} else if (fdls_is_oxid_nvme_req(oxid)) {
+			return FNIC_LS_REQ_ABTS_RSP;
 		}
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			"Received ABTS rsp with unknown oxid(0x%x) from 0x%x. Dropping frame",
@@ -5084,6 +5111,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_BLS_ABTS_RSP:
 			fdls_process_fabric_abts_rsp(iport, fchdr);
 		break;
+	case FNIC_LS_REQ_ABTS_RSP:
+		nvfnic_process_ls_abts_rsp(iport, fchdr);
+		break;
 	case FNIC_FDMI_BLS_ABTS_RSP:
 		fdls_process_fdmi_abts_rsp(iport, fchdr);
 		break;
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 94b7c150c08c..e580930cce9c 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -31,6 +31,11 @@ struct workqueue_struct *fnic_event_queue;
 
 static uint8_t FCOE_ALL_FCF_MAC[6] = FC_FCOE_FLOGI_MAC;
 
+static inline bool fnic_is_nvme_frame(struct fc_frame_header *fchdr)
+{
+	return (fchdr->fh_type == FC_TYPE_NVME);
+}
+
 /*
  * Internal Functions
  * This function will initialize the src_mac address to be
@@ -284,6 +289,7 @@ void fnic_handle_frame(struct work_struct *work)
 	struct fnic *fnic = container_of(work, struct fnic, frame_work);
 	struct fnic_frame_list *cur_frame, *next;
 	int fchdr_offset = 0;
+	struct fc_frame_header *fchdr;
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	list_for_each_entry_safe(cur_frame, next, &fnic->frame_queue, links) {
@@ -313,8 +319,14 @@ void fnic_handle_frame(struct work_struct *work)
 		fchdr_offset = (cur_frame->rx_ethhdr_stripped) ?
 			0 : FNIC_ETH_FCOE_HDRS_OFFSET;
 
-		fnic_fdls_recv_frame(&fnic->iport, cur_frame->fp,
-							 cur_frame->frame_len, fchdr_offset);
+		fchdr = (struct fc_frame_header *)((u8 *)cur_frame->fp + fchdr_offset);
+		if (IS_FNIC_NVME_INITIATOR(fnic) && fnic_is_nvme_frame(fchdr)) {
+			nvfnic_ls_rsp_recv(&fnic->iport, fchdr,
+					  cur_frame->frame_len - fchdr_offset);
+		} else {
+			fnic_fdls_recv_frame(&fnic->iport, cur_frame->fp,
+					     cur_frame->frame_len, fchdr_offset);
+		}
 
 		mempool_free(cur_frame->fp, fnic->frame_recv_pool);
 		mempool_free(cur_frame, fnic->frame_elem_pool);
@@ -617,6 +629,9 @@ void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
 	void *rq_buf = buf->os_buf;
 	struct fnic *fnic = vnic_dev_priv(rq->vdev);
 
+	if (WARN_ON(!buf))
+		return;
+
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_FROM_DEVICE);
 
@@ -651,7 +666,7 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 		dma_unmap_single(&fnic->pdev->dev, pa, frame_len, DMA_TO_DEVICE);
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "vnic work queue descriptor is not available");
-		ret = -1;
+		ret = -ENXIO;
 		goto fnic_send_frame_end;
 	}
 
@@ -685,7 +700,6 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *frame, int frame_size,
 	struct fcoe_hdr *pfcoe_hdr;
 	struct fnic_frame_list *frame_elem;
 	int len = frame_size;
-	int ret;
 	struct fc_frame_header *fchdr = (struct fc_frame_header *) (frame +
 			FNIC_ETH_FCOE_HDRS_OFFSET);
 
@@ -723,8 +737,7 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *frame, int frame_size,
 
 	fnic_debug_dump_fc_frame(fnic, fchdr, frame_size, "Outgoing");
 
-	ret = fnic_send_frame(fnic, frame, len);
-	return ret;
+	return fnic_send_frame(fnic, frame, len);
 }
 
 int fnic_send_fcoe_frame(struct fnic_iport_s *iport, void *frame,
@@ -872,6 +885,9 @@ static void fnic_wq_complete_frame_send(struct vnic_wq *wq,
 {
 	struct fnic *fnic = vnic_dev_priv(wq->vdev);
 
+	if (WARN_ON(!buf))
+		return;
+
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
 	mempool_free(buf->os_buf, fnic->frame_pool);
@@ -917,6 +933,9 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
 
+	if (WARN_ON(!buf))
+		return;
+
 	mempool_free(buf->os_buf, fnic->frame_pool);
 	buf->os_buf = NULL;
 }
-- 
2.47.1

