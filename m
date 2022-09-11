Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C126C6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 11:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiIKLft (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 07:35:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiIKLfs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 07:35:48 -0400
Received: from bg4.exmail.qq.com (bg4.exmail.qq.com [43.154.221.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252E913F4E;
        Sun, 11 Sep 2022 04:35:46 -0700 (PDT)
X-QQ-mid: bizesmtp71t1662896136te681cum
Received: from localhost.localdomain ( [182.148.14.0])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 11 Sep 2022 19:35:34 +0800 (CST)
X-QQ-SSF: 01000000002000E0G000B00A0000000
X-QQ-FEAT: 96VJ2VzXm/qkMCf6pO+WTNatzwnZzLZ/eUXniWUlonI7jQegF5LF32Scc7yuo
        79D68S0Xe8xIXF1EQOsGhB0M17k5eiybCnES65lDqlyVoZCIdlHSuXZJ6P0PuR9mQ74xfy+
        MM4+Fd6P8nD5UYPFX39dBebPTrgNyXGwzNfoBFjnqPTmMtJvdP4xo7OQySW6kc9SghaUU54
        V7/Bgc6r/DDYk1vm5R6/rIIR7Oc6VBEnyXS2gCeFi5ybgr9xswcAO2iQK5i8Wc/dAvJavyY
        KLbHhvASwUG8jT7mgFUzfg96c34yI+cK+wZGHTQCxwLWg9LaGBfUTirMI+ho07w4ux3emR5
        p4T6UXzOIIioINC3jvEPw2vMUMnzMYAIelMis/78m7VsY7/Snuem8MmuNe8Aw==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] scsi: megaraid_sas: fix repeated words in comments
Date:   Sun, 11 Sep 2022 19:35:27 +0800
Message-Id: <20220911113527.7519-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Delete the redundant word 'be'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 9be4ba61a076..52210d99121c 100644
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
2.36.1

