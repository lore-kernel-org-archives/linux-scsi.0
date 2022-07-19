Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83A03CCA479
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 03:28:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbiGSD2B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jul 2022 23:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233966AbiGSD2A (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jul 2022 23:28:00 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C10F26F8;
        Mon, 18 Jul 2022 20:27:55 -0700 (PDT)
X-QQ-mid: bizesmtp68t1658201271ty158g2y
Received: from harry-jrlc.. ( [182.148.15.157])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 19 Jul 2022 11:27:40 +0800 (CST)
X-QQ-SSF: 0100000000000030C000000A0000020
X-QQ-FEAT: ao4JQgu0M3/+OrxY8utf55yQTDv2fm47G55l2I9xGgYO4vclnmm6DOzyP6PKn
        0j07JCw326x/rVgKvqYrzBfY4riT8AG7SSDyMRW+5FK+W3AvJHWJYY3OhuHRbnABslkcOUH
        lgGOOtyeU3JhgAvs++31H9qw9JWMrp0j71Im++isay2noQIuPIde+17wRfa+NhX2ga+cmjt
        SdRaX3NQR3vbCXn+H0qvJHv8gKkc+i9sV+4ZxU2L7aqUsVp+z2lTcFOiGB+RgaXL+tKTL3K
        /Mz1d5EgMohXfZxjSA63h378Cg+B+Atg7O8zuP9fEyekVjsqTzqYHvtjipAU2oOEbhB2mHz
        7UKOE6BPkVFTY2wh1H2nFzX5tAlsm2jl80Djjuo7XqosFUXRHdSgVqLOqA4su/vLf1zW0X9
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] scsi:Unneeded semicolon
Date:   Tue, 19 Jul 2022 11:27:38 +0800
Message-Id: <20220719032738.5325-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unneeded semicolon

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 drivers/scsi/qlogicpti.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 57f2f4135a06..59c82d740139 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1149,7 +1149,7 @@ static struct scsi_cmnd *qlogicpti_intr_handler(struct qlogicpti *qpti)
 		case COMMAND_ERROR:
 		case COMMAND_PARAM_ERROR:
 			break;
-		};
+		}
 		sbus_writew(0, qpti->qregs + SBUS_SEMAPHORE);
 	}
 
-- 
2.30.2

