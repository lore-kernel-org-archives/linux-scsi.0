Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04446225A59;
	Wed, 11 Jun 2025 18:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749666697; cv=none; b=Qh5s41gp/oV1xDw8yidQxXi6bbZ7AKCDr5e7+gQGYM0MqA9PdqLJSzGw1k0cz042x7Somd0LcOBjdrTWxv7gpZTLBV+Y+ne7BsSouH6rXQSnOFofUfB5Ju3Mc8xqQVby1Mkoy5MhXWMKa9kCHq1oNxBKI6rwXTw2EdkQescdFGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749666697; c=relaxed/simple;
	bh=7xJdS0NlV0f6qVbfi2ht7mxeyl33GYCtR2uTV02K/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y4oOx9yWa7Z4UN24ataCKgd0sbojuTqAUtjlmgIKg0O+fE3U9H1dJdRgrR+uf3OtOz7Qx53hqNPvTJW+Z6zHKsmx588MZjnv6RCVyhoJKsGH8l5YcnfscVEScyyddKvdvFJODg4RciD6VTkukwhUl5LHJG29XoD6NoE3+9mk/n8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=RQdfnplY; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="RQdfnplY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7741; q=dns/txt;
  s=iport01; t=1749666695; x=1750876295;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2+bixmuNLdcMxgRBtx96vs2b1DYzsJQTdepEWzrFTc=;
  b=RQdfnplYdPTZd8ol21GD7XNbu33djimyDpbQa3jId3ZGjZlH+ES/5Utw
   mylKSbYmKP3ot17K/gT1q4UvPWTdU8ab3fC2IgiXos/ZGthKlTcqNwalo
   CjEgqFBvEUpH6LHG0Z3A2ZjJTVD4/wBbZg/UqH+ngsoq7cNA5+xDOFqkq
   RV5H6VX06mMXZn6lhxpmumtflCsCF0AZ9q3urgn1LWVqd0ceh/hGTBwEM
   qexV0vwYlS+ez4aeRO5BY2+0RtZ+dMsyw+JzR4DzpbbkCxT2Fh7qz5ZW5
   Vy1+CgCSaHXo4NKc+y0YHLPwsQtvVHkASj6IsO7fipPaCd7A2+mg7hGDt
   Q==;
X-CSE-ConnectionGUID: H8gBBJSPRoSo4K+83D4UFw==
X-CSE-MsgGUID: OcJj2bqTRqe6+CRLovrgDw==
X-IPAS-Result: =?us-ascii?q?A0AEAABcyklo/4sQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBA?=
 =?us-ascii?q?YUHAotmAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE?=
 =?us-ascii?q?4YIhlsCAQMnCwFGEFFWGYMCgm8Dr3GBeTOBAd43gW6BSQGNTHCEdycVBoFJR?=
 =?us-ascii?q?IEVgnlvgVKJNQSDOo9oYIFqgjGMMUiBHgNZLAFVEw0KCwcFgWMDNQwLLhUyP?=
 =?us-ascii?q?DIdgg2FGYISiweESStPhSGFBSRyDwc9QAMLGA1IESw3FBsGPm4HmASDaQeBD?=
 =?us-ascii?q?hSBZEgekyQLkjOBNZ9WhCWhUxozqmGZBKN/hTmBaDyBWTMaCBsVgyJSGQ+OL?=
 =?us-ascii?q?Ra7VSYyPAIHCwEBAwmQFweBFmABAQ?=
