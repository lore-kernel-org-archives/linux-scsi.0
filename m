Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9494C2F7F08;
	Fri,  5 Jun 2026 23:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780703387; cv=none; b=J5LT1WBXZeuRf7S78yJw105+y2ONYy4MY8nTl8IyG71rLxLtQVXHL38FxOydI0wJzt75T+sXPqQoYLCBqDtewuKiLvwp5zAq+zb4wHmVWb4gPfyOlA0SSep94iWwIPamjixn4tr8YKz847LHE/aPCxfMLrZHD0F9KJ7dFcpRjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780703387; c=relaxed/simple;
	bh=DbZaQBKWNkP66MZVfHbHwUt6XaKcXX157O6z/VEF034=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eCOXxUHlzRbKX9mAp1Ev0xzFhVYE8dK9dxoRyiBPKGS4EsFeEkuMxzRYOUG0i3cBveU4NChhMxqsQltOhHW9FkYoRCq34225GxI/3oGlDAKhU9c+QeyBMkB7FDRESzgJaQNk7zTVMmnSHDK5WNMY83Sf56UDZyOLpWqMpIDVXXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=NTDbVvt6; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="NTDbVvt6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8280; q=dns/txt;
  s=iport01; t=1780703385; x=1781912985;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UjdgobZZ/9eUsUSLpYXJoTbVaLHYnDA6ayaePKIt2lQ=;
  b=NTDbVvt6Hl97+RnjR/VO/MuPWUxUB0R9Vmnfhs4Snxg4XcHAi9hY14QL
   v83TI4gFfI1efzoJCUJMLTBQvBlmBcE5byNFOMQNKOOyW98fqF0CbitIP
   9uPHHxcEbd0tJ+WhQtjbFSUAsLTZcTeiuImT/ZwVD1Me/JFRfOU9AnZD0
   RtwsEeEgPlITCdp5h00etQsr8mGvOEtCiXoADqhtlbbG5vRmWTXropD7Z
   twULUVHEKC3m9dXao/lweGtQH5SelXWEHQh8oevuYDCVtVgxCex7L/8Wb
   3Wc319+2L9C/OiPsyYKjfJfhSh/H+RvMf0JVPlU99Dut7SRpkFRcdDIS9
   g==;
X-CSE-ConnectionGUID: 6E+IIGbARi2DtfmlvFE/gg==
X-CSE-MsgGUID: nI9F+cdYS/aCy4kOGeWWMA==
X-IPAS-Result: =?us-ascii?q?A0BDAgAtXyNq/5P/Ja1aglmCGD+BUkMZMJQqgiGBFp0IF?=
 =?us-ascii?q?IFqDwEBAQ9RBAEBhQYCjTMCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBA?=
 =?us-ascii?q?QIBBwWBDhOGXIZbAgEDJwsBRhBRVhmCKliCdAO0BoF5M4EB3kKBZgELFAGBO?=
 =?us-ascii?q?I1ddIR7JxUGgUlEgRWCcgdvgVKCWIZdBIMuhnmJY0iBHgNZLAFVEw0KCwcFg?=
 =?us-ascii?q?WYDNRIqFW4yHYEjPheBCxsHBYFKgUlqgQSFEiMfAzmBF4F8gShnaRUxOhcDC?=
 =?us-ascii?q?xgNSBEsNxQbBD5uB4wuFw+BRWsHAVc3B3SBFAQrAWOSagIBkj6hDoQmoVsaM?=
 =?us-ascii?q?6prmQakCIU4gWg8gVkzGggbFYMiUxkPji0WyDwnMj0CBwIHDgMLk2UBAQ?=
