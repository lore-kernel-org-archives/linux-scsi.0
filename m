Return-Path: <SRS0=lGnU=AD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1558C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 09:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B0FD206F1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Jun 2020 09:38:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=marvell.com header.i=@marvell.com header.b="O0ul+tVk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgFVJil (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Jun 2020 05:38:41 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:34002 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726449AbgFVJik (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Jun 2020 05:38:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05M9aVLA002569
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 02:38:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0818;
 bh=NXmECOkoZTNJ+WxqVL2K9wpw6332uEglzWRt+88Wolc=;
 b=O0ul+tVkwxKH9eEowpvBVBdwWKbsOy5RgXyNnRfBLvVQIhMC8BssakrMgkN351/JB+B4
 Pp1ZvydX1A64MBnUUVO50fiK60FZ7VFNVVUdxaiknkqxMMMmkPGPb8+zdNRNcmTP6YWX
 n1C73EVrW/hD0i+DQOLQwKDNA87Wd5a5A/VToVFX4Btozw/fS4oatuu7QZ8tZmMmWVjN
 5LI/KD6AhBdINNoMpjKAxc/CllNuWkEKQ2jvGreORrtGKfHzZjgHhuoM755/9z2LRyHh
 0sbsApGdH5hYnRe2ClMVwM5tmhtbLp0mDKxx5JesmYGLkgsnCSbMiBh6HcWZdo9fhajB 4g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 31sftpftba-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jun 2020 02:38:39 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 22 Jun
 2020 02:38:39 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 22 Jun 2020 02:38:39 -0700
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id D5ABB3F7040;
        Mon, 22 Jun 2020 02:38:38 -0700 (PDT)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 05M9ccLb003293;
        Mon, 22 Jun 2020 02:38:38 -0700
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 05M9cc03003284;
        Mon, 22 Jun 2020 02:38:38 -0700
From:   Javed Hasan <jhasan@marvell.com>
To:     <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: [PATCH] scsi: bnx2fc: Removal of unused variables.
Date:   Mon, 22 Jun 2020 02:38:14 -0700
Message-ID: <20200622093814.3250-1-jhasan@marvell.com>
X-Mailer: git-send-email 2.12.0
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-22_03:2020-06-22,2020-06-22 signatures=0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Removed all the unused variables.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index d1d92ae..02f8b38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -635,7 +635,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 	struct bnx2fc_cmd *io_req = NULL;
 	struct bnx2fc_interface *interface = tgt->port->priv;
 	struct bnx2fc_hba *hba = interface->hba;
-	int task_idx, index;
 	int rc = 0;
 	u64 err_warn_bit_map;
 	u8 err_warn = 0xff;
@@ -701,15 +700,12 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 		BNX2FC_TGT_DBG(tgt, "buf_offsets - tx = 0x%x, rx = 0x%x\n",
 			err_entry->data.tx_buf_off, err_entry->data.rx_buf_off);
 
-
 		if (xid > hba->max_xid) {
 			BNX2FC_TGT_DBG(tgt, "xid(0x%x) out of FW range\n",
 				   xid);
 			goto ret_err_rqe;
 		}
 
-		task_idx = xid / BNX2FC_TASKS_PER_PAGE;
-		index = xid % BNX2FC_TASKS_PER_PAGE;
 
 		io_req = (struct bnx2fc_cmd *)hba->cmd_mgr->cmds[xid];
 		if (!io_req)
@@ -833,8 +829,6 @@ static void bnx2fc_process_unsol_compl(struct bnx2fc_rport *tgt, u16 wqe)
 		}
 		BNX2FC_TGT_DBG(tgt, "warn = 0x%x\n", err_warn);
 
-		task_idx = xid / BNX2FC_TASKS_PER_PAGE;
-		index = xid % BNX2FC_TASKS_PER_PAGE;
 		io_req = (struct bnx2fc_cmd *)hba->cmd_mgr->cmds[xid];
 		if (!io_req)
 			goto ret_warn_rqe;
@@ -1007,7 +1001,6 @@ static bool bnx2fc_pending_work(struct bnx2fc_rport *tgt, unsigned int wqe)
 	unsigned char *rq_data = NULL;
 	unsigned char rq_data_buff[BNX2FC_RQ_BUF_SZ];
 	int task_idx, index;
-	unsigned char *dummy;
 	u16 xid;
 	u8 num_rq;
 	int i;
@@ -1037,7 +1030,7 @@ static bool bnx2fc_pending_work(struct bnx2fc_rport *tgt, unsigned int wqe)
 	if (num_rq > 1) {
 		/* We do not need extra sense data */
 		for (i = 1; i < num_rq; i++)
-			dummy = bnx2fc_get_next_rqe(tgt, 1);
+			bnx2fc_get_next_rqe(tgt, 1);
 		}
 
 	if (rq_data)
@@ -1509,7 +1502,6 @@ void bnx2fc_init_seq_cleanup_task(struct bnx2fc_cmd *seq_clnp_req,
 	u64 phys_addr = (u64)orig_io_req->bd_tbl->bd_tbl_dma;
 	u32 orig_offset = offset;
 	int bd_count;
-	int orig_task_idx, index;
 	int i;
 
 	memset(task, 0, sizeof(struct fcoe_task_ctx_entry));
@@ -1559,8 +1551,6 @@ void bnx2fc_init_seq_cleanup_task(struct bnx2fc_cmd *seq_clnp_req,
 				offset; /* adjusted offset */
 		task->txwr_only.sgl_ctx.sgl.mul_sgl.cur_sge_idx = i;
 	} else {
-		orig_task_idx = orig_xid / BNX2FC_TASKS_PER_PAGE;
-		index = orig_xid % BNX2FC_TASKS_PER_PAGE;
 
 		/* Multiple SGEs were used for this IO */
 		sgl = &task->rxwr_only.union_ctx.read_info.sgl_ctx.sgl;
@@ -2088,11 +2078,7 @@ static int bnx2fc_allocate_hash_table(struct bnx2fc_hba *hba)
 	pbl = hba->hash_tbl_pbl;
 	i = 0;
 	while (*pbl && *(pbl + 1)) {
-		u32 lo;
-		u32 hi;
-		lo = *pbl;
 		++pbl;
-		hi = *pbl;
 		++pbl;
 		++i;
 	}
-- 
1.8.3.1

