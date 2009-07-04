From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi_transport_fc: fix kernel-doc param name
Date: Sat, 4 Jul 2009 13:10:41 -0700
Message-ID: <20090704131041.47b0da3b.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:61020 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbZGDUKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jul 2009 16:10:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>

From: Randy Dunlap <randy.dunlap@oracle.com>

Change function parameter name in kernel-doc to match the function's
actual parameter name, to fix 2 kernel-doc warnings.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_transport_fc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- lnx-2631-rc2.orig/drivers/scsi/scsi_transport_fc.c
+++ lnx-2631-rc2/drivers/scsi/scsi_transport_fc.c
@@ -3432,7 +3432,7 @@ fc_bsg_jobdone(struct fc_bsg_job *job)
 
 /**
  * fc_bsg_softirq_done - softirq done routine for destroying the bsg requests
- * @req:        BSG request that holds the job to be destroyed
+ * @rq:        BSG request that holds the job to be destroyed
  */
 static void fc_bsg_softirq_done(struct request *rq)
 {




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
