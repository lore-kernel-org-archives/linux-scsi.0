Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9FD388873;
	Thu, 21 May 2026 18:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779386842; cv=none; b=rQ7Wpk8q6UrBQSe/el/GS6Pvmed+780CdXZS7RmJQk5NKHHEw09v798AngFU69LriKxBg0jzja91QOktCEn5KWirxvNgPYrlm0/cSKjESUveq+l1QeO7bPcTf9HJ6vF1zoQi1QRswfbYOWcFgW3oiJIbKjnl5lNyo4bSk6XVX+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779386842; c=relaxed/simple;
	bh=fdG4a7T/836Jb2VwSu4X2QHFDc2vgH5WVh7hP3FJOW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UzKhOn5RRAf+X0njcT9/5WuFsB151VY0qng1DMpDH1cHTuZzUvT0MlXYjtOIVuyfX3I/AulCXxR1drnadrTIQ7N/vY3pz+1Hpqm5ObA9KFNxz5Zw9UdnFyrJg71pAEcxNIMrDcjK59TCfDlvqquTDmBqZyRxBwwTR5KV5fnM06I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=PRhPu9zt; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="PRhPu9zt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=20449; q=dns/txt;
  s=iport01; t=1779386840; x=1780596440;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ccimlN9pnB6TyfJNAvioj9+63QVlxlBZe9ZHyymXCCo=;
  b=PRhPu9ztPhzf/6Hw1qYJvr46lKUNPqMb+2HbhB/2jxyLJGKmq9MFes+M
   9skKBrEMZgmsyaFudd7qCAZQXkm2brFX6kHgdLsv577+X4Nkgy9vXXHNI
   6/PVMSapl0CDVShB8fvkHfeSE6JnN2wQ6Esdf+LumBK8p5+LCKNYOFoAJ
   QAvvA6XKv/MJ1ylzntdihVA3xVcVF9/mmGvhtT3FMTB9PkGrj3tWX1Tft
   KCe0+fsubYKQMAMb/nZZBEn2bwf5EIBgFXEvy/QCr3k43sbQOjlQtq070
   uLPD/g1F50AxHyY8EWJHisgQq7UTbRha+07xbIt9/LGo0xSKGNRUdDYG6
   A==;
X-CSE-ConnectionGUID: rApbEXiHRLyfvizzFv81Mw==
X-CSE-MsgGUID: Z+UJwJhUTHWDuRJBlc+Nsw==
X-IPAS-Result: =?us-ascii?q?A0BDAgCkSA9q/5L/Ja1aHgEBCxIMggULghg/gVBDGTCUK?=
 =?us-ascii?q?oIhgRadCBSBaw8BAQEPUQQBAYUGAo0yAiY0CQ4BAgQDAgMBAQEBAQEBAQEBA?=
 =?us-ascii?q?QsBAQUBAQECAQcFgQ4ThlyGWwIBAycLAUYQUVYZgipYgnQDtCiBeTOBAd5Bg?=
 =?us-ascii?q?WQBCxQBgTiNXHSEeycVBoFJRIEVgnIHb4FSgkkPhl0Egy6FNoEAiGZIgR4DW?=
 =?us-ascii?q?SwBVRMNCgsHBYFmAzUSKhVuMh2BIz4XgQsbBwWBS4E3cmqBBIRXeCMsA06BL?=
 =?us-ascii?q?YFrAwsYDUgRLDcUGwQ+bgeKeRwPgjEBSToLgS1iGQEWHgs6knQKkAyCIaEOh?=
 =?us-ascii?q?CaOd5JhGjOEBKZmmQWkCIU4gWg8gVkzGggbFTuCZ1MZD44tFsseJzI9AgcCB?=
 =?us-ascii?q?w4DC5FpgXwBAQ?=
