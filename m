Received: from rcdn-iport-4.cisco.com (rcdn-iport-4.cisco.com [173.37.86.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7781B2C325E;
	Thu, 12 Jun 2025 22:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749766848; cv=none; b=L6BduqBH6gzUq956hYMa97NZo4v2L2BRzW548bNamUROdBwW56hMP5shKAZpPqwzb3dnraIKm0ZkcAceiFxT8+RXaDdH6IQ4betNuwef0yuHcknvTx9cfIfbwcSbBTKVWBO9ZoRr2T92c0gvhhVQNVggAamf/xd15wO68wtiE2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749766848; c=relaxed/simple;
	bh=7xJdS0NlV0f6qVbfi2ht7mxeyl33GYCtR2uTV02K/aE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d445EMl5hcS4Te/wpGyUFPIYI1694/l72BjaSNCncBOuS88jnhBa7zMgT1FzN0q9SGRwK3q86cYYtqCACooPT97N+0dz/olZEqkHpaAjNPYLTVHSfyrs8bZaxf1XGz0JJWJ6BDfw0Yy7mcVqTCNBEBQXSkKgtxSYNuwsZ++Dfb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=d+q3hSYw; arc=none smtp.client-ip=173.37.86.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="d+q3hSYw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=7741; q=dns/txt;
  s=iport01; t=1749766836; x=1750976436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F2+bixmuNLdcMxgRBtx96vs2b1DYzsJQTdepEWzrFTc=;
  b=d+q3hSYwYmpMQ6qD6dJDVFa2fkNsqa3huUkvjsHnl7oV6Z0ECflRZrcA
   /npluTCZBpr85UnQ62WJThvJH5MWxkOx70CJ1JfUcgZKIvrh8qYcFsE2k
   1dG05TfCECrWCcgSgOQNEIEyObYRHxAW0pIa5AuTcKDoatqwgIL/csHBM
   aUuyH+3xUcYzhBZcryRMmmabsTFx4UTkr3+Vws2Qj4Tbrrq0DJfAK26jI
   ZMkivwrKrt36reagrU4P3iSHm55G/vLPQYEfD1Jqz1zSPii29bQGjF1zU
   0hgw6xyXHxjTFdL0CzQzkzWt9xkhJ31Pl7jvGj04akQPmWFMoeOKdp9bk
   g==;
X-CSE-ConnectionGUID: 9HKOKLw7Tw6EKZE+ouVpmg==
X-CSE-MsgGUID: bU280ej7QHCfeHJxu8HlyQ==
X-IPAS-Result: =?us-ascii?q?A0AEAACoUUto/5MQJK1aGgEBAQEBAQEBAQEDAQEBARIBA?=
 =?us-ascii?q?QEBAgIBAQEBgX8FAQEBAQsBgkqBUkMZMIxwhzSCIZ4ZgSUDVw8BAQEPUQQBA?=
 =?us-ascii?q?YUHAotmAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE?=
 =?us-ascii?q?4YIhlsCAQMnCwFGEFFWGYMCgm8DsAaBeTOBAd43gW6BSQGNTHCEdycVBoFJR?=
 =?us-ascii?q?IEVgnlvgVKJNQSDOo9oYIFqgjGMO0iBHgNZLAFVEw0KCwcFgWMDNQwLLhUyP?=
 =?us-ascii?q?DIdgg2FGYISiwiESStPhSGFByRyDwZHQAMLGA1IESw3FBsGPm4HmAmDaQeBD?=
 =?us-ascii?q?hSBZEgekyQLkjOBNZ9WhCWhUxozqmGZBKN/hTmBaDyBWTMaCBsVgyJSGQ+OL?=
 =?us-ascii?q?Ra7VSYyPAIHCwEBAwmPdQeBFmABAQ?=
IronPort-Data: A9a23:3muMNK4MjlD6XhmMwBs2MQxRtOjGchMFZxGqfqrLsTDasY5as4F+v
 jFJWWyHPq3fZjfzc94ga4vl8EgFvZTSndJlTVFvqnw3Zn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa/lH3dOG49xGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wr/aUzBHf/g2QpajxNsfrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoaSW
 +bZwbilyXjS9hErB8nNuu6TnpoiG+O60aCm0xK6aoD66vRwjnVaPpUTaJLwXXxqZwChxLid/
 jniWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I0DuKxPRL/tS4E4ebK073cVTHj5y6
 qI1CwIgLReeufqzz+fuIgVsrpxLwMjDNYcbvDRkiDreF/tjGMiFSKTR7tge1zA17ixMNa+BP
 IxCN3w2MlKZP0In1lQ/UPrSmM+rj2PjcjlRq3qepLE85C7YywkZPL3Fa4uNIYzRH5gK9qqej
 mj7pTShDxNFDfy0xzel0GKx1s/LjBquDer+E5X9rJaGmma7ymUVThYfT0O2p+W0kGa6WtRWM
 UtS/TAhxYAw+U6hZt38WQCo5n+Ou1gXXN84O+gz8h2MzOzM7hqUHHMJSBZGctUtsMJwTjsvv
 neLmt7vCDNvsZWPRH6d/6vSpjS3UQAPIHEPfzQsVwYJ49D/5oo0i3rnStdlDb7wjdDvHzz06
 y6FoTJ4hLgJi8MPkaKh8jjvhzOqu4iMVQUu5y3JUW+/qAB0foioY8qv81ez0BpbBI+dSl/Eu
 D0PnNKTqblWS5qMjyeKBu4KGdlF+sq4DdEVunY3d7FJythn0yfLkVx4iN2mGHpUDw==
IronPort-HdrOrdr: A9a23:rgMA6a7xs/bt0AP6tQPXwOfXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fjJ7MHd3ASV0mmhD0JbDqmLg==
X-Talos-CUID: =?us-ascii?q?9a23=3AT8zBcWuQn177kHcaDliK99IP6It0Ul7671PPfHO?=
 =?us-ascii?q?nV0tKepDWTkKu4KZrxp8=3D?=
X-Talos-MUID: 9a23:yyobSwRrAPG8fnmPRXTmuWsybMpqvJ2OI04AsbcWppmkMT1JbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.16,231,1744070400"; 
   d="scan'208";a="390383257"
Received: from alln-l-core-10.cisco.com ([173.36.16.147])
  by rcdn-iport-4.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Jun 2025 22:19:26 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.19.134])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by alln-l-core-10.cisco.com (Postfix) with ESMTPSA id 52A5318000161;
	Thu, 12 Jun 2025 22:19:25 +0000 (GMT)
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
Subject: [PATCH v4 3/5] scsi: fnic: Add and improve logs in FDMI and FDMI ABTS paths
Date: Thu, 12 Jun 2025 15:18:03 -0700
Message-ID: <20250612221805.4066-3-kartilak@cisco.com>
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

