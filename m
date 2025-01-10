Received: from alln-iport-6.cisco.com (alln-iport-6.cisco.com [173.37.142.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366C92054E2;
	Fri, 10 Jan 2025 09:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.142.93
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736500639; cv=none; b=NHxcaahuIJb91DAR2qzHyBR8w582I6QL9dlqbHy3x6ASgybZCnurvuytPlCW4a9ZVnv6zICEES13qPb+RU9lwg7QiCkSuSRPXpFFqBFsGFWxW9O/x9RB0dTyuvyZj30AG2ayAWVLQOSAHpNZdW+JstC8iHB3yF1EaFf4eFVcfDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736500639; c=relaxed/simple;
	bh=/RFglmw2/k5VOd0qdeDYNoRXtPz5tHbAd+GcAoQ06DY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mYSxfbELJGlG6DJgVcXxQZtu7QJLZQdxnXJ6cGf0zk4LSu94TivQT7g6dXCGKrEtUB6nF/TlX/rb4gcuAeEx21s0KLYFAS/uAnB7BtNHbcCZDL6FEkS7x5hUvM+HPhTdro5v7N6HJy3T5Ev13EEJyxdGMcQgYPibiVpWjlDuFj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=kpwQkLoE; arc=none smtp.client-ip=173.37.142.93
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="kpwQkLoE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=8048; q=dns/txt; s=iport;
  t=1736500637; x=1737710237;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=T8iOYhTicdQcxZUXaDD0RT3BUHwwFw9r8KiRbUMZY5s=;
  b=kpwQkLoECdGis60PMwy+msACmPLML8VR1xaygBIW/tXs1bqksCSSXZJE
   FZIKqeooyJp2B3Nieg7vl9iR1+1BGP0oWQ2VGQfCLukgAj8VXMQdkCulN
   k4TGmSF1lReauYdlG4NNg/IjJfd+ky92i7FdjO7rBVsLDNiAE15b6pK01
   o=;
X-CSE-ConnectionGUID: +D3t7pdcSQCFQ+AszhHLLw==
X-CSE-MsgGUID: DHyO3SzjSEapRDaPQqaPvA==
X-IPAS-Result: =?us-ascii?q?A0AkAQBD5IBnj5H/Ja1aH4I9ghyBfkMZL5ZDmD6FXYElA?=
 =?us-ascii?q?1YPAQEBD0QEAQGFB4p2AiY0CQ4BAgQBAQEBAwIDAQEBAQEBAQEBAQELAQEFA?=
 =?us-ascii?q?QEBAgEHBRQBAQEBAQE5BQ47hgiGXSsLAUYwgSCCKViCZQOzOIF5M4EB3jOBb?=
 =?us-ascii?q?YFIjUqFZycVBoFJRIEVgTuCLYFSiTUEgjOBRy+DP55KSIEhA1ksAVUTDQoLB?=
 =?us-ascii?q?wWBcwM4DAswFYFPe4JGaUk3Ag0CNYIefIIrhFyER4RWhWWCF4V4QAMLGA1IE?=
 =?us-ascii?q?Sw3FBsGPm4Hmxs8g3CBD4IoARYekyIRCpIVgTSfT4QloUYaM6pSAS6HZJBqq?=
 =?us-ascii?q?S2BZzqBWzMaCBsVgyJSGQ+OLQ0JvBYlMjwCBwsBAQMJkR4BAQ?=
IronPort-Data: A9a23:hdn7Yqz4xwimzi0q8s96t+faxirEfRIJ4+MujC+fZmUNrF6WrkUDz
 msfUG+OaPvbY2rzet1+PIXjo0lVvJ6Gm4U2GVBk+1hgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/lH1b+CJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 ImaT/H3Ygf/hmYtazpMsspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJAIaZpFH4up8Olhl2
 8VbASsfbjCno/3jldpXSsE07igiBNPgMIVavjRryivUSK52B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cPnWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxaYKLIoPTG509ckCwi
 kLX2D/CEBMhGdWH8xaMyku1j9fRtHauMG4VPOblrqEx2gL7KnYoIBEfUx2wqOOhh0iiVsh3L
 00S8zAp668o+ySDTNT/VTW8oXiZrlgdUd8WGOo/gCmIw7DI4gDfHmUYQyRaZdoOs9U/Tjgnk
 FSOmrvBAT1pra3QSn+H8LqQhS29NDJTLmIYYyIACwwf7LHLpIA1kwKKVd14EYargdDvXzL92
 TaHqG45nbp7sCIQ/7+w8VaCh3enoYLEC1ZloA7WRWmiqAh+YeZJerBE93CYwa1cc56VRWK4l
 1Y92OGF/uAuKbWSwXnlrPo2IJml4POMMTv5iFFpHoU8+znFx5JFVd4LiN2ZDBkyWvvoaQPUj
 FnvVRS9DaK/3UdGj4cqOOpd6OxzkcAM8OgJsNiPMbKihbAqK2e6ENlGPxL44owUuBFEfVsDE
 Zmaa92wKn0RFL5qyjG7L89EjuR1mnxhmD+PGc6rp/hC7VZ4TCPKIVviGAbfBt3VEIve+m05D
 v4GbZLTlUkPOAEASnaHqdRIRbz1EZTLLcur85MMLLHrzvtOE2A6APiZ2qI6Z4FghOxUkOyOl
 kxRqWcGoGcTcUbvcF3QAlg6MeuHdc8m8RoTY3d2VX72gCdLXGpaxPtEH3fBVeV8rLQ7pRO1J
 tFZE/i97gNnEW2YomxFMcaj9+SPtn2D3GqzAsZsWxBnF7YIeuAD0oOMktfHnMXWMheKiA==
IronPort-HdrOrdr: A9a23:mrHvQq6DVBvLpLppxAPXwPvXdLJyesId70hD6qm+c3Bom6uj5q
 KTdZsguyMc5Ax6ZJhCo6HiBEDjexLhHPdOiOF7AV7IZmbbUQWTQb1K3M/L3yDgFyri9uRUyK
 tsN5RlBMaYNykesS+D2mmF+xJK+qjhzEhu7t2uq0tQcQ==
X-Talos-CUID: =?us-ascii?q?9a23=3AZqoZomv6HfYuPI76n1gcqVc36ItmXibBk2/cKHS?=
 =?us-ascii?q?BIkhQC5SOW1+w3Id7xp8=3D?=
X-Talos-MUID: 9a23:wZea+gTBag9QGrBCRXTApCBFb/x64Z+DAVg3vZw+gtCNDTJZbmI=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,303,1728950400"; 
   d="scan'208";a="410607160"
Received: from rcdn-l-core-08.cisco.com ([173.37.255.145])
  by alln-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 10 Jan 2025 09:17:10 +0000
Received: from fedora.cisco.com (unknown [10.188.32.212])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-08.cisco.com (Postfix) with ESMTPSA id D9E3A180001E8;
	Fri, 10 Jan 2025 09:17:08 +0000 (GMT)
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
	Dan Carpenter <dan.carpenter@linaro.org>,
	Karan Tilak Kumar <kartilak@cisco.com>
Subject: [PATCH] scsi: fnic: Remove always-true IS_FNIC_FCP_INITIATOR macro
Date: Fri, 10 Jan 2025 01:16:55 -0800
Message-ID: <20250110091655.17643-1-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.188.32.212, [10.188.32.212]
X-Outbound-Node: rcdn-l-core-08.cisco.com

From: Arun Easi <aeasi@cisco.com>

IS_FNIC_FCP_INITIATOR macro is not applicable at this time.
Delete the macro.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
 drivers/scsi/fnic/fdls_disc.c | 85 ++++++++++++++---------------------
 drivers/scsi/fnic/fnic.h      |  2 -
 drivers/scsi/fnic/fnic_main.c | 14 +++---
 3 files changed, 39 insertions(+), 62 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 2534af2fff53..721e0643abe2 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -1242,31 +1242,29 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		tport->timer_pending = 0;
 	}
 
-	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		fnic_rport_exch_reset(iport->fnic, tport->fcid);
-		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+	fnic_rport_exch_reset(iport->fnic, tport->fcid);
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
 
-		if (tport->flags & FNIC_FDLS_SCSI_REGISTERED) {
-			tport_del_evt =
-				kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
-			if (!tport_del_evt) {
-				FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					 "Failed to allocate memory for tport fcid: 0x%0x\n",
-					 tport->fcid);
-				return false;
-			}
-			tport_del_evt->event = TGT_EV_RPORT_DEL;
-			tport_del_evt->arg1 = (void *) tport;
-			list_add_tail(&tport_del_evt->links, &fnic->tport_event_list);
-			queue_work(fnic_event_queue, &fnic->tport_work);
-		} else {
+	if (tport->flags & FNIC_FDLS_SCSI_REGISTERED) {
+		tport_del_evt =
+			kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
+		if (!tport_del_evt) {
 			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-				 "tport 0x%x not reg with scsi_transport. Freeing locally",
+				 "Failed to allocate memory for tport fcid: 0x%0x\n",
 				 tport->fcid);
-			list_del(&tport->links);
-			kfree(tport);
+			return false;
 		}
+		tport_del_evt->event = TGT_EV_RPORT_DEL;
+		tport_del_evt->arg1 = (void *) tport;
+		list_add_tail(&tport_del_evt->links, &fnic->tport_event_list);
+		queue_work(fnic_event_queue, &fnic->tport_work);
+	} else {
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+			 "tport 0x%x not reg with scsi_transport. Freeing locally",
+			 tport->fcid);
+		list_del(&tport->links);
+		kfree(tport);
 	}
 	return true;
 }
