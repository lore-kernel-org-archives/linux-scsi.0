Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7CFC25B0C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 15:12:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiHKPMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 11:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiHKPMd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 11:12:33 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC3667B793;
        Thu, 11 Aug 2022 08:12:27 -0700 (PDT)
X-QQ-mid: bizesmtp83t1660230728t7q7362u
Received: from localhost.localdomain ( [110.188.55.240])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 23:11:58 +0800 (CST)
X-QQ-SSF: 0100000000200070H000B00A0000020
X-QQ-FEAT: UMQM+3VOEYsTPC6jMH0yz2i4V+oZLsGcQU83QUJxmWPROYvQZ4BMGwaf+LtgI
        7CDKQfi+bB1csRp6nSTxoQx8kG1V9KxQmeH5BiOi6CS9Ol/0gDnq+ixD2kfsqM7Im1XBhWz
        kMhcstK/vS4TqTFK9ARDHWWu/sLQG5VdWgGg0IcvIArQdg8463bTMzR/7Eo7uMempJ2/ke3
        nKVqvori/Egh+PIrtf3WhXTZJ9FlOaQrSJt6K0J8ZEpWVKGDYvziHQW1dCPeu5BQx9T8FPt
        aWyrnzJuO5mKnhX/cakL6fZ3p2VjveNskSCfqkGKNwP0O39midPA76BJ5ztNxQdcXcS5dqX
        HuvjhPpQPAdXH/e5qVbSzwLRfuH+PP9qFzXGU4TLqxZdVNBEDAxOgrmnew40w==
X-QQ-GoodBg: 0
From:   min tang <tangmin@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     hare@suse.de, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, min tang <tangmin@cdjrlc.com>
Subject: [PATCH] scsi: Fix comment typo
Date:   Thu, 11 Aug 2022 23:11:46 +0800
Message-Id: <20220811151146.12677-1-tangmin@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The double `the' is duplicated in line 208, remove one.

Signed-off-by: min tang <tangmin@cdjrlc.com>
---
 drivers/scsi/fcoe/fcoe_ctlr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 39e16eab47aa..28e8b9f1e1a4 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -205,7 +205,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 		 * that doesn't have a priv (fcf was deleted). However,
 		 * libfcoe will always delete FCFs before trying to add
 		 * them. This is ensured because both recv_adv and
-		 * age_fcfs are protected by the the fcoe_ctlr's mutex.
+		 * age_fcfs are protected by the fcoe_ctlr's mutex.
 		 * This means that we should never get a FCF with a
 		 * non-NULL priv pointer.
 		 */
-- 
2.17.1

