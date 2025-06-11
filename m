Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327C51A5BAC;
	Wed, 11 Jun 2025 18:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666674; cv=none; b=m4Q5GXp8ZixvHd0+Z7emhtG+9xefJPvzFj7jhYpChQrfWa0ZKn631wPcuYWTbq2my3hPDj9secK4ol+FCJ0+NwfLbAKkSes5ZEna1Qg6w1QZQ0trdXrF9lHJToI7/oqSIVba0BgU2ubMSc6oNs3Gl1vn5/4cq+PGdUt5dj+IDgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666674; c=relaxed/simple;
	bh=kg2LVp5JmyTHBKsD3DMILFj6hR4fnPV3slJOxt5PzhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LYaQtesohsJhE8iHa6FqV54qA5QMBw4FQ7EIkQCpk7tA1dP/KgdmpiqTMoxAkP/V1WmYy9kLL2yx0+exfCgblzc6vohdmYyzwr7mqKP1oBdCAgxPu0SZh0iRG84JBkmMtEpbcTlj36x42Pr8uEq/PwtJSNoWy+mTStoR+3itA0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=gXSMx6gq; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="gXSMx6gq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7963; q=dns/txt;
  s=iport01; t=1749666672; x=1750876272;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=izzQFPo/rU7YNoq8ZmZS4O5oHW8PR42NqnKXflpjBwk=;
  b=gXSMx6gqZVDvrvn6uAGPtL0Yw3cgKNaMGJ8F3pJEZXlfFCOU5gKdQn2a
   JYLJDK/IEpqfbQ2+9ezkLA0OQ2KXCZhzu5NT65oIEfSs8/DnWw0qdLdsT
   IN4WYsDSuhIwZWib4Vwg2hnW/vAUbjwZUHluyC/dKbbJj9CSbyH3eZ9bN
   8w173roV7G+ItPAiGvOovm4Bk+WxhHQXTscExsb7ljqCDZ/k+vmuq39v6
   dB31iYn9J3q3KvSeICGHQPad1vcNJfUpt1FD8x7xxLrBQw5ATgCz60ScS
   HKW3lCtgoWlJGLkw3hEQKrhBwcz4KcejWtltpW01RHQgdQtw8EyPAtgvt
   Q==;
X-CSE-ConnectionGUID: KAtlEn8AT9GHJ6qlxxyjQg==
X-CSE-MsgGUID: mwquzFL5T8CSUj4g7IrhAg==
X-IPAS-Result: =?us-ascii?q?A0ANAABcyklo/4sQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSCIZg9hVyBJQNXDwEBAQ9RBAEBhQcCi?=
 =?us-ascii?q?2YCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGW?=
 =?us-ascii?q?wIBAycLAUYQUVYZgwKCbwOvcYF5M4EB3jeBboFJAY1McIR3JxUGgUlEgRWDa?=
 =?us-ascii?q?IFSiTUEgzqQIIRDjDFIgR4DWSwBVRMNCgsHBYFjAzUMCy4VMjwyHYINhRmCE?=
 =?us-ascii?q?osHhEkrT4UhhQUkcg8HPUADCxgNSBEsNxQbBj5uB5gEgnR1B4EPE4IsHpMmk?=
 =?us-ascii?q?jyBNZ9WhCWhUxozqmEuh2WQcak4gWg8gVkzGggbFYMiUhkPji0Wu1UmMjwCB?=
 =?us-ascii?q?wsBAQMJkhQBAQ?=
IronPort-Data: A9a23:DEGmfK1mc+OkMw9t8fbD5QNwkn2cJEfYwER7XKvMYLTBsI5bpzxUn
 zccXzqOOa2INDb0Ktt2YI/i8BlUv5DWzYBgS1Fp3Hw8FHgiRegpqji6wuYcGwvIc6UvmWo+t
 512huHodZ5yFjmG4E70aNANlFEkvYmQXL3wFeXYDS54QA5gWU8JhAlq8wIDqtYAbeORXUXU5
 7sen+WFYAX4g2AtazpOg06+gEoHUMra6WtwUmMWPZinjHeG/1EJAZQWI72GLneQauF8Au6gS
 u/f+6qy92Xf8g1FIovNfmHTKxBirhb6ZGBiu1IOM0SQqkEqSh8ajs7XAMEhhXJ/0F1lqTzeJ
 OJl7vRcQS9xVkHFdX90vxNwS0mSNoUekFPLzOTWXcG7lyX7n3XQL/pGL2gqOaAeqs9LUE5u1
 6IBLCAdfxK6iLfjqF67YrEEasULJc3vOsYb/3pn1zycVaxgSpHYSKKM7thdtNsyrpkRRrCFO
 YxAN3w2N0Wojx5nYj/7DLo9lf20h332cBVTqUmeouw85G27IAlZi+exb4OLIofVLSlTtkOHv
 3/U0UCkPkExD+GdlTXa02isr+CayEsXX6pXTtVU7MVCjFSVgGcaEgUbU0e2u9G9i0i3QdUZL
 FYbkgIsoKo43EiqSMTtGRyypTiPuRt0c99ZCfE77keVx7bZ+R2UAEADVDdKbNFgv8gzLRQo0
 1KPktzpBBR1vbGVQG7b/bCRxRuoNDYYN3QqfyIITQIZpdLkpekbihPJU8YmE6OviNDxMS//z
 irMryUkgbgXy8kR2M2T+VHBniLpvZPSTyYr6QjNGGGo9AV0YMiifYPA1LTAxf9EKIDcShyKu
 2IJ3pDEqusPFpqK0ieKRY3hAY2U2hpMCxWE6XYHInXr327FF6KLFWyI3AxDGQ==
