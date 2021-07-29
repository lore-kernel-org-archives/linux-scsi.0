Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22040C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:26:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0849161040
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 08:26:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235130AbhG2I0N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Jul 2021 04:26:13 -0400
Received: from mx21.baidu.com ([220.181.3.85]:48818 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234976AbhG2I0M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jul 2021 04:26:12 -0400
Received: from BJHW-Mail-Ex08.internal.baidu.com (unknown [10.127.64.18])
        by Forcepoint Email with ESMTPS id DD1E56CD9CD5C461EE87;
        Thu, 29 Jul 2021 16:26:06 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex08.internal.baidu.com (10.127.64.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 29 Jul 2021 16:26:06 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 29 Jul 2021 16:26:06 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <james.smart@broadcom.com>, <dick.kennedy@broadcom.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] scsi: lpfc: Fix typo in comments
Date:   Thu, 29 Jul 2021 16:25:59 +0800
Message-ID: <20210729082559.1933-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex27.internal.baidu.com (172.31.51.21) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex08_2021-07-29 16:26:07:001
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove the repeated word 'the' from comments

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/scsi/lpfc/lpfc_attr.c    | 10 +++++-----
 drivers/scsi/lpfc/lpfc_els.c     |  2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c |  2 +-
 drivers/scsi/lpfc/lpfc_init.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_mbox.c    |  4 ++--
 drivers/scsi/lpfc/lpfc_nvmet.c   |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c     |  2 +-
 7 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 869c2b6f1515..3745d408a9fd 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2255,7 +2255,7 @@ static inline bool lpfc_rangecheck(uint val, uint min, uint max)
 
 /**
  * lpfc_enable_bbcr_set: Sets an attribute value.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer the adapter structure.
  * @val: integer attribute value.
  *
  * Description:
@@ -2346,7 +2346,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * takes a default argument, a minimum and maximum argument.
  *
  * lpfc_##attr##_init: Initializes an attribute.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer the adapter structure.
  * @val: integer attribute value.
  *
  * Validates the min and max values then sets the adapter config field
@@ -2379,7 +2379,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
  * into a function with the name lpfc_hba_queue_depth_set
  *
  * lpfc_##attr##_set: Sets an attribute value.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer the adapter structure.
  * @val: integer attribute value.
  *
  * Description:
@@ -2508,7 +2508,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * lpfc_##attr##_init: validates the min and max values then sets the
  * adapter config field accordingly, or uses the default if out of range
  * and prints an error message.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer the adapter structure.
  * @val: integer attribute value.
  *
  * Returns:
@@ -2540,7 +2540,7 @@ lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
  * lpfc_##attr##_set: validates the min and max values then sets the
  * adapter config field if in the valid range. prints error message
  * and does not set the parameter if invalid.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer the adapter structure.
  * @val:	integer attribute value.
  *
  * Returns:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 08ae2b12b92c..42568a6507cc 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -7827,7 +7827,7 @@ lpfc_els_rcv_rtv(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
  * @rrq: Pointer to the rrq struct.
  *
  * Build a ELS RRQ command and send it to the target. If the issue_iocb is
- * Successful the the completion handler will clear the RRQ.
+ * Successful the completion handler will clear the RRQ.
  *
  * Return codes
  *   0 - Successfully sent rrq els iocb.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 6da2daf7d9e3..c619a71827b5 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2285,7 +2285,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index: the index of the fcf record to update
  * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
- * flag so the the round robin slection for the particular priority level
+ * flag so the round robin slection for the particular priority level
  * will try a different fcf record that does not have this bit set.
  * If the fcf record is re-read for any reason this flag is cleared brfore
  * adding it to the priority list.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 2c0aaa0a301d..b88f7f3961a0 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -5214,7 +5214,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	bf_set(lpfc_mbx_read_top_link_spd, la,
 	       (bf_get(lpfc_acqe_link_speed, acqe_link)));
 
-	/* Fake the the following irrelvant fields */
+	/* Fake the following irrelvant fields */
 	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
 	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
 	bf_set(lpfc_mbx_read_top_il, la, 0);
@@ -11131,7 +11131,7 @@ lpfc_cpu_affinity_check(struct lpfc_hba *phba, int vectors)
 			/* Mark CPU as IRQ not assigned by the kernel */
 			cpup->flag |= LPFC_CPU_MAP_UNASSIGN;
 
-			/* If so, find a new_cpup thats on the the SAME
+			/* If so, find a new_cpup thats on the SAME
 			 * phys_id as cpup. start_cpu will start where we
 			 * left off so all unassigned entries don't get assgined
 			 * the IRQ of the first entry.
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 6c754ee96bee..7de00701aa35 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2472,7 +2472,7 @@ lpfc_sli4_dump_page_a0(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
  * information via a READ_FCF mailbox command. This mailbox command also is used
  * to indicate where received unsolicited frames from this FCF will be sent. By
  * default this routine will set up the FCF to forward all unsolicited frames
- * the the RQ ID passed in the @phba. This can be overridden by the caller for
+ * the RQ ID passed in the @phba. This can be overridden by the caller for
  * more complicated setups.
  **/
 void
@@ -2540,7 +2540,7 @@ lpfc_reg_fcfi(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
  * information via a READ_FCF mailbox command. This mailbox command also is used
  * to indicate where received unsolicited frames from this FCF will be sent. By
  * default this routine will set up the FCF to forward all unsolicited frames
- * the the RQ ID passed in the @phba. This can be overridden by the caller for
+ * the RQ ID passed in the @phba. This can be overridden by the caller for
  * more complicated setups.
  **/
 void
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index f2d9a3580887..7fb3a0f731fb 100644
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 47dd13719901..75cd05ed15e4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -20156,7 +20156,7 @@ lpfc_log_fw_write_cmpl(struct lpfc_hba *phba, u32 shdr_status,
  * the offset after the write object mailbox has completed. @size is used to
  * determine the end of the object and whether the eof bit should be set.
  *
- * Return 0 is successful and offset will contain the the new offset to use
+ * Return 0 is successful and offset will contain the new offset to use
  * for the next write.
  * Return negative value for error cases.
  **/
-- 
2.25.1

