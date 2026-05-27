Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25BD37472D;
	Wed, 27 May 2026 19:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779911780; cv=none; b=gjn9FJXLUCcCr9tULyBO4We4IHK6DVDpapFJT1DfusyvqrKm/419dkkoC6s61Mx/cqQCgDiyIc7GwVdftwlH116YvcHbFKu52f2fD82qYPmafPcVgjlz6PXUpYxlyp7QYu+uerFldfRU+1xfVBoU9jLUtm9ceCXWlOonDb9V+c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779911780; c=relaxed/simple;
	bh=yd7fSWz2OxQSCIzP6ZDdWKZUlqhjaVinmjUdIfEfCHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eb3GBrtgM5pqH5JnyY3rga+eIOauOCrUGktoTrWGkECgS9TtUh256DG43bVOwk0CEoB1Oti/C2plCPrB5ANVSnm4rL+UvyUtPDaQfjaTiVlsSzasBkxDCVl2ElTobCyit0Dt71RMHNYUfJUE6+610jT6p+8CWeYSDXzYE5+UbjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jkxwJ/Vp; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jkxwJ/Vp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=4608; q=dns/txt;
  s=iport01; t=1779911779; x=1781121379;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=a3u5qG3Fa73TSO0BMlkarqmE7qkhFv2C0cnBcV0o5bQ=;
  b=jkxwJ/Vp9M3vKx5cHTf1uG9Qkcj5dTG3tNrFQ3bht2Ng+1UYaGyGx6up
   xpjDANGtQPWcN79A1pSPchWyezKL7axaKFnXsZDqAyxa0eJasI0AJOYfb
   tScsF0PkeUo1Ev6vCLO7LS63HdMLm0dGyVZ0hO1J8cg2KOVIzxlUX8vDS
   aRHvbCvqsuVHqvdEFj0N6NnxFi/5GAP6UxSwWnI8bVpwO23xwV0WM3CWM
   EX86I7hHrRCeBWIN2YoSSk09Iz1ILLawuqsYslJQPlIJp0u+X+qacrGee
   VWNbfNofgZF/y1UbRI1qBwscEKUGMwfKUBxA9AN4oHpmxP0lnevcXr0vH
   A==;
X-CSE-ConnectionGUID: c/02FJAjS6a3Bx8f44BEzw==
X-CSE-MsgGUID: 2cca4xwDSl+h0gAUhbBCPg==
X-IPAS-Result: =?us-ascii?q?A0BCAgDCSxdq/5P/Ja1aHgEBCxIMggULgleBUEMZMJQqg?=
 =?us-ascii?q?iGeHoF+DwEBAQ9RBAEBhQYCjTICJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7RUgXkzgQHeQYFkAQsUA?=
 =?us-ascii?q?YE4jVx0hHsnFQaBSUSBFYNogQUBTIk1BIMuhnSIHUiBHgNZLAFVEw0KCwcFg?=
 =?us-ascii?q?WYDNRIqFW4yHYEjPheBCxsHBYFLdnJqgQWFGCMmA06BLYF/XQMLGA1IESwUI?=
 =?us-ascii?q?xQbBD5uB4p1Gg+CMYEPgj8eAZMnkkiBNZ9ZhCahWxozqmuZBqQIhTiBaDyBW?=
 =?us-ascii?q?TMaCBsVgyJTGQ+OLQsLzmUnMj0CBwIHDgMLk2UBAQ?=
IronPort-Data: A9a23:p/8McK7Zf/33bjCmB//DzAxRtMnGchMFZxGqfqrLsTDasY5as4F+v
 jdKCzyFPa2KNGKhKth3O4ng80wGvZfVzoNlTQRq+C8xZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH2dOC98RGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo/6UzBHf/g2Qqaj9OtPrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eNspAoMhVKGN1q
 /VDAiBdYEzfrc+k3+fuIgVsrpxLwMjDJogTvDRkiDreF/tjGMiFSKTR7tge1zA17ixMNa+BP
 IxCNnw1MUmGOkEQUrsUIMpWcOOAhXDlbzxcoVG9rqss6G+Vxwt0uFToGIaFJITQHpwIwi50o
 Eqc9G/wXgEFGOebijrd/VuRhuXlthv0Ddd6+LqQs6QCbEeo7mwaEhA+Vlahp/S9zEmkVLp3K
 UEW8AIqrK4v5AqqRNy7VBq9yFaBtwQAWtwWC+Am5RuWx6z85ByQDWwJCDVGbbQOvcM/Rjsy0
 UKhhd7lBTVz9raSTBq19LKZqz69OSk9N2IOZSYYCwAC5rHLuowtgwjUZsxuHK68kpv+HjSY6
 zSGsS41jrM7ltMQ2uOw+lWvqzatoIXZCw04/APaWkq74Q5jIo2ofYql7R7c9/koBIKYSESR+
 WMPgMm28u8DF9eOmTaLTeFLG6umj8tpKxXGilJpWp1k/DO39jv6JcZb4Sp1IwFiNcNslSLVX
 XI/cDh5vPd7VEZGp4cuC25tI6zGFZTdKOk=
IronPort-HdrOrdr: A9a23:DBu9FqzqPEIeEvOobylmKrPw5r1zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0tFfEVNd7xq6Rt/B0KwF017QxQDOL8Cfa
 DsgPauY1GbCAwqhgPRPAh9Y9T+
X-Talos-CUID: 9a23:1CxsMWGmNC02P0JcqmJssxZONOIMcEaDxSz6Mx+2VTpDZa+KHAo=
X-Talos-MUID: =?us-ascii?q?9a23=3AALv0qA0RZ2spddImLiFMtpXEFTUjua+lARwdjrk?=
 =?us-ascii?q?9v4qEbSNZBjeXph+PTdpy?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,172,1774310400"; 
   d="scan'208";a="486023154"
Received: from rcdn-l-core-10.cisco.com ([173.37.255.147])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 27 May 2026 19:56:18 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.14.55])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-10.cisco.com (Postfix) with ESMTPSA id 8110318000241;
	Wed, 27 May 2026 19:56:16 +0000 (GMT)
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
Subject: [PATCH v2 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Date: Wed, 27 May 2026 12:49:57 -0700
Message-ID: <20260527195000.8444-11-kartilak@cisco.com>
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

