Received: from rcdn-iport-6.cisco.com (rcdn-iport-6.cisco.com [173.37.86.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF496259490;
	Thu, 12 Dec 2024 02:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733969206; cv=none; b=k8tOE8VekAoKW+DH0L4L8pdUvxpTU3nmvVKmrUrpHdGfO6TLCBH7LWAMRy+55X6Cl+iCFc9PJMwz/mLJn3HT0awvdRcFaBD78DCDomA0szMr2n1Vdydut8XtvYVwYFYK6LKjhxCnpl9sQXnVVktHGqOccf/NnQeaHsVXg1UasTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733969206; c=relaxed/simple;
	bh=qCOhzKAajeADGdr1+sd84QcJALlIEXGi+kMtM0FYQxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LSc4kArj+neuyUCwaj7IsoC3gBdcla1byY08TAM1L0dWreqGYT0I1KNhzcJvTkVJAVbahXFF3ZUXlt05kCPLe01BWidzonqjnM6pNXOctIuT9S1nA7mhKrqvERFOZZ31mbZrpafAz1H8yT7wjAtyJJyvoatWgrvJxElQAPPwFsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=UppES02g; arc=none smtp.client-ip=173.37.86.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="UppES02g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=25384; q=dns/txt;
  s=iport; t=1733969203; x=1735178803;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/iw27yUVPU9qWjFC11683sqsy09uUG2fqPslh9Jq+fA=;
  b=UppES02gCBKb+mOCG6J9Iot/BxdyurGP9mSzRBIxia627aYEbdseAzuN
   MCXeWfdAKW94g3Q5Nj9I5XHF+gu4HaMk70ibiTz9DrAhaspB+G+azXCdp
   c9sifJk+AVI/xmVSH+GUD6DJOMGBeclyU8rK3ZcRV2TacJsFGz/DPjSbt
   A=;
X-CSE-ConnectionGUID: BIBN42H1SOOpYN6LxSzNUQ==
X-CSE-MsgGUID: FH0xURoBTdK53xKZuMpavw==
X-IPAS-Result: =?us-ascii?q?A0BfAAAVRFpn/5T/Ja1aHQEBAQEJARIBBQUBggAHAQsBg?=
 =?us-ascii?q?kp2WUMZL5ZDgRadBRSBEQNWDwEBAQ85CwQBAYUHAoprAiY1CA4BAgQBAQEBA?=
 =?us-ascii?q?wIDAQEBAQEBAQEBAQELAQEFAQEBAgEHBYEOE4V7DYZbAgEDGg0LAUYQOQEXV?=
 =?us-ascii?q?hmDAQGCZAMRrwWBeTOBAd4zgWcGgUgBjUlwhHcnFQaBSUSBFYJyB2+BBQFMg?=
 =?us-ascii?q?ldiAoV6BIVRg0uOQI5ASIEhA1khEQFVEw0KCwcFgXUDOQwLMRWCIYE/Rj2CS?=
 =?us-ascii?q?WlJNwINAjaCJHx4gVWFGYRpYy8DAwMDgxkghiREgTcegV9AAwsYDUgRLBQjF?=
 =?us-ascii?q?BsGPm4Hm0oBRoNSCActBEoTLBeBNjAHDwEeAQqTF5ItgTSJdpVYhCSMF44Hh?=
 =?us-ascii?q?yYaM5tZjniYe44ClXJQhGaBaQE5gVkzGggbFTuCZxM/GQ+OLQsLiGy7GyUyA?=
 =?us-ascii?q?joCBwsBAQMJj1ICAiQHgU4BAQ?=
IronPort-Data: A9a23:somVAaxu85j91zW/cv96t+cRxyrEfRIJ4+MujC+fZmUNrF6WrkVRn
 zBOWD3XO/aMYDP2eY1yO46zoUJU6JDSy9VqSFRkqlhgHilAwSbn6Xt1DatR0we6dJCroJdPt
 p1GAjX4BJlqCCea/lH1b+CJQUBUjcmgXqD7BPPPJhd/TAplTDZJoR94kobVuKYw6TSCK13L4
 ImaT/H3Ygf/h2cuaztMtspvlTs21BjMkGJA1rABTagjUG/2zxE9EJ8ZLKetGHr0KqE8NvK6X
 evK0Iai9Wrf+Ro3Yvv9+losWhRXKlJ6FVHmZkt+A8BOsDAbzsAB+vpT2M4nVKtio27hc+adZ
 zl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CCe5xWuTpfi/xlhJGsXF6tEoMYuOkZp7
 c0+dhQdVQKlutvjldpXSsE07igiBNPgMIVavjRryivUSK9/B5vCWK7No9Rf2V/chOgXQq2YP
 JVfM2cyKk2cM3WjOX9PYH46tOShnGX+dzRbgFmUvqEwpWPUyWSd1ZC3YYeOI4XbFJk9ckCwi
 EKe71nDBTsmOP/CkiqmwG+JnubRgnauMG4VPPjinhJwu3WXxXQ7CRsKWF/9qv684ma8VtBVA
 0gV/Dc+66k48QqgSdyVdxixumKFuFgEVsZdCfY37imK0KPf5wvfDW8BJhZFado7pIo1SCYs2
 1uhgdzkH3psvaeTRHbb8a2bxRu2OC4IPSoZbjQFZRUK7sOlo4wpiB/LCNF5H8aIYsbdAzr8x
 XWO6SM5nbhW1JdN3KSg9leBiDWpznTUcjMICszsdjrNxmtEiESNPuRENXCzAS58Ebuk
IronPort-HdrOrdr: A9a23:pLJFl69kR4VWqrZ8Z9xuk+D3I+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINg/J
 YlW7RiCdH2EFhxhdv37U2FCdo6qeP3l5xA/d2/85+oJjsaEp2JKGxCe2CmLnE=
X-Talos-CUID: 9a23:OVBWtm/O3mPYHlyoKOGVv2Q1MOZ5KF2E91D3O36eV0J5c6+zdGbFrQ==
X-Talos-MUID: 9a23:r2Y7hwo5qQdpK2oBDU4ezx9CbNdV2aOENEwuzM4WmPuZEDR5JSjI2Q==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.12,227,1728950400"; 
   d="scan'208";a="295311994"
Received: from rcdn-l-core-11.cisco.com ([173.37.255.148])
  by rcdn-iport-6.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 12 Dec 2024 02:06:37 +0000
Received: from fedora.cisco.com (unknown [10.24.83.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-11.cisco.com (Postfix) with ESMTPSA id 20A1318000259;
	Thu, 12 Dec 2024 02:06:36 +0000 (GMT)
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
	Karan Tilak Kumar <kartilak@cisco.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v7 05/15] scsi: fnic: Add support for unsolicited requests and responses
Date: Wed, 11 Dec 2024 18:03:02 -0800
Message-ID: <20241212020312.4786-6-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241212020312.4786-1-kartilak@cisco.com>
References: <20241212020312.4786-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.83.168, [10.24.83.168]
X-Outbound-Node: rcdn-l-core-11.cisco.com

Add support for unsolicited requests and responses.
Add support to accept and reject frames.

Reported-by: kernel test robot <lkp@intel.com>
Closes:
https://lore.kernel.org/oe-kbuild-all/202409291705.MugERX98-lkp@
intel.com/

Reviewed-by: Sesidhar Baddela <sebaddel@cisco.com>
Co-developed-by: Gian Carlo Boffa <gcboffa@cisco.com>
Signed-off-by: Gian Carlo Boffa <gcboffa@cisco.com>
Co-developed-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Signed-off-by: Arulprabhu Ponnusamy <arulponn@cisco.com>
Co-developed-by: Arun Easi <aeasi@cisco.com>
Signed-off-by: Arun Easi <aeasi@cisco.com>
Co-developed-by: Karan Tilak Kumar <kartilak@cisco.com>
Signed-off-by: Karan Tilak Kumar <kartilak@cisco.com>
---
Changes between v5 and v6:
    Incorporate review comments from Martin:
        Remove GCC 13.3 warnings.
    Incorporate review comments from Hannes:
	Allocate OXID from a pool.
	Modify frame initialization.

Changes between v4 and v5:
    Incorporate review comments from Martin:
        Remove unnecessary fdls_get_tgt_oxid_pool call.
        Modify attribution appropriately.

Changes between v3 and v4:
   Fix kernel test robot warnings.

Changes between v2 and v3:
    Add fnic_std_ba_acc removed from previous patch.
    Incorporate review comments from Hannes:
        Replace redundant definitions with standard definitions.

Changes between v1 and v2:
    Incorporate review comments from Hannes:
        Replace fnic_del_tport_timer_sync macro calls with function
        calls.
        Fix indentation.
        Replace definitions with standard definitions from fc_els.h.
---
 drivers/scsi/fnic/fdls_disc.c | 683 ++++++++++++++++++++++++++++++++++
 1 file changed, 683 insertions(+)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index b2af0f6dfa1b..e08cf343bad7 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -42,6 +42,8 @@ static void fdls_tport_timer_callback(struct timer_list *t);
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void fdls_init_plogi_frame(uint8_t *frame, struct fnic_iport_s *iport);
+static void fdls_init_els_acc_frame(uint8_t *frame, struct fnic_iport_s *iport);
+static void fdls_init_els_rjt_frame(uint8_t *frame, struct fnic_iport_s *iport);
 static void fdls_init_logo_frame(uint8_t *frame, struct fnic_iport_s *iport);
 static void fdls_init_fabric_abts_frame(uint8_t *frame,
 						struct fnic_iport_s *iport);
@@ -447,6 +449,39 @@ void fdls_init_plogi_frame(uint8_t *frame,
 	FNIC_STD_SET_S_ID(pplogi->fchdr, s_id);
 }
 
+static void fdls_init_els_acc_frame(uint8_t *frame,
+		struct fnic_iport_s *iport)
+{
+	struct fc_std_els_acc_rsp *pels_acc;
+	uint8_t s_id[3];
+
+	pels_acc = (struct fc_std_els_acc_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	*pels_acc = (struct fc_std_els_acc_rsp) {
+		.fchdr = {.fh_r_ctl = FC_RCTL_ELS_REP,
+			  .fh_type = FC_TYPE_ELS, .fh_f_ctl = {FNIC_ELS_REP_FCTL, 0, 0}},
+		.acc.la_cmd = ELS_LS_ACC,
+	};
+
+	hton24(s_id, iport->fcid);
+	FNIC_STD_SET_S_ID(pels_acc->fchdr, s_id);
+	FNIC_STD_SET_RX_ID(pels_acc->fchdr, FNIC_UNASSIGNED_RXID);
+}
+
+static void fdls_init_els_rjt_frame(uint8_t *frame,
+		struct fnic_iport_s *iport)
+{
+	struct fc_std_els_rjt_rsp *pels_rjt;
+
+	pels_rjt = (struct fc_std_els_rjt_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	*pels_rjt = (struct fc_std_els_rjt_rsp) {
+		.fchdr = {.fh_r_ctl = FC_RCTL_ELS_REP, .fh_type = FC_TYPE_ELS,
+			  .fh_f_ctl = {FNIC_ELS_REP_FCTL, 0, 0}},
+		.rej.er_cmd = ELS_LS_RJT,
+	};
+
+	FNIC_STD_SET_RX_ID(pels_rjt->fchdr, FNIC_UNASSIGNED_RXID);
+}
+
 static void fdls_init_logo_frame(uint8_t *frame,
 		struct fnic_iport_s *iport)
 {
@@ -484,6 +519,73 @@ static void fdls_init_fabric_abts_frame(uint8_t *frame,
 		.fh_parm_offset = 0x00000000,	/* bit:0 = 0 Abort a exchange */
 	};
 }
+
+static void
+fdls_send_rscn_resp(struct fnic_iport_s *iport,
+		    struct fc_frame_header *rscn_fchdr)
+{
+	uint8_t *frame;
+	struct fc_std_els_acc_rsp *pels_acc;
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_els_acc_rsp);
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate frame to send RSCN response");
+		return;
+	}
+
+	pels_acc = (struct fc_std_els_acc_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_els_acc_frame(frame, iport);
+
+	FNIC_STD_SET_D_ID(pels_acc->fchdr, rscn_fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(rscn_fchdr);
+	FNIC_STD_SET_OX_ID(pels_acc->fchdr, oxid);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "0x%x: FDLS send RSCN response with oxid: 0x%x",
+		 iport->fcid, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
+static void
+fdls_send_logo_resp(struct fnic_iport_s *iport,
+		    struct fc_frame_header *req_fchdr)
+{
+	uint8_t *frame;
+	struct fc_std_els_acc_rsp *plogo_resp;
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_els_acc_rsp);
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate frame to send LOGO response");
+		return;
+	}
+
+	plogo_resp = (struct fc_std_els_acc_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_els_acc_frame(frame, iport);
+
+	FNIC_STD_SET_D_ID(plogo_resp->fchdr, req_fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(req_fchdr);
+	FNIC_STD_SET_OX_ID(plogo_resp->fchdr, oxid);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "0x%x: FDLS send LOGO response with oxid: 0x%x",
+		 iport->fcid, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
@@ -3118,6 +3220,232 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void
+fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
+{
+	uint8_t *frame;
+	struct fc_std_abts_ba_acc *pba_acc;
+	uint32_t nport_id;
+	uint16_t oxid;
+	struct fnic_tport_s *tport;
+	struct fnic *fnic = iport->fnic;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_abts_ba_acc);
+
+	nport_id = ntoh24(fchdr->fh_s_id);
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Received abort from SID 0x%8x", nport_id);
+
+	tport = fnic_find_tport_by_fcid(iport, nport_id);
+	if (tport) {
+		oxid = FNIC_STD_GET_OX_ID(fchdr);
+		if (tport->active_oxid == oxid) {
+			tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
+			fdls_free_oxid(iport, oxid, &tport->active_oxid);
+		}
+	}
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"0x%x: Failed to allocate frame to send response for ABTS req",
+				iport->fcid);
+		return;
+	}
+
+	pba_acc = (struct fc_std_abts_ba_acc *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	*pba_acc = (struct fc_std_abts_ba_acc) {
+		.fchdr = {.fh_r_ctl = FC_RCTL_BA_ACC,
+				.fh_f_ctl = {FNIC_FCP_RSP_FCTL, 0, 0}},
+		.acc = {.ba_low_seq_cnt = 0, .ba_high_seq_cnt = cpu_to_be16(0xFFFF)}
+	};
+
+	FNIC_STD_SET_S_ID(pba_acc->fchdr, fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID(pba_acc->fchdr, fchdr->fh_s_id);
+	FNIC_STD_SET_OX_ID(pba_acc->fchdr, FNIC_STD_GET_OX_ID(fchdr));
+	FNIC_STD_SET_RX_ID(pba_acc->fchdr, FNIC_STD_GET_RX_ID(fchdr));
+
+	pba_acc->acc.ba_rx_id = cpu_to_be16(FNIC_STD_GET_RX_ID(fchdr));
+	pba_acc->acc.ba_ox_id = cpu_to_be16(FNIC_STD_GET_OX_ID(fchdr));
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "0x%x: FDLS send BA ACC with oxid: 0x%x",
+		 iport->fcid, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
+static void
+fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
+				 struct fc_frame_header *fchdr)
+{
+	uint8_t *frame;
+	struct fc_std_els_rjt_rsp *pls_rsp;
+	uint16_t oxid;
+	uint32_t d_id = ntoh24(fchdr->fh_d_id);
+	struct fnic *fnic = iport->fnic;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_els_rjt_rsp);
+
+	if (iport->fcid != d_id) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping unsupported ELS with illegal frame bits 0x%x\n",
+			 d_id);
+		return;
+	}
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Dropping unsupported ELS request in iport state: %d",
+			 iport->state);
+		return;
+	}
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			"Failed to allocate frame to send response to unsupported ELS request");
+		return;
+	}
+
+	pls_rsp = (struct fc_std_els_rjt_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_els_rjt_frame(frame, iport);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: Process unsupported ELS request from SID: 0x%x",
+		     iport->fcid, ntoh24(fchdr->fh_s_id));
+
+	/* We don't support this ELS request, send a reject */
+	pls_rsp->rej.er_reason = 0x0B;
+	pls_rsp->rej.er_explan = 0x0;
+	pls_rsp->rej.er_vendor = 0x0;
+
+	FNIC_STD_SET_S_ID(pls_rsp->fchdr, fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID(pls_rsp->fchdr, fchdr->fh_s_id);
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID(pls_rsp->fchdr, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
+static void
+fdls_process_rls_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
+{
+	uint8_t *frame;
+	struct fc_std_rls_acc *prls_acc_rsp;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_rls_acc);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process RLS request %d", iport->fnic->fnic_num);
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received RLS req in iport state: %d. Dropping the frame.",
+			 iport->state);
+		return;
+	}
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate frame to send RLS accept");
+		return;
+	}
+	prls_acc_rsp = (struct fc_std_rls_acc *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+
+	FNIC_STD_SET_S_ID(prls_acc_rsp->fchdr, fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID(prls_acc_rsp->fchdr, fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID(prls_acc_rsp->fchdr, oxid);
+	FNIC_STD_SET_RX_ID(prls_acc_rsp->fchdr, FNIC_UNASSIGNED_RXID);
+
+	FNIC_STD_SET_F_CTL(prls_acc_rsp->fchdr, FNIC_ELS_REP_FCTL << 16);
+	FNIC_STD_SET_R_CTL(prls_acc_rsp->fchdr, FC_RCTL_ELS_REP);
+	FNIC_STD_SET_TYPE(prls_acc_rsp->fchdr, FC_TYPE_ELS);
+
+	prls_acc_rsp->els.rls_cmd = ELS_LS_ACC;
+	prls_acc_rsp->els.rls_lesb.lesb_link_fail =
+	    cpu_to_be32(iport->fnic->link_down_cnt);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
+static void
+fdls_process_els_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr,
+					 uint32_t len)
+{
+	uint8_t *frame;
+	struct fc_std_els_acc_rsp *pels_acc;
+	uint16_t oxid;
+	uint8_t *fc_payload;
+	uint8_t type;
+	struct fnic *fnic = iport->fnic;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET;
+
+	fc_payload = (uint8_t *) fchdr + sizeof(struct fc_frame_header);
+	type = *fc_payload;
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Dropping ELS frame type: 0x%x in iport state: %d",
+				 type, iport->state);
+		return;
+	}
+	switch (type) {
+	case ELS_ECHO:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "sending LS_ACC for ECHO request %d\n",
+					 iport->fnic->fnic_num);
+		break;
+
+	case ELS_RRQ:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "sending LS_ACC for RRQ request %d\n",
+					 iport->fnic->fnic_num);
+		break;
+
+	default:
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "sending LS_ACC for 0x%x ELS frame\n", type);
+		break;
+	}
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate frame to send ELS response for 0x%x",
+				type);
+		return;
+	}
+
+	if (type == ELS_ECHO) {
+		/* Brocade sends a longer payload, copy all frame back */
+		memcpy(frame, fchdr, len);
+	}
+
+	pels_acc = (struct fc_std_els_acc_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_els_acc_frame(frame, iport);
+
+	FNIC_STD_SET_D_ID(pels_acc->fchdr, fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID(pels_acc->fchdr, oxid);
+
+	if (type == ELS_ECHO)
+		frame_size += len;
+	else
+		frame_size += sizeof(struct fc_std_els_acc_rsp);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
 static void
 fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 			  struct fc_frame_header *fchdr)
@@ -3254,6 +3582,336 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 	}
 
 }
