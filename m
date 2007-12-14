From: akpm@linux-foundation.org
Subject: [patch 25/30] drivers/scsi/ipr.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Thu, 13 Dec 2007 16:14:27 -0800
Message-ID: <200712140014.lBE0ERCC026252@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53250 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764362AbXLNAV6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 19:21:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, crquan@gmail.com, brking@linux.vnet.ibm.com

From: Denis Cheng <crquan@gmail.com>

Signed-off-by: Denis Cheng <crquan@gmail.com>
Acked-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ipr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/ipr.c~drivers-scsi-iprc-use-list_head-instead-of-list_head_init drivers/scsi/ipr.c
--- a/drivers/scsi/ipr.c~drivers-scsi-iprc-use-list_head-instead-of-list_head_init
+++ a/drivers/scsi/ipr.c
@@ -84,7 +84,7 @@
 /*
  *   Global Data
  */
-static struct list_head ipr_ioa_head = LIST_HEAD_INIT(ipr_ioa_head);
+static LIST_HEAD(ipr_ioa_head);
 static unsigned int ipr_log_level = IPR_DEFAULT_LOG_LEVEL;
 static unsigned int ipr_max_speed = 1;
 static int ipr_testmode = 0;
_
