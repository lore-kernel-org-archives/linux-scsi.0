From: Dave C Boutcher <sleddog@us.ibm.com>
Subject: [patch] ibmvscsi.c: remove max-sectors module parm
Date: Tue, 21 Dec 2004 16:36:45 -0600
Message-ID: <20041221223645.GA2736@cs.umn.edu>
Reply-To: boutcher@cs.umn.edu
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.cs.umn.edu ([128.101.35.202]:28849 "EHLO mail.cs.umn.edu")
	by vger.kernel.org with ESMTP id S261860AbULUWgs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Dec 2004 17:36:48 -0500
Received: from localhost (localhost [127.0.0.1])
	by augustus.cs.umn.edu (Postfix) with ESMTP id B134F5C36D
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 16:36:47 -0600 (CST)
Received: from mail.cs.umn.edu ([127.0.0.1])
 by localhost (augustus [127.0.0.1]) (amavisd-new, port 10024) with LMTP
 id 07085-01-10 for <linux-scsi@vger.kernel.org>;
 Tue, 21 Dec 2004 16:36:46 -0600 (CST)
Received: from tera.cs.umn.edu (tera.cs.umn.edu [128.101.35.163])
	by mail.cs.umn.edu (Postfix) with ESMTP id 4497F5C355
	for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2004 16:36:46 -0600 (CST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Description: Based on comments from Jens Axboe, remove
redundant module parm to set max sectors.  This should
be set through the /dev/block/xxx/queue/max_sectors_kb
interface.  This incremental patch fixes the only comments
received to the previous set of patches submitted.

Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
---

 ibmvscsi.c |    2 --
 1 files changed, 2 deletions(-)

Index: linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c
===================================================================
--- linux-2.6.10-rc3.orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-21 14:11:06.224966784 -0600
+++ linux-2.6.10-rc3/drivers/scsi/ibmvscsi/ibmvscsi.c	2004-12-21 14:11:28.323068472 -0600
@@ -103,8 +103,6 @@
 MODULE_PARM_DESC(init_timeout, "Initialization timeout in seconds");
 module_param_named(max_requests, max_requests, int, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(max_requests, "Maximum requests for this adapter");
-module_param_named(max_sectors, max_sectors, int, S_IRUGO | S_IWUSR);
-MODULE_PARM_DESC(max_sectors, "Maximum sectors per request for this adapter");
 
 /* ------------------------------------------------------------
  * Routines for the event pool and event structs

-- 
Dave Boutcher