IronPort-Data: A9a23:UTwrO6zkomPffyUuGaF6t+e8xyrEfRIJ4+MujC+fZmUNrF6WrkVRz
 2FMWmGAP66LazSjet8jaY6y8BsP7MTRztFqSQpr+1hgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/VH1buSJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 4+aT/H3Ygf/hWYpaDtMt8pvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJFsfJYc1yudXO0Vf+
 +IZOiIjcEDaov3jldpXSsE07igiBNPgMIVavjRryivUSK53B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cPXWjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZCxYIaLJYXSHZs9ckCwl
 CH73XvbAiwmFOOz1ACn2HanxcnUgnauMG4VPPjinhJwu3WTz3YeIB4bT122pb++kEHWc95WL
 Qof8zA2oK4u+VaDStj7Vge/5nmesXY0WddSGcU+6QeQ2uzV6QPfDW8BJhZEYcY6tclwXTE22
 0WSktXBAiZmu7mYD3ma89+8pD+7Oi8NKnIqfyIITQIZpdLkpekbjBfCSNtsEK+dlND5GTjsh
 TuNqUAWnbgNgNQQ/7+28VDOn3SnoZ2hZgo5+wPcV2SN9R5iaciuYInAwVza6+tQaYWUVF+Mu
 FAalMWEquMDF5eAkGqKWuplNLWo4euVdSbXml9HAZYs7XKu9mSlcIQW5ytxTHqFKe4ecjPvJ
 UuWsgRL6doLbT2hbLR8ZMS6DMFCIbXcKOkJn8v8NrJmCqWdvifelM2yTSZ8B1zQrXU=
IronPort-HdrOrdr: A9a23:ik+wAa4P9QeVJfO9TgPXwALXdLJyesId70hD6qm+c3Bom6uj5q
 STdZsguyMc5Ax6ZJhko6HiBEDiewK4yXcW2+gs1N6ZNWGMhILrFvAB0WKI+VLd8kPFm9J15O
 NJb7V+BNrsDVJzkMr2pDWjH81I+qjhzEnRv4fj5kYoax12YKd96Ao8IAOaHkpqADRiP/MCZf
 yhDg4tnUvZRZzRBf7Lf0U4Yw==
X-Talos-CUID: =?us-ascii?q?9a23=3AXKRDaGnni26opDF5y2XVVxUq2oDXOWf01H39E06?=
 =?us-ascii?q?YM0J4RqOUW02+5vM9ttU7zg=3D=3D?=
X-Talos-MUID: 9a23:qXC2CAU/84UxHQ7q/A2vuRN9FsdV34SRJF03s78CsIqiLjMlbg==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.24,160,1774310400"; 
   d="scan'208";a="484671006"
Received: from rcdn-l-core-09.cisco.com ([173.37.255.146])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 May 2026 18:07:14 +0000
Received: from fedora.lan?044cisco.com (unknown [10.188.18.181])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-09.cisco.com (Postfix) with ESMTPSA id DABE718000236;
	Thu, 21 May 2026 18:07:12 +0000 (GMT)
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
	adakopou@redhat.com,
	lduncan@suse.com,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Hannes Reinecke <hare@kernel.org>
Subject: [PATCH 05/13] scsi: fnic: Add FDLS role handling for NVMe initiators
Date: Thu, 21 May 2026 11:04:50 -0700
Message-ID: <20260521180458.5448-6-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20260521180458.5448-1-kartilak@cisco.com>
References: <20260521180458.5448-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.188.18.181];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.188.18.181, [10.188.18.181]
X-Outbound-Node: rcdn-l-core-09.cisco.com

Modify FDLS registration and discovery flows to use NVMe FC-4 type,
features, PRLI service parameters, and FDMI attributes when the adapter
runs as an NVMe initiator.

Limit SCSI host setup, teardown, rport reset, and FC host notifications to
FCP initiators while keeping target-port events available to both FCP and
NVMe roles.

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Reviewed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Reviewed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Reviewed-by: Arun Easi <aeasi@cisco.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
Co-developed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/fnic/fcpio.h     |  23 +++++
 drivers/scsi/fnic/fdls_disc.c | 159 +++++++++++++++++++++++-----------
 drivers/scsi/fnic/fdls_fc.h   |   1 +
 drivers/scsi/fnic/fnic_fcs.c  |  26 +++---
 drivers/scsi/fnic/fnic_fdls.h |  19 ++--
 drivers/scsi/fnic/fnic_main.c |  23 +++--
 drivers/scsi/fnic/fnic_scsi.c |   3 +-
 7 files changed, 176 insertions(+), 78 deletions(-)

