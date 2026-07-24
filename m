Received: from alln-iport-2.cisco.com (alln-iport-2.cisco.com [173.37.142.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC680C8CE;
	Fri, 24 Jul 2026 17:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784915654; cv=none; b=pJtw4/1yGL6RDpRCA08iQGnOBJgj5X2lh6TROj1EMjF4v9/Dw/bhg1eH32VgnzK2rsqLRaNJIRfzV+Us9+jtGgXZoL3wGLqOoZ3VrsHzvX6Dh6YcKqFmJ9yIYH9jftMv+bkvXWf9fCPR6gBuDe59t8S+UiN4kDNRjdzb9j8bGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784915654; c=relaxed/simple;
	bh=p3QlGX+Iiff45uXFUTIZMntWRgpT8+OHyk64wod2ymE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRy06qGK8THUB8IN/6V8TMFwM62AKQMqqjhj4Mnzzs92O44EWmpLxSGhNiNDpoWFJlOjo0Ctv70xRQNlvEGamCbSwI0Npi7KSW9j8mZkDUTeolrAU/QIuqEInJ01BhtoMxecs9/pFJCBaW9J6k1pzT3dTj8T2oKUvNftQf/1ZD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=ZPi+4fxw; arc=none smtp.client-ip=173.37.142.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="ZPi+4fxw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8183; q=dns/txt;
  s=iport01; t=1784915652; x=1786125252;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VXJJ9YMwSOAgyzChW3/r1XJ7dvfa4ysqUepQPAItqZc=;
  b=ZPi+4fxwU6YHrTB+eggEBni0OiX9Em8GUG8dHawUcKdz/SICW+9EmOmo
   WjUJovO2Te8o/O8dz6+opy8QQO4U+Zug0nzZHzer1RP2NmMRkTJuWeJbY
   Z3EKG/md3RC+FJIV1lG9AS0ZqeuKVlmyuXtWtcvBBTG0xxWWKdG2b5kuF
   zl77dq+4SNpF6GTBqWIJUbbs2+RGgPXPHXAfZHbR/PQ18v3PwSQGDvFyP
   tYR7cTCtE4eyAQNAYRjwe+AEfl5cfW6dVkt5VzJk2+17mXcs7Jgj8jBwc
   Ln7k2xOH8QtDMGqS+XSDwteDhU1HaKFANw5/ug7alaPJ/+/wj9AMvTKTk
   Q==;
X-CSE-ConnectionGUID: 3TXpxZZ1S8u8jEoTdk7o4A==
X-CSE-MsgGUID: QJtmHg7tQDix7EbjdMkoHA==
X-IPAS-Result: =?us-ascii?q?A0BCAgDcpWNq/5AQJK1aglmCV4FSQxkwlCmCIZ4egX4PA?=
 =?us-ascii?q?QEBD1EEAQGFBQKNYAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHB?=
 =?us-ascii?q?YEOE4ZchlsCAQMnCwFGEFFWGYMCgnUDwjCBeTOBAd5FgWYBCxQBgTiNX3WEf?=
 =?us-ascii?q?CcVBoFJRIEVg2mBBQFMiTYEgy6DZIFhjHtIgR4DWSwBVRMNCgsHBYFmAzUSK?=
 =?us-ascii?q?hVuMh2BIz4XgQwbBwWBHYEseYRYIx8DOX+BL3VKdy1pARIXgSaDSwKBTwMLG?=
 =?us-ascii?q?A1IESwUIxQZBD5uB413I4JAgQQLE2yBPwEeAZMnkkiBNZ9ahCehWxozqmyZC?=
 =?us-ascii?q?KQKhTmBaDyBWTMaCBsVO4JnUxkPji0LC9I6JzI9AQEHAgcOAwuBaJF+AQE?=
IronPort-Data: A9a23:06S8Da3DUsA7cK/KKPbD5SVwkn2cJEfYwER7XKvMYLTBsI5bpz0Cn
 2MeXWrSafaKZmKne9Bza4/jo04OuJ7QzN5mTgc93Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmH4E/xbtANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXX5
 Lsen+WFYAX7g2EubjtNg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGV30GJZ0qyL9MUXwe9
 9EfFDwOMRffrrfjqF67YrEEasULJc3vOsYb/3pn1zycValgSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2MEiojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZj+ixbIWIJYfaLSlTtn+6u
 mfm8DvlOz0bJIOywziJ13GrpsaayEsXX6pXTtVU7MVCgFSJy0QQBQcQWF/9puO24ma8VtBVA
 0gV/Dc+66k48QqgSdyVdxixumKFuFgEVsZdCfY37imK0KPf5wvfDW8BJhZIZNUls9cxWBQw2
 1OJls+vDjtq2JWXTH+b+7iUrBuoNCQVJHNEbigBJSMf7sfuupoblB/DTt9/VqWyi7XdHT3tx
 TuDqgAlmq4ey8UM0s2T+VHBniLppZXTSAMxzhvYU3jj7Q5jYoOhIYuy5jDz6fdGMZbcVVKav
 VAalMWEquMDF5eAkGqKWuplIV2yz/+BNDuZhRtkGIMssmzyvXWiZotXpjp5IS+FL/o5RNMgW
 2eL0Ss52XOZFCHCgXNfC25pN/kX8A==
IronPort-HdrOrdr: A9a23:KoiU26+aYQSzgarjbU1uk+ASI+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/815dCSd3dqpn8wB1TiyfEkFwWU16IKBRLu
 v72iKCzADQAUj+qa+AdwA4Y9Q=
X-Talos-CUID: 9a23:NaNyUG+/zpgnYhGdagyVvxUoKtg1QE+E9yfNc02VDlplS+KSFXbFrQ==
X-Talos-MUID: =?us-ascii?q?9a23=3ApTsozQ1FFarzTSN+d9ks9/+5OTUj2oayDWACzok?=
 =?us-ascii?q?/l8iUagF6OTu4jzOXa9py?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,183,1779148800"; 
   d="scan'208";a="784475738"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by alln-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jul 2026 17:54:11 +0000
Received: from fedora.cisco.com (unknown [10.189.189.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 686DB180001C6;
	Fri, 24 Jul 2026 17:54:05 +0000 (GMT)
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
Subject: [PATCH v6 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Date: Fri, 24 Jul 2026 10:48:08 -0700
Message-ID: <20260724174811.5118-11-kartilak@cisco.com>
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

Changes between v4 and v5:
Incorporate review comments from Sashiko:
	Arm NVMe LS abort timer after send succeeds

Changes between v5 and v6:
Incorporate review comments from Sashiko:
	Send timed-out LS aborts under fnic lock
---
 drivers/scsi/fnic/fdls_disc.c | 44 ++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |  2 +
 drivers/scsi/fnic/fnic_nvme.c | 69 ++++++++++++++++++++++++++++-------
 3 files changed, 101 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 30d9bcd3795f..8cb40466872f 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -670,6 +670,50 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
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
index 0b05dc9698be..aa3c935d0815 100644
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
@@ -1279,6 +1283,23 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
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
@@ -1288,6 +1309,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
 	uint16_t oxid = nvfnic_ls_req->oxid;
+	int timeout;
 
 	FNIC_NVME_DBG(KERN_INFO, fnic,
 		      "tport: 0x%x lsreq: 0x%x state: %d timeout\n",
@@ -1309,10 +1331,8 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
@@ -1321,6 +1341,18 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 		FNIC_NVME_DBG(KERN_ERR, fnic,
 			      "tport: 0x%x lsreq: 0x%x sending abort\n",
 			      tport->fcid, nvfnic_ls_req->oxid);
+		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
+
+		if (fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid) == 0) {
+			timeout = FNIC_LS_REQ_TMO_MSECS(ls_req->timeout);
+			mod_timer(&nvfnic_ls_req->ls_req_timer,
+				  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+			return;
+		}
+		FNIC_NVME_DBG(KERN_ERR, fnic,
+			      "tport: 0x%x lsreq: 0x%x cannot send abort\n",
+			      tport->fcid, oxid);
 	}
 
 	if (ls_req->private == NULL) {
@@ -1328,10 +1360,8 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 		return;
 	}
 
-	list_del(&nvfnic_ls_req->list);
 	ls_req = nvfnic_ls_req->ls_req;
-	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
-	ls_req->private = NULL;
+	nvfnic_ls_req_cleanup(iport, ls_req, oxid);
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 	ls_req->done(ls_req, -ETIMEDOUT);
@@ -1442,11 +1472,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 
 	ret = fnic_send_fcoe_frame(iport, frame, frame_size);
 	if (ret) {
-		list_del(&nvfnic_ls_req->list);
-		fdls_free_oxid(iport, nvfnic_ls_req->oxid,
-			       &nvfnic_ls_req->oxid);
-		nvfnic_ls_req->state = FNIC_LS_REQ_CMD_COMPLETE;
-		ls_req->private = NULL;
+		nvfnic_ls_req_cleanup(iport, ls_req, nvfnic_ls_req->oxid);
 		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 		mempool_free(frame, fnic->frame_pool);
 		return ret;
@@ -1590,6 +1616,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	struct nvfnic_ls_req *nvfnic_ls_req;
 	uint16_t oxid;
 	int timeout;
+	int ret;
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
@@ -1648,10 +1675,24 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 
 	/* Mark the state and flags */
 	nvfnic_ls_req->state = FNIC_LS_REQ_CMD_ABTS_PENDING;
-	timeout = FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
-	mod_timer(&nvfnic_ls_req->ls_req_timer,
-		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+	oxid = nvfnic_ls_req->oxid;
+
+	ret = fdls_send_ls_req_abts(iport, tport, oxid);
+	if (!ret) {
+		timeout = FNIC_LS_REQ_TMO_MSECS(lsreq->timeout);
+		mod_timer(&nvfnic_ls_req->ls_req_timer,
+			  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		return;
+	}
+
+	if (!nvfnic_ls_req_cleanup(iport, lsreq, oxid)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		return;
+	}
+
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+	lsreq->done(lsreq, -EAGAIN);
 }
 
 bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
-- 
2.47.1

