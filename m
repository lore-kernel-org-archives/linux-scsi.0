Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 939C131B10B;
	Fri, 24 Jul 2026 17:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915591; cv=none; b=k34N5vcDzDbpbmugq613gjPSa9IpCxzWKI6/3diV+W8VJQp3/DojZ5dtYnFi0bn28Mw2gyuDqh5K+EApxISYPHMYRhaFRSz+QkZRBO0ml4SqMV8mkI4ySk3bQZHhAfBUXPcgTTr7nfHg4WZ8xnxBCxuJY0RvU9K7FnTVkga0MQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915591; c=relaxed/simple;
	bh=o1thsjw4o2s/lD4DW/bA1x/Q2hfJd47TKzqDAnJqIO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dSWKq6rsxgPoAOR3788z9GJL7ThaTE5J0RWbtUQnJZLkCZa3mWXbTqW5Er5xBqZLDJiC/cfvEjnIv4XA3k/T84OdLw3LoJsCBXGRfrAxKItOcS65s6xKx4FCYiKqBoMSsih0Oe17p8fKF00fuZFqg4kqk2/pPv29cb159nPypGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ftDBabYj; arc=none smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ftDBabYj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=9376; q=dns/txt;
  s=iport01; t=1784915588; x=1786125188;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nT+FvfEGbQ0ml6w8AOYwQaYsTAGGRTvkSsubkJ2NHMo=;
  b=ftDBabYj2c7yp5NhydDcsHsjnAIHj1Ekka5MTF0Drs1s3S6Yy7lrs+Wv
   CL5uoh8Wmx/P451snKc2P/wt1uW2MZ08JnZ6A/7mVrVSIySdT2/iV6vb9
   3nUzWHra8Ji/6p3evJiwNR17ViaL9rRFztKr9knh84UcqIQ24QwNyWUdZ
   tAoBT0A/90sf1D7P1sbw1ubo43a+QBhKN0TRW7O9bHiBCgDSoGV9V4n77
   9k0o91hLGm+PJa+/6pDXzD1y/CCvEngdP//gdLxFAGsJlbNwiuHMjXDGE
   WRORU1ACyMAFWTmt2H4D+JpKX2R1vuinILCP+VZ0Tj3piSLRKEFvVt6sx
   w==;
X-CSE-ConnectionGUID: ff5KOHu7THKJ6hyNITyMRQ==
X-CSE-MsgGUID: N+22lYGYSdu2ytroV7GzgA==
X-IPAS-Result: =?us-ascii?q?A0BDAgBrpWNq/5AQJK1aglmCV4FSQxkwlCmCIYEWnQgUg?=
 =?us-ascii?q?WoPAQEBD1EEAQGFBQKNYAImNAkOAQIEAwIDAQEBAQEBAQEBAQEBCgEBBQEBA?=
 =?us-ascii?q?QIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ1A8IwgXkzgQHeRYFmAQsUAYE4j?=
 =?us-ascii?q?V91hHwnFQaBSUSBFYJzB2+BUoJYhl4EgxwSgkiDF4xhSIEeA1ksAVUTDQoLB?=
 =?us-ascii?q?wWBZgM1EioVbjIdgSM+F4EMGwcFgR2BLHmEWCMfAzl/gS91SnctaQESF4Emg?=
 =?us-ascii?q?0sCgU8DCxgNSBEsNxQZBD5uB413I4FOawcBLCspDgd0gRgrAWOSRiQCAZI+o?=
 =?us-ascii?q?Q+EJ6FbGjOqbJkIpAqFOYFoPIFZMxoIGxWDIlMZD44tFtI6JzI9AQEHAgcOA?=
 =?us-ascii?q?wuBaJAABIF6AQE?=
IronPort-Data: A9a23:LHHEC6o0cUi1m1usBNnfUXzSvzVeBmLuZBIvgKrLsJaIsI4StFCzt
 garIBmFafmJYGP2L9l2bY7i9E4E78XTzYVgQQQ+qCEzFSpH9uPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOWn9T8jifHgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgLNNwJcaDpOtfrc8k825ZwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0uh5XEJp1
 eFHFBAuTE6DlsSX/KOecNA506zPLOGzVG8eknhkyTecCbMtRorOBv2Vo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtLYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUozSGZwLxRnG+
 Aoq+UzfQUtAMO2w+AGJ7yi9mvXIo3zUSo07QejQGvlCxQf7KnYoIB0fT1aTovSjjEO6HdVFJ
 CQ8+Ccsp4A29Uq2Xp/8VRj+q3mB1jYZUsBMEut88AyRx7DP7gCxAXINRTpMLtchsaceTDAj1
 ViRmM7BHzFjsLSJD3ma89+8rza/PyUaLW4qfyIITQIZpdLkpekblB/RQ8x4OLS4gt38BXf7x
 DXihCwymrMYhMgjzLig8BbMhDfEjpzISBMlowbaRGSo6itna4O/IY+l817W6bBHNonxZl2Au
 mUU3tOV9+EmE56AjmqOTf8LEbXv4OyKWAAwmnZmG50nsjDo8Hm5cMUIv3d1JVxiNYAPfjqBj
 FLvhD69LaR7ZBOCBZKbqarrYyj25cAMzejYa80=
