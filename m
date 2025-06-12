Received: from rcdn-iport-7.cisco.com (rcdn-iport-7.cisco.com [173.37.86.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ACE54CE08;
	Thu, 12 Jun 2025 00:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749689172; cv=none; b=UbAj8z3zZCm2il2MgcTobhoZN6j8cS2P9P7t1NZQWyYmj3VxER687n+qrSfwcL/o/iUVliKq4/PENo5YYDv2eVdTqSss21TkU7qmCeu8W9zHMzX0V5xYthxwwJV3aY2LSTWmZw4HprWCp79ylNpx7A5iJ0IqK7pEvj/tb2m2Pr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749689172; c=relaxed/simple;
	bh=E196Vg+b/vuv6OTESfu4lrhh0PlejlBtQ2P0xQVANjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GIi9ElM4kxzl0pByRgHjWnInVsuHZMjY7m2RML+bksWdwZPk/VuWINTLIO9pZEJtqi8G1CE6qavtUZUikTi8BFYaEEEd3H+j/AZv7juFpHzypSrc/NKGGOeV1Oa272eGbZv9BNLBtHLvgUdj14eRfRvTHMxFuxg4HzZo2uOep4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Mw5Y6zfm; arc=none smtp.client-ip=173.37.86.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Mw5Y6zfm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8103; q=dns/txt;
  s=iport01; t=1749689170; x=1750898770;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ubjOtCQkGshuAMXxzlZa/zi3xGhg4T/VrT+G2QYkywM=;
  b=Mw5Y6zfme9Z3WNxvsMxIU3eZMDQe5f5MyttrvZWPnVRrj8xsYEKGVZD/
   6Ob4a6ifB69tu3XXNbbyFR8hZzZXxfAwZUT4utVUrhmDiXb685gs6yFOb
   jDSe5h3TF0CEQMjV7thfYuWjyFLH7zeR9X8aRmSPVwHAtBhjI/1zn6m3R
   UtoNr0zhVVTiKWlkTIQZaq7CX7ZSsmMu+sqox4fevmY3so5oMck7QI999
   0+LkLGA3KbC+UQ88yJ9Ktqpf4oSWbg/UIk4cDQ1zaAB1HIFQVt8QahWUm
   agesv0h+Cg0DD1ky60HXXjPkyrRrPLOsPDqJGv68GNxdAHPrEdm3To4Js
   Q==;
X-CSE-ConnectionGUID: 7+6vvTHGRr+e4WMzDJAbhA==
X-CSE-MsgGUID: IklZYFZpQtmrKpTD3tvatw==
X-IPAS-Result: =?us-ascii?q?A0AEAACOIUpo/5IQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSCIZg9hVyBJQNXDwEBAQ9RB?=
 =?us-ascii?q?AEBhQcCi2YCJjQJDgECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFg?=
 =?us-ascii?q?Q4ThgiGWwIBAycLAUYQUVYZgwKCbwOwCYF5M4EB3jeBboFJAY1McIR3JxUGg?=
 =?us-ascii?q?UlEgRWDaIFSiTUEgzqQIIRDjDtIgR4DWSwBVRMNCgsHBYFjAzUMCy4VMjwyH?=
 =?us-ascii?q?YINhRmCEosHhEkrT4UhhQUkcg8HSkADCxgNSBEsNxQbBj5uB5gLgnR1B4EPE?=
 =?us-ascii?q?4IsHguTG5I8gTWfVoQloVMaM4QEjQ2ZUC6HZZBxqTiBaDyBWTMaCBsVgyJSG?=
 =?us-ascii?q?Q+OLRa7VSYyPAIHCwEBAwmSFAEB?=
IronPort-Data: A9a23:EfKuWag4lfXeOVYykn+msDlDX161iBEKZh0ujC45NGQN5FlHY01je
 htvUGyPaK3eajfxctx/bIm38hlXvsTQmoNqTQRu/yszFCJjpJueD7x1DKtf0wB+jyHnZBg6h
 ynLQoCYdKjYdleF+FH1dOKn9CAmvU2xbuKUIPbePSxsThNTRi4kiBZy88Y0mYcAbeKRW2thg
 vus5ZSBULOZ82QsaD9Mtfva8EgHUMna4Vv0gHRvPZing3eG/5UlJMp3Db28KXL+Xr5VEoaSL
 87fzKu093/u5BwkDNWoiN7TKiXmlZaLYGBiIlIPM0STqkAqSh4ai87XB9JAAatjsAhlqvgqo
 Dl7WTNcfi9yVkHEsLx1vxC1iEiSN4UekFPMCSDXXcB+UyQqflO0q8iCAn3aMqVHubhpH11u2
 sYCaz1RUTWRq8CfyrKSH7wEasQLdKEHPasWvnVmiDWcBvE8TNWbEuPB5MRT23E7gcUm8fT2P
 pVCL2ExKk2eJUQTZD/7C7pm9Ausrnr2aSFZrFuWjaE2+GPUigd21dABNfKOKozaG5wLwBzwS
 mTu3mf9MCA0BsSm1T+f0WqQqrTTgyrnR9dHfFG/3rsw6LGJ/UQfARtQXlKhufS/lkOkc9ZeL
 UUO/Wwpt6da3E6mTNPVWxy+vW7CvxQZHdFXFoUS7QiX1qvSpR6UGmUeVTNHQNs8vcQySHoh0
 Vrht9HsCDpiv72UYWiQ+redsXW5Pi19BXUPeyIeViMf7tXjqZ11hRXKJv5nEaionpj2FCv2z
 jSisicznfMQgNQN2qH9+krI6xqop57UXksu7R7Wdnyq4xk/Z4O/YYGsr1/B4p5oN5qQRF2Ml
 GYLltLY7+0UC5yJ0iuXT40w8KqB7vKBNnjYxFVoBZRkr2Xr8H+4docW6zZ7TKt0Dvs5lfbSS
 Be7kWtsCFV7YxNGsYcfj1qNNvkX
IronPort-HdrOrdr: A9a23:nILB96NgfWO2PMBcTu6jsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVbSO09QYVcemsAJsQiTtENg==
X-Talos-CUID: 9a23:2Vr2823XJYKIBjPaRepTd7xfRYN7bGPh7FjqOQy1VVlMWpG3YFWQ0fYx
X-Talos-MUID: =?us-ascii?q?9a23=3AjR9+2Awzlel3CyKvMPETGRQPQ2SaqIWtDHI8v6c?=
 =?us-ascii?q?egtWBLw9oBxvGkCq+XpByfw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="388861662"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:45:01 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id DAF3318000443;
	Thu, 12 Jun 2025 00:44:59 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>,
	stable@vger.kernel.org
Subject: [PATCH v3 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Date: Wed, 11 Jun 2025 17:44:23 -0700
Message-ID: <20250612004426.4661-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612004426.4661-1-kartilak@cisco.com>
References: <20250612004426.4661-1-kartilak@cisco.com>
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
Cc: <stable@vger.kernel.org> # 6.14.x Please see patch description
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

