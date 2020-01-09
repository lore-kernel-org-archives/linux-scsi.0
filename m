Return-Path: <SRS0=Z6Af=26=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC03C32771
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 08:30:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CB9B2072A
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jan 2020 08:30:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgAIIao (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jan 2020 03:30:44 -0500
Received: from smtp.infotech.no ([82.134.31.41]:33900 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbgAIIao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Jan 2020 03:30:44 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id EC632204191;
        Thu,  9 Jan 2020 09:30:40 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id prn6E5iWnJr3; Thu,  9 Jan 2020 09:30:40 +0100 (CET)
Received: from xtwo70.infotech.no (unknown [82.134.31.177])
        by smtp.infotech.no (Postfix) with ESMTPA id A5B58204196;
        Thu,  9 Jan 2020 09:30:40 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC v2 6/6] scsi_debug: bump to version 1.89
Date:   Thu,  9 Jan 2020 09:30:39 +0100
Message-Id: <20200109083039.16582-7-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200109083039.16582-1-dgilbert@interlog.com>
References: <20200109083039.16582-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_debug driver version is visible in:
   /sys/modules/scsi_debug/version
and can thus be used by user space programs to alter the
features they try to use. Since the doublestore option is
a significant addition, bump the version number which
will appear as 0189 when the above file is read.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e140e764dfba..5601d800e7a3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -7,7 +7,7 @@
  *  anything out of the ordinary is seen.
  * ^^^^^^^^^^^^^^^^^^^^^^^ Original ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  *
- * Copyright (C) 2001 - 2018 Douglas Gilbert
+ * Copyright (C) 2001 - 2019 Douglas Gilbert
  *
  *  For documentation see http://sg.danny.cz/sg/sdebug26.html
  */
@@ -57,8 +57,8 @@
 #include "scsi_logging.h"
 
 /* make sure inq_product_rev string corresponds to this version */
-#define SDEBUG_VERSION "0188"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20190125";
+#define SDEBUG_VERSION "0189"	/* format to fit INQUIRY revision field */
+static const char *sdebug_version_date = "20191229";
 
 #define MY_NAME "scsi_debug"
 
-- 
2.24.1

