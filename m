Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1BC0C38A2D
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Oct 2022 06:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbiJYGAa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Oct 2022 02:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiJYGA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Oct 2022 02:00:29 -0400
Received: from out199-16.us.a.mail.aliyun.com (out199-16.us.a.mail.aliyun.com [47.90.199.16])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA0EEDBE7F;
        Mon, 24 Oct 2022 23:00:26 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0VT1YRYf_1666677621;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0VT1YRYf_1666677621)
          by smtp.aliyun-inc.com;
          Tue, 25 Oct 2022 14:00:22 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     james.smart@broadcom.com
Cc:     dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] scsi: lpfc: clean up some inconsistent indentings
Date:   Tue, 25 Oct 2022 14:00:20 +0800
Message-Id: <20221025060020.20250-1-yang.lee@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

drivers/scsi/lpfc/lpfc_attr.c:1944 lpfc_xcvr_data_show() warn:
inconsistent indenting

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2535
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/scsi/lpfc/lpfc_attr.c | 46 +++++++++++++++--------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 030ad1d59cbd..d7a3496471cd 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1941,33 +1941,25 @@ lpfc_xcvr_data_show(struct device *dev, struct device_attribute *attr,
 			&rdp_context->page_a0[SSF_TRANSCEIVER_CODE_B7];
 
 	len += scnprintf(buf + len, PAGE_SIZE - len, "Speeds: \t");
-		if (*(uint8_t *)trasn_code_byte7 == 0) {
-			len += scnprintf(buf + len, PAGE_SIZE - len,
-					 "Unknown\n");
-		} else {
-			if (trasn_code_byte7->fc_sp_100MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "1 ");
-			if (trasn_code_byte7->fc_sp_200mb)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "2 ");
-			if (trasn_code_byte7->fc_sp_400MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "4 ");
-			if (trasn_code_byte7->fc_sp_800MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "8 ");
-			if (trasn_code_byte7->fc_sp_1600MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "16 ");
-			if (trasn_code_byte7->fc_sp_3200MB)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "32 ");
-			if (trasn_code_byte7->speed_chk_ecc)
-				len += scnprintf(buf + len, PAGE_SIZE - len,
-						 "64 ");
-			len += scnprintf(buf + len, PAGE_SIZE - len, "GB\n");
-		}
+	if (*(uint8_t *)trasn_code_byte7 == 0) {
+		len += scnprintf(buf + len, PAGE_SIZE - len, "Unknown\n");
+	} else {
+		if (trasn_code_byte7->fc_sp_100MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "1 ");
+		if (trasn_code_byte7->fc_sp_200mb)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "2 ");
+		if (trasn_code_byte7->fc_sp_400MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "4 ");
+		if (trasn_code_byte7->fc_sp_800MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "8 ");
+		if (trasn_code_byte7->fc_sp_1600MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "16 ");
+		if (trasn_code_byte7->fc_sp_3200MB)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "32 ");
+		if (trasn_code_byte7->speed_chk_ecc)
+			len += scnprintf(buf + len, PAGE_SIZE - len, "64 ");
+		len += scnprintf(buf + len, PAGE_SIZE - len, "GB\n");
+	}
 	temperature = (rdp_context->page_a2[SFF_TEMPERATURE_B1] << 8 |
 		       rdp_context->page_a2[SFF_TEMPERATURE_B0]);
 	vcc = (rdp_context->page_a2[SFF_VCC_B1] << 8 |
-- 
2.20.1.7.g153144c

