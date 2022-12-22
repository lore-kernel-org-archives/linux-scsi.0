Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD817C4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Dec 2022 04:39:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbiLVEjt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Dec 2022 23:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiLVEjo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2022 23:39:44 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4720D19C20
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:43 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BM1SDgG018335
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=F+5C3O+WaoipRTSFannNVD1kUGuqQ/VtBQn7HfPsZgE=;
 b=D9YERL2A3kRwtd5dkS/O4WzxyI/gN6MjHkyGZiY73L38cb1RViR8kaIrs8RrKyIxuM66
 SG6TDGmpPuuG44XTkR50xFq2j8eUVuuHXX8lWfFnc1r/L7Tc0ESfCnPeH1jCxFXAV+y1
 iSxJIPtQRlQ7sLuLu0RIo+Gl4pLz8VnGqog1G+5R9b/4Zp64xumCkW8WlciWmpyC4ZER
 ZCbqcA7JD1jPprm4qWVePfld61ilTRXqt9wfS57+/ylyRlrDDViCELt64fYohFN3PTo0
 izw9uerWTqVZxybSjJ/exLvEufDsJFTBb9qft4aVhnVLzHy4Lu2n/W4wpBGeZlfPhLbn vw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3mm79c2j8t-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 21 Dec 2022 20:39:42 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 21 Dec
 2022 20:39:40 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Wed, 21 Dec 2022 20:39:40 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id AADC95B6948;
        Wed, 21 Dec 2022 20:39:40 -0800 (PST)
From:   Nilesh Javali <njavali@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <bhazarika@marvell.com>,
        <agurumurthy@marvell.com>, <sdeodhar@marvell.com>
Subject: [PATCH 03/10] qla2xxx: Remove dead code (GNN ID)
Date:   Wed, 21 Dec 2022 20:39:26 -0800
Message-ID: <20221222043933.2825-4-njavali@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20221222043933.2825-1-njavali@marvell.com>
References: <20221222043933.2825-1-njavali@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: D2o8QmKuvmWPcFZdg71mNUBUQOAnXDqk
X-Proofpoint-GUID: D2o8QmKuvmWPcFZdg71mNUBUQOAnXDqk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-22_01,2022-12-21_01,2022-06-22_01
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <qutran@marvell.com>

Remove stale/unused code (GNN ID).

