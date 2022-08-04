Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142B7C19F2B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Aug 2022 12:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239656AbiHDMJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Aug 2022 08:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbiHDMJ2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Aug 2022 08:09:28 -0400
Received: from bg5.exmail.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A7A51A0E;
        Thu,  4 Aug 2022 05:09:27 -0700 (PDT)
X-QQ-mid: bizesmtp89t1659614955tbc9z673
Received: from localhost.localdomain ( [182.148.15.41])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 04 Aug 2022 20:09:13 +0800 (CST)
X-QQ-SSF: 01000000008000F0U000B00A0000020
X-QQ-FEAT: zT6n3Y95oi36ac8W/ajpseDSN2k/mvuSYYNCi980UU/EI34PLtAzm9rsUaP+R
        ib4cdvZOkbgB1b7zM7lGKz+iiOBe3g6lvnPSN5BNB8k+/rYEm2D0JLyERAj87FktZMmpPW9
        +u7hs185y4uvWWO7L2VguTuQazPhF1XxJZJmd9xZTh2/leh72hf72ZcMckI0KqWI8FcyDBb
        EQ1WuKmV1ETbP980WKyoOpN6KCmUPfMr3CdxYQmuH3HEME5qOfoswLPEK7ICcaTsxdIupFc
        ny4J64oTbeH5MZZ938QO1UP+kfkoMAgNZNBmJryPPnHYikTubCzV4uaPmmvDBg4dLGAVZ2m
        qIx1Wl/U8PpkB2079VD2c7PmwuyCvbB+Dg9DjyvKnhbCiDnKlHbGWs7Pb+5IA2nrWX3W9Z/
        GgnRMVrF6hY=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     sumit.saxena@broadcom.com
Cc:     kashyap.desai@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] scsi: megaraid: Fix comment typo
Date:   Thu,  4 Aug 2022 20:09:11 +0800
Message-Id: <20220804120911.61806-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The double `be' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index a3e117a4b8e7..aec33fa565d4 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2823,7 +2823,7 @@ static int megasas_wait_for_outstanding(struct megasas_instance *instance)
 			       "commands to complete\n",i,outstanding);
 			/*
 			 * Call cmd completion routine. Cmd to be
-			 * be completed directly without depending on isr.
+			 * completed directly without depending on isr.
 			 */
 			megasas_complete_cmd_dpc((unsigned long)instance);
 		}
-- 
2.35.1