@@ -1388,8 +1386,7 @@ static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
 		 "0x%x: FDLS send RFT with oxid: 0x%x", iport->fcid,
 		 oxid);
 
-	if (IS_FNIC_FCP_INITIATOR(fnic))
-		prft_id->rft_id.fr_fts.ff_type_map[0] =
+	prft_id->rft_id.fr_fts.ff_type_map[0] =
 	    cpu_to_be32(1 << FC_TYPE_FCP);
 
 	prft_id->rft_id.fr_fts.ff_type_map[1] =
@@ -1451,12 +1448,7 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 		 "0x%x: FDLS send RFF with oxid: 0x%x", iport->fcid,
 		 oxid);
 
-	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		prff_id->rff_id.fr_type = FC_TYPE_FCP;
-	} else {
-		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-					 "0x%x: Unknown type", iport->fcid);
-	}
+	prff_id->rff_id.fr_type = FC_TYPE_FCP;
 
 	fnic_send_fcoe_frame(iport, frame, frame_size);
 
@@ -2333,9 +2325,6 @@ static void fdls_send_delete_tport_msg(struct fnic_tport_s *tport)
 	struct fnic *fnic = iport->fnic;
 	struct fnic_tport_event_s *tport_del_evt;
 
-	if (!IS_FNIC_FCP_INITIATOR(fnic))
-		return;
-
 	tport_del_evt = kzalloc(sizeof(struct fnic_tport_event_s), GFP_ATOMIC);
 	if (!tport_del_evt) {
 		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
@@ -3489,11 +3478,9 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 					 "From fabric: R_A_TOV: %d E_D_TOV: %d",
 					 iport->r_a_tov, iport->e_d_tov);
 
