Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57510C4320A
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3032761055
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhG2IYX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:24:23 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:53064
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235072AbhG2IYV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jul 2021 04:24:21 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id EA4603F0A1;
        Thu, 29 Jul 2021 08:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627547055;
        bh=4FpdAbguBC8R5cT139L5zc/kVvyam5BTMAbPj1jdBX0=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=hcbpJNWmUyVIqVFLHuqY0fVC3WdbJotqSdd+ZimoT+r+AaRIVJWgSvz32l3DTuPgH
         Jbp9eh8GS2aVruIQJPnwB1+c1kI9wLEwz7ht8dv0ILbOa5L6HF/slPK++3NEvCIyPE
         l7minC7JG92OOe25fnysrEVw3mWZk0BU0h0jIFYDqQy6iiWbkjDHSP9LlFBd5X8Iqh
         mstFCmGeP3byPtj3Wdhm5acxFaACv2jl7kXA7JRrIlZSXJsWWqOGlJtH6PLNVMB1/0
         KpJ+udbSqYWfpmz85cOlz2z7D4RUFMTpQfHL9lKM9gqg9GQcXGKvp0tQvVbXWman2i
         Kn/D/luMY3E0w==
From:   Colin King <colin.king@canonical.com>
To:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: qla2xxx: Fix spelling mistakes "allloc" -> "alloc"
Date:   Thu, 29 Jul 2021 09:24:13 +0100
Message-Id: <20210729082413.4761-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are two spelling mistakes with the same triple l in alloc,
one in a comment, the other in a ql_dbg debug message. Fix them.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/qla2xxx/qla_edif.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index ccbe0e1bfcbc..fde410989c03 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -1886,7 +1886,7 @@ qla_edb_node_alloc(scsi_qla_host_t *vha, uint32_t ntype)
 	return node;
 }
 
-/* adds a already alllocated enode to the linked list */
+/* adds a already allocated enode to the linked list */
 static bool
 qla_edb_node_add(scsi_qla_host_t *vha, struct edb_node *ptr)
 {
@@ -2334,7 +2334,7 @@ void qla24xx_auth_els(scsi_qla_host_t *vha, void **pkt, struct rsp_que **rsp)
 	ptr = qla_enode_alloc(vha, N_PUREX);
 	if (!ptr) {
 		ql_dbg(ql_dbg_edif, vha, 0x09109,
-		    "WARNING: enode allloc failed for sid=%x\n",
+		    "WARNING: enode alloc failed for sid=%x\n",
 		    sid);
 		qla_els_reject_iocb(vha, (*rsp)->qpair, &a);
 		__qla_consume_iocb(vha, pkt, rsp);
-- 
2.31.1