diff --git a/drivers/scsi/fnic/fcpio.h b/drivers/scsi/fnic/fcpio.h
index 54a0b2ba8f6f..46eb442a47cb 100644
--- a/drivers/scsi/fnic/fcpio.h
+++ b/drivers/scsi/fnic/fcpio.h
@@ -33,6 +33,9 @@ enum fcpio_type {
 	FCPIO_ICMND_CMPL,
 	FCPIO_ITMF,
 	FCPIO_ITMF_CMPL,
+	FCPIO_NVME_CMD,
+	FCPIO_NVME_ERSP_HW_CMPL,
+	FCPIO_NVME_ERSP_FW_CMPL,
 
 	/*
 	 * Target request types
@@ -179,10 +182,22 @@ fcpio_header_dec(struct fcpio_header *hdr,
 	*tag = hdr->tag;
 }
 
+#define NVME_CMD_SZ 96
 #define CDB_16      16
 #define CDB_32      32
 #define LUN_ADDRESS 8
 
+struct fcpio_nvme_cmnd {
+	uint8_t d_id[3];
+	u_int8_t flags;		/* command flags */
+	u_int32_t sgl_cnt;	/* scatter-gather list count */
+	u_int64_t sgl_addr;	/* scatter-gather list addr */
+	u_int16_t cmd_len;
+	u_int16_t _resvd1;	/* reserved: should be 0 */
+	u_int32_t data_len;	/* length of data expected */
+	u_int8_t nvme_cmnd[NVME_CMD_SZ];	/* NVME command */
+};
+
 /*
  * fcpio_icmnd_16: host -> firmware request
  *
@@ -458,6 +473,7 @@ struct fcpio_host_req {
 		/*
 		 * Initiator host requests
 		 */
+		struct fcpio_nvme_cmnd              nvcmnd;
 		struct fcpio_icmnd_16               icmnd_16;
 		struct fcpio_icmnd_32               icmnd_32;
 		struct fcpio_itmf                   itmf;
@@ -482,6 +498,12 @@ struct fcpio_host_req {
 	} u;
 };
 
+struct fcpio_nvme_cmpl {
+	uint8_t resp_size;
+	uint8_t resvd[3];
+	uint8_t resp_bytes[32];
+};
+
 /*
  * fcpio_icmnd_cmpl: firmware -> host response
  *
@@ -682,6 +704,7 @@ struct fcpio_fw_req {
 		 * Initiator firmware responses
 		 */
 		struct fcpio_icmnd_cmpl         icmnd_cmpl;
