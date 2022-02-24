Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBFAC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 01:53:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbiBXByH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 20:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiBXByC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 20:54:02 -0500
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D56C225C4B;
        Wed, 23 Feb 2022 17:53:32 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0V5Lhse3_1645663671;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0V5Lhse3_1645663671)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 24 Feb 2022 08:47:52 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kashyap.desai@broadcom.com
Cc:     sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: megasas: clean up some inconsistent indenting
Date:   Thu, 24 Feb 2022 08:47:48 +0800
Message-Id: <20220224004748.59442-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eliminate the follow smatch warning:
drivers/scsi/megaraid/megaraid_sas_fusion.c:5104 megasas_reset_fusion()
warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c72364864bf4..aab600ef4cd6 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -5101,8 +5101,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 				for (j = 0; j < MAX_LOGICAL_DRIVES_EXT; ++j) {
 					memset(fusion->stream_detect_by_ld[j],
 					0, sizeof(struct LD_STREAM_DETECT));
-				 fusion->stream_detect_by_ld[j]->mru_bit_map
-						= MR_STREAM_BITMAP;
+				fusion->stream_detect_by_ld[j]->mru_bit_map
+					= MR_STREAM_BITMAP;
 				}
 			}
 
-- 
2.20.1.7.g153144c

