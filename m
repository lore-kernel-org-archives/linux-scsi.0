Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E849C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 13:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234971AbiHKNzi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235268AbiHKNze (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 09:55:34 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C521BE56;
        Thu, 11 Aug 2022 06:55:23 -0700 (PDT)
X-QQ-mid: bizesmtp82t1660226113t8eblv65
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 21:55:11 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000020
X-QQ-FEAT: XC6Q9XtnZK9eJ7YYi5ptnFnj5nBsOi1bu3+p7rqQszYqiyrbWWSgmXV+r7zP0
        eJX+MW3G+5gJdQeJYBCMDmZUu8T64P2Mu55qwvz3HdWm2Bb79bXhWJNhdGNQiIZWejJ0Ks9
        Kib+gdPGRhptque1Xxslm5KORdqhEXj47vdH537vVeTZtVJXzXlLYyS9CUMPPf1NUEvw63o
        OvCuFU7mL4UhR5zhSVyrOifDy/FyRx4mgnJpkZqPX2VWx+0qu9d8ZhaEjXuGcFw8soziRht
        709h2JqxtDN+AVj293pGgtrM64xezGyJxqFF70GfFQS1LPLdK1QILEaEZfUMZkEwHUvOY5J
        UqKb4HxFFJ8mYqbYXyv8rQIy72PBssqZ3suKQ+lxGaI9mUURwX2etWHRcLKG/37AqkUSbXi
        mCu4OSj/5+w=
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     martin.petersen@oracle.com
Cc:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] scsi: lpfc: Fix comment typo
Date:   Thu, 11 Aug 2022 21:55:03 +0800
Message-Id: <20220811135503.23035-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The double `the' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f7cfac0da9b6..7517dd55fe91 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1469,7 +1469,7 @@ lpfc_nvmet_cleanup_io_context(struct lpfc_hba *phba)
 	if (!infop)
 		return;
 
-	/* Cycle the the entire CPU context list for every MRQ */
+	/* Cycle the entire CPU context list for every MRQ */
 	for (i = 0; i < phba->cfg_nvmet_mrq; i++) {
 		for_each_present_cpu(j) {
 			infop = lpfc_get_ctx_list(phba, j, i);
-- 
2.36.1

