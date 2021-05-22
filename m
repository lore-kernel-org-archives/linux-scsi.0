Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19BFBC47084
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC0F661402
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 08:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhEVImK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 04:42:10 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4578 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhEVImF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 04:42:05 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FnH0t47v1zsT65;
        Sat, 22 May 2021 16:37:50 +0800 (CST)
Received: from dggemi760-chm.china.huawei.com (10.1.198.146) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi760-chm.china.huawei.com (10.1.198.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Sat, 22 May 2021 16:40:38 +0800
From:   Hui Tang <tanghui20@huawei.com>
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tanghui20@huawei.com>, Nilesh Javali <njavali@marvell.com>
Subject: [PATCH 05/24] scsi: qla2xxx: remove leading spaces before tabs
Date:   Sat, 22 May 2021 16:37:09 +0800
Message-ID: <1621672648-39955-6-git-send-email-tanghui20@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
References: <1621672648-39955-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggemi760-chm.china.huawei.com (10.1.198.146)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are a few leading spaces before tabs and remove it by running
the following commard:

    $ find . -name '*.[ch]' | xargs sed -r -i 's/^[ ]+\t/\t/'

Cc: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Hui Tang <tanghui20@huawei.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |  4 ++--
 drivers/scsi/qla2xxx/qla_mbx.c | 32 ++++++++++++++++----------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index f2d0559..03c248a 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -1032,12 +1032,12 @@ qla2100_fw_dump(scsi_qla_host_t *vha)
 	if (rval == QLA_SUCCESS) {
 		/* Get RISC SRAM. */
 		risc_address = 0x1000;
- 		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_WORD);
+		WRT_MAILBOX_REG(ha, reg, 0, MBC_READ_RAM_WORD);
 		clear_bit(MBX_INTERRUPT, &ha->mbx_cmd_flags);
 	}
 	for (cnt = 0; cnt < ARRAY_SIZE(fw->risc_ram) && rval == QLA_SUCCESS;
 	    cnt++, risc_address++) {
- 		WRT_MAILBOX_REG(ha, reg, 1, risc_address);
+		WRT_MAILBOX_REG(ha, reg, 1, risc_address);
 		wrt_reg_word(&reg->hccr, HCCR_SET_HOST_INT);
 
 		for (timer = 6000000; timer != 0; timer--) {
diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 0bcd8af..1a7891c 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2708,28 +2708,28 @@ qla2x00_login_local_device(scsi_qla_host_t *vha, fc_port_t *fcport,
 		mcp->mb[1] = fcport->loop_id << 8;
 	mcp->mb[2] = opt;
 	mcp->out_mb = MBX_2|MBX_1|MBX_0;
- 	mcp->in_mb = MBX_7|MBX_6|MBX_1|MBX_0;
+	mcp->in_mb = MBX_7|MBX_6|MBX_1|MBX_0;
 	mcp->tov = (ha->login_timeout * 2) + (ha->login_timeout / 2);
 	mcp->flags = 0;
 	rval = qla2x00_mailbox_command(vha, mcp);
 
- 	/* Return mailbox statuses. */
- 	if (mb_ret != NULL) {
- 		mb_ret[0] = mcp->mb[0];
- 		mb_ret[1] = mcp->mb[1];
- 		mb_ret[6] = mcp->mb[6];
- 		mb_ret[7] = mcp->mb[7];
- 	}
+	/* Return mailbox statuses. */
+	if (mb_ret != NULL) {
+		mb_ret[0] = mcp->mb[0];
+		mb_ret[1] = mcp->mb[1];
+		mb_ret[6] = mcp->mb[6];
+		mb_ret[7] = mcp->mb[7];
+	}
 
 	if (rval != QLA_SUCCESS) {
- 		/* AV tmp code: need to change main mailbox_command function to
- 		 * return ok even when the mailbox completion value is not
- 		 * SUCCESS. The caller needs to be responsible to interpret
- 		 * the return values of this mailbox command if we're not
- 		 * to change too much of the existing code.
- 		 */
- 		if (mcp->mb[0] == 0x4005 || mcp->mb[0] == 0x4006)
- 			rval = QLA_SUCCESS;
+		/* AV tmp code: need to change main mailbox_command function to
+		 * return ok even when the mailbox completion value is not
+		 * SUCCESS. The caller needs to be responsible to interpret
+		 * the return values of this mailbox command if we're not
+		 * to change too much of the existing code.
+		 */
+		if (mcp->mb[0] == 0x4005 || mcp->mb[0] == 0x4006)
+			rval = QLA_SUCCESS;
 
 		ql_dbg(ql_dbg_mbx, vha, 0x106b,
 		    "Failed=%x mb[0]=%x mb[1]=%x mb[6]=%x mb[7]=%x.\n",
-- 
2.8.1

