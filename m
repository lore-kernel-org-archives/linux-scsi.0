Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B35231C56D;
	Tue, 17 Feb 2026 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.90
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771368055; cv=none; b=gbIRK8QwQhlUjE4XvaPWWCbq9/uVV5lSa2nU2DOP++jOPy5ptDXye1UB/yB77LHlkLvsby/esAORYvhcNEyh71vWj0W4a8buEr5Jw6910FAG9zL21RtQ8ifq30oz1k2db6c+5NeAjL8e89Zt7ZGoXaDrVudKMp8WPDCJGmRj/bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771368055; c=relaxed/simple;
	bh=DOr76Ulr51/11oRu2I0faGZRHEa28Wn4STnfwvobRg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKMtfUsCNnmVQD5BETI2eEHyyQTEaN6fCT4LYyHeRMtfU062Z3YIhHtp5Eo17QAlKtzApYPCdcSEpJDgVYFxF3Cu9nSvJDJzxICG+HGpxHWb0l/i6OPbrqzE+HSryErCWqQkzaULptedwgSZEAreNOsqVZhtYVFwco9RrIKtBqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=NuJntPV4; arc=none smtp.client-ip=173.37.142.90
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="NuJntPV4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8350; q=dns/txt;
  s=iport01; t=1771368053; x=1772577653;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=32vPaoyEWQVyv5suTntYZt0OVvCBEdGcdbgZqkLcU7U=;
  b=NuJntPV4LYXP1AGibPvL5+7yPX3begY56QuIkk8VMoBgPpeVxM4tqnTq
   ycL0t50nUvHu1ZAa3RLmzbL+Mj4CAJELMzIo9npSElb1Ef/n+Nmf4hBGw
   SZjPSFqcRotPYDCHMjuTOYF+npt6ta6TEsRKuxA55yBD+QD7HnwVwnCGq
   WUWlPL8O1yeSAWjNU6PnucCbeeJowy6hrXXy+myhHdkPxX18pGrcHjoQb
   1HVI1uVyIvE1mSJuoRk53ALXFJbsZFEGxDsZUPhe7Xbd/DNM6rhUOIufj
   1N0A9EhNlxYNbAp41vHipkbJnfFpW5HoKOEyzM1aQQban6DkYLmrxR0ha
   w==;
X-CSE-ConnectionGUID: +Fs4VPHgS2u7WYkxpmwLTQ==
X-CSE-MsgGUID: Z3LBXOvERbuTHcEzHfwupw==
X-IPAS-Result: =?us-ascii?q?A0A/BgCL7ZRp/5X/Ja1aglmCSA+BT0MZMJQqmmCFXhSBa?=
 =?us-ascii?q?w8BAQEPUQQBAYUHAo0fAiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQEBCgEBB?=
 =?us-ascii?q?QEBAQIBBwWBDhOGXIZbAgEDJwsBRhBRVhmDAoJ0A615gXkzgQHePoFkAQsUA?=
 =?us-ascii?q?YE4jVV0hHonFQaBSUSBFYNogVKCWIZdBIMwk2FIgR4DWSwBVRMNCgsHBYFmA?=
 =?us-ascii?q?zUSKhVuMh2BIz4XgQsbBwWHcw+JBXhugR+BDAMLGA1IESw3FBsEPm4HjjpBg?=
 =?us-ascii?q?jOBD0uBdGOSdJI1oQ6EJqFYGjOqay6HZZBzqUGBaDyBWTMaCBsVgyJSGQ+OL?=
 =?us-ascii?q?RbEViUyPAIHCwEBAwmTZwEB?=