IronPort-Data: A9a23:lhcBua8YIarPIpeDmg8qDrUDUH+TJUtcMsCJ2f8bNWPcYEJGY0x3y
 WZJXTjSOv+OZmT9ctggO46/px8BucSGytMwTgVqpX9EQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4E3ra+G7xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4qsyyHjEAX9gWMsbDtNs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kWbYIy0MRMOVtJz
 vtEC3NdNTzfusyplefTpulE3qzPLeHiOIcZ/3UlxjbDALN+G9bIQr7B4plT2zJYasJmRKmFI
 ZFHL2MxKk2bMnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC2b4aKI4LRHZg9ckCwg
 Wnk/T7zGy0gLdHBihG/1nWynODjgnauMG4VPPjinhJwu3Wfz2pVAxQMTVa9vfSjokq/XdtFL
 AoT4CVGhao/9kaDStj7Qg3+oXSB+BUbXrJ4FuQg9ACLjLLZ/wuDHWUCZjlbYdciuYk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLT9B+AOu2g8fzFDXY3
 T+Htm49iq8VgMpN0L+0lXjDgjSxtt3SRRU0zhvYU3jj7Q5jYoOhIYuy5jDmAe1oJYKdSByF+
 XMDgcXbtLpIBpCWnyvLS+IIdF2028u43PTnqQYHN/EcG/6FoBZPoag4DOlCGXpU
IronPort-HdrOrdr: A9a23:BmTb6qFBmECpDdYrpLqEx8eALOsnbusQ8zAXPo5KJSC9Ffbo8/
 xG88506faZslwssTQb6LO90cq7MBbhHPxOgLX5VI3KNGLbUSmTXeNfBODZrAEIdReSysdtkY
 99bqlzD8DxB1Bmgcu/3BO1CL8bsb66GdiT5ds3CxxWPHhXg2YK1XYeNjqm
X-Talos-CUID: 9a23:LEdk8mAS77jITvf6Ewk3+2Q+OPsdSHrmyyvzYB/jJTpUZqLAHA==
X-Talos-MUID: 9a23:2upHAwTUuhpE3FylRXTLjxNgbs1x3563BR5Ouq8ivNeeOgBvbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,228,1744070400"; 
   d="scan'208";a="374716305"
Received: from alln-l-core-02.cisco.com ([173.36.16.139])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 11 Jun 2025 18:31:33 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-02.cisco.com (Postfix) with ESMTPSA id 4B06A18000153;
	Wed, 11 Jun 2025 18:31:32 +0000 (GMT)
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
Subject: [PATCH 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
Date: Wed, 11 Jun 2025 11:30:31 -0700
Message-ID: <20250611183033.4205-3-kartilak@cisco.com>
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

Add logs in FDMI and FDMI ABTS paths.
Modify log text in these paths.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 65 +++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 0ee1b74967b9..9e9939d41fa8 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -791,6 +791,7 @@ static uint8_t *fdls_alloc_init_fdmi_abts_frame(struct fnic_iport_s *iport,
 static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
 {
 	uint8_t *frame;
+	struct fnic *fnic = iport->fnic;
 	unsigned long fdmi_tov;
 	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
 			sizeof(struct fc_frame_header);
@@ -801,6 +802,9 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
 		if (frame == NULL)
 			return;
 
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: FDLS send FDMI PLOGI abts. iport->fabric.state: %d oxid: 0x%x",
+			 iport->fcid, iport->fabric.state, iport->active_oxid_fdmi_plogi);
 		fnic_send_fcoe_frame(iport, frame, frame_size);
 	} else {
 		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
@@ -809,6 +813,9 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
 			if (frame == NULL)
 				return;
 
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "0x%x: FDLS send FDMI RHBA abts. iport->fabric.state: %d oxid: 0x%x",
+				 iport->fcid, iport->fabric.state, iport->active_oxid_fdmi_rhba);
 			fnic_send_fcoe_frame(iport, frame, frame_size);
 		}
 		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
@@ -821,6 +828,9 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
 					return;
 			}
 
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				 "0x%x: FDLS send FDMI RPA abts. iport->fabric.state: %d oxid: 0x%x",
+				 iport->fcid, iport->fabric.state, iport->active_oxid_fdmi_rpa);
 			fnic_send_fcoe_frame(iport, frame, frame_size);
 		}
 	}
