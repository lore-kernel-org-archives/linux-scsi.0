Return-Path: <SRS0=ICpX=ZG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A954C432C3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 18:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEDE42072C
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Nov 2019 18:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKNSAR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Nov 2019 13:00:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45993 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfKNSAQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2019 13:00:16 -0500
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1iVJPb-00051J-Jk; Thu, 14 Nov 2019 18:00:07 +0000
From:   Colin King <colin.king@canonical.com>
To:     "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Ching Huang <ching2048@areca.com.tw>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: arcmsr: fix indentation issues
Date:   Thu, 14 Nov 2019 18:00:07 +0000
Message-Id: <20191114180007.325856-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There are a few statements that are indented incorrectly, fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 88053b15c363..db687ef8a99e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1400,7 +1400,7 @@ static void arcmsr_drain_donequeue(struct AdapterControlBlock *acb, struct Comma
 				, pCCB->acb
 				, pCCB->startdone
 				, atomic_read(&acb->ccboutstandingcount));
-		  return;
+		return;
 	}
 	arcmsr_report_ccb_state(acb, pCCB, error);
 }
@@ -3476,8 +3476,8 @@ static int arcmsr_hbaC_polling_ccbdone(struct AdapterControlBlock *acb,
 					, pCCB->pcmd->device->id
 					, (u32)pCCB->pcmd->device->lun
 					, pCCB);
-					pCCB->pcmd->result = DID_ABORT << 16;
-					arcmsr_ccb_complete(pCCB);
+				pCCB->pcmd->result = DID_ABORT << 16;
+				arcmsr_ccb_complete(pCCB);
 				continue;
 			}
 			printk(KERN_NOTICE "arcmsr%d: polling get an illegal ccb"
-- 
2.20.1

