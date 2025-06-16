Received: from rcdn-iport-3.cisco.com (rcdn-iport-3.cisco.com [173.37.86.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDB72874E1;
	Mon, 16 Jun 2025 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750091247; cv=none; b=J8ZD2Uhbeil8WGie0H2cLHDhpEPPqAOmRAAPrskV1aEem+VI9+YwKvRO5GhvgG5Sjhv19/hCtfzcTdOjdBhjJDWPQmM+nAhEAayN+76NufC1hTZQapfxtR5+ZPBLWewr7nTIrxHgVrpNzbCoxvSPlUX2iPd3ovJoPIm2cjTuHmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750091247; c=relaxed/simple;
	bh=L8wIpTB92/GO7zypSaXWXZ0oMLQI18H2zmJruLR+hlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/2L5a+G8UnCg6qwzL5v9UFIbvOj9iTU0N5YSGVozWWOJQhlZlB2EmBfhey8P2COXFDiBbw0z/0/k/I14XePmtB8lqksq73ZkKc4ecMAtvJ5Xn4Z+jMW8GI2IhaNjykTfchKqC6pRPlECwBIVkd1PP0cJVEmfBLiU0NNsuP+xO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=JlVAlUC/; arc=none smtp.client-ip=173.37.86.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="JlVAlUC/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7792; q=dns/txt;
  s=iport01; t=1750091245; x=1751300845;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xv2pY2dcZZStRYn70I+jXe/82sKmKsqwAsAOsWBhsGQ=;
  b=JlVAlUC/TkH8XYRYpVlXB/PkGCI8vQ7HdEgVuXo4IMLeJn5OtcdI0Bhc
   7dZpI4Kk2QWb+A4cI0wNks83pERJ9Eq8/nAkJ83Jf5SDZ5yhSlzrpy0Nq
   M8Abww6yMYUar/J+W06HY6HMSicgjsIDSpstR21+o9kJeunyteLjw/fi5
   oAmyfjQj9JCCMOzuU6q8XCg2P2LuW+adePnEd1c4KMutLilkkXBj1hagz
   WllGiT60xv7woIKrm0+ZUvxm13FEtYXbU/rOWBkTdYtFCk6LJFQrBIMQ+
   eSuD/IlIBgFm40uy6aygUT+2inpiX+HLIuqvzGfQCQ6/w+3ctPU1Olw1z
   w==;
X-CSE-ConnectionGUID: t1BiUVzURFaafk0l0RWgnw==
X-CSE-MsgGUID: JZxj47rgTAO0mKipMVBsug==
X-IPAS-Result: =?us-ascii?q?A0ANAACbRFBo/5QQJK1aGwEBAQEBAQEBBQEBARIBAQEDA?=
 =?us-ascii?q?wEBAYF/BgEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBAYUHAotmA?=
 =?us-ascii?q?iY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4YIhlsCA?=
 =?us-ascii?q?QMnCwFGEFFWGYMCgm8Dr3iBeTOBAd43gW6BSQGNTXCEdycVBoFJRIEVgnlvg?=
 =?us-ascii?q?VKJNQSDOo9oYIFqgjGMQEiBHgNZLAFVEw0KCwcFgWMDNQwLLhUyPDIdgg2FG?=
 =?us-ascii?q?YISiwiESStPhSGFBSRxDwZPQAMLGA1IESw3FBsGPm4HmAuDaweBDhSBZEgek?=
 =?us-ascii?q?yQLkjOBNZ9WhCWhUxozqmGZBKN/hTmBaDyBWTMaCBsVgyJSGQ+OLRa7UyYyP?=
 =?us-ascii?q?AIHCwEBAwmPfweBFmABAQ?=
IronPort-Data: A9a23:nnYDB6oKvbQu9NnCCUX+2OVJ9O5eBmLIZBIvgKrLsJaIsI4StFCzt
 garIBmGa/3cYDbwKYggao3kpBhTvJGEz9A2HlNp/HtnFC1Dp+PIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9z8ljPvgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQHNNwJcaDpOtvrd8U035pwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0vouK2Bzy
 +4lEh4EZx6A3+bu+o20TPY506zPLOGzVG8eknhkyTecCbMtRorOBvyTo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtHYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofbHpoNwxbB/
 woq+UzbMAEYaIOFxgas1Sqppe7XuB3RQ58dQejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBBzlitrCaSXO17LqYrTqufyMSKAcqfyIaQBEey8PurIE6klTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRLt1VXGIu
 HwC3szb5+cUANTUzWqGQf4GG/ei4PPt3CDgvGOD1qIJr1yFk0NPt6gJiN2iDC+F6vo5RAI=
IronPort-HdrOrdr: A9a23:MHODWaCsF62YoT3lHemD55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuQ8bpE0dND2DrMpbnmFENjo=
X-Talos-CUID: 9a23:62ulh265/U71XbPgJNss6Bc+G/0bYEDn4n7ZLUzgDT5Td7KTVgrF
X-Talos-MUID: 9a23:zYB6TgVICYBuX+Pq/B3elDM+a91n342JUEUukI0jheOfKCMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,241,1744070400"; 
   d="scan'208";a="393705811"
Received: from alln-l-core-11.cisco.com ([173.36.16.148])
  by rcdn-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 16 Jun 2025 16:27:24 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-11.cisco.com (Postfix) with ESMTPSA id AC408180001E7;
	Mon, 16 Jun 2025 16:27:22 +0000 (GMT)
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
Subject: [PATCH v5 3/4] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
Date: Mon, 16 Jun 2025 09:26:31 -0700
Message-ID: <20250616162632.4835-3-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250616162632.4835-1-kartilak@cisco.com>
References: <20250616162632.4835-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.19.134, [10.188.19.134]
X-Outbound-Node: alln-l-core-11.cisco.com

Add logs in FDMI and FDMI ABTS paths.
Modify log text in these paths.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 65 +++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 146744ca97c2..14691db4d5f9 100644
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

