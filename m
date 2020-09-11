Return-Path: <SRS0=m8O6=CU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48B73C43461
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:11:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 081E12087C
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Sep 2020 09:11:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgIKJLk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Sep 2020 05:11:40 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:12235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725764AbgIKJLj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Sep 2020 05:11:39 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2FC2E6F992C11FCE14EB;
        Fri, 11 Sep 2020 17:11:38 +0800 (CST)
Received: from huawei.com (10.175.127.227) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.487.0; Fri, 11 Sep 2020
 17:11:29 +0800
From:   Jason Yan <yanaijie@huawei.com>
To:     <gotom@debian.or.jp>, <yokota@netlab.is.tsukuba.ac.jp>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     Jason Yan <yanaijie@huawei.com>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH] scsi: nsp32: remove unneeded semicolon
Date:   Fri, 11 Sep 2020 17:10:49 +0800
Message-ID: <20200911091049.2938158-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.127.227]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This addresses the following coccinelle warning:

drivers/scsi/nsp32.c:1250:4-5: Unneeded semicolon
drivers/scsi/nsp32.c:1842:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
---
 drivers/scsi/nsp32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/nsp32.c b/drivers/scsi/nsp32.c
index b6e04d14292d..da814c2da16d 100644
--- a/drivers/scsi/nsp32.c
+++ b/drivers/scsi/nsp32.c
@@ -1247,7 +1247,7 @@ static irqreturn_t do_nsp32_isr(int irq, void *dev_id)
 				 *   ---> AutoSCSI with MSGOUTreg is processed.
 				 */
 				data->msgout_len = 0;
-			};
+			}
 
 			nsp32_dbg(NSP32_DEBUG_INTR, "MsgOut phase processed");
 		}
@@ -1839,7 +1839,7 @@ static void nsp32_msgout_occur(struct scsi_cmnd *SCpnt)
 
 		nsp32_dbg(NSP32_DEBUG_MSGOUTOCCUR, "bus: 0x%x\n",
 			  nsp32_read1(base, SCSI_BUS_MONITOR));
-	};
+	}
 
 	data->msgout_len = 0;
 
-- 
2.25.4

