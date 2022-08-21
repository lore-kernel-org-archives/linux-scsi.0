Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8523FC00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 14:59:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiHUO7A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 10:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230172AbiHUO66 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 10:58:58 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D9413E32;
        Sun, 21 Aug 2022 07:58:56 -0700 (PDT)
X-QQ-mid: bizesmtp88t1661093925tvxkcjjm
Received: from localhost.localdomain ( [182.148.14.124])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 21 Aug 2022 22:58:44 +0800 (CST)
X-QQ-SSF: 0100000000200010B000B00A0000000
X-QQ-FEAT: znfcQSa1hKbKZkYhV9HDBhW5K8s8OaP5VjlK5FpvfRLvWySaY0EHwSNuttPD9
        HxydUy6qQFVBzKIP3Fvex+/gWEffvpuviO+rNAurpq18QMTuRdkr7EU23DQcFY4lNfXQODg
        W6dKqiu1PlBHJi0oHuuGuBH/VgQ0yiVOVtSTDKw/UK34SBPOWXi6/V2Rk/yKOMenXqJxr/P
        Tm9RqE4ELN7hxNgWrYlz5HOgg4bO3ijoMQes4qzIRPSpWecW4UbPsM8esjL0OMCUMOGbhLP
        ZqEmGnQP2fDJWheLZDLTcpdN2PbabWRs7Sh5QJ6JpZOOaQK34vARl/71XKTxoAA0waS7i5J
        ttkNF5j7TbUIwhFHO6T7AjO/3k8GwDE8TQYpPXFZ6fVOR+KnzY=
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     james.smart@broadcom.com, dick.kennedy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] scsi/lpfc: fix repeated words in comments
Date:   Sun, 21 Aug 2022 22:58:37 +0800
Message-Id: <20220821145837.50480-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

 Delete the redundant word 'on'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 639f86635127..a997cb559ff0 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -240,7 +240,7 @@ lpfc_els_abort(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	if (phba->sli_rev == LPFC_SLI_REV4)
 		spin_lock(&pring->ring_lock);
 	list_for_each_entry_safe(iocb, next_iocb, &pring->txcmplq, list) {
-	/* Add to abort_list on on NDLP match. */
+	/* Add to abort_list on NDLP match. */
 		if (lpfc_check_sli_ndlp(phba, pring, iocb, ndlp))
 			list_add_tail(&iocb->dlist, &abort_list);
 	}
-- 
2.36.1