+
+static void
+fdls_process_plogi_req(struct fnic_iport_s *iport,
+		       struct fc_frame_header *fchdr)
+{
+	uint8_t *frame;
+	struct fc_std_els_rjt_rsp *pplogi_rsp;
+	uint16_t oxid;
+	uint32_t d_id = ntoh24(fchdr->fh_d_id);
+	struct fnic *fnic = iport->fnic;
+	uint16_t frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_els_rjt_rsp);
+
+	if (iport->fcid != d_id) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received PLOGI with illegal frame bits. Dropping frame from 0x%x",
+			 d_id);
+		return;
+	}
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received PLOGI request in iport state: %d Dropping frame",
+			 iport->state);
+		return;
+	}
+
+	frame = fdls_alloc_frame(iport);
+	if (frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			"Failed to allocate frame to send response to PLOGI request");
+		return;
+	}
+
+	pplogi_rsp = (struct fc_std_els_rjt_rsp *) (frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+	fdls_init_els_rjt_frame(frame, iport);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "0x%x: Process PLOGI request from SID: 0x%x",
+				 iport->fcid, ntoh24(fchdr->fh_s_id));
+
+	/* We don't support PLOGI request, send a reject */
+	pplogi_rsp->rej.er_reason = 0x0B;
+	pplogi_rsp->rej.er_explan = 0x0;
+	pplogi_rsp->rej.er_vendor = 0x0;
+
+	FNIC_STD_SET_S_ID(pplogi_rsp->fchdr, fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID(pplogi_rsp->fchdr, fchdr->fh_s_id);
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID(pplogi_rsp->fchdr, oxid);
+
+	fnic_send_fcoe_frame(iport, frame, frame_size);
+}
+
+static void
+fdls_process_logo_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
+{
+	struct fc_std_logo *logo = (struct fc_std_logo *)fchdr;
+	uint32_t nport_id;
+	uint64_t nport_name;
+	struct fnic_tport_s *tport;
+	struct fnic *fnic = iport->fnic;
+	uint16_t oxid;
+
+	nport_id = ntoh24(logo->els.fl_n_port_id);
+	nport_name = be64_to_cpu(logo->els.fl_n_port_wwn);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process LOGO request from fcid: 0x%x", nport_id);
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "Dropping LOGO req from 0x%x in iport state: %d",
+			 nport_id, iport->state);
+		return;
+	}
+
+	tport = fnic_find_tport_by_fcid(iport, nport_id);
+
+	if (!tport) {
+		/* We are not logged in with the nport, log and drop... */
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "Received LOGO from an nport not logged in: 0x%x(0x%llx)",
+			 nport_id, nport_name);
+		return;
+	}
+	if (tport->fcid != nport_id) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+		 "Received LOGO with invalid target port fcid: 0x%x(0x%llx)",
+		 nport_id, nport_name);
+		return;
+	}
+	if (tport->timer_pending) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "tport fcid 0x%x: Canceling disc timer\n",
+					 tport->fcid);
+		fnic_del_tport_timer_sync(fnic, tport);
+		tport->timer_pending = 0;
+	}
+
+	/* got a logo in response to adisc to a target which has logged out */
+	if (tport->state == FDLS_TGT_STATE_ADISC) {
+		tport->retry_counter = 0;
+		oxid = tport->active_oxid;
+		fdls_free_oxid(iport, oxid, &tport->active_oxid);
+		fdls_delete_tport(iport, tport);
+		fdls_send_logo_resp(iport, &logo->fchdr);
+		if ((iport->state == FNIC_IPORT_STATE_READY)
+			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT)
+			&& (fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+						 "Sending GPNFT in response to LOGO from Target:0x%x",
+						 nport_id);
+			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
+			return;
+		}
+	} else {
+		fdls_delete_tport(iport, tport);
+	}
+	if (iport->state == FNIC_IPORT_STATE_READY) {
+		fdls_send_logo_resp(iport, &logo->fchdr);
+		if ((fdls_get_state(&iport->fabric) != FDLS_STATE_SEND_GPNFT) &&
+			(fdls_get_state(&iport->fabric) != FDLS_STATE_RSCN_GPN_FT)) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+						 "Sending GPNFT in response to LOGO from Target:0x%x",
+						 nport_id);
+			fdls_send_gpn_ft(iport, FDLS_STATE_SEND_GPNFT);
+		}
+	}
+}
+
+static void
+fdls_process_rscn(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
+{
+	struct fc_std_rscn *rscn;
+	struct fc_els_rscn_page *rscn_port = NULL;
+	int num_ports;
+	struct fnic_tport_s *tport, *next;
+	uint32_t nport_id;
+	uint8_t fcid[3];
+	int newports = 0;
+	struct fnic_fdls_fabric_s *fdls = &iport->fabric;
+	struct fnic *fnic = iport->fnic;
+	uint16_t rscn_payload_len;
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "FDLS process RSCN %p", iport);
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "FDLS RSCN received in state(%d). Dropping",
+					 fdls_get_state(fdls));
+		return;
+	}
+
+	rscn = (struct fc_std_rscn *)fchdr;
+	rscn_payload_len = be16_to_cpu(rscn->els.rscn_plen);
+
+	/* frame validation */
+	if ((rscn_payload_len % 4 != 0) || (rscn_payload_len < 8)
+	    || (rscn_payload_len > 1024)
+	    || (rscn->els.rscn_page_len != 4)) {
+		num_ports = 0;
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "RSCN payload_len: 0x%x page_len: 0x%x",
+				     rscn_payload_len, rscn->els.rscn_page_len);
+		/* if this happens then we need to send ADISC to all the tports. */
+		list_for_each_entry_safe(tport, next, &iport->tport_list, links) {
+			if (tport->state == FDLS_TGT_STATE_READY)
+				tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+			FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "RSCN for port id: 0x%x", tport->fcid);
+		}
+	} else {
+		num_ports = (rscn_payload_len - 4) / rscn->els.rscn_page_len;
+		rscn_port = (struct fc_els_rscn_page *)(rscn + 1);
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "RSCN received for num_ports: %d payload_len: %d page_len: %d ",
+		     num_ports, rscn_payload_len, rscn->els.rscn_page_len);
+
+	/*
+	 * RSCN have at least one Port_ID page , but may not have any port_id
+	 * in it. If no port_id is specified in the Port_ID page , we send
+	 * ADISC to all the tports
+	 */
+
+	while (num_ports) {
+
+		memcpy(fcid, rscn_port->rscn_fid, 3);
+
+		nport_id = ntoh24(fcid);
+		rscn_port++;
+		num_ports--;
+		/* if this happens then we need to send ADISC to all the tports. */
+		if (nport_id == 0) {
+			list_for_each_entry_safe(tport, next, &iport->tport_list,
+									 links) {
+				if (tport->state == FDLS_TGT_STATE_READY)
+					tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+
+				FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+							 "RSCN for port id: 0x%x", tport->fcid);
+			}
+			break;
+		}
+		tport = fnic_find_tport_by_fcid(iport, nport_id);
+
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "RSCN port id list: 0x%x", nport_id);
+
+		if (!tport) {
+			newports++;
+			continue;
+		}
+		if (tport->state == FDLS_TGT_STATE_READY)
+			tport->flags |= FNIC_FDLS_TPORT_SEND_ADISC;
+	}
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+		 "FDLS process RSCN sending GPN_FT: newports: %d", newports);
+		fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
+		fdls_send_rscn_resp(iport, fchdr);
+}
+static void
+fdls_process_adisc_req(struct fnic_iport_s *iport,
+		       struct fc_frame_header *fchdr)
+{
+	struct fc_std_els_adisc *padisc_acc;
+	struct fc_std_els_adisc *adisc_req = (struct fc_std_els_adisc *)fchdr;
+	uint64_t frame_wwnn;
+	uint64_t frame_wwpn;
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	uint8_t *rjt_frame;
+	uint8_t *acc_frame;
+	struct fc_std_els_rjt_rsp *prjts_rsp;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
+	uint16_t rjt_frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_els_rjt_rsp);
+	uint16_t acc_frame_size = FNIC_ETH_FCOE_HDRS_OFFSET +
+			sizeof(struct fc_std_els_adisc);
+
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process ADISC request %d", iport->fnic->fnic_num);
+
+	fcid = FNIC_STD_GET_S_ID(fchdr);
+	tgt_fcid = ntoh24(fcid);
+	tport = fnic_find_tport_by_fcid(iport, tgt_fcid);
+	if (!tport) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+					 "tport for fcid: 0x%x not found. Dropping ADISC req.",
+					 tgt_fcid);
+		return;
+	}
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "Dropping ADISC req from fcid: 0x%x in iport state: %d",
+			 tgt_fcid, iport->state);
+		return;
+	}
+
+	frame_wwnn = be64_to_cpu(adisc_req->els.adisc_wwnn);
+	frame_wwpn = be64_to_cpu(adisc_req->els.adisc_wwpn);
+
+	if ((frame_wwnn != tport->wwnn) || (frame_wwpn != tport->wwpn)) {
+		/* send reject */
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "ADISC req from fcid: 0x%x mismatch wwpn: 0x%llx wwnn: 0x%llx",
+			 tgt_fcid, frame_wwpn, frame_wwnn);
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+			 "local tport wwpn: 0x%llx wwnn: 0x%llx. Sending RJT",
+			 tport->wwpn, tport->wwnn);
+
+		rjt_frame = fdls_alloc_frame(iport);
+		if (rjt_frame == NULL) {
+			FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate rjt_frame to send response to ADISC request");
+			return;
+		}
+
+		prjts_rsp = (struct fc_std_els_rjt_rsp *) (rjt_frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+		fdls_init_els_rjt_frame(rjt_frame, iport);
+
+		prjts_rsp->rej.er_reason = 0x03;	/*  logical error */
+		prjts_rsp->rej.er_explan = 0x1E;	/*  N_port login required */
+		prjts_rsp->rej.er_vendor = 0x0;
+
+		FNIC_STD_SET_S_ID(prjts_rsp->fchdr, fchdr->fh_d_id);
+		FNIC_STD_SET_D_ID(prjts_rsp->fchdr, fchdr->fh_s_id);
+		oxid = FNIC_STD_GET_OX_ID(fchdr);
+		FNIC_STD_SET_OX_ID(prjts_rsp->fchdr, oxid);
+
+		fnic_send_fcoe_frame(iport, rjt_frame, rjt_frame_size);
+		return;
+	}
+
+	acc_frame = fdls_alloc_frame(iport);
+	if (acc_frame == NULL) {
+		FNIC_FCS_DBG(KERN_ERR, fnic->lport->host, fnic->fnic_num,
+				"Failed to allocate frame to send ADISC accept");
+		return;
+	}
+
+	padisc_acc = (struct fc_std_els_adisc *) (acc_frame + FNIC_ETH_FCOE_HDRS_OFFSET);
+
+	FNIC_STD_SET_S_ID(padisc_acc->fchdr, fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID(padisc_acc->fchdr, fchdr->fh_s_id);
+
+	FNIC_STD_SET_F_CTL(padisc_acc->fchdr, FNIC_ELS_REP_FCTL << 16);
+	FNIC_STD_SET_R_CTL(padisc_acc->fchdr, FC_RCTL_ELS_REP);
+	FNIC_STD_SET_TYPE(padisc_acc->fchdr, FC_TYPE_ELS);
+
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID(padisc_acc->fchdr, oxid);
+	FNIC_STD_SET_RX_ID(padisc_acc->fchdr, FNIC_UNASSIGNED_RXID);
+
+	padisc_acc->els.adisc_cmd = ELS_LS_ACC;
+
+	FNIC_STD_SET_NPORT_NAME(&padisc_acc->els.adisc_wwpn,
+			iport->wwpn);
+	FNIC_STD_SET_NODE_NAME(&padisc_acc->els.adisc_wwnn,
+			iport->wwnn);
+	memcpy(padisc_acc->els.adisc_port_id, fchdr->fh_d_id, 3);
+
+	fnic_send_fcoe_frame(iport, acc_frame, acc_frame_size);
+}
+
 /*
  * Performs a validation for all FCOE frames and return the frame type
  */
