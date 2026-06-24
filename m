Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29537257844;
	Wed, 24 Jun 2026 04:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276500; cv=none; b=gwJ4D1/sopzrTgpAUpR6Cuv9IteHDwXLom9l6GSQv0y66fgx9cjBtcz8sB9A5GpbLhgYPJHyWOExK/v7QlTxsGR1rS0O+8CgxlyTA+CtP6CHU9rJeUn+7eEhJ4XdlUWXFfmmRqpACgqpKMe5eM4LaMHtUrIKjSy1CIq269IECwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276500; c=relaxed/simple;
	bh=MpyQxjkrQCOJ/gVXN0JYbY0N3Ez6kUTWcZC/V/BujEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unhVn4Am3R7LrU/g9z7ErWS/ZMiLSwMPtdyDp+v61q6Qp5OTClZ/VgBDtvjL8KQApUG9UTEOwT++DIDQFpSwiefvZZljJBoYJS3GnZCQdILGBtIzrWjoHC6bTy7uIsnEa5BGB8IwNfEHUjI6QwQ5JAEhni27w1N2U589UnrRqsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=dfb/1aQZ; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="dfb/1aQZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8531; q=dns/txt;
  s=iport01; t=1782276499; x=1783486099;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PHciosCRtyJjhflhVc0bsNi5Yz1Sd64aUZvL6yhXACE=;
  b=dfb/1aQZydD9ghEoeuQgXmpgfoFMtH7PzSPqNf6DVUW12sWguZCNOoNY
   WsZV3JrKxNu8/9nRb+WMaXV0OOkPN1SmGQ5Xf4vMM9jR5WXH9cw2gADt4
   vd1vvu2ZO6BhItRZEFayzKY8nCnfQ0VYhPS3tn7/c1h1xzo2NvGCHn15p
   pHCTkj0a+i88hnizQmxx0wbUMBMp9ZHc7mJqoDWZO/fJvugrjpirwA09e
   +j1Mn9jWokiC913CDyCbgGD4o4ZQFuJTMy0Shpl4oCAHcfQEo+uGhGQIy
   NCWwY42FJgRUOndSV2xKsMiKwemUaQODmZHLtIR3MrSM4hdjbHB+PaCJg
   g==;
X-CSE-ConnectionGUID: T5LBHN8fTGKgVBYY79Up2w==
X-CSE-MsgGUID: LCiWmZZfRlKBbgQZ2/XMtA==
X-IPAS-Result: =?us-ascii?q?A0BDAgB4YDtq/4//Ja1aglmCV4FSQxkwlCqCIYEWnQgUg?=
 =?us-ascii?q?WoPAQEBD1EEAQGFBgKNSgImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZchlsCAQMnCwFGEFFWGYMCgnQDsjWBeTOBAd5DgWYBCxQBgTiNX?=
 =?us-ascii?q?nSEfCcVBoFJRIEVgnMHb4FSgliGXgSDHBKGGIpqSIEeA1ksAVUTDQoLBwWBZ?=
 =?us-ascii?q?gM1EioVbjIdgSM+F4EMGwcFgR2BboEEhQIjHwM5f4E/gSRkZhUwNYEBAREfC?=
 =?us-ascii?q?oE1AwsYDUgRLDcUGwQ+bgeMXRcPgUtrBwFXNwd0gRgrAWOSagIBkj6hD4Qno?=
 =?us-ascii?q?VsaM6psmQikCoU4gWg8gVkzGggbFYMiUxkPji0W0jonMj0CBwIHDgMLkWgEg?=
 =?us-ascii?q?XkBAQ?=