IronPort-Data: A9a23:wjT4la4r86l78jrJN2lmYAxRtNvGchMFZxGqfqrLsTDasY5as4F+v
 mEYCDqPbvzeMGr0ftAgbNiw8khV7ZHTmoRrSAdtrngxZn8b8sCt6fZ1gavT04J+CuWZESqLO
 u1HMoGowPgcFyGa+1H1dOO8/BGQ7InQLpLkEunIJyttcgFtTSYlmHpLlvUw6mJSqYDR7zil5
 5Wo+qUzBHf/g2QqajhNtPrZwP9SlK2aVA0w7wRWic9j5Dcyp1FNZLoDKKe4KWfPQ4U8NoZWk
 M6akdlVVkuAl/scIovNfoTTKyXmcZaOVeS6sUe6boD56vR0SoPe5Y5gXBYUQR8/ZzxkBLmdw
 v0V3XC7YV9B0qEhBI3xXjEAexySM5Gq95eED2Pjj/SzwHacbiTT8vZ+FEQpGbEhr7Mf7WFmr
 ZT0KRgXZRyFwubzy7WhR6w13IIoLdLgO8UUvXQIITPxVKl9B8ucBf+XuJkBgGZYasNmRZ4yY
 +IaYCBzbRDJYDVEO0wcD9Q1m+LAanzXLW0F9wPL+Ppqi4TV5D4q9JLdF8T4QNaXeeVes1S4q
 H3b53usV3n2M/Tak1Jp6EmEhubVkAv4VZgUGbn+8eRl6HWfz2pVAxQMTVa9vfSjokq/XdtFL
 AoT4CVGhao/9kaDStj7Qg3+oXSB+BUbXrJ4FuQg9ACLjLLZ/wuDHWUCZjlbYdciuYk9QjlC/
 l2MktXkCjxumKeYRXKU6vGfqjbaETIYM2IYfgceQAcF6sWlq4Y25jrLQstlG6ezpsboAjy2y
 DePxAA6hrMOnYsI2r+98FTvnT2hvN7KQxQz6wGRWXiqhit9ZYi4d8mz4kPaxehPIZzfTVSbu
 nUA3c+E44gz4YqljieBRqAJWbqu/fvAaWeail90FJ5n/DOok5K+Qb1tDPhFDB8BGq45lfXBO
 Sc/ZSs5CEdvAUaX
IronPort-HdrOrdr: A9a23:36VGbKAoHtROMW3lHemD55DYdb4zR+YMi2TDGXocdfUzSL39qy
 nAppomPHPP4gr5HUtQ+uxoW5PwJE80l6QV3WB5B97LNzUO+lHYTr2KhrGM/9SPIUDD398Y/b
 t8cqR4Fd37BUV3gILH+gWieuxQp+VviJrJuQ8bpE0dND2DrMpbnmFENjo=
X-Talos-CUID: 9a23:eyJQ/mzuW75fnvgzjH92BgVXNNt5TEX9w0yKPhCHOGV5ULiKbWOprfY=
X-Talos-MUID: 9a23:9MGbign/Sra1Lv55DdV+dnpQb+NC04OwJXoHjKkmsOSWFSJvJi+C2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.21,297,1763424000"; 
   d="scan'208";a="685796585"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 17 Feb 2026 22:40:52 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.109.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTPSA id EE8581800030C;
	Tue, 17 Feb 2026 22:40:50 +0000 (GMT)
From: Karan Tilak Kumar <kartilak@cisco.com>
To: sebaddel@cisco.com
Cc: arulponn@cisco.com,
	djhawar@cisco.com,
	gcboffa@cisco.com,
	aeasi@cisco.com,
	mkai2@cisco.com,
	satishkh@cisco.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jmeneghi@redhat.com,
	revers@redhat.com,
	dan.carpenter@linaro.org,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>,
	Lee Duncan <lduncan@suse.com>
Subject: [PATCH 3/5] scsi: fnic: Rename fnic_scsi_fcpio_reset()
Date: Tue, 17 Feb 2026 14:39:41 -0800
Message-ID: <20260217223943.7938-3-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260217223943.7938-1-kartilak@cisco.com>
References: <20260217223943.7938-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.109.174, [10.188.109.174]
X-Outbound-Node: rcdn-l-core-12.cisco.com

The function has no dependency on SCSI/FCP, so rename it to
fnic_fcpio_reset() and move it to fnic_fcs.c

