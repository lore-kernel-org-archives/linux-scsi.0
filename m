Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF60AC43334
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 11:28:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356119AbiFVL2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 07:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351464AbiFVL2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 07:28:10 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6E2CE6F;
        Wed, 22 Jun 2022 04:27:54 -0700 (PDT)
X-QQ-mid: bizesmtp86t1655897202tx041d9n
Received: from ubuntu.localdomain ( [223.104.103.173])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 19:26:36 +0800 (CST)
X-QQ-SSF: 01000000008000B0B000B00A0000000
X-QQ-FEAT: ZHWZeLXy+8dQ4P92o0vLTgxDkCcPa7CHSCaLCem5mT2Di0F36ZMXLTE5DMC70
        SZ8lsdJxYyZsvHQEDeQOOb0YqqoPPPl6oAZMaYYYcQROaFPjJg2emikD3xHrOQl+1ubFE91
        j7HZmiLUGcy83SnoJZ7FcCcW+IAR696512fNC/0tKfqQ7mv3bD+E0wDFdghKsZcNRqfaOKB
        +1fnjl9+qjDciaeO5kV9WspjMLH69CvZg4anZpfOem2wMgxh8sg6e3B5Ov+1mGFlhiVTcKa
        q7M3jQfRNwallc4cRSVXAjMYW2aDPMSCeRZjuMSEeAhrlhwMB4809KGrQnZZ+bBZ6CyuLQ5
        v6d13jF+NbAmkVbVoA3SojUfP8iIW7v8nEO8bvN
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] scsi: lpfc: fix typos in the comments.
Date:   Wed, 22 Jun 2022 19:26:34 +0800
Message-Id: <20220622112634.12313-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Changed unexpected word 'the' to 'that' for more understandable.

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index fb36f26170e4..e70fae75ff03 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2453,7 +2453,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: the index of the fcf record to update
  * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
- * flag so the the round robin slection for the particular priority level
+ * flag so that the round robin slection for the particular priority level
  * will try a different fcf record that does not have this bit set.
  * If the fcf record is re-read for any reason this flag is cleared brfore
  * adding it to the priority list.
-- 
2.17.1