+		struct fcpio_nvme_cmpl          nvme_cmpl;
 		struct fcpio_itmf_cmpl          itmf_cmpl;
 
 		/*
diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 48b37748f44a..9ecbb967be2e 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -13,6 +13,10 @@
 #include <linux/utsname.h>
 
 #define FC_FC4_TYPE_SCSI 0x08
+#define FNIC_NVME_FEAT_TARG (1 << 0)
+#define FNIC_NVME_FEAT_INIT (1 << 1)
+#define FNIC_NVME_FEAT_DISC (1 << 2)
+
 #define PORT_SPEED_BIT_8 8
 #define PORT_SPEED_BIT_9 9
 #define PORT_SPEED_BIT_14 14
@@ -562,6 +566,22 @@ static void fdls_init_fabric_abts_frame(uint8_t *frame,
 	};
 }
 
+static void fdls_set_frame_type(struct fnic *fnic, uint8_t *frame_type)
+{
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		*frame_type = FC_TYPE_FCP;
+	else if (IS_FNIC_NVME_INITIATOR(fnic))
+		*frame_type = FC_TYPE_NVME;
+}
+
+static void fdls_set_feature_type(struct fnic *fnic, uint8_t *feature_type)
+{
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		*feature_type = FCP_FEAT_INIT;
+	else if (IS_FNIC_NVME_INITIATOR(fnic))
+		*feature_type = FNIC_NVME_FEAT_INIT;
+}
+
 static void
 fdls_send_rscn_resp(struct fnic_iport_s *iport,
 		    struct fc_frame_header *rscn_fchdr)
@@ -1137,10 +1157,10 @@ static void fdls_send_gpn_ft(struct fnic_iport_s *iport, int fdls_state)
 		      .fh_rx_id = cpu_to_be16(FNIC_UNASSIGNED_RXID)},
 		.fc_std_ct_hdr = {.ct_rev = FC_CT_REV, .ct_fs_type = FC_FST_DIR,
 			      .ct_fs_subtype = FC_NS_SUBTYPE,
-			      .ct_cmd = cpu_to_be16(FC_NS_GPN_FT)},
-		.gpn_ft.fn_fc4_type = 0x08
+			      .ct_cmd = cpu_to_be16(FC_NS_GPN_FT)}
 	};
 
+	fdls_set_frame_type(fnic, &pgpn_ft->gpn_ft.fn_fc4_type);
 	hton24(fcid, iport->fcid);
 	FNIC_STD_SET_S_ID(pgpn_ft->fchdr, fcid);
 
@@ -1264,11 +1284,14 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		tport->timer_pending = 0;
 	}
 
-	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-	fnic_rport_exch_reset(iport->fnic, tport->fcid);
-	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		fnic_rport_exch_reset(iport->fnic, tport->fcid);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+	}
 
-	if (tport->flags & FNIC_FDLS_SCSI_REGISTERED) {
+	if ((tport->flags & FNIC_FDLS_SCSI_REGISTERED) ||
+	    (tport->flags & FNIC_FDLS_NVME_REGISTERED)) {
 		tport_del_evt =
 			kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
 		if (!tport_del_evt) {
@@ -1288,6 +1311,7 @@ bool fdls_delete_tport(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		list_del(&tport->links);
 		kfree(tport);
 	}
+
 	return true;
 }
 
@@ -1404,12 +1428,16 @@ static void fdls_send_register_fc4_types(struct fnic_iport_s *iport)
 	}
 	FNIC_STD_SET_OX_ID(prft_id->fchdr, oxid);
 
+	if (IS_FNIC_NVME_INITIATOR(fnic))
+		prft_id->rft_id.fr_fts.ff_type_map[FC_TYPE_NVME / FC_NS_BPW] =
+			cpu_to_be32(1 << (FC_TYPE_NVME % FC_NS_BPW));
+	else if (IS_FNIC_FCP_INITIATOR(fnic))
+		prft_id->rft_id.fr_fts.ff_type_map[FC_TYPE_FCP / FC_NS_BPW] =
+			cpu_to_be32(1 << (FC_TYPE_FCP % FC_NS_BPW));
 
-	prft_id->rft_id.fr_fts.ff_type_map[0] =
-	    cpu_to_be32(1 << FC_TYPE_FCP);
+	prft_id->rft_id.fr_fts.ff_type_map[FC_TYPE_CT / FC_NS_BPW] |=
+		cpu_to_be32(1 << (FC_TYPE_CT % FC_NS_BPW));
 
-	prft_id->rft_id.fr_fts.ff_type_map[1] =
-	cpu_to_be32(1 << (FC_TYPE_CT % FC_NS_BPW));
 	FNIC_FCS_DBG(KERN_INFO, fnic,
 		     "0x%x: FDLS send RFT 0x%08x 0x%08x 0x%08x with oxid: 0x%x",
 		     iport->fcid, prft_id->rft_id.fr_fts.ff_type_map[0],
@@ -1449,10 +1477,11 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 		.fc_std_ct_hdr = {.ct_rev = FC_CT_REV, .ct_fs_type = FC_FST_DIR,
 			      .ct_fs_subtype = FC_NS_SUBTYPE,
 			      .ct_cmd = cpu_to_be16(FC_NS_RFF_ID)},
-		.rff_id.fr_feat = 0x2,
-		.rff_id.fr_type = FC_TYPE_FCP
 	};
 
+	fdls_set_frame_type(fnic, &prff_id->rff_id.fr_type);
+	fdls_set_feature_type(fnic, &prff_id->rff_id.fr_feat);
+
 	hton24(fcid, iport->fcid);
 	FNIC_STD_SET_S_ID(prff_id->fchdr, fcid);
 	FNIC_STD_SET_PORT_ID(prff_id->rff_id, fcid);
@@ -1469,8 +1498,6 @@ static void fdls_send_register_fc4_features(struct fnic_iport_s *iport)
 	}
 	FNIC_STD_SET_OX_ID(prff_id->fchdr, oxid);
 
-	prff_id->rff_id.fr_type = FC_TYPE_FCP;
-
 	FNIC_FCS_DBG(KERN_INFO, fnic,
 		"0x%x: FDLS send RFF with oxid: 0x%x type 0%x feat 0%x",
 		iport->fcid, oxid, prff_id->rff_id.fr_type,
@@ -1508,13 +1535,20 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 		.fchdr = {.fh_r_ctl = FC_RCTL_ELS_REQ, .fh_type = FC_TYPE_ELS,
 			  .fh_f_ctl = {FNIC_ELS_REQ_FCTL, 0, 0},
 			  .fh_rx_id = cpu_to_be16(FNIC_UNASSIGNED_RXID)},
-		.els_prli = {.prli_cmd = ELS_PRLI,
-			     .prli_spp_len = 16,
-			     .prli_len = cpu_to_be16(0x14)},
-		.sp = {.spp_type = 0x08, .spp_flags = 0x0020,
-		       .spp_params = cpu_to_be32(0xA2)}
+		.els_prli = {.prli_cmd = ELS_PRLI},
+		.sp = {.spp_params = cpu_to_be32(iport->service_params)}
 	};
 
+	fdls_set_frame_type(fnic, &pprli->sp.spp_type);
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		pprli->els_prli.prli_spp_len = 16;
+		pprli->els_prli.prli_len = cpu_to_be16(0x14);
+		pprli->sp.spp_flags = FC_SPP_EST_IMG_PAIR;
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		pprli->els_prli.prli_spp_len = 20;
+		pprli->els_prli.prli_len = cpu_to_be16(0x18);
+	}
+
 	oxid = fdls_alloc_oxid(iport, FNIC_FRAME_TYPE_TGT_PRLI, &tport->active_oxid);
 	if (oxid == FNIC_UNASSIGNED_OXID) {
 		FNIC_FCS_DBG(KERN_ERR, fnic,
@@ -2067,7 +2101,10 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	put_unaligned_be64(iport->wwnn, data);
 
 	memset(data, 0, FNIC_FDMI_FC4_LEN);
-	data[2] = 1;
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		data[2] = 1;
+	else if (IS_FNIC_NVME_INITIATOR(fnic))
+		data[6] = 1;
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_FC4_TYPES,
 		FNIC_FDMI_FC4_LEN, data, &attr_off_bytes);
 
@@ -2096,9 +2133,11 @@ static void fdls_fdmi_register_pa(struct fnic_iport_s *iport)
 	FNIC_FCS_DBG(KERN_INFO, fnic,
 			"OS name set <%s>, off=%d", data, attr_off_bytes);
 
-	sprintf(fc_host_system_hostname(fnic->host), "%s", utsname()->nodename);
-	strscpy_pad(data, fc_host_system_hostname(fnic->host),
-					FNIC_FDMI_HN_LEN);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		sprintf(fc_host_system_hostname(fnic->host), "%s",
+			utsname()->nodename);
+
+	strscpy_pad(data, utsname()->nodename, FNIC_FDMI_HN_LEN);
 	fnic_fdmi_attr_set(fdmi_attr, FNIC_FDMI_TYPE_HOST_NAME,
 		FNIC_FDMI_HN_LEN, data, &attr_off_bytes);
 
@@ -2796,7 +2835,8 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "PRLI accepted from target: 0x%x", tgt_fcid);
 
-		if (prli_rsp->sp.spp_type != FC_FC4_TYPE_SCSI) {
+		if (IS_FNIC_FCP_INITIATOR(fnic) &&
+		    prli_rsp->sp.spp_type != FC_FC4_TYPE_SCSI) {
 			FNIC_FCS_DBG(KERN_INFO, fnic,
 				 "mismatched target zoned with FC SCSI initiator: 0x%x",
 				 tgt_fcid);
@@ -2852,14 +2892,22 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	tport->fcp_csp = be32_to_cpu(prli_rsp->sp.spp_params);
 	tport->retry_counter = 0;
 
-	if (tport->fcp_csp & FCP_SPPF_RETRY)
-		tport->tgt_flags |= FNIC_FC_RP_FLAGS_RETRY;
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		if (tport->fcp_csp & FCP_SPPF_RETRY)
+			tport->tgt_flags |= FNIC_FC_RP_FLAGS_RETRY;
+	} else if (IS_FNIC_NVME_INITIATOR(fnic)) {
+		if (tport->fcp_csp & FNIC_NVME_SP_SLER)
+			tport->tgt_flags |= FNIC_FC_RP_FLAGS_RETRY;
+	}
 
 	/* Check if the device plays Target Mode Function */
