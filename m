From: Denis Cheng <crquan@gmail.com>
Subject: [PATCH 10/20] drivers/scsi/ipr.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu,  6 Dec 2007 23:21:30 +0800
Message-ID: <1196954490-5516-1-git-send-email-crquan@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.186]:34089 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXLFPYb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Dec 2007 10:24:31 -0500
Received: by rv-out-0910.google.com with SMTP id k20so292724rvb
        for <linux-scsi@vger.kernel.org>; Thu, 06 Dec 2007 07:24:30 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org

single list_head variable initialized with LIST_HEAD_INIT could almost
always can be replaced with LIST_HEAD declaration, this shrinks the code
and looks better.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/scsi/ipr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 0841df0..9018ee8 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -84,7 +84,7 @@
 /*
  *   Global Data
  */
-static struct list_head ipr_ioa_head = LIST_HEAD_INIT(ipr_ioa_head);
+static LIST_HEAD(ipr_ioa_head);
 static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
-- 
1.5.3.4