IronPort-HdrOrdr: A9a23:bD+MW6qpodqpSnUqc8qgMZ4aV5oEeYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McemvAJsQljuQzW2gYytLeDU=
X-Talos-CUID: 9a23:3Wajkm+jfLMYJOkU9FGVv209BsQIdC308Cb/A23mEGJ5WKyXcFDFrQ==
X-Talos-MUID: 9a23:bB+9nwZ2eX3o7+BTsiD1mSNMEJpUs4+VNUJRnsonocmtOnkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,228,1744070400"; 
   d="scan'208";a="374716037"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 11 Jun 2025 18:31:10 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPSA id 7347A18000151;
	Wed, 11 Jun 2025 18:31:08 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Date: Wed, 11 Jun 2025 11:30:30 -0700
Message-ID: <20250611183033.4205-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250611183033.4205-1-kartilak@cisco.com>
References: <20250611183033.4205-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-02.cisco.com

When both the RHBA and RPA FDMI requests time out, fnic reuses a frame
to send ABTS for each of them. On send completion, this causes an
attempt to free the same frame twice that leads to a crash.

Fix crash by allocating separate frames for RHBA and RPA,
and modify ABTS logic accordingly.

Tested by checking MDS for FDMI information.
Tested by using instrumented driver to:
Drop PLOGI response
Drop RHBA response
Drop RPA response
Drop RHBA and RPA response
Drop PLOGI response + ABTS response
Drop RHBA response + ABTS response
Drop RPA response + ABTS response
Drop RHBA and RPA response + ABTS response for both of them

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Tested-by: Arun Easi <aeasi@cisco.com>
Co-developed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 113 +++++++++++++++++++++++++---------
 drivers/scsi/fnic/fnic_fdls.h |   1 +
 2 files changed, 86 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index c2b6f4eb338e..0ee1b74967b9 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -763,47 +763,69 @@ static void fdls_send_fabric_abts(struct fnic_iport_s *iport)
 	iport->fabric.timer_pending = 1;
 }
 
-static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
+static uint8_t *fdls_alloc_init_fdmi_abts_frame(struct fnic_iport_s *iport,
+		uint16_t oxid)
 {
-	uint8_t *frame;
+	struct fc_frame_header *pfdmi_abts;
 	uint8_t d_id[3];
+	uint8_t *frame;
 	struct fnic *fnic = iport->fnic;
-	struct fc_frame_header *pfabric_abts;
-	unsigned long fdmi_tov;
-	uint16_t oxid;
-	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
-			sizeof(struct fc_frame_header);
 
 	frame = fdls_alloc_frame(iport);
 	if (frame == NULL) {
 		FNIC_FCS_DBG(KERN_ERR, fnic->host, fnic->fnic_num,
 				"Failed to allocate frame to send FDMI ABTS");
-		return;
+		return NULL;
 	}
 
-	pfabric_abts = (struct fc_frame_header *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	pfdmi_abts = (struct fc_frame_header *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
 	fdls_init_fabric_abts_frame(frame, iport);
 
 	hton24(d_id, FC_FID_MGMT_SERV);
-	FNIC_STD_SET_D_ID(*pfabric_abts, d_id);
+	FNIC_STD_SET_D_ID(*pfdmi_abts, d_id);
+	FNIC_STD_SET_OX_ID(*pfdmi_abts, oxid);
+
+	return frame;
+}
+
+static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
+{
+	uint8_t *frame;
+	unsigned long fdmi_tov;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_frame_header);
 
 	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
-		oxid = iport->active_oxid_fdmi_plogi;
-		FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
+		frame = fdls_alloc_init_fdmi_abts_frame(iport,
+						iport->active_oxid_fdmi_plogi);
+		if (frame == NULL)
+			return;
+
 		fnic_send_fcoe_frame(iport, frame, frame_size);
 	} else {
 		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
-			oxid = iport->active_oxid_fdmi_rhba;
-			FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
+			frame = fdls_alloc_init_fdmi_abts_frame(iport,
+						iport->active_oxid_fdmi_rhba);
+			if (frame == NULL)
+				return;
+
 			fnic_send_fcoe_frame(iport, frame, frame_size);
 		}
 		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
-			oxid = iport->active_oxid_fdmi_rpa;
-			FNIC_STD_SET_OX_ID(*pfabric_abts, oxid);
+			frame = fdls_alloc_init_fdmi_abts_frame(iport,
+						iport->active_oxid_fdmi_rpa);
+			if (frame == NULL) {
+				if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING)
+					goto arm_timer;
+				else
+					return;
+			}
+
 			fnic_send_fcoe_frame(iport, frame, frame_size);
 		}
 	}
 