Cc: stable@vger.kernel.org
Signed-off-by: Quinn Tran <qutran@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
---
 drivers/scsi/qla2xxx/qla_def.h  |   3 -
 drivers/scsi/qla2xxx/qla_gbl.h  |   3 -
 drivers/scsi/qla2xxx/qla_gs.c   | 110 --------------------------------
 drivers/scsi/qla2xxx/qla_init.c |   7 +-
 drivers/scsi/qla2xxx/qla_os.c   |   3 -
 5 files changed, 1 insertion(+), 125 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 9ee9ce613c75..2ed04f71cfc5 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -2485,7 +2485,6 @@ struct ct_sns_desc {
 
 enum discovery_state {
 	DSC_DELETED,
-	DSC_GNN_ID,
 	DSC_GNL,
 	DSC_LOGIN_PEND,
 	DSC_LOGIN_FAILED,
@@ -2699,7 +2698,6 @@ extern const char *const port_state_str[5];
 
 static const char *const port_dstate_str[] = {
 	[DSC_DELETED]		= "DELETED",
-	[DSC_GNN_ID]		= "GNN_ID",
 	[DSC_GNL]		= "GNL",
 	[DSC_LOGIN_PEND]	= "LOGIN_PEND",
 	[DSC_LOGIN_FAILED]	= "LOGIN_FAILED",
@@ -3492,7 +3490,6 @@ enum qla_work_type {
 	QLA_EVT_GPNFT,
 	QLA_EVT_GPNFT_DONE,
 	QLA_EVT_GNNFT_DONE,
-	QLA_EVT_GNNID,
 	QLA_EVT_GFPNID,
 	QLA_EVT_SP_RETRY,
 	QLA_EVT_IIDMA,
diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gbl.h
index 2acddc8dc943..08ea8dc6c6bb 100644
--- a/drivers/scsi/qla2xxx/qla_gbl.h
+++ b/drivers/scsi/qla2xxx/qla_gbl.h
@@ -730,9 +730,6 @@ int qla24xx_async_gffid(scsi_qla_host_t *vha, fc_port_t *fcport, bool);
 int qla24xx_async_gpnft(scsi_qla_host_t *, u8, srb_t *);
 void qla24xx_async_gpnft_done(scsi_qla_host_t *, srb_t *);
 void qla24xx_async_gnnft_done(scsi_qla_host_t *, srb_t *);
-int qla24xx_async_gnnid(scsi_qla_host_t *, fc_port_t *);
-void qla24xx_handle_gnnid_event(scsi_qla_host_t *, struct event_arg *);
-int qla24xx_post_gnnid_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_post_gfpnid_work(struct scsi_qla_host *, fc_port_t *);
 int qla24xx_async_gfpnid(scsi_qla_host_t *, fc_port_t *);
 void qla24xx_handle_gfpnid_event(scsi_qla_host_t *, struct event_arg *);
diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.c
index fe1eb06db654..4738f8935f7f 100644
--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3893,116 +3893,6 @@ void qla_scan_work_fn(struct work_struct *work)
 	spin_unlock_irqrestore(&vha->work_lock, flags);
 }
 
-/* GNN_ID */
-void qla24xx_handle_gnnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
-{
-	qla24xx_post_gnl_work(vha, ea->fcport);
-}
-
-static void qla2x00_async_gnnid_sp_done(srb_t *sp, int res)
-{
-	struct scsi_qla_host *vha = sp->vha;
-	fc_port_t *fcport = sp->fcport;
-	u8 *node_name = fcport->ct_desc.ct_sns->p.rsp.rsp.gnn_id.node_name;
-	struct event_arg ea;
-	u64 wwnn;
-
-	fcport->flags &= ~FCF_ASYNC_SENT;
-	wwnn = wwn_to_u64(node_name);
-	if (wwnn)
-		memcpy(fcport->node_name, node_name, WWN_SIZE);
-
-	memset(&ea, 0, sizeof(ea));
-	ea.fcport = fcport;
-	ea.sp = sp;
-	ea.rc = res;
-
-	ql_dbg(ql_dbg_disc, vha, 0x204f,
-	    "Async done-%s res %x, WWPN %8phC %8phC\n",
-	    sp->name, res, fcport->port_name, fcport->node_name);
-
-	qla24xx_handle_gnnid_event(vha, &ea);
-
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-}
-
-int qla24xx_async_gnnid(scsi_qla_host_t *vha, fc_port_t *fcport)
-{
-	int rval = QLA_FUNCTION_FAILED;
-	struct ct_sns_req       *ct_req;
-	srb_t *sp;
-
-	if (!vha->flags.online || (fcport->flags & FCF_ASYNC_SENT))
-		return rval;
-
-	qla2x00_set_fcport_disc_state(fcport, DSC_GNN_ID);
-	/* ref: INIT */
-	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
-	if (!sp)
-		goto done;
-
-	fcport->flags |= FCF_ASYNC_SENT;
-	sp->type = SRB_CT_PTHRU_CMD;
-	sp->name = "gnnid";
-	sp->gen1 = fcport->rscn_gen;
-	sp->gen2 = fcport->login_gen;
-	qla2x00_init_async_sp(sp, qla2x00_get_async_timeout(vha) + 2,
-			      qla2x00_async_gnnid_sp_done);
-
-	/* CT_IU preamble  */
-	ct_req = qla2x00_prep_ct_req(fcport->ct_desc.ct_sns, GNN_ID_CMD,
-	    GNN_ID_RSP_SIZE);
-
-	/* GNN_ID req */
-	ct_req->req.port_id.port_id = port_id_to_be_id(fcport->d_id);
-
-
-	/* req & rsp use the same buffer */
-	sp->u.iocb_cmd.u.ctarg.req = fcport->ct_desc.ct_sns;
-	sp->u.iocb_cmd.u.ctarg.req_dma = fcport->ct_desc.ct_sns_dma;
-	sp->u.iocb_cmd.u.ctarg.rsp = fcport->ct_desc.ct_sns;
-	sp->u.iocb_cmd.u.ctarg.rsp_dma = fcport->ct_desc.ct_sns_dma;
-	sp->u.iocb_cmd.u.ctarg.req_size = GNN_ID_REQ_SIZE;
-	sp->u.iocb_cmd.u.ctarg.rsp_size = GNN_ID_RSP_SIZE;
-	sp->u.iocb_cmd.u.ctarg.nport_handle = NPH_SNS;
-
-	ql_dbg(ql_dbg_disc, vha, 0xffff,
-	    "Async-%s - %8phC hdl=%x loopid=%x portid %06x.\n",
-	    sp->name, fcport->port_name,
-	    sp->handle, fcport->loop_id, fcport->d_id.b24);
-
-	rval = qla2x00_start_sp(sp);
-	if (rval != QLA_SUCCESS)
-		goto done_free_sp;
-	return rval;
-
-done_free_sp:
-	/* ref: INIT */
-	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
-done:
-	return rval;
-}
-
-int qla24xx_post_gnnid_work(struct scsi_qla_host *vha, fc_port_t *fcport)
-{
-	struct qla_work_evt *e;
-	int ls;
-
-	ls = atomic_read(&vha->loop_state);
-	if (((ls != LOOP_READY) && (ls != LOOP_UP)) ||
-		test_bit(UNLOADING, &vha->dpc_flags))
-		return 0;
-
-	e = qla2x00_alloc_work(vha, QLA_EVT_GNNID);
-	if (!e)
-		return QLA_FUNCTION_FAILED;
-
-	e->u.fcport.fcport = fcport;
-	return qla2x00_post_work(vha, e);
-}
-
 /* GPFN_ID */
 void qla24xx_handle_gfpnid_event(scsi_qla_host_t *vha, struct event_arg *ea)
 {
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index c66a0106a7fc..a23cb2e5ab58 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1718,12 +1718,7 @@ int qla24xx_fcport_handle_login(struct scsi_qla_host *vha, fc_port_t *fcport)
 			}
 			break;
 		default:
-			if (wwn == 0)    {
-				ql_dbg(ql_dbg_disc, vha, 0xffff,
-				    "%s %d %8phC post GNNID\n",
-				    __func__, __LINE__, fcport->port_name);
-				qla24xx_post_gnnid_work(vha, fcport);
-			} else if (fcport->loop_id == FC_NO_LOOP_ID) {
+			if (fcport->loop_id == FC_NO_LOOP_ID) {
 				ql_dbg(ql_dbg_disc, vha, 0x20bd,
 				    "%s %d %8phC post gnl\n",
 				    __func__, __LINE__, fcport->port_name);
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bbbdf2ffb682..c0ac6bfeeafe 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5502,9 +5502,6 @@ qla2x00_do_work(struct scsi_qla_host *vha)
 		case QLA_EVT_GNNFT_DONE:
 			qla24xx_async_gnnft_done(vha, e->u.iosb.sp);
 			break;
-		case QLA_EVT_GNNID:
-			qla24xx_async_gnnid(vha, e->u.fcport.fcport);
-			break;
 		case QLA_EVT_GFPNID:
 			qla24xx_async_gfpnid(vha, e->u.fcport.fcport);
 			break;
-- 
2.19.0.rc0

