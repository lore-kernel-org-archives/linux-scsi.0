Received: from rcdn-iport-9.cisco.com (rcdn-iport-9.cisco.com [173.37.86.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF42A522F;
	Thu, 12 Jun 2025 22:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749766743; cv=none; b=TTDdaApapRKH9rKD6jhLp81SduYeHGQ4gPFhSbOZ1E1rEwXXcVoMLlKZ8sMOcW9pD2Xj8iicYy0OhIrXg5W1Rm63QD3yrJMer2PQS/S9axHMgsSpt7LVcKmuDJCW1O0vDiDX1vXJroJMtdVXADGELlNJSg85VybJXsrXCdpf39I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749766743; c=relaxed/simple;
	bh=Gqyar+hQSrrH1YHm6t78GgVY4j21C+QeD3jVDtbSVNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqONv65deLjBbJHszX8NZ2q1Ydv66jni1TZD049pck+BaBg56VtO6bsM7F2lNvgLghtIJfaVrtrml5Ap7LIbf4X4Vw0E6WfGQIAC/WDt2Nxw9s0n1xEQPuQmbm3qTpFTJKlvVIvYtU2suBl8J+T5UP3LOHeYBz0/dN+EYBPRxUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=QLmyBw1p; arc=none smtp.client-ip=173.37.86.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="QLmyBw1p"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8355; q=dns/txt;
  s=iport01; t=1749766741; x=1750976341;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=nFPRRQWj+FJbbJ92ROcrNYzAfZT1d2keom2UuyWkoHc=;
  b=QLmyBw1pTpy17+xJOYodbhYY9GJSxidD7BtJpH0+XrGIhvmjYHnkmXvW
   uJ/8vSN1H1624u2XeKE0ncGXXGX2eAEF5X+hOveK+A2oXgIRpR0DBdhvO
   YB97q4DRbYEsm7eXXpslRnpOKbU8eTrH9lMmkwUoLXSBAVRDT4nhDm3Z/
   FtlcBo5Gzb9FIRXMlDM1RH84PvqtfOwJve5769nUzumc2pRTsrO6w8pE+
   WFv7ejTuLAflSaq76WK024Wtv2DAjQHe7ZiQ+1GjZCuW2yIUG7mrkRjle
   th4X1extySH6JeA8WPqKZ7Q/lspTZ4pI7VDzQUxaupdnHQ6x2Ae4Y3GjV
   w==;
X-CSE-ConnectionGUID: rJHMlrzvSpSM08gnREK0mg==
X-CSE-MsgGUID: BIJl3HNnRDSJJe4035sO7A==
X-IPAS-Result: =?us-ascii?q?A0ANAACoUUto/5MQJK1aGwEBAgIBAQUBARQBAQMDAQGCA?=
 =?us-ascii?q?AYBAQwBgkqBUkMZMIxwhzSCIZg9hVyBJQNXDwEBAQ9RBAEBhQcCi2YCJjQJD?=
 =?us-ascii?q?gECBAEBAQEDAgMBAQEBAQEBAQEBAQsBAQUBAQECAQcFgQ4ThgiGWwIBAycLA?=
 =?us-ascii?q?UYQUVYZgwKCbwOwBoF5M4EB3jeBboFJAY1McIR3JxUGgUlEgRWDaIFSiTUEg?=
 =?us-ascii?q?zqQIIRDUItrSIEeA1ksAVUTDQoLBwWBYwM1DAsuFTI8Mh2CDYUZghKLCIRJK?=
 =?us-ascii?q?0+FIYUHJHIPBkdAAwsYDUgRLDcUGwY+bgeYCYJ0dQeBDxOCFRYBHguTG5I8g?=
 =?us-ascii?q?TWfVoQloVMaM6phLodlkHGpOIFoPIFZMxoIGxWDIlIZD44tFrtVJjI8AgcLA?=
 =?us-ascii?q?QEDCZFyAQE?=
IronPort-Data: A9a23:SSeuGK+d5AUDgURkEOfBDrUDaH+TJUtcMsCJ2f8bNWPcYEJGY0x3x
 mNJWDvVPKyMZjPwKN1xb46+9UIAvJGHz9E1SANo+ShEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E3ra+G7xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qsyyHjEAX9gWMsbDtOs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2ksH609/vxlH1pWz
 tlAeD8LVD2g3+e5lefTpulE3qzPLeHiOIcZ/3UlxjbDALN/GdbIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2cPHWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC2YIuKJYLbFZo9ckCwj
 EPk+z/ZJBcgGOe96zfZqinxnciQtHauMG4VPPjinhJwu3Wfz2pVAxQMTVa9vfSjokq/XdtFL
 AoT4CVGhao/9kaDStj7Qg3+oXSB+BUbXrJ4FuQg9ACLjLLZ/wuDHWUCZjlbYdciuYk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLT9B+AOu2g8fzFDXY3
 T+Htm49iq8VgMpN0L+0lXjDgjSxtt3SRRU0zhvYU3jj7Q5jYoOhIYuy5jDz9upJJoKUZkeOs
 WJCmMWE6u0KS5aXm0SwrP4lFbWt4bOBdTbbm1MqRsFn/DW28HnldodViN1jGHpU3g8/UWeBS
 CfuVcl5vve/4FPCgXdLXr+M
IronPort-HdrOrdr: A9a23:9RYZXKn3SUTS6zU/VqrJjqFoZ+/pDfID3DAbv31ZSRFFG/FwWf
 rDoB19726RtN9/Yh8dcLy7UpVoBEmslqKdgrNhWItKPjOGhILAFugLhrcKgQeQeREWndQz6U
 4PScVDIey1JURmjMr8/QmzG8stzZ266qyy7N2uqEuFNTsLV0mlhD0Jczpy1SZNNW97OaY=
X-Talos-CUID: =?us-ascii?q?9a23=3A6V0bvGm95n2zekwWNNjXmYT1fsXXOWf/7FLUOV2?=
 =?us-ascii?q?mMn5SbeXFRlmq1YA8lsU7zg=3D=3D?=
X-Talos-MUID: 9a23:bhV8aAvZ8TFSHaC2oM2nrhBAMJxIxaKUJHsvs5ha45LZLgsvEmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,231,1744070400"; 
   d="scan'208";a="389776987"
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by rcdn-iport-9.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 22:19:00 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPSA id E69DA1800015F;
	Thu, 12 Jun 2025 22:18:58 +0000 (GMT)
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
Subject: [PATCH v4 2/5] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Date: Thu, 12 Jun 2025 15:18:02 -0700
Message-ID: <20250612221805.4066-2-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250612221805.4066-1-kartilak@cisco.com>
References: <20250612221805.4066-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-10.cisco.com

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v3 and v4:
    - Incorporate review comments from Dan:
	- Remove comments from Cc tag

Changes between v2 and v3:
    - Incorporate review comments from Dan:
	- Add Cc to stable

Changes between v1 and v2:
    - Incorporate review comments from Dan:
        - Add Fixes tag
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