IronPort-Data: A9a23:hLp4UqkKwznFxz+tp2KoUXvo5gxwJ0RdPkR7XQ2eYbSJt1+Wr1Gzt
 xIWXGiOM6qMYzanLYwnbYjjpE0CuZTcm99iSVA6+Cs8FFtH+JHPbTi7wugcHM8zwunrFh8PA
 xA2M4GYRCwMZiaC4E/raf658SUUOZigHtLUEPTDNj16WThqQSIgjQMLs+Mii+aEu/Dha++2k
 Y20+ZG31GONgWYubDpKs//b8XuDgdyr0N8mlg1mDRx0lAe2e0k9VPo3Oay3Jn3kdYhYdsbSb
 /rD1ryw4lTC9B4rDN6/+p6jGqHdauePVeQmoiM+t5mK2nCulARrukoIHKZ0hXNsttm8t4sZJ
 OOhGnCHYVxB0qXkwIzxWvTDes10FfUuFLTveRBTvSEPpqHLWyOE/hlgMK05FdM1ucdWLmtnz
 /1CBCwDaxSdqc/xz73uH4GAhux7RCXqFJkUtnclyXTSCuwrBMmbBa7L/tRfmjw3g6iiH96HO
 JFfMmUpNkmdJUQTZT/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKJJYLQFZsPxRzwS
 mTu+UWoLFIROO2kjjOu4y6vocDCohzecddHfFG/3rsw6LGJ/UQTAQcbfVi2u/+0jgi5Qd03A
 04Z+CAGqak06VztT9P4GRa/pRasuxcGR9tWVfU39AyX0afSywGDD2MAQ3hKb9lOnMY6TD8tz
 liUt8nkCTxmrPueTnf13rWRoDW/NigUBXUPaS8NUU0O5NyLiJs+kB/VVf55HaK1h8GzEjb1q
 xiOoDU4jLwVpdUWzKj99lfC6xqop57UXks26x/RU2aN8Ax0fsimapau5Fyd6uxPRK6dT1+cr
 D0fkNOfxP4BAIvLlyGXRugJWraz6J643Cb0m1VjGdwlsj+q4XPmJNgW6zBlL0AvOcEBEdP0X
 HLuVcpqzMc7FBOXgWVfOupd1+xCIXDcKOnY
IronPort-HdrOrdr: A9a23:EfhMhK+XRZT1xY8d3gduk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: =?us-ascii?q?9a23=3AN7VrwGk8Jr4f8fnkqWS45G/sPW7XOSPwj1bxDEW?=
 =?us-ascii?q?RM2czZKGbTFuO1o4jnMU7zg=3D=3D?=
X-Talos-MUID: 9a23:w50l1wVZ3q0C7xDq/DnN1R8hP8tZ2OOnI1FRkrIptva7EAUlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,189,1774310400"; 
   d="scan'208";a="476286232"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 05 Jun 2026 23:49:44 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.102.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 1FD2B18000887;
	Fri,  5 Jun 2026 23:49:43 +0000 (GMT)
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
Subject: [PATCH v3 08/13] scsi: fnic: Handle NVMe LS frames in FDLS
Date: Fri,  5 Jun 2026 16:45:33 -0700
Message-ID: <20260605234538.7950-9-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260605234538.7950-1-kartilak@cisco.com>
References: <20260605234538.7950-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.102.68];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.102.68, [10.188.102.68]
X-Outbound-Node: rcdn-l-core-10.cisco.com

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
 drivers/scsi/fnic/fnic_fcs.c  | 33 +++++++++++++++++++++++++++------
 2 files changed, 57 insertions(+), 6 deletions(-)

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
index ac1febaa8474..24fc36c0ad5c 100644
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
@@ -1048,6 +1067,8 @@ void fnic_tport_event_handler(struct work_struct *work)
 			if (tport->state == FDLS_TGT_STATE_READY) {
 				if (IS_FNIC_FCP_INITIATOR(fnic))
 					fnic_fdls_add_tport(&fnic->iport, tport, flags);
+				else if (IS_FNIC_NVME_INITIATOR(fnic))
+					nvfnic_add_tport(fnic, tport);
 			} else {
 				FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "Target not ready. Add rport event dropped: 0x%x",
-- 
2.47.1

