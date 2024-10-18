Received: from rcdn-iport-5.cisco.com (rcdn-iport-5.cisco.com [173.37.86.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA52020262E;
	Fri, 18 Oct 2024 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.37.86.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729268254; cv=none; b=NwfRRFU4HuUbi0pQ/1Zom1Rq4yIcJktFxLlNe68/DTSfIz3/f/oLb+GmQfZixFlthIa3wqCzvu7n9acxVIOMIi0pIQGbw9TZJZEAxYvDZYgeJU//yduPhm9zjHr4Ha+DvzrGD/C+K8MLFhVEPI/lcJmjcK5Y9ogQHuDGt98/LfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729268254; c=relaxed/simple;
	bh=HGoXVBfoyRZhA7DDRb4nI10V+SEk1+sWb0pcFuPjXQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdaT4udmqhko6/tdogJlgAHYRg5jHUa1QeAtfglYPoKCPcnT646dbQVwTsXu27930i9FOE4lXegbP+EfRfjCwK+KesJI8tKCY84V1VLTD4FNIATKXShSzMYfSZXBATwweCDOqPFgyBePEWWiY4nfkIaqJ2r6aNt46VsL7chPEZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b=NPa+IpRZ; arc=none smtp.client-ip=173.37.86.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cisco.com header.i=@cisco.com header.b="NPa+IpRZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=22348; q=dns/txt;
  s=iport; t=1729268251; x=1730477851;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pHh4ZVpxb6Pd542PEZO2r7LKNU2q5ZYHhUh7OXJPjxA=;
  b=NPa+IpRZvWwkUWBxV4IPVdELr56DOolCRM11kAtVWRDrO9rdhDMY3eBb
   uygydNyUY3z/JjOwSUz3Wqy/7JfXZIOCj3a/B4XI2sEnq/ch+h3749KjO
   Z7kX7WpC+DEozY52wUS452JHWPaKZ8C/S/JEhq/JjwbGvsW636F9rPIHb
   0=;
X-CSE-ConnectionGUID: q+PffflJTL+odg3/ARY36w==
X-CSE-MsgGUID: FTOaKmgtT8iDLh6fYoqhNg==
X-IPAS-Result: =?us-ascii?q?A0AnAAAtiRJn/5D/Ja1aHAEBAQEBAQcBARIBAQQEAQGBe?=
 =?us-ascii?q?wcBAQsBgkp2WUMZL4xyiVGBFp0BFIERA1YPAQEBDzkLBAEBhQcCiiMCJjQJD?=
 =?us-ascii?q?gECBAEBAQEDAgMBAQEBAQEBAQENAQEFAQEBAgEHBYEOE4V7DYZbAgEDGg0LA?=
 =?us-ascii?q?UYQOQEXVhmDAQGCZAMRr3OBeTOBAd4zgWYGgUgBjUVwhHcnFQaBSUSBFYE7g?=
 =?us-ascii?q?TcHb4EFAUyCV2IChXoEhko1aYcQhRcFAQqDR4YJJYEzhDiDUpFASIEhA1khA?=
 =?us-ascii?q?hEBVRMNCgsJBYk1gRCCFimBa4EIgwiFJYFnCWGIR4EHLYERgR86ggOBNkqDa?=
 =?us-ascii?q?IFPRz+CT2pONwINAjeCJIEAeIFZhVI2QAMLGA1IESwUIRQbBj5uB6p3gVoBR?=
 =?us-ascii?q?oJOCActBEoTLBeBNjAHDwEeAQqTEpIcgTSJdJVWhCSMFo4EhyUaM5tWjnaYd?=
 =?us-ascii?q?419lW9OhGaBZzyBWTMaCBsVO4JnEz8ZD44tCwuIbMI3JjICOQIHCwEBAwmMJ?=
 =?us-ascii?q?gICJAeBTgEB?=
IronPort-Data: A9a23:gp6hoaMTEwvGlD/vrR2DlsFynXyQoLVcMsEvi/4bfWQNrUoihjMEz
 jYdXGCCbvbbMGbxedlyYdnkph4Ov8TUx9Q2SHM5pCpnJ55oRWUpJjg4wmPYZX76whjrFRo/h
 ykmQoCdap1yFDmE/0fF3oHJ9RFUzbuPSqf3FNnKMyVwQR4MYCo6gHqPocZh6mJTqYb/WlrlV
 e/a+ZWFZAb9gm4sbwr41orawP9RlKWq0N8nlgRWicBj5Df2i3QTBZQDEqC9R1OQapVUBOOzW
 9HYx7i/+G7Dlz91Yj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnBaPpIACRYpQRw/ZwNlMDxG4
 I4lWZSYEW/FN0BX8QgXe0Ew/ypWZcWq9FJbSJSymZT78qHIT5fj6+wtNE84M4k6xsI0Bm1Br
 rsxEgFWMA/W0opawJrjIgVtrt4oIM+uOMYUvWttiGmGS/0nWpvEBa7N4Le03h9p2ZsIRqmYP
 ZdEL2MzMHwsYDUXUrsTIJE3hvupgnD8WzZZs1mS46Ew5gA/ySQrj+a1aoCMIYziqcN9sHq/r
 0HD8HjFUhA2ENzBxwuC63KKibqa9c/8cMdIfFGizdZug0W7x2oPBRlQXly+ydG7h0y0c9ZeL
 VEEvCskqO4580nDZtz0RQG5pjicswIRQcFdFcU98giGzqeS6AGcbkAATzhceJkludUwSDgCy
 FCEhZXqCCZpvbnTTmiSnp+QrDWvKW0OJnQDTTELQBFD4NT5pow3yBXVQb5e/LWdlNb5H3T0h
 juNtiV73+pVhs8Q3KL99lfC696xmqX0oscOzl2/dgqYAslRPeZJu6TABYDn0Mt9
IronPort-HdrOrdr: A9a23:K4cOm60X9i2t2a5pYl/dIgqjBJ0kLtp133Aq2lEZdPWaSKClfq
 eV7ZAmPHDP5gr5NEtLpTnEAtjifZq+z+8R3WByB9aftWDd0QPCEGgh1/qB/9SKIULDH4BmuJ
 tIQuxXFMDwAV9mjczz/QW0V+o7zMLvytHOuQ6n9RdQpcUAUdAY0++/YTzrdHFLeA==
X-Talos-CUID: =?us-ascii?q?9a23=3Ah9r1CWvgKoLpV9phyM2GT2UQ6Is8MUXTwnnUAXO?=
 =?us-ascii?q?cSmFlR+bSYGWho/17xp8=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AVG/c2Q46f3DP7FNgI0k+NYmSxoxG34OnK0UCjal?=
 =?us-ascii?q?WuuWgNXJ+CjCEjBK4F9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.11,214,1725321600"; 
   d="scan'208";a="276022138"
Received: from rcdn-l-core-07.cisco.com ([173.37.255.144])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 18 Oct 2024 16:17:24 +0000
Received: from fedora.cisco.com (unknown [10.24.40.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kartilak@cisco.com)
	by rcdn-l-core-07.cisco.com (Postfix) with ESMTPSA id 88BD918000233;
	Fri, 18 Oct 2024 16:17:22 +0000 (GMT)
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
Subject: [PATCH v5 05/14] scsi: fnic: Add support for unsolicited requests and responses
Date: Fri, 18 Oct 2024 09:14:00 -0700
Message-ID: <20241018161409.4442-6-kartilak@cisco.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241018161409.4442-1-kartilak@cisco.com>
References: <20241018161409.4442-1-kartilak@cisco.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-User: kartilak@cisco.com
X-Outbound-SMTP-Client: 10.24.40.136, [10.24.40.136]
X-Outbound-Node: rcdn-l-core-07.cisco.com

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
 drivers/scsi/fnic/fdls_disc.c | 579 +++++++++++++++++++++++++++++++++-
 1 file changed, 576 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/fnic/fdls_disc.c b/drivers/scsi/fnic/fdls_disc.c
index 52459f6bb589..a9a98ddc3a84 100644
--- a/drivers/scsi/fnic/fdls_disc.c
+++ b/drivers/scsi/fnic/fdls_disc.c
@@ -142,6 +142,22 @@ struct fc_std_scr fnic_std_scr_req = {
 	    .scr_reg_func = ELS_SCRF_FULL}
 };
 
+/*
+ * Variables:
+ * did, ox_id, rx_id
+ */
+struct fc_std_els_rsp fnic_std_els_acc = {
+	.fchdr = {.fh_r_ctl = FC_RCTL_ELS_REP, .fh_d_id = {0xFF, 0xFF, 0xFD},
+		  .fh_type = FC_TYPE_ELS, .fh_f_ctl = {FNIC_ELS_REP_FCTL, 0, 0}},
+	.u.acc.la_cmd = ELS_LS_ACC,
+};
+
+struct fc_std_els_rsp fnic_std_els_rjt = {
+	.fchdr = {.fh_r_ctl = FC_RCTL_ELS_REP, .fh_type = FC_TYPE_ELS,
+		  .fh_f_ctl = {FNIC_ELS_REP_FCTL, 0, 0}},
+	.u.rej.er_cmd = ELS_LS_RJT,
+};
+
 /*
  * Variables:
  * did, ox_id, rx_id, fcid, wwpn
@@ -169,6 +185,12 @@ struct fc_frame_header fc_std_tport_abts = {
 	.fh_parm_offset = 0x00000000,	/* bit:0 = 0 Abort a exchange */
 };
 
+static struct fc_std_abts_ba_acc fnic_std_ba_acc = {
+	.fchdr = {.fh_r_ctl = FC_RCTL_BA_ACC,
+						.fh_f_ctl = {FNIC_FCP_RSP_FCTL, 0, 0}},
+	.acc = {.ba_low_seq_cnt = 0, .ba_high_seq_cnt = 0xFFFF}
+};
+
 #define RETRIES_EXHAUSTED(iport)      \
 	(iport->fabric.retry_counter == FABRIC_LOGO_MAX_RETRY)
 
@@ -202,7 +224,6 @@ static void fdls_target_restart_nexus(struct fnic_tport_s *tport);
 static void fdls_start_tport_timer(struct fnic_iport_s *iport,
 					struct fnic_tport_s *tport, int timeout);
 static void fdls_tport_timer_callback(struct timer_list *t);
-
 static void fdls_start_fabric_timer(struct fnic_iport_s *iport,
 			int timeout);
 static void
@@ -507,6 +528,50 @@ fdls_start_tport_timer(struct fnic_iport_s *iport,
 	tport->timer_pending = 1;
 }
 
+static void
+fdls_send_rscn_resp(struct fnic_iport_s *iport,
+		    struct fc_frame_header *rscn_fchdr)
+{
+	struct fc_std_els_rsp els_acc;
+	uint16_t oxid;
+	uint8_t fcid[3];
+
+	memcpy(&els_acc, &fnic_std_els_acc, FC_ELS_RSP_ACC_SIZE);
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID((&els_acc.fchdr), fcid);
+	FNIC_STD_SET_D_ID((&els_acc.fchdr), rscn_fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(rscn_fchdr);
+	FNIC_STD_SET_OX_ID((&els_acc.fchdr), oxid);
+
+	FNIC_STD_SET_RX_ID((&els_acc.fchdr), FNIC_UNASSIGNED_RXID);
+
+	fnic_send_fcoe_frame(iport, &els_acc, FC_ELS_RSP_ACC_SIZE);
+}
+
+static void
+fdls_send_logo_resp(struct fnic_iport_s *iport,
+		    struct fc_frame_header *req_fchdr)
+{
+	struct fc_std_els_rsp logo_resp;
+	uint16_t oxid;
+	uint8_t fcid[3];
+
+	memcpy(&logo_resp, &fnic_std_els_acc, sizeof(struct fc_std_els_rsp));
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID((&logo_resp.fchdr), fcid);
+	FNIC_STD_SET_D_ID((&logo_resp.fchdr), req_fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(req_fchdr);
+	FNIC_STD_SET_OX_ID((&logo_resp.fchdr), oxid);
+
+	FNIC_STD_SET_RX_ID((&logo_resp.fchdr), FNIC_UNASSIGNED_RXID);
+
+	fnic_send_fcoe_frame(iport, &logo_resp, FC_ELS_RSP_ACC_SIZE);
+}
+
 void
 fdls_send_tport_abts(struct fnic_iport_s *iport,
 					 struct fnic_tport_s *tport)
@@ -1047,7 +1112,6 @@ fdls_send_tgt_prli(struct fnic_iport_s *iport, struct fnic_tport_s *tport)
 
 	timeout = max(2 * iport->e_d_tov, iport->plogi_timeout);
 
-	fdls_get_tgt_oxid_pool(tport);
 	fnic_send_fcoe_frame(iport, &prli, sizeof(struct fc_std_els_prli));
 	/* Even if fnic_send_fcoe_frame() fails we want to retry after timeout */
 	fdls_start_tport_timer(iport, tport, timeout);
@@ -2890,6 +2954,192 @@ fdls_process_fabric_abts_rsp(struct fnic_iport_s *iport,
 	}
 }
 
+static void
+fdls_process_abts_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
+{
+	struct fc_std_abts_ba_acc ba_acc;
+	uint32_t nport_id;
+	uint16_t oxid;
+	struct fnic_tport_s *tport;
+	struct fnic *fnic = iport->fnic;
+	struct fnic_tgt_oxid_pool_s *oxid_pool;
+
+	nport_id = ntoh24(fchdr->fh_s_id);
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Received abort from SID %8x", nport_id);
+
+	tport = fnic_find_tport_by_fcid(iport, nport_id);
+	if (tport) {
+		oxid = FNIC_STD_GET_OX_ID(fchdr);
+		if (tport->oxid_used == oxid) {
+			tport->flags |= FNIC_FDLS_TGT_ABORT_ISSUED;
+			oxid_pool = fdls_get_tgt_oxid_pool(tport);
+			fdls_free_tgt_oxid(iport, oxid_pool, ntohs(oxid));
+		}
+	}
+
+	memcpy(&ba_acc, &fnic_std_ba_acc, sizeof(struct fc_std_abts_ba_acc));
+	FNIC_STD_SET_S_ID((&ba_acc.fchdr), fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID((&ba_acc.fchdr), fchdr->fh_s_id);
+
+	ba_acc.fchdr.fh_rx_id = fchdr->fh_rx_id;
+	ba_acc.acc.ba_rx_id = ba_acc.fchdr.fh_rx_id;
+	ba_acc.fchdr.fh_ox_id = fchdr->fh_ox_id;
+	ba_acc.acc.ba_ox_id = ba_acc.fchdr.fh_ox_id;
+
+	fnic_send_fcoe_frame(iport, &ba_acc, sizeof(struct fc_std_abts_ba_acc));
+}
+
+static void
+fdls_process_unsupported_els_req(struct fnic_iport_s *iport,
+				 struct fc_frame_header *fchdr)
+{
+	struct fc_std_els_rsp ls_rsp;
+	uint16_t oxid;
+	uint32_t d_id = ntoh24(fchdr->fh_d_id);
+	struct fnic *fnic = iport->fnic;
+
+	memcpy(&ls_rsp, &fnic_std_els_rjt, FC_ELS_RSP_REJ_SIZE);
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
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process unsupported ELS request from SID: 0x%x",
+		     ntoh24(fchdr->fh_s_id));
+	/* We don't support this ELS request, send a reject */
+	ls_rsp.u.rej.er_reason = 0x0B;
+	ls_rsp.u.rej.er_explan = 0x0;
+	ls_rsp.u.rej.er_vendor = 0x0;
+
+	FNIC_STD_SET_S_ID((&ls_rsp.fchdr), fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID((&ls_rsp.fchdr), fchdr->fh_s_id);
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID((&ls_rsp.fchdr), oxid);
+
+	FNIC_STD_SET_RX_ID((&ls_rsp.fchdr), FNIC_UNSUPPORTED_RESP_OXID);
+
+	fnic_send_fcoe_frame(iport, &ls_rsp, FC_ELS_RSP_REJ_SIZE);
+}
+
+static void
+fdls_process_rls_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr)
+{
+	struct fc_std_rls_acc rls_acc_rsp;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
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
+	memset(&rls_acc_rsp, 0, sizeof(struct fc_std_rls_acc));
+
+	FNIC_STD_SET_S_ID((&rls_acc_rsp.fchdr), fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID((&rls_acc_rsp.fchdr), fchdr->fh_s_id);
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID((&rls_acc_rsp.fchdr), oxid);
+	FNIC_STD_SET_RX_ID((&rls_acc_rsp.fchdr), 0xffff);
+	FNIC_STD_SET_F_CTL(&rls_acc_rsp.fchdr, FNIC_ELS_REP_FCTL << 16);
+	FNIC_STD_SET_R_CTL(&rls_acc_rsp.fchdr, FC_RCTL_ELS_REP);
+	FNIC_STD_SET_TYPE(&rls_acc_rsp.fchdr, FC_TYPE_ELS);
+	rls_acc_rsp.els.rls_cmd = ELS_LS_ACC;
+	rls_acc_rsp.els.rls_lesb.lesb_link_fail =
+	    htonl(iport->fnic->link_down_cnt);
+
+	fnic_send_fcoe_frame(iport, &rls_acc_rsp,
+			     sizeof(struct fc_std_rls_acc));
+}
+
+static void
+fdls_process_els_req(struct fnic_iport_s *iport, struct fc_frame_header *fchdr,
+					 uint32_t len)
+{
+	struct fc_std_els_rsp *els_acc;
+	uint16_t oxid;
+	uint8_t fcid[3];
+	uint8_t *fc_payload;
+	uint8_t *dst_frame;
+	uint8_t type;
+	struct fnic *fnic = iport->fnic;
+
+	fc_payload = (uint8_t *) fchdr + sizeof(struct fc_frame_header);
+	type = *fc_payload;
+
+	if ((iport->state != FNIC_IPORT_STATE_READY)
+		&& (iport->state != FNIC_IPORT_STATE_FABRIC_DISC)) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Dropping ELS frame type :%x in iport state: %d",
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
+					 "sending LS_ACC for %x ELS frame\n", type);
+		break;
+	}
+	dst_frame = kzalloc(len, GFP_ATOMIC);
+	if (!dst_frame) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+					 "Failed to allocate ELS response for %x", type);
+		return;
+	}
+	if (type == ELS_ECHO) {
+		/* Brocade sends a longer payload, copy all frame back */
+		memcpy(dst_frame, fchdr, len);
+	}
+
+	els_acc = (struct fc_std_els_rsp *)dst_frame;
+	memcpy(els_acc, &fnic_std_els_acc, FC_ELS_RSP_ACC_SIZE);
+
+	hton24(fcid, iport->fcid);
+	FNIC_STD_SET_S_ID((&els_acc->fchdr), fcid);
+	FNIC_STD_SET_D_ID((&els_acc->fchdr), fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID((&els_acc->fchdr), oxid);
+	FNIC_STD_SET_RX_ID((&els_acc->fchdr), 0xffff);
+
+	if (type == ELS_ECHO)
+		fnic_send_fcoe_frame(iport, els_acc, len);
+	else
+		fnic_send_fcoe_frame(iport, els_acc, FC_ELS_RSP_ACC_SIZE);
+
+	kfree(dst_frame);
+}
+
 static void
 fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 			  struct fc_frame_header *fchdr)
