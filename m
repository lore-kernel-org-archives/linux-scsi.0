Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE956C433E1
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1F6F2072D
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 18:29:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729237AbgGLS3i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 14:29:38 -0400
Received: from smtp.infotech.no ([82.134.31.41]:50600 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbgGLS3i (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jul 2020 14:29:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 67653204164;
        Sun, 12 Jul 2020 20:29:36 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id QH0J1U9cOSmS; Sun, 12 Jul 2020 20:29:34 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 5C1A8204259;
        Sun, 12 Jul 2020 20:29:31 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [PATCH 2/2] scsi_debug: update documentation url and bump version
Date:   Sun, 12 Jul 2020 14:29:27 -0400
Message-Id: <20200712182927.72044-3-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200712182927.72044-1-dgilbert@interlog.com>
References: <20200712182927.72044-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This driver maintains a version number which is cross-referenced
in the documentation (e.g. to indicate when features are added or
changed) and exposed through the responses to various SCSI
commands. For example the version number is use as the Product
Revision number in standard SCSI INQUIRY responses issued by this
driver. The version date string is placed in a vendor specific
area in each standard SCSI INQUIRY response. This patch bumps
both.

Update the driver documentation URL that appears at the top of
the driver source file.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index e37df710c623..01d40f6eec20 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -9,7 +9,7 @@
  *
  * Copyright (C) 2001 - 2020 Douglas Gilbert
  *
- *  For documentation see http://sg.danny.cz/sg/sdebug26.html
+ *  For documentation see http://sg.danny.cz/sg/scsi_debug.html
  */
 
 
@@ -60,8 +60,8 @@
 #include "scsi_logging.h"
 
 /* make sure inq_product_rev string corresponds to this version */
-#define SDEBUG_VERSION "0189"	/* format to fit INQUIRY revision field */
-static const char *sdebug_version_date = "20200421";
+#define SDEBUG_VERSION "0190"	/* format to fit INQUIRY revision field */
+static const char *sdebug_version_date = "20200710";
 
 #define MY_NAME "scsi_debug"
 
-- 
2.25.1

