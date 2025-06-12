Received: from rcdn-iport-1.cisco.com (rcdn-iport-1.cisco.com [173.37.86.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC0B3AC1C;
	Thu, 12 Jun 2025 00:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749687883; cv=none; b=Abq72KxHNAZl4GpFYlhqMnVfm/6xK1s7Km/J3r6NdEHyANEECz2tZedZj8huWmWPK7fdxE1as3epm+0Thfjxpk1RqatI8W0dXj6nRcE5wO2D20+26RS8V2ngGvjqdwDoEpG3brWEvdecHD9J7Nf6Pp7N13P55fqq+iMZdxQSp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749687883; c=relaxed/simple;
	bh=7xJdS0NlV0f6qVbfi2ht7mxeyl33GYCtR2uTV02K/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fj/mYTNUJYM18hlig8sJhyrTXpP/i62ddU1nEBttaTrbWLgPfSpckmWb1BF8051MODDzkowIW++kWXtr3b2sDIxP1+wR3SI5Nh/wvZVNY6GXeV2mBPANeHXh9hRPdg+5+SjYM0pXw9tmiyEco06iaTyTAlqDne9kY1RlnCRvezY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=jQQMzNfW; arc=none smtp.client-ip=173.37.86.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="jQQMzNfW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7741; q=dns/txt;
  s=iport01; t=1749687881; x=1750897481;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2+bixmuNLdcMxgRBtx96vs2b1DYzsJQTdepEWzrFTc=;
  b=jQQMzNfWLh3+yvCwWeuCp3WlC9nB5PcdDtrnuKWXwTPFJS8+oX2TRhe8
   5ngwPbwZqhDWTe8cyEiWRqi7usnRcfmA3dLfnI/JmsEbQpe9DMUcc0J6l
   Lwf8hetI7XkJvpkAhkSdKX31LmAR/inv7fktcaDv3ejiBgnIEAQvkPAnu
   UXi+n1Hb9wTsne+DWlltEzSMaXJgoUD2eDuHwxIjLATluYTTm74GZd4Hl
   TpVugrhveKILTBvwgxNDAJVBt08z8CAZ5HcOTqVQ5S19LVgxfHVK14SEi
   Ju4Mw1vcOXSREot7wQ9U6tFE7ghdk84Qqj4+UgJd4Gi2j/cMVCxEXegjb
   g==;
X-CSE-ConnectionGUID: RMuIPrA7TOGV5BJHsO16YA==
X-CSE-MsgGUID: hFaWRCjWTQ+eXKCLLQw/MA==
X-IPAS-Result: =?us-ascii?q?A0AEAACTHUpo/5IQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBA?=
 =?us-ascii?q?YUHAotmAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE?=
 =?us-ascii?q?4YIhlsCAQMnCwFGEFFWGYMCgm8DsBOBeTOBAd43gW6BSQGNTHCEdycVBoFJR?=
 =?us-ascii?q?IEVgnlvgVKJNQSDOo9oYIFqgjGMO0iBHgNZLAFVEw0KCwcFgWMDNQwLLhUyP?=
 =?us-ascii?q?DIdgg2FGYISiweESStPhSGFBSRyDwdKQAMLGA1IESw3FBsGPm4HmAuDaQeBD?=
 =?us-ascii?q?hSBZEgekyQLkjOBNZ9WhCWhUxozqmGZBKN/hTmBaDyBWTMaCBsVgyJSGQ+OL?=
 =?us-ascii?q?Ra7VSYyPAIHCwEBAwmQFweBFmABAQ?=
IronPort-Data: A9a23:Mz/f8ao4Yh65sHvz5++eQd4mQ9JeBmLzZBIvgKrLsJaIsI4StFCzt
 garIBnSPqnbZzagfIskPI7l80lSsJGDnNQyTlFtqCE0Hi5B9OPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOCn9z8ljPvgqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYQHNNwJcaDpOtvrd8Uo355wehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86r5K255G7Q4yA2AdqjlLvhGmVSKlIFFVHT4pb+c/HKbilq/kTe4I5iXBYvQRs/ZwGyojxE4
 I4lWapc5useFvakdOw1C3G0GszlVEFM0OevzXOX6aR/w6BaGpfh660GMa04AWEX0txSHEB27
 9VHFBciUE2ppcKt5+vle8A506zPLOGzVG8eknhkyTecCbMtRorOBv2bo9RZxzw3wMtJGJ4yZ
 eJANmEpN0qGOkMJYwtJYH49tL/Aan3XcDRCtFORrKkf6GnIxws327/oWDbQUofaFZoExBbD/
 goq+Uz5LBglDved9ga8sX+cpcTruRrkH6c7QejQGvlCxQf7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBBzlitrCaSXO17LqYrTqufyMSKAcqfyIaQBEey8PurIE6klTESdMLOKq0iMDlXDL92
 TaHqAAgiLgJy80GzaO2+RbAmT3EjpzISBMlox7cRWON8Ax0fsimapau5Fyd6uxPRK6CUlCLu
 HUshceT9qYNAIuLmSjLR/8CdIxF/N6MNDnaxFoqFJ47+nH1qjiofJtb53d1I0IB3ts4RAIFq
 XT74Wt5jKK/9lPzPMebv6rZ5xwW8JXd
IronPort-HdrOrdr: A9a23:j4d5QqNLXfY5VMBcTu6jsMiBIKoaSvp037Dk7SxMoHtuA6ilfq
 +V8sjzuSWftN9VYgBCpTniAtjkfZq/z/9ICOAqVN/IYOClghrLEGgI1+TfKlPbdhHWx6p0yb
 pgf69iCNf5EFR2yfrh7BLQKadG/DD+ysCVbSO09QYVcemsAJsQiTtENg==
X-Talos-CUID: =?us-ascii?q?9a23=3At63JLmqntR4sn2OaHvO1IOXmUfoAb1zl1l6PH2i?=
 =?us-ascii?q?XNztDap2ObgbOyYoxxg=3D=3D?=
X-Talos-MUID: 9a23:rKktrQaf/7LNA+BTtxHluwtJNvhU2uejOGMmtbE/pI6hHHkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,229,1744070400"; 
   d="scan'208";a="388792830"
Received: from alln-l-core-09.cisco.com ([173.36.16.146])
  by rcdn-iport-1.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 00:23:12 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-09.cisco.com (Postfix) with ESMTPSA id 429011800023E;
	Thu, 12 Jun 2025 00:23:11 +0000 (GMT)
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
Subject: [PATCH v2 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
Date: Wed, 11 Jun 2025 17:22:10 -0700
Message-ID: <20250612002212.4144-3-kartilak@cisco.com>
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

