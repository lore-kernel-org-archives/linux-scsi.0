Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD8F386C3D;
	Thu, 21 May 2026 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779387073; cv=none; b=ac1AO8lm0A+UoElNkHZKzSn5yw37UGqmDRBCGyTJb6tnFdlz3PvNFukDpM1kewWxYME+gWHHNwS3nSGvABeCU5c9cAeWi6lWpWQ87BeMeRWwfCekOtGG5IpLfwZmY6/tGY4e2VvwTiTwhuS0iTVdjpxZRxxRbT4/7ojg8sfB7mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779387073; c=relaxed/simple;
	bh=yd7fSWz2OxQSCIzP6ZDdWKZUlqhjaVinmjUdIfEfCHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GCSqIqnJlpgpzGwELXpm91I95IRG7tuq4AfoMQhM9EPOihjl0AnLSH2ftSTUagx4Lm1UqEUJGQ3UITJBOTWoUDINM5E43oWStXVEcgqc1Q59oXUnxkw2rCtQeaDhOS9smYIS0n0NVlNIaHHXew8XGadO257LhiZHp0DMY8LWnow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Lr2wyXlV; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Lr2wyXlV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4608; q=dns/txt;
  s=iport01; t=1779387071; x=1780596671;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a3u5qG3Fa73TSO0BMlkarqmE7qkhFv2C0cnBcV0o5bQ=;
  b=Lr2wyXlVwgkVq0ZUA5k7NzEvtBvApUBciJ7o1xk628nLoUu07296OnSg
   rLCaMRUQxkQnm8XIGHhsS04S42SykPYbJyZas6nm1JwnXH0BaGWPFfZ1D
   j972Zjhy++llLiwNwYYn452rBiDh8riyAy0RNtROg7pTaVEcF0Lcl5EYs
   XkZJFezNaYfVpinBwwEQYq5/gfFg6tWZuLoI8uX6+ShC8qsBDqVRZu0Gc
   LzNYWLokGlRgHeTzr8dzrz0dZ+ufl+tkYR+c8AnoaFpPb1h7fpkavayfA
   N9ZFKWTkZGU28Le812sYSTt3GoXn4gYgVA1Qk/Dnqi9KwcKW3n6Pa2b6s
   g==;
X-CSE-ConnectionGUID: q/hK26UwR0CClI9FsTA6Rg==
X-CSE-MsgGUID: d+w2xGqWRH6t/l/zW23nPQ==
X-IPAS-Result: =?us-ascii?q?A0BCAgDGSQ9q/5L/Ja1aHgEBCxIMggULgleBUEMZMJQqg?=
 =?us-ascii?q?iGeHoF/DwEBAQ9RBAEBhQYCjTICJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7QbgXkzgQHeQYFkAQsUA?=
 =?us-ascii?q?YE4jVx0hHsnFQaBSUSBFYNogQUBTIk1BIMuhxqIAkiBHgNZLAFVEw0KCwcFg?=
 =?us-ascii?q?WYDNRIqFW4yHYEjPheBCxsHBYFLgTdyaoEEhFd4IywDToEtgWsDCxgNSBEsF?=
 =?us-ascii?q?CMUGwQ+bgeKeRwPgjGBD4I/HgGTJ5JIgTWfWYQmoVgaM6pqmQWkCIU4gWg8g?=
 =?us-ascii?q?VkzGggbFYMiUxkPji0LC8seJzI9AgcCBw4DC5NlAQE?=
