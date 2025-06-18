Received: from rcdn-iport-2.cisco.com (rcdn-iport-2.cisco.com [173.37.86.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77E32F531E;
	Wed, 18 Jun 2025 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750206949; cv=none; b=etKBOFmf2QAuCUswV2FJhDUHLumM+bIL6SoauLD4vNZnStRwNMAqvJqyzb7oOKiHwa+3CpVM1wWeUSmjzR/K0qVTfGE/C5vSId65ViiTGkd40m4agiwr7nAYjkQH8SDC7vZfGve6qD0T7u0TGCgixHrH6vjYogQlJa8Z+SlCYsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750206949; c=relaxed/simple;
	bh=wMX5/yKNtIH9pOwugAid9jYQ4Y8lOAbKgjxqAXXAYhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjlSfI9jWipUsQxUi5qW/52dEpYXdO7FtBhS0NNb15WauXBmDc8EZKJKZZZOXLpT+lIY9BDnSfNGoLlnj0F1mkQbOS6tJqR8Y4tNWRu2jUwGvLB5XIO/GGCmcHkrN1c7T+sHdc5zL51ySvm7Eil0RRCHpbr0P4F263QutKqq9/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=VygOFIQE; arc=none smtp.client-ip=173.37.86.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="VygOFIQE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7906; q=dns/txt;
  s=iport01; t=1750206947; x=1751416547;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1XUFzHCyxgA1T041xPFqfafnV1RDhUWFqfLydQX2HeY=;
  b=VygOFIQEc8gLV9pQzUbrhIctAHvFjiiDgMuxScuGCjMRNJQK5UHKUjVS
   BtZyqPnIeG1ksAr13fYWJI3QkU4mT3Hce+VSayghXViBzHJ7TyE8OP4sy
   0Dg+xuOzZWiWaAP5BNrDQhaMmqzkhHPOEDbiSJrfIqvAm72BIZWeuHhU/
   ioq43+3SDtXQwp12h6a0Hux/VArOjGL8rt7pk886bbd/sdFF1yncBhM7O
   ggVhziAa5EXXbgNJoIJ8GwcE+BZ2KUtZfbezbtZY/6WFLJWyMgQK7JZiZ
   UAttcf/q4DsbsMGhuhn1y9FpxPBV7tVGHKmGJqzCLJKy22qohS89dsfHu
   A==;
X-CSE-ConnectionGUID: DzpAv+OsRhC+8hTxFBmx5g==
X-CSE-MsgGUID: S+cs6uxMSY2hStcSoTMqfA==
X-IPAS-Result: =?us-ascii?q?A0AEAACDCFJo/5AQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBA?=
 =?us-ascii?q?YUHAotmAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE?=
 =?us-ascii?q?4YIhlsCAQMnCwFGEFFWGYMCgm8DrwqBeTOBAd43gW6BSQGNTXCEdycVBoFJR?=
 =?us-ascii?q?IEVgnlvgVKJNQSDOo9mYIFqgg4mUIwUSIEeA1ksAVUTDQoLBwWBYwM1DAsuF?=
 =?us-ascii?q?TI8Mh2CDYUZghKLBYRHK0+FIYUFJHEPBoELQAMLGA1IESw3FBsGPm4HmDCDa?=
 =?us-ascii?q?weBDhSBZEcBHpMkC5IzgTWfVoQloVMaM6phmQSjf4U5gWg8gVkzGggbFYMiU?=
 =?us-ascii?q?hkPji0Wu1UmMjwCBwsBAQMJkAgHgRZgAQE?=
IronPort-Data: A9a23:JW305qKStWIog7rOFE+RAZQlxSXFcZb7ZxGr2PjKsXjdYENS1WQPx
 jcaXTyAbqyMamHxKI11ad+y8klSsJGBmtA3QQcd+CA2RRqmiyZq6fd1j6vUF3nPRiEWZBs/t
 63yUvGZcoZsCCWa/073WlTYhSEU/bmSQbbhA/LzNCl0RAt1IA8skhsLd9QR2uaEuvDnRVrT0
 T/Oi5eHYgL9hWcrajl8B5+r8XuDgtyj4Fv0gXRmDRx7lAe2v2UYCpsZOZawIxPQKqFIHvS3T
 vr017qw+GXU5X8FUrtJRZ6iLyXm6paLVeS/oiI+t5qK23CulQRuukoPD8fwXG8M49m/c3+d/
 /0W3XC4YV9B0qQhA43xWTEAe811FfUuFLMqvRFTvOTLp3AqfUcAzN1CHlkfI84/4dx3KiIe9
 cAIBhoIfk2M0rfeLLKTEoGAh+wqKM3teYdasXZ6wHSBUrAtQIvIROPB4towMDUY358VW62AI
 ZNHL2MzMHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQqgOC8aYuFI4PiqcN9pQWTv
 Tzb70HCM0saD8CU8j2512uir7qa9c/8cMdIfFGizdZmiVvVzWUJEBAQSVahif24jEekXJRYM
 UN80igjr6Ia8E2tU8m7Xhe95nWDu3Y0XtNKD+w8rhmA1qfO+AufLm8eRzVFZZots8pebT4v2
 1mEkNPoLSZivL2cVTSW8bL8hSm/JyUPNkcYaCMERBdD6N7myKk3jxTSXpNgHbSzg9ndBz792
 XaJoTI4irFVitQEv42//Fbak3e3rYPIZhA66x+RXW+/6A59Iom/aOSVBUPz5PJEKsOdC1KGp
 nVBw5fY5+EVBpbLnyuIKAkQIIyUCz++GGW0qTZS81MJqFxBJ1bLkVhs3QxD
IronPort-HdrOrdr: A9a23:qbS446qzzffNfjZHTREn+/0aV5oEeYIsimQD101hICG9vPb1qy
 nIpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdWpk7IMHsDFR8kMbx6BS1HpId2tWdmZrY4ts2t00McemvAJsQljuQzW2gYytLeDU=
X-Talos-CUID: =?us-ascii?q?9a23=3ARA+0y2qaB/g9gvnVVddlQ4/mUew3alTDj1DLGU+?=
 =?us-ascii?q?TSjZpdK27Y1qApawxxg=3D=3D?=
X-Talos-MUID: 9a23:fRQhcAscFJp6XeAows2nv3JpL5l184GVORoNqokNgM64EDV+EmLI
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,244,1744070400"; 
   d="scan'208";a="380919817"
Received: from alln-l-core-07.cisco.com ([173.36.16.144])
  by rcdn-iport-2.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Jun 2025 00:35:46 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.123.35])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-07.cisco.com (Postfix) with ESMTPSA id 6C387180001EC;
	Wed, 18 Jun 2025 00:35:45 +0000 (GMT)
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
Subject: [PATCH v6 3/4] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
Date: Tue, 17 Jun 2025 17:34:30 -0700
Message-ID: <20250618003431.6314-3-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250618003431.6314-1-kartilak@cisco.com>
References: <20250618003431.6314-1-kartilak@cisco.com>
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

Add logs in FDMI and FDMI ABTS paths.
Modify log text in these paths.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v5 and v6:
    - Incorporate review comments from John:
	- Rebase patches on 6.17/scsi-queue
---
 drivers/scsi/fnic/fdls_disc.c | 65 +++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index fa9cf0b37d72..ae37f85f618b 100644
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
@@ -2294,7 +2308,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 
 	if (!iport->fabric.fdmi_pending) {
 		/* timer expired after fdmi responses received. */
@@ -2302,7 +2316,7 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
 		return;
 	}
 	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-		"fdmi timer callback : 0x%x\n", iport->fabric.fdmi_pending);
+		"iport->fabric.fdmi_pending: 0x%x\n", iport->fabric.fdmi_pending);
 
 	/* if not abort pending, send an abort */
 	if (!(iport->fabric.fdmi_pending & FDLS_FDMI_ABORT_PENDING)) {
@@ -2311,26 +2325,37 @@ void fdls_fdmi_timer_callback(struct timer_list *t)
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
 
@@ -3745,12 +3770,26 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
 
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
@@ -3761,8 +3800,17 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
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
@@ -3773,6 +3821,9 @@ static void fdls_process_fdmi_abts_rsp(struct fnic_iport_s *iport,
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

