Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B1CBC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 15:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbiFUPCI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 11:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241568AbiFUPCI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 11:02:08 -0400
Received: from smtpbg.qq.com (smtpbg136.qq.com [106.55.201.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D16A226AEC;
        Tue, 21 Jun 2022 08:02:01 -0700 (PDT)
X-QQ-mid: bizesmtp90t1655823701tb93jqah
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 23:01:37 +0800 (CST)
X-QQ-SSF: 0100000000700070B000D00A0000000
X-QQ-FEAT: 7zplUpjHcnoyzKgwGO4YsHy8RATQXXCS9QWuYZDM5utjDzLWZet91XhDLB56y
        4JkeNIUNaMKhmFP2tCCUXPln4c8dMKwHjkiNvTBQK6nfGLU5rdgIPaPM58kUMiOAIXqK8iy
        M1cgWiHjwaZa4FYTkZO3ZTJHj92E7hb1waCKiJ901j3MijOlAIoiElbJeUN/WYVNo84p041
        RPJkS8wYd05OLN5IQTJHoonjMBFA0Po8PPhNWQyYr6t1G1zl9PlrkeL+ZszfOqAotiuOcf9
        MJQmqDnCgTKDqYGirhf5YYosL14M55TCbuZF5lguNKyj5KpllBv4A/X8M2q2F+YxXoiNA4u
        TOBNnZrYZbHimy0sjyzBxFcRe+F4w==
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     kartilak@cisco.com, sebaddel@cisco.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] snic: Remove duplicate 'on' in two places.
Date:   Tue, 21 Jun 2022 23:01:36 +0800
Message-Id: <20220621150136.9264-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

file: ./drivers/scsi/snic/snic_fwint.h
line: 148
 * Bit 3: Async event notifications on on tgt online/offline events.
changed to
 * Bit 3: Async event notifications on tgt online/offline events.

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/scsi/snic/snic_fwint.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_fwint.h b/drivers/scsi/snic/snic_fwint.h
index e6b3e8b431c0..2550ba964b03 100644
--- a/drivers/scsi/snic/snic_fwint.h
+++ b/drivers/scsi/snic/snic_fwint.h
@@ -145,7 +145,7 @@ struct snic_exch_ver_req {
  * HBA Capabilities
  * Bit 1: Reserved.
  * Bit 2: Dynamic Discovery of LUNs.
- * Bit 3: Async event notifications on on tgt online/offline events.
+ * Bit 3: Async event notifications on tgt online/offline events.
  * Bit 4: IO timeout support in FW.
  * Bit 5-31: Reserved.
  */
-- 
2.17.1