-	if (!(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) {
+	if ((IS_FNIC_FCP_INITIATOR(fnic) &&
+	     !(tport->fcp_csp & FCP_PRLI_FUNC_TARGET)) ||
+	    (IS_FNIC_NVME_INITIATOR(fnic) &&
+	     !(tport->fcp_csp & FCP_PRLI_FUNC_TARGET))) {
 		FNIC_FCS_DBG(KERN_INFO, fnic,
-			 "Remote port(0x%x): no target support. Deleting it\n",
-			 tgt_fcid);
+				 "Remote port(0x%x): no target support. Deleting it\n",
+				 tgt_fcid);
 		fdls_tgt_logout(iport, tport);
 		fdls_delete_tport(iport, tport);
 		return;
@@ -2868,20 +2916,23 @@ fdls_process_tgt_prli_rsp(struct fnic_iport_s *iport,
 	fdls_set_tport_state(tport, FDLS_TGT_STATE_READY);
 
 	/* Inform the driver about new target added */
-	tport_add_evt = kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
-	if (!tport_add_evt) {
-		FNIC_FCS_DBG(KERN_INFO, fnic,
+	if (IS_FNIC_FCP_INITIATOR(fnic) ||
+	    IS_FNIC_NVME_INITIATOR(fnic)) {
+		tport_add_evt = kzalloc_obj(struct fnic_tport_event_s, GFP_ATOMIC);
+		if (!tport_add_evt) {
+			FNIC_FCS_DBG(KERN_INFO, fnic,
 				     "iport fcid: 0x%x tport event memory allocation failure: 0x%0x\n",
 				     iport->fcid, tport->fcid);
-		return;
-	}
-	tport_add_evt->event = TGT_EV_RPORT_ADD;
-	tport_add_evt->arg1 = (void *) tport;
+			return;
+		}
+		tport_add_evt->event = TGT_EV_RPORT_ADD;
+		tport_add_evt->arg1 = (void *)tport;
 		FNIC_FCS_DBG(KERN_INFO, fnic,
 			     "iport fcid: 0x%x add tport event fcid: 0x%x\n",
 			     tport->fcid, iport->fcid);
-	list_add_tail(&tport_add_evt->links, &fnic->tport_event_list);
-	queue_work(fnic_event_queue, &fnic->tport_work);
+		list_add_tail(&tport_add_evt->links, &fnic->tport_event_list);
+		queue_work(fnic_event_queue, &fnic->tport_work);
+	}
 }
 
 
@@ -3530,9 +3581,11 @@ fdls_process_flogi_rsp(struct fnic_iport_s *iport,
 					 "From fabric: R_A_TOV: %d E_D_TOV: %d",
 					 iport->r_a_tov, iport->e_d_tov);
 
-		fc_host_fabric_name(iport->fnic->host) =
-		get_unaligned_be64(&FNIC_LOGI_NODE_NAME(flogi_rsp->els));
-		fc_host_port_id(iport->fnic->host) = iport->fcid;
+		if (IS_FNIC_FCP_INITIATOR(fnic)) {
+			fc_host_fabric_name(iport->fnic->host) =
+					get_unaligned_be64(&FNIC_LOGI_NODE_NAME(flogi_rsp->els));
+			fc_host_port_id(iport->fnic->host) = iport->fcid;
+		}
 
 		fnic_fdls_learn_fcoe_macs(iport, rx_frame, fcid);
 
@@ -4622,9 +4675,11 @@ void fnic_fdls_disc_start(struct fnic_iport_s *iport)
 {
 	struct fnic *fnic = iport->fnic;
 
-	fc_host_fabric_name(iport->fnic->host) = 0;
-	fc_host_post_event(iport->fnic->host, fc_get_event_number(),
-					   FCH_EVT_LIPRESET, 0);
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		fc_host_fabric_name(iport->fnic->host) = 0;
+		fc_host_post_event(iport->fnic->host, fc_get_event_number(),
+						FCH_EVT_LIPRESET, 0);
+	}
 
 	if (!iport->usefip) {
 		if (iport->flags & FNIC_FIRST_LINK_UP) {
@@ -5087,14 +5142,18 @@ void fnic_fdls_link_down(struct fnic_iport_s *iport)
 	fdls_set_state((&iport->fabric), FDLS_STATE_LINKDOWN);
 	iport->fabric.flags = 0;
 
-	spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
-	fnic_fcpio_reset(iport->fnic);
-	spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
-	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
-		FNIC_FCS_DBG(KERN_INFO, fnic,
+	if (IS_FNIC_FCP_INITIATOR(fnic) ||
+	    IS_FNIC_NVME_INITIATOR(fnic)) {
+		spin_unlock_irqrestore(&fnic->fnic_lock, fnic->lock_flags);
+		fnic_fcpio_reset(iport->fnic);
+		spin_lock_irqsave(&fnic->fnic_lock, fnic->lock_flags);
+		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+			FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "removing rport: 0x%x", tport->fcid);
-		fdls_delete_tport(iport, tport);
+			fdls_delete_tport(iport, tport);
+		}
 	}
+	fdls_reset_oxid_pool(iport);
 
 	if (fnic_fdmi_support == 1) {
 		if (iport->fabric.fdmi_pending > 0) {
diff --git a/drivers/scsi/fnic/fdls_fc.h b/drivers/scsi/fnic/fdls_fc.h
index e33c829545fb..a7b8b969f019 100644
--- a/drivers/scsi/fnic/fdls_fc.h
+++ b/drivers/scsi/fnic/fdls_fc.h
@@ -53,6 +53,7 @@
 
 #define FNIC_FCP_RSP_FCTL      (0x000099)
 #define FNIC_REQ_ABTS_FCTL     (0x000009)
+#define FNIC_NVME_LS_REQ_FCTL  (0x000029)
 
 #define FNIC_FC_PH_VER_HI      (0x20)
 #define FNIC_FC_PH_VER_LO      (0x20)
diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index ca592bc3f618..a67d1085d720 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -1018,7 +1018,8 @@ void fnic_delete_fcp_tports(struct fnic *fnic)
 					 "removing fcp rport fcid: 0x%x", tport->fcid);
 		fdls_set_tport_state(tport, FDLS_TGT_STATE_OFFLINING);
 		fnic_del_tport_timer_sync(fnic, tport);
-		fnic_fdls_remove_tport(&fnic->iport, tport, flags);
+		if (IS_FNIC_FCP_INITIATOR(fnic))
+			fnic_fdls_remove_tport(&fnic->iport, tport, flags);
 	}
 	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
 }
@@ -1044,8 +1045,8 @@ void fnic_tport_event_handler(struct work_struct *work)
 			FNIC_FCS_DBG(KERN_INFO, fnic,
 						 "Add rport event");
 			if (tport->state == FDLS_TGT_STATE_READY) {
-				fnic_fdls_add_tport(&fnic->iport,
-					(struct fnic_tport_s *) cur_evt->arg1, flags);
+				if (IS_FNIC_FCP_INITIATOR(fnic))
+					fnic_fdls_add_tport(&fnic->iport, tport, flags);
 			} else {
 				FNIC_FCS_DBG(KERN_INFO, fnic,
 					 "Target not ready. Add rport event dropped: 0x%x",
@@ -1056,8 +1057,8 @@ void fnic_tport_event_handler(struct work_struct *work)
 			FNIC_FCS_DBG(KERN_INFO, fnic,
 						 "Remove rport event");
 			if (tport->state == FDLS_TGT_STATE_OFFLINING) {
-				fnic_fdls_remove_tport(&fnic->iport,
-					   (struct fnic_tport_s *) cur_evt->arg1, flags);
+				if (IS_FNIC_FCP_INITIATOR(fnic))
+					fnic_fdls_remove_tport(&fnic->iport, tport, flags);
 			} else {
 				FNIC_FCS_DBG(KERN_INFO, fnic,
 							 "remove rport event dropped tport fcid: 0x%x",
@@ -1110,12 +1111,15 @@ void fnic_reset_work_handler(struct work_struct *work)
 		spin_unlock_irqrestore(&reset_fnic_list_lock,
 							   reset_fnic_list_lock_flags);
 
-		dev_err(&cur_fnic->pdev->dev, "fnic: <%d>: issuing a host reset\n",
-			   cur_fnic->fnic_num);
-		host_reset_ret_code = fnic_host_reset(cur_fnic->host);
-		dev_err(&cur_fnic->pdev->dev,
-		   "fnic: <%d>: returned from host reset with status: %d\n",
-		   cur_fnic->fnic_num, host_reset_ret_code);
+		if (IS_FNIC_FCP_INITIATOR(cur_fnic)) {
+			dev_err(&cur_fnic->pdev->dev,
+				"fnic: <%d>: issuing a host reset\n",
+				cur_fnic->fnic_num);
+			host_reset_ret_code = fnic_host_reset(cur_fnic->host);
+			dev_err(&cur_fnic->pdev->dev,
+				"fnic: <%d>: returned from host reset with status: %d\n",
+				cur_fnic->fnic_num, host_reset_ret_code);
+		}
 
 		spin_lock_irqsave(&cur_fnic->fnic_lock, cur_fnic->lock_flags);
 		cur_fnic->pc_rscn_handling_status =
diff --git a/drivers/scsi/fnic/fnic_fdls.h b/drivers/scsi/fnic/fnic_fdls.h
index e2959120c4f9..ff1e3bd0e39f 100644
--- a/drivers/scsi/fnic/fnic_fdls.h
+++ b/drivers/scsi/fnic/fnic_fdls.h
@@ -78,14 +78,17 @@
 #define FNIC_FDLS_FPMA_LEARNT             0x2
 
 /* tport flags */
-#define FNIC_FDLS_TPORT_IN_GPN_FT_LIST 0x1
-#define FNIC_FDLS_TGT_ABORT_ISSUED     0x2
-#define FNIC_FDLS_TPORT_SEND_ADISC     0x4
-#define FNIC_FDLS_RETRY_FRAME          0x8
-#define FNIC_FDLS_TPORT_BUSY	       0x10
-#define FNIC_FDLS_TPORT_TERMINATING      0x20
-#define FNIC_FDLS_TPORT_DELETED        0x40
-#define FNIC_FDLS_SCSI_REGISTERED      0x200
+#define FNIC_FDLS_TPORT_IN_GPN_FT_LIST        0x1
+#define FNIC_FDLS_TGT_ABORT_ISSUED            0x2
+#define FNIC_FDLS_TPORT_SEND_ADISC            0x4
+#define FNIC_FDLS_RETRY_FRAME                 0x8
+#define FNIC_FDLS_TPORT_BUSY                  0x10
+#define FNIC_FDLS_TPORT_TERMINATING           0x20
+#define FNIC_FDLS_TPORT_DELETED               0x40
+#define FNIC_FDLS_NVME_REGISTERED             0x80
+#define FNIC_FDLS_NVME_TPORT_CLEANUP_PENDING  0x100
+#define FNIC_FDLS_SCSI_REGISTERED             0x200
+#define FNIC_TPORT_CAN_BE_FREED               0x400
 
 /* Retry supported by rport(returned by prli service parameters) */
 #define FDLS_FC_RP_FLAGS_RETRY 0x1
diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
index 5850d51b0e8f..0d7828be244d 100644
--- a/drivers/scsi/fnic/fnic_main.c
+++ b/drivers/scsi/fnic/fnic_main.c
@@ -1087,9 +1087,11 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	fnic_fdls_init(fnic, (fnic->config.flags & VFCF_FIP_CAPABLE));
 
-	err = fnic_scsi_drv_init(fnic);
-	if (err)
-		goto err_out_scsi_drv_init;
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		err = fnic_scsi_drv_init(fnic);
+		if (err)
+			goto err_out_scsi_drv_init;
+	}
 
 	err = fnic_stats_debugfs_init(fnic);
 	if (err) {
@@ -1109,7 +1111,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_free_stats_debugfs:
 	fnic_stats_debugfs_remove(fnic);
 	fnic_free_ioreq_tables_mq(fnic);
-	scsi_remove_host(fnic->host);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		scsi_remove_host(fnic->host);
 err_out_scsi_drv_init:
 	fnic_free_intr(fnic);
 err_out_fnic_request_intr:
@@ -1135,7 +1138,8 @@ static int fnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 err_out_fnic_alloc_vnic_res:
 	fnic_clear_intr_mode(fnic);
 err_out_fnic_set_intr_mode:
-	scsi_host_put(fnic->host);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		scsi_host_put(fnic->host);
 err_out_fnic_role:
 err_out_scsi_host_alloc:
 err_out_fnic_get_config:
@@ -1184,7 +1188,8 @@ static void fnic_remove(struct pci_dev *pdev)
 	 */
 	flush_workqueue(fnic_event_queue);
 
-	fnic_scsi_unload(fnic);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		fnic_scsi_unload(fnic);
 
 	if (vnic_dev_get_intr_mode(fnic->vdev) == VNIC_DEV_INTR_MODE_MSI)
 		timer_delete_sync(&fnic->notify_timer);
@@ -1228,8 +1233,10 @@ static void fnic_remove(struct pci_dev *pdev)
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
 	ida_free(&fnic_ida, fnic->fnic_num);
-	fnic_scsi_unload_cleanup(fnic);
-	scsi_host_put(fnic->host);
+	if (IS_FNIC_FCP_INITIATOR(fnic)) {
+		fnic_scsi_unload_cleanup(fnic);
+		scsi_host_put(fnic->host);
+	}
 	kfree(fnic);
 }
 
diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
index b92260583c67..37d1e136b7b9 100644
--- a/drivers/scsi/fnic/fnic_scsi.c
+++ b/drivers/scsi/fnic/fnic_scsi.c
@@ -732,7 +732,8 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
 	atomic64_inc(&reset_stats->fw_reset_completions);
 
 	/* Clean up all outstanding io requests */
-	fnic_cleanup_io(fnic, SCSI_NO_TAG);
+	if (IS_FNIC_FCP_INITIATOR(fnic))
+		fnic_cleanup_io(fnic, SCSI_NO_TAG);
 
 	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
 	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
-- 
2.47.1

