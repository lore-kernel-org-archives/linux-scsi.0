Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8A07E105;
	Wed, 24 Jun 2026 04:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276583; cv=none; b=SmtqB5JsBHEYatoWdBhChyh3qlwKbuYl/HmIAeHO1hHVfYUCkH2TZ7EkDp4FoOpuhhKNTqFOtz/aSDv0HVe0vkJkBwujsEKzTAtB/fqJCs29duPk2Q9LhNhhDr0hJtCs5enYC0ZC+X0MFYDAyxd/9W3zKSdDaCrzZeI8hdzvUlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276583; c=relaxed/simple;
	bh=YNZQk3K4lS+qyn37WILN04iJMkBfaMI/s745+zJW5iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpLKncAfQSxvApwor9sccZsaAoCXbc0Ghj4sCoNy8nhsXvdSqXBHUkYX/J23osFzfyBCUcNn5c/obCfHc2d6K2ZMP3OYznn0Lp8Ky4jlpc0cYZoWZHN2YeuFVFEcvfTDvBoKJdPp2BB8yiNXaaJNvl3BZ6VBP2Zc7DqjY8AxEfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=La4ycICe; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="La4ycICe"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8125; q=dns/txt;
  s=iport01; t=1782276581; x=1783486181;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fftHBRor3AghukrV+dy0ZCZoXItjyNYCHoCXPlDeqLc=;
  b=La4ycICe1TUMZUpUtjNA6ffognagvnEk5aXlR0KYfBHNpaHY9DKoSyrj
   UrMQH71FV6RiUNm3O4xzwEaGKSLISP9R5Y0OBfevga1VeqX/TPlI5B6Pr
   +07XhAUVV/fxikA+3dOIQopo0i/PTdgQGbOy2ctW4z79Q5Zodh7l0ldrD
   Zs36QHahaIPBpR1wQ6IxKVPKlRDt9bJJGItj6u47xX2oPP9wc97WEn4Si
   eoThGiHubz7ubMDxtPzt1C6y2qy99XG4S2a04gOzDdrdy6fKP3LsIegS2
   m/brmDw/NTuuA2gBztGGYyTfvLhzaB1Ij927j+eCTrLufxKcwCNfW4eLP
   g==;
X-CSE-ConnectionGUID: XCXoUwLRSF+4O+v4Sz2+Fg==
X-CSE-MsgGUID: 2w4TW9E6TfybTQwLQIzD9g==
X-IPAS-Result: =?us-ascii?q?A0BCAgD1YDtq/4//Ja1aHgEBCxIMggULgleBUkMZMJQqg?=
 =?us-ascii?q?iGeHoF+DwEBAQ9RBAEBhQYCjUoCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A7IsgXkzgQHeQ4FmAQsUA?=
 =?us-ascii?q?YE4jV50hHwnFQaBSUSBFYNpgQUBTIk2BIMuhByBYosESIEeA1ksAVUTDQoLB?=
 =?us-ascii?q?wWBZgM1EioVbjIdgSM+F4EMGwcFgR2BboEEhQIjHwM5f4E/gSRkZhUwNYEBA?=
 =?us-ascii?q?REfCoE1AwsYDUgRLBQjFBsEPm4HjF0XD4I9gQQLE4IrAR4BkyeSSIE1n1qEJ?=
 =?us-ascii?q?6FbGjOqbJkIpAqFOIFoPIFZMxoIGxU7gmdTGQ+OLQsL0jonMj0CBwIHDgMLk?=
 =?us-ascii?q?2UBAQ?=