IronPort-HdrOrdr: A9a23:l1CaWK/BhHlSsSDVsHNuk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: 9a23:1fJb4Wzglbp8DNbQBPjbBgUaFJ0GVV3Ak0vwAG3mCXdPaYGEbGWprfY=
X-Talos-MUID: 9a23:fc9M2QWuE2svsJnq/Bmv3mtmBehZ2KizUlERi5I45OaWOgUlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="804163766"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:53:07 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id D00BF180001E7;
	Fri, 24 Jul 2026 17:53:01 +0000 (GMT)
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
Subject: [PATCH v6 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Date: Fri, 24 Jul 2026 10:48:06 -0700
Message-ID: <20260724174811.5118-9-kartilak@cisco.com>
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

Changes between v5 and v6:
Incorporate review comments from Sashiko:
	Avoid stale OXID reclaim after pool reset
---
 drivers/scsi/fnic/fdls_disc.c | 48 ++++++++++++++++++++++++++++++++++-
 drivers/scsi/fnic/fnic_fcs.c  | 34 ++++++++++++++++++++-----
 2 files changed, 74 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index e03256183ac6..30d9bcd3795f 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -327,12 +327,19 @@ void fdls_schedule_oxid_free_retry_work(struct work_struct *work)
 			return;
 		}
 
-		clear_bit(idx, oxid_pool->pending_schedule_free);
 		reclaim_entry->oxid_idx = idx;
 		reclaim_entry->expires = round_jiffies(jiffies + delay_j);
+
 		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		/* Reset may have cleared this bit while this worker allocated. */
+		if (!test_and_clear_bit(idx, oxid_pool->pending_schedule_free)) {
+			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+			kfree(reclaim_entry);
+			continue;
+		}
 		list_add_tail(&reclaim_entry->links, &oxid_pool->oxid_reclaim_list);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
 		schedule_delayed_work(&oxid_pool->oxid_reclaim_work, delay_j);
 	}
 }
@@ -387,10 +394,25 @@ static bool fdls_is_oxid_tgt_req(uint16_t oxid)
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
 
@@ -1288,6 +1310,10 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 		fnic_rport_exch_reset(iport->fnic, tport->fcid);
 		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		nvfnic_exch_reset(iport, tport);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	}
 
 	if ((tport->flags & FNIC_FDLS_SCSI_REGISTERED) ||
@@ -1829,6 +1855,7 @@ static struct fnic_tport_s *fdls_create_tport(struct fnic_iport_s *iport,
 	tport->fcid = fcid;
 	tport->wwpn = wwpn;
 	tport->iport = iport;
+	INIT_LIST_HEAD(&tport->ls_req_list);
 
 	FNIC_FCS_DBG(KERN_DEBUG, fnic,
 				 "Need to setup tport timer callback");
@@ -2440,6 +2467,8 @@ static void fdls_tport_timer_callback(struct timer_list *t)
 	struct fnic *fnic = iport->fnic;
 	uint16_t oxid;
 	unsigned long flags;
+	struct fc_frame_header fchdr = {0};
+	uint8_t fcid[3];
 
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	if (!tport->timer_pending) {
@@ -2532,6 +2561,12 @@ static void fdls_tport_timer_callback(struct timer_list *t)
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
@@ -2842,6 +2877,12 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
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
@@ -4853,6 +4894,8 @@ fnic_fdls_validate_and_get_frame_type(struct fnic_iport_s *iport,
 			return FNIC_FDMI_BLS_ABTS_RSP;
 		} else if (fdls_is_oxid_tgt_req(oxid)) {
 			return FNIC_TPORT_BLS_ABTS_RSP;
+		} else if (fdls_is_oxid_nvme_req(oxid)) {
+			return FNIC_LS_REQ_ABTS_RSP;
 		}
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			"Received ABTS rsp with unknown oxid(0x%x) from 0x%x. Dropping frame",
@@ -5085,6 +5128,9 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
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