IronPort-Data: A9a23:ahheGKpj89sOaM6irLkJzxGu43teBmLpZBIvgKrLsJaIsI4StFCzt
 garIBmEbvfZYzb0eY8lYIXnp0wFvsWAztY2HVds+3pkQiMaoOPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgPNNwJcaDpOtfrd8kg35pwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0toqJUtu0
 6wWFB8uYS6pttPpkY+jEPY506zPLOGzVG8ekmtrwTecCbMtRorOBv2Uo9RZxzw3wMtJGJ4yZ
 eJANmEpN0uGOUASfA5LU/rSn8/w7pX7Wz5Rsk6UoaM0y2PS1wd2lrPqNbI5f/TWFJQOxRvF/
 jquE2LRJjobC9mt+zS/9lGGjOD2r3m8aKcOPejtnhJtqBjJroAJMzUWXEG2ifq0kEizX5RYM
 UN80igjr6Ia8E2tU8m7Xhe95nWDu3Y0XtNKD+w8rhmA1qfO+AufLm8eRzVFZZots8pebTUm3
 1yOh9T0LSZivL2cVTSW8bL8hTG3NC4YIm8DTTUJQQsM/5/op4RbpgjCUNt5C4avg9H1EC22y
 DePxAA6i6gVhscN/76m5l2BiDWpzrDNTwgo9kDUU3ij4wdReoGofcqr5ELd4PIGK5yWJnGFv
 X4Zi42F5/sPJY+CmTbLQ+gXGrytofGfP1XhbUVHBZIt8XGpvnWkZ40VuG84L0ZyOcFCcjjsC
 KPOhT5sCFZoFCPCRcdKj0iZUqzGEYCI+QzZa83p
IronPort-HdrOrdr: A9a23:aIGUZ6sByl+O4hq+gdnkOOZA7skDvNV00zEX/kB9WHVpmwKj+/
 xG+85rsSMc5wx+ZJhNo7q90ey7MBDhHP1OkOws1NWZPTUO0VHAROpfBMnZsl/d8kbFmdK1u5
 0MT4FOTPXtEFl3itv76gGkH9tl/MOK68mT9IDjJg9WLT1CWuVH8xpzDBqdHwldQQlLAod8Kb
 +nj/A3wQZJvR8sH7yG7r5vZZm7m+H2
X-Talos-CUID: 9a23:HZXiTmAGqlbdMVD6ExU60GQ0PJArTlL+w0n6En7nWFtxEqLAHA==
X-Talos-MUID: 9a23:gcjV6QuaqFHJBUaK882noBpjC8Ja0aqUDGMnm5o/iZPDBQlsEmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499335500"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:48:12 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id B2677180003A1;
	Wed, 24 Jun 2026 04:48:10 +0000 (GMT)
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
Subject: [PATCH v5 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Date: Tue, 23 Jun 2026 21:43:29 -0700
Message-ID: <20260624044334.3079-9-kartilak@cisco.com>
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

Changes between v4 and v5:
Incorporate review comments from Sashiko:
	Check cleaned buffers before dereferencing them
	Drain OXID reclaim state on reset
---
 drivers/scsi/fnic/fdls_disc.c | 39 +++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fcs.c  | 34 +++++++++++++++++++++++-------
 2 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index e03256183ac6..f66c121cb712 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -387,10 +387,25 @@ static bool fdls_is_oxid_tgt_req(uint16_t oxid)
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
+	struct reclaim_entry_s *reclaim_entry, *next;
 
+	cancel_delayed_work(&oxid_pool->oxid_reclaim_work);
+	cancel_delayed_work(&oxid_pool->schedule_oxid_free_retry);
+	list_for_each_entry_safe(reclaim_entry, next,
+				 &oxid_pool->oxid_reclaim_list, links) {
+		list_del(&reclaim_entry->links);
+		kfree(reclaim_entry);
+	}
+	bitmap_clear(oxid_pool->pending_schedule_free, 0, FNIC_OXID_POOL_SZ);
+	bitmap_clear(oxid_pool->bitmap, 0, FNIC_OXID_POOL_SZ);
 	oxid_pool->next_idx = 0;
 }
 
