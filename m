Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD241C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 12:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8AEF60F35
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 12:47:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240793AbhHJMrc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 08:47:32 -0400
Received: from smtpbg127.qq.com ([109.244.180.96]:47561 "EHLO smtpbg.qq.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238768AbhHJMrc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 08:47:32 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2021 08:47:31 EDT
X-QQ-mid: bizesmtp37t1628599174tyw4pwyz
Received: from localhost.localdomain (unknown [171.223.97.227])
        by esmtp6.qq.com (ESMTP) with 
        id ; Tue, 10 Aug 2021 20:39:32 +0800 (CST)
X-QQ-SSF: 01000000004000B0C000B00A0000000
X-QQ-FEAT: 3pmN80QJYaRFZzPyB0vJaRCgwd6ff8O/hIzko3qChSRzLjuJNa/uNtNGkzPJz
        aKS9lEacsFv34hIDZJVgeJwKxyPrAbtJ+nj5HV2mHPD7pacca2S5jwU3cnLX8N8eDfBQ947
        R6Emozrvk5aV+tafzykQ2m4mK3/mug71GK/SbWXUkybg5kfM6lDG88gew0cL44t3mKp3UI9
        CQHhOSzo0wlgzj0G6s1y7/A7YiIn1o9EXXIaxWFqncVe22n9iIuxdmtVpEcUZY1ZEyqh/Vs
        MT9Ucr85uoGTYJMOOtg4g+rnVXcqt3oMSunaK9WlL6/9wV5MY73Vt/X549aEu82CoAWQ==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     martin.petersen@oracle.com
Cc:     jejb@linux.ibm.com, brking@us.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] scsi: ipr: Remove unneeded semicolon
Date:   Tue, 10 Aug 2021 20:39:19 +0800
Message-Id: <20210810123919.75443-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The semicolon after a code block bracket is unneeded in C. Thus, we can
remove the redundant semicolon from the code safely.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
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
2.32.0

