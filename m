Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02702F5319;
	Wed, 18 Jun 2025 00:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206890; cv=none; b=ZC7tENqNnx9M6+hvRUL4gHTrK5wzfjC0QFvvZql9iPblUcgv10UBXGFpy7uUXZq8CamnE1/Q9AYuR7ljBpIrLnrpg9s5unwyObuFlGw4PHqIALt/PM59iqJF1Axmj10i6r4X/WcGvI8Eee7cXRMYuj99/oXogoFfBrRVcCxaH9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206890; c=relaxed/simple;
	bh=WiZUoyoFY3AScDyboS+zTxUIRU70l9n0/wjCuApaxPM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i5n5N670/1uX5arukpx+WkDlbmTC7HcWnEFW2yf+MI0cIb/nVejlq/3mqlNs71Tko1KLJAnVLSY6cfs+SCXll7u6OTm2pmIQTMM3CBl96r8OEvfE6gWbzZ50n/PAg2RYz1FnjceBC6lIvRlnGPuCc2hJHbC6xSw9uxLCTk+pp/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=blAtLrCQ; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="blAtLrCQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8981; q=dns/txt;
  s=iport01; t=1750206889; x=1751416489;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hlri3zQLHj9NGS7y9ZyRm5BsYSUPYki2EWvITOrmbtI=;
  b=blAtLrCQ4SYBxM3leYHQy901OBkfyG5/Thlv3YQsf1kKGt8egqOC2uQ/
   kEdwJskIS88WrnmVlfKfcb/VXeUNTC8i3mB5BD24d1hitP5HS8BC0csLU
   JAk0hUSegB63ek2Er1HxHlU0KR8yVlSHhnva4YcxXWWlVVN29x1Cvyu8l
   AiwF3d5wAG/EdTIjRDxp3vNOHBSMDWkzAzL9KrzuQwkU0BUOjBy9xSnpx
   WuXafbFrJ/rcqhg0CBmO3JyU8QWjQRa9r2wScLe/+jNZ1NxLcvU6bnKAC
   kOSBpSNMzY/IisM9g+7Jv63BeH4OA9hgZ9/OB/ZJwVwe9oZKUxYQXO22P
   A==;
X-CSE-ConnectionGUID: rORXCQb4RJiTW+VHGrm0NQ==
X-CSE-MsgGUID: cdPheT1uQROiG5eVhHq3XQ==
X-IPAS-Result: =?us-ascii?q?A0AnAACDCFJo/5AQJK1aHAEBAQEBAQcBARIBAQQEAQGBf?=
 =?us-ascii?q?wcBAQsBgkqBUkMZMIxwhzSCIZg9hVyBJQNXDwEBAQ9RBAEBhQeLaAImNAkOA?=
 =?us-ascii?q?QIEAQEBAQMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBBwWBDhOGCIZdKwsBRoFQg?=
 =?us-ascii?q?wKCbwOvCoF5M4EB3jeBboFJAY1NcIR3JxUGgUlEgRWDaIFSiTUEgzqQHoQgJ?=
 =?us-ascii?q?lCMFEiBHgNZLAFVEw0KCwcFgWMDNQwLLhUyPDIdgg2FGYISiwWERytPhSGFB?=
 =?us-ascii?q?SRxDwaBC0ADCxgNSBEsNxQbBj5uB5gwgnZ1B4EPE4IVFgEeC5MbkjyBNZ9Wh?=
 =?us-ascii?q?CWhUxozqmEuh2WQcak4gWg8gVkzGggbFYMiUhkPji0Wu1UmMjwCBwsBAQMJk?=
 =?us-ascii?q?gUBAQ?=
IronPort-Data: A9a23:/xSNc6Jf0I92onaMFE+ROZQlxSXFcZb7ZxGr2PjKsXjdYENSgjQGz
 GIdXWuGaP+OM2ryLopyYY7k9koC68TUz9NjT1Ad+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCWa/073WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrT0
 T/Oi5eHYgL9hWcrajl8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN10K3sGFrQSptxVAF1xt
 sI4ByoINja60rfeLLKTEoGAh+wqKM3teYdasXZ6wHSBUrAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzMHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQqgOC8aYqLJIDiqcN9lUqgp
 m/6pnnAODYbG4GS9zql6ymcv7qa9c/8cMdIfFGizdZmiVvVzWUJEBAQSVahif24jEekXJRYM
 UN80igjr6Ia8E2tU8m7Xhe95nWDu3Y0XtNKD+w8rhmA1qfO+AufLm8eRzVFZZots8pebT4v2
 1mEkNPoLSZivL2cVTSW8bL8hSm/JyUPNkcYaCMERBdD6N7myKk3jxTSXpNgHbSzg9ndBz792
 XaJoTI4irFVitQEv42//Fbak3e3rYPIZhA66x+RXW+/6A59Iom/aOSA8kTS5/JNBJiWQ0PHv
 3UencWaqucUAvmweDelSeEJGvStov2CKjCZ2QEpFJg6/DPr8HmmFWxN3AxDyI5SGp5sUVfUj
 IX74mu9OLc70KOWUJJK
IronPort-HdrOrdr: A9a23:1Gp2paluisX2t3P0dZ6MV3s1Q/jpDfIf3DAbv31ZSRFFG/FwWf
 rDoB19726XtN9/Yh8dcLy7UpVoIkmslqKdg7NxAV7KZmCP01dAR7sM0WKN+VDdMhy73vJB1K
 tmbqh1AMD9ABxHl8rgiTPIdurIuOPmzEht7t2uqEuEimpRGsVd0zs=
X-Talos-CUID: 9a23:2Vm4U27Zh7JzsaPisNss7mkuKusceCHn7nbsHAyGKUlzTeWzcArF
X-Talos-MUID: 9a23:g2qG/goPsFedVf4V2d8ezzpuDMdl3/2zMXoqkLpbtveEFTUrCw7I2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,244,1744070400"; 
   d="scan'208";a="380918664"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Jun 2025 00:34:42 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.123.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id B2CD8180001E1;
	Wed, 18 Jun 2025 00:34:40 +0000 (GMT)
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
Subject: [PATCH v6 1/4] scsi: fnic: Fix crash in fnic_wq_cmpl_handler when FDMI times out
Date: Tue, 17 Jun 2025 17:34:28 -0700
Message-ID: <20250618003431.6314-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.123.35, [10.188.123.35]
X-Outbound-Node: alln-l-core-07.cisco.com

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
Changes between v5 and v6:
    - Incorporate review comments from John:
	- Rebase patches on 6.17/scsi-queue

Changes between v4 and v5:
    - Incorporate review comments from John:
	- Refactor patches

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
 drivers/scsi/fnic/fnic.h      |   2 +-
 drivers/scsi/fnic/fnic_fdls.h |   1 +
 3 files changed, 87 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index f8ab69c51dab..36b498ad55b4 100644
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
@@ -2245,6 +2267,21 @@ void fdls_fabric_timer_callback(struct timer_list *t)
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
 	struct fnic_fdls_fabric_s *fabric = timer_container_of(fabric, t,
@@ -2291,14 +2328,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
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
@@ -3716,11 +3746,32 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
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
@@ -3730,10 +3781,16 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
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
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 6c5f6046b1f5..86e293ce530d 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -30,7 +30,7 @@
 
 #define DRV_NAME		"fnic"
 #define DRV_DESCRIPTION		"Cisco FCoE HBA Driver"
-#define DRV_VERSION		"1.8.0.0"
+#define DRV_VERSION		"1.8.0.1"
 #define PFX			DRV_NAME ": "
 #define DFX                     DRV_NAME "%d: "
 
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