IronPort-Data: A9a23:jbov7qrUr7THiBAdgfqUeIpi4xheBmKTZBIvgKrLsJaIsI4StFCzt
 garIBmAb/iJMDSnftxxbN+09RxUv8eAnNViHAY5+y9nQnhH+ePIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9j8kif3gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgPNNwJcaDpOtfre8ko34JwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0v8wAUIUq
 8EHEmgmRRSi1syt/JvlcOY506zPLOGzVG8ekmtrwTecCbMtRorOBv2bo9RZxzw3wMtJGJ4yZ
 eJANmEpN0uGOUASfA5LVvrSn8/w7pX7Wz5Rsk6UoaM0y2PS1wd2lrPqNbI5f/TWFZkLzxfC/
 zOuE2LRDlIFbsyw0AW/0iywweuIjxyhA4QqLejtnhJtqBjJroAJMzUWXEG2ifq0kEizX5RYM
 UN80iYnq+45/VazQ9/hUgeQpH+CtwQbHd1KHIUS6gyPwILQ4gCEFi4FRDsHY9sj3OczTCY21
 1nPh971CCZ0vbu9TmiU/bOZ6zi1PEA9JGMLZigcShYt+dTvoIgvyBnIS75LEqu4iND6GTDY2
 T2GrCEiwb4UiKYjzail8ErcqyihqpjAUkg+4QC/dmap8wVybYiNfJGz5B7Q6vMoBIKYSESR+
 XsJgc6T6MgQApyX0i+AWuMAGPeu/fntGDndh0N/WoIq7DWF5XGuZ8ZT7St4KUMvNdwLEQIFe
 2fJsg9XoZsWN3ywYOovMsS6Ct8hyu7rEtGNuu3oU+eiq6NZLGevlByCr2bJt4wxuCDASZ0CB
 Ko=
IronPort-HdrOrdr: A9a23:SXwzv64NG70R7/SNhAPXwALXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fj5kYoax12YKd96Ao8IAOaHkpqADRiP/MCZf
 yhDg4tnUvZRZzRBf7Lf0U4Yw==
X-Talos-CUID: 9a23:9ElLGm1RLhqmXXqkd2wR5rxfA4clUSeD8Wjqe2STDUc4ZqapYAGq9/Yx
X-Talos-MUID: =?us-ascii?q?9a23=3A84xLSgybYJU216+q2ZtbKNBYiR+aqKjtFxodvow?=
 =?us-ascii?q?5genaKWt0fCWi1m+xerZyfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="484699219"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:11:10 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id D201A1800023E;
	Thu, 21 May 2026 18:11:08 +0000 (GMT)
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
	dan.carpenter@linaro.org,
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Date: Thu, 21 May 2026 11:04:55 -0700
Message-ID: <20260521180458.5448-11-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260521180458.5448-1-kartilak@cisco.com>
References: <20260521180458.5448-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.18.181];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.18.181, [10.188.18.181]
X-Outbound-Node: rcdn-l-core-09.cisco.com

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
 drivers/scsi/fnic/fdls_disc.c | 38 +++++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |  2 ++
 drivers/scsi/fnic/fnic_nvme.c | 16 +++++++++++++++
 3 files changed, 56 insertions(+)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 0fcdfdea8fb4..5d010b38102c 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -654,6 +654,44 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
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
+	fnic_send_fcoe_frame(iport, frame, frame_size);
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
index 83a43df28956..dc202f0ae4d8 100644
--- a/drivers/scsi/fnic/fnic_nvme.c
+++ b/drivers/scsi/fnic/fnic_nvme.c
@@ -1195,6 +1195,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
 	uint16_t oxid = nvfnic_ls_req->oxid;
+	int timeout;
 
 	FNIC_NVME_DBG(KERN_INFO, fnic,
 		      "tport: 0x%x lsreq: 0x%x state: %d timeout\n",
@@ -1228,6 +1229,19 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
@@ -1519,6 +1533,8 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	mod_timer(&nvfnic_ls_req->ls_req_timer,
 		  round_jiffies(jiffies + msecs_to_jiffies(timeout)));
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+
+	fdls_send_ls_req_abts(iport, tport, nvfnic_ls_req->oxid);
 }
 
 bool nvfnic_queue_abort_io_req(struct fnic *fnic, int tag,
-- 
2.47.1