-		if (IS_FNIC_FCP_INITIATOR(fnic)) {
-			fc_host_fabric_name(iport->fnic->host) =
-			get_unaligned_be64(&FNIC_LOGI_NODE_NAME(flogi_rsp->els));
-			fc_host_port_id(iport->fnic->host) = iport->fcid;
-		}
+		fc_host_fabric_name(iport->fnic->host) =
+		get_unaligned_be64(&FNIC_LOGI_NODE_NAME(flogi_rsp->els));
+		fc_host_port_id(iport->fnic->host) = iport->fcid;
 
 		fnic_fdls_learn_fcoe_macs(iport, rx_frame, fcid);
 
@@ -4531,11 +4518,9 @@ void fnic_fdls_disc_start(struct fnic_iport_s *iport)
 {
 	struct fnic *fnic = iport->fnic;
 
-	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		fc_host_fabric_name(iport->fnic->host) = 0;
-		fc_host_post_event(iport->fnic->host, fc_get_event_number(),
-						   FCH_EVT_LIPRESET, 0);
-	}
+	fc_host_fabric_name(iport->fnic->host) = 0;
+	fc_host_post_event(iport->fnic->host, fc_get_event_number(),
+					   FCH_EVT_LIPRESET, 0);
 
 	if (!iport->usefip) {
 		if (iport->flags & FNIC_FIRST_LINK_UP) {
@@ -4998,15 +4983,13 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 	fdls_set_state((&iport->fabric), FDLS_STATE_LINKDOWN);
 	iport->fabric.flags = 0;
 
-	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-		fnic_scsi_fcpio_reset(iport->fnic);
-		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
-		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
-			FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
-						 "removing rport: 0x%x", tport->fcid);
-			fdls_delete_tport(iport, tport);
-		}
+	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+	fnic_scsi_fcpio_reset(iport->fnic);
+	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->host, fnic->fnic_num,
+					 "removing rport: 0x%x", tport->fcid);
+		fdls_delete_tport(iport, tport);
 	}
 
 	if ((fnic_fdmi_support == 1) && (iport->fabric.fdmi_pending > 0)) {
diff --git a/drivers/scsi/fnic/fnic.h b/drivers/scsi/fnic/fnic.h
index 0feea9557934..6c5f6046b1f5 100644
--- a/drivers/scsi/fnic/fnic.h
+++ b/drivers/scsi/fnic/fnic.h
@@ -80,8 +80,6 @@
 #define FNIC_DEV_RST_TERM_DONE          BIT(20)
 #define FNIC_DEV_RST_ABTS_PENDING       BIT(21)
 
-#define IS_FNIC_FCP_INITIATOR(fnic) (fnic->role == FNIC_ROLE_FCP_INITIATOR)
-
 #define FNIC_FW_RESET_TIMEOUT        60000	/* mSec   */
 #define FNIC_FCOE_MAX_CMD_LEN        16
 /* Retry supported by rport (returned by PRLI service parameters) */
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 127aabedd90c..b5dca8e7e2e4 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1031,7 +1031,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE));
 
