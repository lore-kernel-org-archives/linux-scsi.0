Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8784C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Jul 2022 19:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229689AbiGTTw4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Jul 2022 15:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiGTTwz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jul 2022 15:52:55 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 119C35C37C;
        Wed, 20 Jul 2022 12:52:49 -0700 (PDT)
X-QQ-mid: bizesmtp79t1658346761t5xe0b0z
Received: from harry-jrlc.. ( [125.70.163.183])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 21 Jul 2022 03:52:30 +0800 (CST)
X-QQ-SSF: 0100000000200030C000C00A0000020
X-QQ-FEAT: xqT8U4SkSpiEzvjDnymI3vMk/gxgX8PAnf1S86afxsOTUNm9jw6gOv2cXBZer
        zMgF+mzW0dEsycAQxY3SXkXt5w/T0bQf4c8mUIlO7W1vGjSuh/5EwAfgygk9KTVgxR1AQDF
        h6qlnid9cUzpyt1nqrG2r+i69qSFppZ8btxdFgLDS4dnn/ldENkv6KOJpJDYhakje6TkYI4
        F7BpszZDQYi9gfObtpy+yepA+6zgNuo16iRmrkG7sSL1GiGqd07eovytqts4+ekMSmqDWaC
        Q8L9BJpMiuQiq8UpJIgtC3eIdTBdW/jdy/XvO4tAF2a5dq6YYr1/si2rArL+ewjajPHeZ2D
        apFFSjBEik7Viygbs2EHtkkwzNYP+DRj4Kt9wMazTDf1wXkLoQpWXPRSoImBQ==
X-QQ-GoodBg: 0
From:   Xin Gao <gaoxin@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xin Gao <gaoxin@cdjrlc.com>
Subject: [PATCH] scsi:do not initialise statics to 0.
Date:   Thu, 21 Jul 2022 03:52:29 +0800
Message-Id: <20220720195229.9109-1-gaoxin@cdjrlc.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

do not initialise statics to 0.

Signed-off-by: Xin Gao <gaoxin@cdjrlc.com>
---
 drivers/scsi/ch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ch.c b/drivers/scsi/ch.c
index 908854869864..7ab29eaec6f3 100644
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -63,7 +63,7 @@ static int verbose = 1;
 module_param(verbose, int, 0644);
 MODULE_PARM_DESC(verbose,"be verbose (default: on)");
 
-static int debug = 0;
+static int debug;
 module_param(debug, int, 0644);
 MODULE_PARM_DESC(debug,"enable/disable debug messages, also prints more "
 		 "detailed sense codes on scsi errors (default: off)");
-- 
2.30.2

