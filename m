Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9587C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 11:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0B0F21D90
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 11:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727825AbgGNLL7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 07:11:59 -0400
Received: from out1.zte.com.cn ([202.103.147.172]:3532 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbgGNLL7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 07:11:59 -0400
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Jul 2020 07:11:58 EDT
Received: from mse-fl1.zte.com.cn (unknown [10.30.14.238])
        by Forcepoint Email with ESMTPS id 58476E37E1D18590D425;
        Tue, 14 Jul 2020 18:56:24 +0800 (CST)
Received: from notes_smtp.zte.com.cn (notes_smtp.zte.com.cn [10.30.1.239])
        by mse-fl1.zte.com.cn with ESMTP id 06EAuIRN053109;
        Tue, 14 Jul 2020 18:56:18 +0800 (GMT-8)
        (envelope-from wang.yi59@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2020071418563168-4282341 ;
          Tue, 14 Jul 2020 18:56:31 +0800 
From:   Yi Wang <wang.yi59@zte.com.cn>
To:     jejb@linux.ibm.com
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, xue.zhihong@zte.com.cn,
        wang.yi59@zte.com.cn, wang.liang82@zte.com.cn,
        Liao Pingfang <liao.pingfang@zte.com.cn>
Subject: [PATCH] scsi: imm: Remove superfluous breaks
Date:   Tue, 14 Jul 2020 18:59:27 +0800
Message-Id: <1594724367-11593-1-git-send-email-wang.yi59@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2020-07-14 18:56:31,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2020-07-14 18:56:20,
        Serialize complete at 2020-07-14 18:56:20
X-MAIL: mse-fl1.zte.com.cn 06EAuIRN053109
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Liao Pingfang <liao.pingfang@zte.com.cn>

Remove superfluous breaks, as there is a "return" before them.

Signed-off-by: Liao Pingfang <liao.pingfang@zte.com.cn>
Signed-off-by: Yi Wang <wang.yi59@zte.com.cn>
---
 drivers/scsi/imm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 2519fb7..1459b14 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -903,7 +903,6 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			w_ctr(ppb, 0x4);
 		}
 		return 0;	/* Finished */
-		break;
 
 	default:
 		printk("imm: Invalid scsi phase\n");
@@ -969,10 +968,8 @@ static int imm_abort(struct scsi_cmnd *cmd)
 	case 1:		/* Have not connected to interface */
 		dev->cur_cmd = NULL;	/* Forget the problem */
 		return SUCCESS;
-		break;
 	default:		/* SCSI command sent, can not abort */
 		return FAILED;
-		break;
 	}
 }
 
-- 
2.9.5