@@ -3529,6 +4187,31 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 	case FNIC_FABRIC_BLS_ABTS_RSP:
 			fdls_process_fabric_abts_rsp(iport, fchdr);
 		break;
+	case FNIC_BLS_ABTS_REQ:
+		fdls_process_abts_req(iport, fchdr);
+		break;
+	case FNIC_ELS_UNSUPPORTED_REQ:
+		fdls_process_unsupported_els_req(iport, fchdr);
+		break;
+	case FNIC_ELS_PLOGI_REQ:
+		fdls_process_plogi_req(iport, fchdr);
+		break;
+	case FNIC_ELS_RSCN_REQ:
+		fdls_process_rscn(iport, fchdr);
+		break;
+	case FNIC_ELS_LOGO_REQ:
+		fdls_process_logo_req(iport, fchdr);
+		break;
+	case FNIC_ELS_RRQ:
+	case FNIC_ELS_ECHO_REQ:
+		fdls_process_els_req(iport, fchdr, len);
+		break;
+	case FNIC_ELS_ADISC:
+		fdls_process_adisc_req(iport, fchdr);
+		break;
+	case FNIC_ELS_RLS:
+		fdls_process_rls_req(iport, fchdr);
+		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
 			 "s_id: 0x%x d_did: 0x%x", s_id, d_id);
-- 
2.47.0

