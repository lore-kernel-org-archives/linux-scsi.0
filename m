Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F26FC43460
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 79DF26115A
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 06:48:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDJGsZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 02:48:25 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:16889 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234367AbhDJGsM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 02:48:12 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FHQWJ4L90zkhq0;
        Sat, 10 Apr 2021 14:46:04 +0800 (CST)
Received: from huawei.com (10.69.192.56) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Sat, 10 Apr 2021
 14:47:45 +0800
From:   Luo Jiaxing <luojiaxing@huawei.com>
To:     <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <shivasharan.srikanteshwara@broadcom.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <megaraidlinux.pdl@broadcom.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        <luojiaxing@huawei.com>
Subject: [PATCH v1 6/8] scsi: megaraid: clean up for code indent
Date:   Sat, 10 Apr 2021 14:48:05 +0800
Message-ID: <1618037287-460-7-git-send-email-luojiaxing@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
References: <1618037287-460-1-git-send-email-luojiaxing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Following error is reported by checkpatch.pl

ERROR: code indent should use tabs where possible
+^I^I        unsigned long arg)$

So fix them all.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
---
 drivers/scsi/megaraid/mega_common.h       | 2 +-
 drivers/scsi/megaraid/megaraid_mm.c       | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/megaraid/mega_common.h b/drivers/scsi/megaraid/mega_common.h
index 2a0981b..9a19eec 100644
--- a/drivers/scsi/megaraid/mega_common.h
+++ b/drivers/scsi/megaraid/mega_common.h
@@ -249,7 +249,7 @@ typedef struct {
  * ### Helper routines ###
  */
 #define LSI_DBGLVL mraid_debug_level	// each LLD must define a global
- 					// mraid_debug_level
+					// mraid_debug_level
 
 #ifdef DEBUG
 #if defined (_ASSERT_PANIC)
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 234885c..1d6244e 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -213,7 +213,7 @@ mraid_mm_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 
 static long
 mraid_mm_unlocked_ioctl(struct file *filep, unsigned int cmd,
-		        unsigned long arg)
+			unsigned long arg)
 {
 	int err;
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2b17529..f29a3716 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4821,7 +4821,7 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 
 	if (!cmd) {
 		dev_warn(&instance->pdev->dev,
-		         "megasas_ld_list_query: Failed to get cmd\n");
+			 "%s: Failed to get cmd\n", __func__);
 		return -ENOMEM;
 	}
 
-- 
2.7.4

