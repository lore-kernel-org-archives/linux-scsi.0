Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC0C6C25B0E
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 15:46:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236485AbiHKPqb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 11:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236354AbiHKPpU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 11:45:20 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBB3F85A83;
        Thu, 11 Aug 2022 08:39:34 -0700 (PDT)
X-QQ-mid: bizesmtp80t1660232370t2k0kspq
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 23:39:24 +0800 (CST)
X-QQ-SSF: 0100000000200060B000B00A0000000
X-QQ-FEAT: DQ0OCu3gog0v2CmrXL5aP554rtncg5anknbV1mQ7QqGeHs/fCaJUaT9f9hsch
        0NRLMAaqVNP1lYZio17nx0kb9Y1/5Tgbcmgx/x5aqKSpg0DLkYwhfOKF23l4vSIekBeOtvq
        XCuCxygvuy+HxycQ8aYpejJMgCWdFcJdTy/5uc0fPwdn5BCVfLtbz7Uq5JXc04uGnCGrz13
        m+QjIkaeqjvEmgYcIwvGi/FVA9FD5ahfipDPvW/yxG0PV2JRYrjqj/vQxq6LNxb/1nsAgiK
        ZchkJuD1E+qX3hzVDYI/5ZJKgH4e5i0XZOtVrknjSmOHpyU/Jp04ombHptTbyAKZmHfJrZ6
        jAj29DN4kevjUSt9loo0SdQFlaLOa0LPcJ50rg1zw1Xek40+yc6VijeK7IzTPLRzEmpc+oV
        NlrEemIJMOw=
X-QQ-GoodBg: 0
From:   Shaomin Deng <dengshaomin@cdjrlc.com>
To:     martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shaomin Deng <dengshaomin@cdjrlc.com>
Subject: [PATCH] scsi: core: Remove repeated word "calling" in target_core_pscsi.c
Date:   Thu, 11 Aug 2022 11:39:23 -0400
Message-Id: <20220811153923.17278-1-dengshaomin@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is repeated word, so remove it.

Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
---
 drivers/target/target_core_pscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index e6a967ddc08c..245912fc209c 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -500,7 +500,7 @@ static int pscsi_configure_device(struct se_device *dev)
 			continue;
 		/*
 		 * Functions will release the held struct scsi_host->host_lock
-		 * before calling calling pscsi_add_device_to_list() to register
+		 * before calling pscsi_add_device_to_list() to register
 		 * struct scsi_device with target_core_mod.
 		 */
 		switch (sd->type) {
-- 
2.35.1

