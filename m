From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Trivial patch for 2.5.71
Date: Mon, 23 Jun 2003 17:14:35 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030623072401.262E42C293@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:31925 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S264115AbTFWHJy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Jun 2003 03:09:54 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@transmeta.com, linux-scsi@vger.kernel.org

From:  Alan Stern <stern@rowland.harvard.edu>

  ===== drivers/scsi/scsi_error.c 1.28 vs edited =====

--- trivial-2.5.73/drivers/scsi/scsi_error.c.orig	2003-06-23 17:04:36.000000000 +1000
+++ trivial-2.5.73/drivers/scsi/scsi_error.c	2003-06-23 17:04:36.000000000 +1000
@@ -1338,7 +1338,7 @@
 
 	if (unlikely(!sreq)) {
 		printk(KERN_ERR "%s: request allocate failed,"
-		       "prevent media removal cmd not sent", __FUNCTION__);
+		       "prevent media removal cmd not sent\n", __FUNCTION__);
 		return;
 	}
 
-- 
  What is this? http://www.kernel.org/pub/linux/kernel/people/rusty/trivial/
  Don't blame me: the Monkey is driving
  File: Alan Stern <stern@rowland.harvard.edu>: Trivial patch for 2.5.71
