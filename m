Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC61EE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 14:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235821AbjHVOdv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 10:33:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233509AbjHVOdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 10:33:51 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC834D7
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 07:33:42 -0700 (PDT)
Received: from canpemm500007.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RVWxS5XLXzTlt7;
        Tue, 22 Aug 2023 22:31:24 +0800 (CST)
Received: from localhost (10.174.179.215) by canpemm500007.china.huawei.com
 (7.192.104.62) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 22 Aug
 2023 22:33:39 +0800
From:   Yue Haibing <yuehaibing@huawei.com>
To:     <skashyap@marvell.com>, <jhasan@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <njavali@marvell.com>,
        <mrangankar@marvell.com>, <yuehaibing@huawei.com>,
        <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH -next] scsi: qed: Remove unused declarations
Date:   Tue, 22 Aug 2023 22:33:38 +0800
Message-ID: <20230822143338.19120-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500007.china.huawei.com (7.192.104.62)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Thes declarations are never implemented, remove them.

Signed-off-by: Yue Haibing <yuehaibing@huawei.com>
---
 drivers/scsi/qedf/qedf.h     | 1 -
 drivers/scsi/qedi/qedi_gbl.h | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf.h b/drivers/scsi/qedf/qedf.h
index c5c0bbdafc4e..1619cc33034f 100644
--- a/drivers/scsi/qedf/qedf.h
+++ b/drivers/scsi/qedf/qedf.h
@@ -548,7 +548,6 @@ extern void qedf_get_generic_tlv_data(void *dev, struct qed_generic_tlvs *data);
 extern void qedf_wq_grcdump(struct work_struct *work);
 void qedf_stag_change_work(struct work_struct *work);
 void qedf_ctx_soft_reset(struct fc_lport *lport);
-extern void qedf_board_disable_work(struct work_struct *work);
 extern void qedf_schedule_hw_err_handler(void *dev,
 		enum qed_hw_err_type err_type);
 
diff --git a/drivers/scsi/qedi/qedi_gbl.h b/drivers/scsi/qedi/qedi_gbl.h
index 0e316cc24b19..772218445a56 100644
--- a/drivers/scsi/qedi/qedi_gbl.h
+++ b/drivers/scsi/qedi/qedi_gbl.h
@@ -67,8 +67,6 @@ void qedi_trace_io(struct qedi_ctx *qedi, struct iscsi_task *task,
 int qedi_alloc_id(struct qedi_portid_tbl *id_tbl, u16 id);
 u16 qedi_alloc_new_id(struct qedi_portid_tbl *id_tbl);
 void qedi_free_id(struct qedi_portid_tbl *id_tbl, u16 id);
-int qedi_create_sysfs_ctx_attr(struct qedi_ctx *qedi);
-void qedi_remove_sysfs_ctx_attr(struct qedi_ctx *qedi);
 void qedi_clearsq(struct qedi_ctx *qedi,
 		  struct qedi_conn *qedi_conn,
 		  struct iscsi_task *task);
-- 
2.34.1