-	if (IS_FNIC_FCP_INITIATOR(fnic) && fnic_scsi_drv_init(fnic))
+	if (fnic_scsi_drv_init(fnic))
 		goto err_out_scsi_drv_init;
 
 	err = fnic_stats_debugfs_init(fnic);
@@ -1075,8 +1075,7 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_fnic_alloc_vnic_res:
 	fnic_clear_intr_mode(fnic);
 err_out_fnic_set_intr_mode:
-	if (IS_FNIC_FCP_INITIATOR(fnic))
-		scsi_host_put(fnic->host);
+	scsi_host_put(fnic->host);
 err_out_fnic_role:
 err_out_scsi_host_alloc:
 err_out_fnic_get_config:
@@ -1125,8 +1124,7 @@ static void fnic_remove(struct pci_dev *pdev)
 	 */
 	flush_workqueue(fnic_event_queue);
 
-	if (IS_FNIC_FCP_INITIATOR(fnic))
-		fnic_scsi_unload(fnic);
+	fnic_scsi_unload(fnic);
 
 	if (vnic_dev_get_intr_mode(fnic->vdev) == VNIC_DEV_INTR_MODE_MSI)
 		del_timer_sync(&fnic->notify_timer);
@@ -1171,10 +1169,8 @@ static void fnic_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	ida_free(&fnic_ida, fnic->fnic_num);
-	if (IS_FNIC_FCP_INITIATOR(fnic)) {
-		fnic_scsi_unload_cleanup(fnic);
-		scsi_host_put(fnic->host);
-	}
+	fnic_scsi_unload_cleanup(fnic);
+	scsi_host_put(fnic->host);
 	kfree(fnic);
 }
 
-- 
2.47.1