@@ -3032,6 +3282,303 @@ fdls_process_tgt_abts_rsp(struct fnic_iport_s *iport,
 				 "Received ABTS response for unknown frame %p", iport);
 }
 
+static void
+fdls_process_plogi_req(struct fnic_iport_s *iport,
+		       struct fc_frame_header *fchdr)
+{
+	struct fc_std_els_rsp plogi_rsp;
+	uint16_t oxid;
+	uint32_t d_id = ntoh24(fchdr->fh_d_id);
+	struct fnic *fnic = iport->fnic;
+
+	memcpy(&plogi_rsp, &fnic_std_els_rjt, sizeof(struct fc_std_els_rsp));
+
+	if (iport->fcid != d_id) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received PLOGI with illegal frame bits. Dropping frame %p",
+			 iport);
+		return;
+	}
+
+	if (iport->state != FNIC_IPORT_STATE_READY) {
+		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+			 "Received PLOGI request in iport state: %d Dropping frame",
+			 iport->state);
+		return;
+	}
+	FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
+				 "Process PLOGI request from SID: 0x%x",
+		     ntoh24(fchdr->fh_s_id));
+
+	/* We don't support PLOGI request, send a reject */
+	plogi_rsp.u.rej.er_reason = 0x0B;
+	plogi_rsp.u.rej.er_explan = 0x0;
+	plogi_rsp.u.rej.er_vendor = 0x0;
+
+	FNIC_STD_SET_S_ID((&plogi_rsp.fchdr), fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID((&plogi_rsp.fchdr), fchdr->fh_s_id);
+
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID((&plogi_rsp.fchdr), oxid);
+
+	FNIC_STD_SET_RX_ID((&plogi_rsp.fchdr), FNIC_UNASSIGNED_RXID);
+
+	fnic_send_fcoe_frame(iport, &plogi_rsp, FC_ELS_RSP_REJ_SIZE);
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
+	nport_name = logo->els.fl_n_port_wwn;
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
+		oxid = ntohs(tport->oxid_used);
+		fdls_free_tgt_oxid(iport, &iport->adisc_oxid_pool, oxid);
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
+						 "RSCN for port id: 0x%x", tport->fcid);
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
+	fdls_send_gpn_ft(iport, FDLS_STATE_RSCN_GPN_FT);
+	fdls_send_rscn_resp(iport, fchdr);
+}
+
+static void
+fdls_process_adisc_req(struct fnic_iport_s *iport,
+		       struct fc_frame_header *fchdr)
+{
+	struct fc_std_els_adisc adisc_acc;
+	struct fc_std_els_adisc *adisc_req = (struct fc_std_els_adisc *)fchdr;
+	uint64_t frame_wwnn;
+	uint64_t frame_wwpn;
+	uint32_t tgt_fcid;
+	struct fnic_tport_s *tport;
+	uint8_t *fcid;
+	struct fc_std_els_rsp rjts_rsp;
+	uint16_t oxid;
+	struct fnic *fnic = iport->fnic;
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
+	frame_wwnn = ntohll(adisc_req->els.adisc_wwnn);
+	frame_wwpn = ntohll(adisc_req->els.adisc_wwpn);
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
+		memcpy(&rjts_rsp, &fnic_std_els_rjt,
+		       sizeof(struct fc_std_els_rsp));
+
+		rjts_rsp.u.rej.er_reason = 0x03;	/*  logical error */
+		rjts_rsp.u.rej.er_explan = 0x1E;	/*  N_port login required */
+		rjts_rsp.u.rej.er_vendor = 0x0;
+		FNIC_STD_SET_S_ID((&rjts_rsp.fchdr), fchdr->fh_d_id);
+		FNIC_STD_SET_D_ID((&rjts_rsp.fchdr), fchdr->fh_s_id);
+		oxid = FNIC_STD_GET_OX_ID(fchdr);
+		FNIC_STD_SET_OX_ID((&rjts_rsp.fchdr), oxid);
+		FNIC_STD_SET_RX_ID((&rjts_rsp.fchdr), FNIC_UNASSIGNED_RXID);
+
+		fnic_send_fcoe_frame(iport, &rjts_rsp, FC_ELS_RSP_REJ_SIZE);
+		return;
+	}
+	memset(&adisc_acc.fchdr, 0, sizeof(struct fc_frame_header));
+	FNIC_STD_SET_S_ID(&adisc_acc.fchdr, fchdr->fh_d_id);
+	FNIC_STD_SET_D_ID(&adisc_acc.fchdr, fchdr->fh_s_id);
+	FNIC_STD_SET_F_CTL(&adisc_acc.fchdr, FNIC_ELS_REP_FCTL << 16);
+	FNIC_STD_SET_R_CTL(&adisc_acc.fchdr, FC_RCTL_ELS_REP);
+	FNIC_STD_SET_TYPE(&adisc_acc.fchdr, FC_TYPE_ELS);
+	oxid = FNIC_STD_GET_OX_ID(fchdr);
+	FNIC_STD_SET_OX_ID(&adisc_acc.fchdr, oxid);
+	FNIC_STD_SET_RX_ID(&adisc_acc.fchdr, FNIC_UNASSIGNED_RXID);
+	adisc_acc.els.adisc_cmd = ELS_LS_ACC;
+
+	FNIC_STD_SET_NPORT_NAME(&adisc_acc.els.adisc_wwpn,
+				le64_to_cpu(iport->wwpn));
+	FNIC_STD_SET_NODE_NAME(&adisc_acc.els.adisc_wwnn,
+			       le64_to_cpu(iport->wwnn));
+	memcpy(adisc_acc.els.adisc_port_id, fchdr->fh_d_id, 3);
+
+	fnic_send_fcoe_frame(iport, &adisc_acc,
+			     sizeof(struct fc_std_els_adisc));
+}
+
 /*
  * Performs a validation for all FCOE frames and return the frame type
  */
@@ -3314,8 +3861,34 @@ void fnic_fdls_recv_frame(struct fnic_iport_s *iport, void *rx_frame,
 		if (fdls_is_oxid_in_fabric_range(oxid) &&
 			(iport->fabric.flags & FNIC_FDLS_FABRIC_ABORT_ISSUED)) {
 			fdls_process_fabric_abts_rsp(iport, fchdr);
-		} else
+		} else {
 			fdls_process_tgt_abts_rsp(iport, fchdr);
+		}
+		break;
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
 		break;
 	default:
 		FNIC_FCS_DBG(KERN_INFO, fnic->lport->host, fnic->fnic_num,
-- 
2.31.1

