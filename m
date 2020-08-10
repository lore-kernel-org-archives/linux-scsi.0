Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 668C5C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 09:08:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CB2F20716
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 09:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgHJJIr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 05:08:47 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52743 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgHJJIr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 05:08:47 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1k53nP-0002Kl-HR; Mon, 10 Aug 2020 09:08:43 +0000
From:   Colin King <colin.king@canonical.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: csiostor: fix fix spelling mistake "couldnt" -> "couldn't"
Date:   Mon, 10 Aug 2020 10:08:43 +0100
Message-Id: <20200810090843.49553-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are spelling mistakes in two comments and a csio_err error
message. Fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/csiostor/csio_scsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/csiostor/csio_scsi.c b/drivers/scsi/csiostor/csio_scsi.c
index 00cf33573136..55e74da2f3cb 100644
--- a/drivers/scsi/csiostor/csio_scsi.c
+++ b/drivers/scsi/csiostor/csio_scsi.c
@@ -933,14 +933,14 @@ csio_scsis_aborting(struct csio_ioreq *req, enum csio_scsi_ev evt)
 		 *    abort for that I/O by the FW crossed each other.
 		 *    The FW returned FW_EINVAL. The original I/O would have
 		 *    returned with FW_SUCCESS or any other SCSI error.
-		 * 3. The FW couldnt sent the abort out on the wire, as there
+		 * 3. The FW couldn't sent the abort out on the wire, as there
 		 *    was an I-T nexus loss (link down, remote device logged
 		 *    out etc). FW sent back an appropriate IT nexus loss status
 		 *    for the abort.
 		 * 4. FW sent an abort, but abort timed out (remote device
 		 *    didnt respond). FW replied back with
 		 *    FW_SCSI_ABORT_TIMEDOUT.
-		 * 5. FW couldnt genuinely abort the request for some reason,
+		 * 5. FW couldn't genuinely abort the request for some reason,
 		 *    and sent us an error.
 		 *
 		 * The first 3 scenarios are treated as  succesful abort
@@ -1859,7 +1859,7 @@ csio_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmnd)
 	spin_unlock_irqrestore(&hw->lock, flags);
 
 	if (retval != 0) {
-		csio_err(hw, "ioreq: %p couldnt be started, status:%d\n",
+		csio_err(hw, "ioreq: %p couldn't be started, status:%d\n",
 			 ioreq, retval);
 		CSIO_INC_STATS(scsim, n_busy_error);
 		goto err_put_req;
-- 
2.27.0