@@ -1288,6 +1303,10 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		fnic_rport_exch_reset(iport->fnic, tport->fcid);
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		nvfnic_exch_reset(iport, tport);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	}
 
 	if ((tport->flags & FNIC_FDLS_SCSI_REGISTERED) ||
@@ -1829,6 +1848,7 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 	tport->fcid = fcid;
 	tport->wwpn = wwpn;
 	tport->iport = iport;
+	INIT_LIST_HEAD(&tport->ls_req_list);
 
 	FNIC_FCS_DBG(KERN_DEBUG, fnic,
 				 "Need to setup tport timer callback");
@@ -2440,6 +2460,8 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 	struct fnic *fnic = iport->fnic;
 	uint16_t oxid;
 	unsigned long flags;
+	struct fc_frame_header fchdr = {0};
+	uint8_t fcid[3];
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (!tport->timer_pending) {
@@ -2532,6 +2554,12 @@ static void fdls_tport_timer_callback(struct timer_list *t)
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
@@ -2842,6 +2870,12 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
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
@@ -4853,6 +4887,8 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			return FNIC_FDMI_BLS_ABTS_RSP;
 		} else if (fdls_is_oxid_tgt_req(oxid)) {
 			return FNIC_TPORT_BLS_ABTS_RSP;
+		} else if (fdls_is_oxid_nvme_req(oxid)) {
+			return FNIC_LS_REQ_ABTS_RSP;
 		}
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			"Received ABTS rsp with unknown oxid(0x%x) from 0x%x. Dropping frame",
@@ -5085,6 +5121,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
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
index 94b7c150c08c..b00672ef8b00 100644
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
@@ -614,9 +626,13 @@ int fnic_alloc_rq_frame(struct vnic_rq *rq)
 
 void fnic_free_rq_buf(struct vnic_rq *rq, struct vnic_rq_buf *buf)
 {
-	void *rq_buf = buf->os_buf;
+	void *rq_buf;
 	struct fnic *fnic = vnic_dev_priv(rq->vdev);
 
+	if (WARN_ON(!buf))
+		return;
+
+	rq_buf = buf->os_buf;
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_FROM_DEVICE);
 
@@ -651,7 +667,7 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 		dma_unmap_single(&fnic->pdev->dev, pa, frame_len, DMA_TO_DEVICE);
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "vnic work queue descriptor is not available");
-		ret = -1;
+		ret = -ENXIO;
 		goto fnic_send_frame_end;
 	}
 
@@ -685,7 +701,6 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *frame, int frame_size,
 	struct fcoe_hdr *pfcoe_hdr;
 	struct fnic_frame_list *frame_elem;
 	int len = frame_size;
-	int ret;
 	struct fc_frame_header *fchdr = (struct fc_frame_header *) (frame +
 			FNIC_ETH_FCOE_HDRS_OFFSET);
 
@@ -723,8 +738,7 @@ fdls_send_fcoe_frame(struct fnic *fnic, void *frame, int frame_size,
 
 	fnic_debug_dump_fc_frame(fnic, fchdr, frame_size, "Outgoing");
 
-	ret = fnic_send_frame(fnic, frame, len);
-	return ret;
+	return fnic_send_frame(fnic, frame, len);
 }
 
 int fnic_send_fcoe_frame(struct fnic_iport_s *iport, void *frame,
@@ -872,6 +886,9 @@ static void fnic_wq_complete_frame_send(struct vnic_wq *wq,
 {
 	struct fnic *fnic = vnic_dev_priv(wq->vdev);
 
+	if (WARN_ON(!buf))
+		return;
+
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
 	mempool_free(buf->os_buf, fnic->frame_pool);
@@ -914,6 +931,9 @@ void fnic_free_wq_buf(struct vnic_wq *wq, struct vnic_wq_buf *buf)
 {
 	struct fnic *fnic = vnic_dev_priv(wq->vdev);
 
+	if (WARN_ON(!buf))
+		return;
+
 	dma_unmap_single(&fnic->pdev->dev, buf->dma_addr, buf->len,
 			 DMA_TO_DEVICE);
 
-- 
2.47.1

