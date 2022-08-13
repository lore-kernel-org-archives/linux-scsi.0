Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4F7BC25B0F
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Aug 2022 15:39:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239808AbiHMPjN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 13 Aug 2022 11:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiHMPjL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 13 Aug 2022 11:39:11 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B581F25C5E;
        Sat, 13 Aug 2022 08:39:09 -0700 (PDT)
X-QQ-mid: bizesmtp74t1660405136teg4hwd1
Received: from localhost.localdomain ( [110.188.55.240])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 13 Aug 2022 23:38:49 +0800 (CST)
X-QQ-SSF: 0100000000200080H000B00A0000020
X-QQ-FEAT: ILHsT53NKPiNk4bRb0kPAJY/QtGiaRH8J/HzxnHfLoNJrHOFmjgz5qyvD+Be6
        LhMv7Xujrtk3qpUMcO3VZsn0p/WdvprwMS8WlW+vau1Dtzj+jmIXC+nEHA6TSgyjTY1GMEu
        B2dJgjH3eDKbsIvs3YHrXl22+jY3ItrDOhmk+Mq8SdpU47Fzv4ZDLrGCXCw5g6SFjwBalOR
        NS6W8yaLlGJaRx2hNBERxwPDWClcD3z1syLdQrAkNA+XV8nFpj0GeT6CgtSgI06QsGIhoST
        HaRfdmSoxnz9prkE+xq33HZcJ+fZmVhxlbCOycA4frNrEub1RsHgzC5FgviwM54QZoFmuVQ
        0o0nzr7QVRs9mOUaiSbtvLEMldvsO4/XKPwJgLH0pTFrgbKcE4jvi/nDkX66w==
X-QQ-GoodBg: 0
From:   min tang <tangmin@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     brking@us.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, min tang <tangmin@cdjrlc.com>
Subject: [PATCH] scsi: ipr: Unneeded semicolon
Date:   Sat, 13 Aug 2022 23:38:37 +0800
Message-Id: <20220813153837.4938-1-tangmin@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There is no semicolon after '}' in line 1980.

Signed-off-by: min tang <tangmin@cdjrlc.com>
---
 drivers/scsi/ipr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ipr.h b/drivers/scsi/ipr.h
index 69444d21fca1..54e47ce18338 100644
--- a/drivers/scsi/ipr.h
+++ b/drivers/scsi/ipr.h
@@ -1977,7 +1977,7 @@ static inline int ipr_sdt_is_fmt2(u32 sdt_word)
 	case IPR_SDT_FMT2_BAR5_SEL:
 	case IPR_SDT_FMT2_EXP_ROM_SEL:
 		return 1;
-	};
+	}
 
 	return 0;
 }
-- 
2.17.1

