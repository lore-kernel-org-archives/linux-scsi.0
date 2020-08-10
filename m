Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B05C433DF
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 08:51:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B30120748
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 08:51:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbgHJIvC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 04:51:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52438 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbgHJIvB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 04:51:01 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k53WD-0000zR-Q8; Mon, 10 Aug 2020 08:50:57 +0000
From:   Colin King <colin.king@canonical.com>
To:     QLogic-Storage-Upstream@qlogic.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: bnx2fc: fix spelling mistake "couldnt" -> "couldn't"
Date:   Mon, 10 Aug 2020 09:50:57 +0100
Message-Id: <20200810085057.49039-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in various printk messages. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1aba5897ccb0..1a0dc18d6915 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -864,7 +864,7 @@ int bnx2fc_initiate_abts(struct bnx2fc_cmd *io_req)
 
 	abts_io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_ABTS);
 	if (!abts_io_req) {
-		printk(KERN_ERR PFX "abts: couldnt allocate cmd\n");
+		printk(KERN_ERR PFX "abts: couldn't allocate cmd\n");
 		rc = FAILED;
 		goto abts_err;
 	}
@@ -957,7 +957,7 @@ int bnx2fc_initiate_seq_cleanup(struct bnx2fc_cmd *orig_io_req, u32 offset,
 
 	seq_clnp_req = bnx2fc_elstm_alloc(tgt, BNX2FC_SEQ_CLEANUP);
 	if (!seq_clnp_req) {
-		printk(KERN_ERR PFX "cleanup: couldnt allocate cmd\n");
+		printk(KERN_ERR PFX "cleanup: couldn't allocate cmd\n");
 		rc = -ENOMEM;
 		kfree(cb_arg);
 		goto cleanup_err;
@@ -1015,7 +1015,7 @@ int bnx2fc_initiate_cleanup(struct bnx2fc_cmd *io_req)
 
 	cleanup_io_req = bnx2fc_elstm_alloc(tgt, BNX2FC_CLEANUP);
 	if (!cleanup_io_req) {
-		printk(KERN_ERR PFX "cleanup: couldnt allocate cmd\n");
+		printk(KERN_ERR PFX "cleanup: couldn't allocate cmd\n");
 		rc = -1;
 		goto cleanup_err;
 	}
-- 
2.27.0