IronPort-Data: A9a23:LjrT5q/9RuZwswc3AtUJDrUDcX+TJUtcMsCJ2f8bNWPcYEJGY0x3z
 mEYUW3UM/qPMWf1eotwOt6x80wF6p6HnYJmHAU4qChEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4muyyHjEAX9gWAsbDhPs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kGFr0fx/lTO1pgt
 qA/ay5RVQLZxMy5lefTpulE3qzPLeHxN48Z/3UlxjbDALN+H9bIQr7B4plT2zJYasJmRKmFI
 ZFGL2AyMVKZP0Yn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3FbIuEJYPRFZ0J9qqej
 jjZo1jGUzxECNKOwwa87VaVp/3jzCyuDer+E5X9rJaGmma7xmUJBTUVWEG9rP3/jVSxM/pdJ
 k4e0i4vq7Uisk2hS5/2WBjQiHuNpAIdXZxIHvE38hqAzILT+Q+SAmVCRTlEAPQvuMY1QiQty
 3eTkt/pDCApu7qQIVqf87qSoDyyOAAPIGMCbDNCRgwAi/H5rZ8+lAnnVNtvEKepyNbyHFnYx
 zyXqiM3gZ0IkNUGka68+DjvhzOqu4iMTQMv4AjTdnyq4xk/Z4O/YYGsr1/B4p5oKIefU0nEp
 3MfmuCA4+0US5KAjiqARKMKBr7B2hqeGCfXjVgqG9wq8C6gvib9O4tR+zp5YkxuN67oZAPUX
 aMagisJjLc7AZdgRfUfj16ZYyjy8ZXdKA==
IronPort-HdrOrdr: A9a23:8RWRtKqA6YId5nbLcTBJBdMaV5rheYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McShaL4d98gx+FgGXVmdyRAVAGN4FMa
 D03Lsgm9JlEk5nFvhSwRI+LpH+m+E=
X-Talos-CUID: 9a23:uxYNpGM8ZXmQ2+5DaAJX83MLPvoeXD6B6zTOf3SqUyVHR+jA
X-Talos-MUID: =?us-ascii?q?9a23=3AN0lRAw1S4onjmb06M4gA+/3tqTUjubvyNH9cvMs?=
 =?us-ascii?q?6tdiOCRVvHw68nhjmTdpy?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,221,1774310400"; 
   d="scan'208";a="499773804"
Received: from rcdn-l-core-06.cisco.com ([173.37.255.143])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Jun 2026 04:49:35 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.122.232])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-06.cisco.com (Postfix) with ESMTPSA id CE7D818000277;
	Wed, 24 Jun 2026 04:49:33 +0000 (GMT)
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
Subject: [PATCH v5 10/13] scsi: fnic: Abort timed-out NVMe LS requests
Date: Tue, 23 Jun 2026 21:43:31 -0700
Message-ID: <20260624044334.3079-11-kartilak@cisco.com>
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
---
 drivers/scsi/fnic/fdls_disc.c | 44 ++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |  2 +
 drivers/scsi/fnic/fnic_nvme.c | 70 ++++++++++++++++++++++++++++-------
 3 files changed, 102 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index f66c121cb712..d44b98e753d1 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -663,6 +663,50 @@ fdls_send_logo_resp(struct fnic_iport_s *iport,
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
index 16e2f0add5ce..c4de6606c0b2 100644
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
@@ -1248,6 +1252,23 @@ void nvfnic_ls_rsp_recv(struct fnic_iport_s *iport,
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
@@ -1257,6 +1278,7 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 	struct fnic_iport_s *iport = &fnic->iport;
 	struct fnic_tport_s *tport = (struct fnic_tport_s *) nvfnic_ls_req->tport;
 	uint16_t oxid = nvfnic_ls_req->oxid;
+	int timeout;
 
 	FNIC_NVME_DBG(KERN_INFO, fnic,
 		      "tport: 0x%x lsreq: 0x%x state: %d timeout\n",
@@ -1278,10 +1300,8 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
@@ -1290,6 +1310,19 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
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
@@ -1297,10 +1330,8 @@ void nvfnic_ls_req_timeout(struct timer_list *t)
 		return;
 	}
 
-	list_del(&nvfnic_ls_req->list);
 	ls_req = nvfnic_ls_req->ls_req;
-	fdls_free_oxid(iport, oxid, &nvfnic_ls_req->oxid);
-	ls_req->private = NULL;
+	nvfnic_ls_req_cleanup(iport, ls_req, oxid);
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
 	ls_req->done(ls_req, -ETIMEDOUT);
@@ -1411,11 +1442,7 @@ int nvfnic_ls_req_send(struct nvme_fc_local_port *lport,
 
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
@@ -1534,6 +1561,7 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 	struct nvfnic_ls_req *nvfnic_ls_req;
 	uint16_t oxid;
 	int timeout;
+	int ret;
 
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
@@ -1592,10 +1620,24 @@ void nvfnic_ls_req_abort(struct nvme_fc_local_port *lport,
 
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

