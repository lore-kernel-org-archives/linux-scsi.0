Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70D07C19F2A
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Aug 2022 15:41:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236211AbiHKPkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Aug 2022 11:40:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236229AbiHKPkS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Aug 2022 11:40:18 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587BC6611A;
        Thu, 11 Aug 2022 08:35:36 -0700 (PDT)
X-QQ-mid: bizesmtp65t1660232128t7vb3wej
Received: from localhost.localdomain ( [110.188.55.240])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 23:34:56 +0800 (CST)
X-QQ-SSF: 0100000000200080H000B00A0000020
X-QQ-FEAT: eSZ1CZgv+JAYe9sMCjBWExPgF7vZS5c1uGr3RzgRWt00ux6K74KDayhMzZpYT
        fHUu1+Gn9v9rGFXhiXOigk1GYKaXmifPrK6Nvp6dkk0oaAM1ZIIIlKSvZGIQzdUpUqJf5lX
        zUiIBqtU1U8kP/CDFzT4SEdP93YTYK4ip4KrinMeYnzybowuAytqn8mdxaTHN0d8peHuqb1
        1bnVHwGblRgT8Lo3zG8nGSEmlxggyLio6JMF99Zh0eAxN9emHYVhAQoRKzDJL0GpkH1DYai
        NzXTXWmlQpWfHlpm+LkbXxyh7ym9kwgSHgxgek5wUqTMf/Jj7sNlIRinVYcO8ymm+LMbuv1
        xiAVraTUQgWNh6j5qR6NMjmIrt7ABpzrcP1Nlrv00AKCree8ELtJNuc23Sd/anXmdy2F2gF
X-QQ-GoodBg: 0
From:   min tang <tangmin@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        min tang <tangmin@cdjrlc.com>
Subject: [PATCH] scsi: Fix comment typo
Date:   Thu, 11 Aug 2022 23:34:44 +0800
Message-Id: <20220811153444.13119-1-tangmin@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The double `only' is duplicated in line 1806, remove one.

Signed-off-by: min tang <tangmin@cdjrlc.com>
---
 drivers/scsi/sd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 749316462075..aae7ec6651e0 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1803,7 +1803,7 @@ static const struct block_device_operations sd_fops = {
  *
  *	This function is called by the SCSI midlayer before starting
  *	SCSI EH. When counting medium access failures we have to be
- *	careful to register it only only once per device and SCSI EH run;
+ *	careful to register it only once per device and SCSI EH run;
  *	there might be several timed out commands which will cause the
  *	'max_medium_access_timeouts' counter to trigger after the first
  *	SCSI EH run already and set the device to offline.
-- 
2.17.1