@@ -829,6 +839,10 @@ static void fdls_send_fdmi_abts(struct fnic_iport_s *iport)
 	fdmi_tov = jiffies + msecs_to_jiffies(2 * iport->e_d_tov);
 	mod_timer(&iport->fabric.fdmi_timer, round_jiffies(fdmi_tov));
 	iport->fabric.fdmi_pending |= FDLS_FDMI_ABORT_PENDING;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+		 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+		 iport->fcid, iport->fabric.fdmi_pending);
 }
 
 static void fdls_send_fabric_flogi(struct fnic_iport_s *iport)
@@ -2292,7 +2306,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 
 	if (!iport->fabric.fdmi_pending) {
 		/* timer expired after fdmi responses received. */
@@ -2300,7 +2314,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 		return;
 	}
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 
 	/* if not abort pending, send an abort */
 	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
@@ -2309,26 +2323,37 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 		return;
 	}
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 
 	/* ABTS pending for an active fdmi request that is pending.
 	 * That means FDMI ABTS timed out
 	 * Schedule to free the OXID after 2*r_a_tov and proceed
 	 */
 	if (iport->fabric.fdmi_pending & FDLS_FDMI_PLOGI_PENDING) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			"FDMI PLOGI ABTS timed out. Schedule oxid free: 0x%x\n",
+			iport->active_oxid_fdmi_plogi);
 		fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_plogi);
 	} else {
-		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING)
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_REG_HBA_PENDING) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+						"FDMI RHBA ABTS timed out. Schedule oxid free: 0x%x\n",
+						iport->active_oxid_fdmi_rhba);
 			fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_rhba);
-		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING)
+		}
+		if (iport->fabric.fdmi_pending & FDLS_FDMI_RPA_PENDING) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+						"FDMI RPA ABTS timed out. Schedule oxid free: 0x%x\n",
+						iport->active_oxid_fdmi_rpa);
 			fdls_schedule_oxid_free(iport, &iport->active_oxid_fdmi_rpa);
+		}
 	}
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 
 	fdls_fdmi_retry_plogi(iport);
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
 
@@ -3743,12 +3768,26 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 
 	switch (FNIC_FRAME_TYPE(oxid)) {
 	case FNIC_FRAME_TYPE_FDMI_PLOGI:
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			"Received FDMI PLOGI ABTS rsp with oxid: 0x%x", oxid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+			 iport->fcid, iport->fabric.fdmi_pending);
 		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_plogi);
 
 		iport->fabric.fdmi_pending &= ~FDLS_FDMI_PLOGI_PENDING;
 		iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+			 iport->fcid, iport->fabric.fdmi_pending);
 		break;
 	case FNIC_FRAME_TYPE_FDMI_RHBA:
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			"Received FDMI RHBA ABTS rsp with oxid: 0x%x", oxid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+			 iport->fcid, iport->fabric.fdmi_pending);
+
 		iport->fabric.fdmi_pending &= ~FDLS_FDMI_REG_HBA_PENDING;
 
 		/* If RPA is still pending, don't turn off ABORT PENDING.
@@ -3759,8 +3798,17 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
 
 		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rhba);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+			 iport->fcid, iport->fabric.fdmi_pending);
 		break;
 	case FNIC_FRAME_TYPE_FDMI_RPA:
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			"Received FDMI RPA ABTS rsp with oxid: 0x%x", oxid);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+			 iport->fcid, iport->fabric.fdmi_pending);
+
 		iport->fabric.fdmi_pending &= ~FDLS_FDMI_RPA_PENDING;
 
 		/* If RHBA is still pending, don't turn off ABORT PENDING.
@@ -3771,6 +3819,9 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 			iport->fabric.fdmi_pending &= ~FDLS_FDMI_ABORT_PENDING;
 
 		fdls_free_oxid(iport, oxid, &iport->active_oxid_fdmi_rpa);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "0x%x: iport->fabric.fdmi_pending: 0x%x",
+			 iport->fcid, iport->fabric.fdmi_pending);
 		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-- 
2.47.1

