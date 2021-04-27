Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62CD7C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BF7613FF
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 22:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239522AbhD0WAx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 18:00:53 -0400
Received: from smtp.infotech.no ([82.134.31.41]:38966 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239530AbhD0WAh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Apr 2021 18:00:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 2B813204199;
        Tue, 27 Apr 2021 23:59:49 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dIMAPy0+fqEP; Tue, 27 Apr 2021 23:59:47 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id C4B3C2042AE;
        Tue, 27 Apr 2021 23:59:43 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH v18 83/83] sg: bump version to 4.0.47
Date:   Tue, 27 Apr 2021 17:57:33 -0400
Message-Id: <20210427215733.417746-85-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210427215733.417746-1-dgilbert@interlog.com>
References: <20210427215733.417746-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Version is bumped to > 4.0.30 so test tools is sg3_utils (beta 1.45
revision 827 and later) can distinguish between this full
featured driver and a reduced featured version. The full featured
driver has request sharing and multiple requests (in a single
invocation) support. The reduced featured driver only adds sg v4
interface support and its version numbers
are >= 4.0.00 and < 4.0.30 .

Both versions of the sg v4 driver are described on this webpage:
    https://sg.danny.cz/sg/sg_v40.html

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/sg.c      | 4 ++--
 include/uapi/scsi/sg.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 5328befc0893..f10b252fc091 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -12,8 +12,8 @@
  *
  */
 
-static int sg_version_num = 40012;  /* [x]xyyzz where [x] empty when x=0 */
-#define SG_VERSION_STR "4.0.12"		/* [x]x.[y]y.zz */
+static int sg_version_num = 40047;  /* [x]xyyzz where [x] empty when x=0 */
+#define SG_VERSION_STR "4.0.47"		/* [x]x.[y]y.zz */
 static char *sg_version_date = "20210421";
 
 #include <linux/module.h>
diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
index 871073d1a8d3..22ed1e1ad91e 100644
--- a/include/uapi/scsi/sg.h
+++ b/include/uapi/scsi/sg.h
@@ -14,7 +14,7 @@
  * Later extensions (versions 2, 3 and 4) to driver:
  *   Copyright (C) 1998 - 2021 Douglas Gilbert
  *
- * Version 4.0.12 (20210111)
+ * Version 4.0.46 (20210111)
  *  This version is for Linux 4 and 5 series kernels.
  *
  * Documentation
-- 
2.25.1

