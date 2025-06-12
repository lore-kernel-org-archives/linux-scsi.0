Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC3F11CAF;
	Thu, 12 Jun 2025 00:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687842; cv=none; b=IIFsf8QkwZF20EhtHGxNbp+FSm+CusMUlfaX2WJqIRzg/8iOi9V2F+xDvF+cpOQggmB94ggUtL9ytS7bvdpqiQjgEH8EXsaIrh5abTzkft9ho+k+7ftAjQLLjZH88MPv7isiLTI6a9TwOAe/V1SjpSTI4ofpu5h7PM5oJc/9zK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687842; c=relaxed/simple;
	bh=5t7HitfeR7YAWYTuJW3KskrSVxmCerhAEcqd6hVRE/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnkVsy8ILmhKK4u7hGZQlKVhFOvIY3n+R+D2fPlqSYtRjRuWq/O0mkQRCOrU925WrG42bH+l7IAhEkxp1IsxvHErdTj7qUs/+ylu01GyFHDAUdkZle8DZ+CKISRw4/68oYFXx+TVOH+kJbEMnKVoh2WAgdZC6Ht74WEu3Pc2Ivc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=HFUpmYuQ; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="HFUpmYuQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8035; q=dns/txt;
  s=iport01; t=1749687841; x=1750897441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mqGmeKKlWbf4mkt7N6cgvpmiLcYh/dQjHcR7YQ6/OAs=;
  b=HFUpmYuQLLqRR3KZhadDe4NTRPHAWB2PN2I9GCTSEdQBzkT8ZjZUVAAl
   uN3L/rYwALSOSQr5BD93OLGG4VQcSk5aUd5rBD815RZSLhPpfK+6wWJZE
   lKlOPEpgN5C9aR6Xb4o5uaE3/MS/ifRKKknU9s2XzE9SCN8E6IkqNPF1n
   LfBP52GgclI1zIqujZ1hU6PEwD8IiPbk5Oibe8aAJ9o3qgyy82jdQ8o09
   4wf+kXXTsNlq8vXg9cQ+VBiaMg3oVouTmBJ7ip5GOBA4fuJYnRB6HZU0A
   pMPPKb/o4olTealT0LJYunkSClWVN0pIuhANki+H0bYQiJG3RBmHP1/Hq
   Q==;
X-CSE-ConnectionGUID: 5kwdCJHxRECVwzJNY/dKjQ==
X-CSE-MsgGUID: EdGYZt36QAaXILBEwTpA+Q==
X-IPAS-Result: =?us-ascii?q?A0ANAAChHEpo/5IQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSCIZg9hVyBJQNXDwEBAQ9RBAEBhQcCi?=
 =?us-ascii?q?2YCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGW?=
 =?us-ascii?q?wIBAycLAUYQUVYZgwKCbwOwEYF5M4EB3jeBboFJAY1McIR3JxUGgUlEgRWDa?=
 =?us-ascii?q?IFSiTUEgzqQIIRDjDtIgR4DWSwBVRMNCgsHBYFjAzUMCy4VMjwyHYINhRmCE?=
 =?us-ascii?q?osHhEkrT4UhhQUkcg8HSkADCxgNSBEsNxQbBj5uB5gLgnR1B4EPE4IsHguTG?=
 =?us-ascii?q?5I8gTWfVoQloVMaM6phLodlkHGpOIFoPIFZMxoIGxWDIlIZD44tFrtVJjI8A?=
 =?us-ascii?q?gcLAQEDCZIUAQE?=
IronPort-Data: A9a23:bPEZxq4W7XcTrp7pTSKI5AxRtNDGchMFZxGqfqrLsTDasY5as4F+v
 mUbXmiGPK2MY2Lyc4h+a4mwpEMP75PQyNdnHAE6qno2Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH3dOG49xGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr/aUzBHf/g2QpajxNsvrYwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4eYI4H9s1VIXF02
 NcmNyIvSCHEi8G0+efuIgVsrpxLwMjDNYcbvDRkiDreF/tjGcGFSKTR7tge1zA17ixMNa+BP
 IxCN3w2MlKZP0Mn1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3Fa4qFJIDWHZ4F9qqej
 k/K0FXLHkpEDfWW+Ruh2F+zuvfm3hquDer+E5X9rJaGmma7ymUVThYfT0O2p+W0kGa6WtRWM
 UtS/TAhxYAw+U6hZt38WQCo5n+Ou1gXXN84O+gz8h2MzOzM7hqUHHMJSBZGctUtsMJwTjsvv
 neLmt7vCDNvsZWPRH6d/6vSpjS3UQAPIHEPfzQsVwYJ49D/5oo0i3rnStdlDb7wjdDvHzz06
 y6FoTJ4hLgJi8MPkaKh8jjvhzOqu4iMVQUu5y3JUW+/qAB0foioY8qv81ezxe1cJYydQ3Gfs
 3Ue3cuT9uYDCdeKjiPlfQkWNLit4/DANHjXhkRiWsFwsT+s4HWkO4tX5VmSOXtUDyrNQhexC
 Ge7hO+bzMQ70KeCBUOvX7+MNg==
IronPort-HdrOrdr: A9a23:zhTWPKwfywFXMzeuoLqTKrPwA71zdoMgy1knxilNoNJuHvBw8P
 re+MjzuiWbtN98YhsdcJW7Scq9qBDnhPtICOsqXItKNTOO0ACVxcNZnOnfKlbbdBEWmNQx6Y
 5QN4BjFdz9CkV7h87m7AT9L8wt27C8gceVbJ/lr0uEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: 9a23:oTAS6GASUJsZYCf6E3Rk60I/OOA1SFD28mjCAWmJTmpKSoTAHA==
X-Talos-MUID: 9a23:TKdznQi9d2lKIl3HonVV3cMpGctH0payUx40uJw2mu2uGDNMIx7etWHi
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="388644038"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:22:50 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 1FE8D18000443;
	Thu, 12 Jun 2025 00:22:49 +0000 (GMT)
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
	stable@vger.kernel.org,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH v2 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Date: Wed, 11 Jun 2025 17:22:09 -0700
Message-ID: <20250612002212.4144-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612002212.4144-1-kartilak@cisco.com>
References: <20250612002212.4144-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-09.cisco.com

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

Fixes: 09c1e6ab4ab2 ("scsi: fnic: Add and integrate support for FDMI")
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