Tested-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fdls_disc.c |  4 +--
 drivers/scsi/fnic/fip.c       |  2 +-
 drivers/scsi/fnic/fnic.h      |  1 -
 drivers/scsi/fnic/fnic_fcs.c  | 50 ++++++++++++++++++++++++++++++++
 drivers/scsi/fnic/fnic_fdls.h |  2 +-
 drivers/scsi/fnic/fnic_scsi.c | 54 +----------------------------------
 6 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index ae37f85f618b..d276f1d696f8 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -4613,7 +4613,7 @@ void fnic_fdls_disc_start(struct fnic_iport_s *iport)
 	if (!iport->usefip) {
 		if (iport->flags & FNIC_FIRST_LINK_UP) {
 			spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-			fnic_scsi_fcpio_reset(iport->fnic);
+			fnic_fcpio_reset(iport->fnic);
 			spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
 			iport->flags &= ~FNIC_FIRST_LINK_UP;
@@ -5072,7 +5072,7 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 	iport->fabric.flags = 0;
 
 	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-	fnic_scsi_fcpio_reset(iport->fnic);
+	fnic_fcpio_reset(iport->fnic);
 	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
diff --git a/drivers/scsi/fnic/fip.c b/drivers/scsi/fnic/fip.c
index ce62ab1180bd..6926bb1de163 100644
--- a/drivers/scsi/fnic/fip.c
+++ b/drivers/scsi/fnic/fip.c
@@ -737,7 +737,7 @@ void fnic_work_on_fip_timer(struct work_struct *work)
 		if (memcmp(iport->selected_fcf.fcf_mac, zmac, ETH_ALEN) != 0) {
 
 			if (iport->flags & FNIC_FIRST_LINK_UP) {
-				fnic_scsi_fcpio_reset(iport->fnic);
+				fnic_fcpio_reset(iport->fnic);
 				iport->flags &= ~FNIC_FIRST_LINK_UP;
 			}
 
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 88b47ea04ab2..f1b6c7978231 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -513,7 +513,6 @@ int fnic_host_reset(struct Scsi_Host *shost);
 void fnic_reset(struct Scsi_Host *shost);
 int fnic_issue_fc_host_lip(struct Scsi_Host *shost);
 void fnic_get_host_port_state(struct Scsi_Host *shost);
-void fnic_scsi_fcpio_reset(struct fnic *fnic);
 int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do, unsigned int cq_index);
 int fnic_wq_cmpl_handler(struct fnic *fnic, int);
 int fnic_flogi_reg_handler(struct fnic *fnic, u32);
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 2b543d570051..063eb864a5cd 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1128,3 +1128,53 @@ void fnic_reset_work_handler(struct work_struct *work)
 	spin_unlock_irqrestore(&reset_fnic_list_lock,
 						   reset_fnic_list_lock_flags);
 }
+
+void fnic_fcpio_reset(struct fnic *fnic)
+{
+	unsigned long flags;
+	enum fnic_state old_state;
+	struct fnic_iport_s *iport = &fnic->iport;
+	DECLARE_COMPLETION_ONSTACK(fw_reset_done);
+	int time_remain;
+
+	/* issue fw reset */
+	spin_lock_irqsave(&fnic->fnic_lock, flags);
+	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
+		/* fw reset is in progress, poll for its completion */
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			  "fnic is in unexpected state: %d for fw_reset\n",
+			  fnic->state);
+		return;
+	}
+
+	old_state = fnic->state;
+	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
+
+	fnic_update_mac_locked(fnic, iport->hwmac);
+	fnic->fw_reset_done = &fw_reset_done;
+	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				"Issuing fw reset\n");
+	if (fnic_fw_reset_handler(fnic)) {
+		spin_lock_irqsave(&fnic->fnic_lock, flags);
+		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
+			fnic->state = old_state;
+		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
+	} else {
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					  "Waiting for fw completion\n");
+		time_remain = wait_for_completion_timeout(&fw_reset_done,
+						  msecs_to_jiffies(FNIC_FW_RESET_TIMEOUT));
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					  "Woken up after fw completion timeout\n");
+		if (time_remain == 0) {
+			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+				  "FW reset completion timed out after %d ms\n",
+				  FNIC_FW_RESET_TIMEOUT);
+		}
+		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_reset_timeouts);
+	}
+	fnic->fw_reset_done = NULL;
+}
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index 531d0b37e450..e2959120c4f9 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -410,6 +410,7 @@ void fnic_fdls_add_tport(struct fnic_iport_s *iport,
 void fnic_fdls_remove_tport(struct fnic_iport_s *iport,
 			    struct fnic_tport_s *tport,
 			    unsigned long flags);
+void fnic_fcpio_reset(struct fnic *fnic);
 
 /* fip.c */
 void fnic_fcoe_send_vlan_req(struct fnic *fnic);
@@ -422,7 +423,6 @@ void fnic_handle_fip_timer(struct timer_list *t);
 extern void fdls_fabric_timer_callback(struct timer_list *t);
 
 /* fnic_scsi.c */
-void fnic_scsi_fcpio_reset(struct fnic *fnic);
 extern void fdls_fabric_timer_callback(struct timer_list *t);
 void fnic_rport_exch_reset(struct fnic *fnic, u32 fcid);
 int fnic_fdls_register_portid(struct fnic_iport_s *iport, u32 port_id,
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index 1494aeb908ba..05b203b9b69b 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -1975,8 +1975,7 @@ void fnic_scsi_unload(struct fnic *fnic)
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 
 	if (fdls_get_state(&fnic->iport.fabric) != FDLS_STATE_INIT)
-		fnic_scsi_fcpio_reset(fnic);
-
+		fnic_fcpio_reset(fnic);
 	spin_lock_irqsave(&fnic->fnic_lock, flags);
 	fnic->in_remove = 1;
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
@@ -3040,54 +3039,3 @@ int fnic_eh_host_reset_handler(struct scsi_cmnd *sc)
 	ret = fnic_host_reset(shost);
 	return ret;
 }
-
-
-void fnic_scsi_fcpio_reset(struct fnic *fnic)
-{
-	unsigned long flags;
-	enum fnic_state old_state;
-	struct fnic_iport_s *iport = &fnic->iport;
-	DECLARE_COMPLETION_ONSTACK(fw_reset_done);
-	int time_remain;
-
-	/* issue fw reset */
-	spin_lock_irqsave(&fnic->fnic_lock, flags);
-	if (unlikely(fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)) {
-		/* fw reset is in progress, poll for its completion */
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-			  "fnic is in unexpected state: %d for fw_reset\n",
-			  fnic->state);
-		return;
-	}
-
-	old_state = fnic->state;
-	fnic->state = FNIC_IN_FC_TRANS_ETH_MODE;
-
-	fnic_update_mac_locked(fnic, iport->hwmac);
-	fnic->fw_reset_done = &fw_reset_done;
-	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-
-	FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-				  "Issuing fw reset\n");
-	if (fnic_fw_reset_handler(fnic)) {
-		spin_lock_irqsave(&fnic->fnic_lock, flags);
-		if (fnic->state == FNIC_IN_FC_TRANS_ETH_MODE)
-			fnic->state = old_state;
-		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
-	} else {
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					  "Waiting for fw completion\n");
-		time_remain = wait_for_completion_timeout(&fw_reset_done,
-						  msecs_to_jiffies(FNIC_FW_RESET_TIMEOUT));
-		FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					  "Woken up after fw completion timeout\n");
-		if (time_remain == 0) {
-			FNIC_SCSI_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-				  "FW reset completion timed out after %d ms)\n",
-				  FNIC_FW_RESET_TIMEOUT);
-		}
-		atomic64_inc(&fnic->fnic_stats.reset_stats.fw_reset_timeouts);
-	}
-	fnic->fw_reset_done = NULL;
-}
-- 
2.47.1