+arm_timer:
 	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
 	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
 	iport->fabric.fdmi_pending |= FDLS_FDMI_ABORT_PENDING;
@@ -2244,6 +2266,21 @@ void fdls_fabric_timer_callback(struct timer_list *t)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
+void fdls_fdmi_retry_plogi(struct fnic_iport_s *iport)
+{
+	struct fnic *fnic = iport->fnic;
+
+	iport->fabric.fdmi_pending = 0;
+	/* If max retries not exhausted, start over from fdmi plogi */
+	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
+		iport->fabric.fdmi_retry++;
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					 "Retry FDMI PLOGI. FDMI retry: %d",
+					 iport->fabric.fdmi_retry);
+		fdls_send_fdmi_plogi(iport);
+	}
+}
+
 void fdls_fdmi_timer_callback(struct timer_list *t)
 {
 	struct fnic_fdls_fabric_s *fabric = from_timer(fabric, t, fdmi_timer);
@@ -2289,14 +2326,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
 
-	iport->fabric.fdmi_pending = 0;
-	/* If max retries not exhaused, start over from fdmi plogi */
-	if (iport->fabric.fdmi_retry < FDLS_FDMI_MAX_RETRY) {
-		iport->fabric.fdmi_retry++;
-		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					 "retry fdmi timer %d", iport->fabric.fdmi_retry);
-		fdls_send_fdmi_plogi(iport);
-	}
+	fdls_fdmi_retry_plogi(iport);
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
 		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -3714,11 +3744,32 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 	switch (FNIC_FRAME_TYPE(oxid)) {
 	case FNIC_FRAME_TYPE_FDMI_PLOGI:
 		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_plogi);
+
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_PLOGI_PENDING;
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
 		break;
 	case FNIC_FRAME_TYPE_FDMI_RHBA:
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_REG_HBA_PENDING;
+
+		/* If RPA is still pending, don't turn off ABORT PENDING.
+		 * We count on the timer to detect the ABTS timeout and take
+		 * corrective action.
+		 */
+		if (!(iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING))
+			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
+
 		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rhba);
 		break;
 	case FNIC_FRAME_TYPE_FDMI_RPA:
+		iport->fabric.fdmi_pending &= ~FDLS_FDMI_RPA_PENDING;
+
+		/* If RHBA is still pending, don't turn off ABORT PENDING.
+		 * We count on the timer to detect the ABTS timeout and take
+		 * corrective action.
+		 */
+		if (!(iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING))
+			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
+
 		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
 		break;
 	default:
@@ -3728,10 +3779,16 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 		break;
 	}
 
-	timer_delete_sync(&iport->fabric.fdmi_timer);
-	iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
-
-	fdls_send_fdmi_plogi(iport);
+	/*
+	 * Only if ABORT PENDING is off, delete the timer, and if no other
+	 * operations are pending, retry FDMI.
+	 * Otherwise, let the timer pop and take the appropriate action.
+	 */
+	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
+		timer_delete_sync(&iport->fabric.fdmi_timer);
+		if (!iport->fabric.fdmi_pending)
+			fdls_fdmi_retry_plogi(iport);
+	}
 }
 
 static void
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index 8e610b65ad57..531d0b37e450 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -394,6 +394,7 @@ void fdls_send_tport_abts(struct fnic_iport_s *iport,
 bool fdls_delete_tport(struct fnic_iport_s *iport,
 		       struct fnic_tport_s *tport);
 void fdls_fdmi_timer_callback(struct timer_list *t);
+void fdls_fdmi_retry_plogi(struct fnic_iport_s *iport);
 
 /* fnic_fcs.c */
 void fnic_fdls_init(struct fnic *fnic, int usefip);
-- 
2.47.1

