From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -RESEND/LOST] scsi_transport_fc: fix missing kernel-doc
Date: Mon, 21 Sep 2009 10:51:13 -0700
Message-ID: <20090921105113.d6b62532.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:35715 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbZIURvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2009 13:51:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <James.Bottomley@HansenPartnership.com>, akpm <akpm@linux-foundation.org>

Date: Thu, 18 Jun 2009 19:39:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: scsi <linux-scsi@vger.kernel.org>,  James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi_transport_fc: fix missing kernel-doc
Ref: http://marc.info/?l=linux-scsi&m=124650196316695&w=2


From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing kernel-doc notation in scsi_transport_fc.c:

Warning(drivers/scsi/scsi_transport_fc.c:3593): No description found for parameter 'q'
Warning(drivers/scsi/scsi_transport_fc.c:3700): No description found for parameter 'q'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_transport_fc.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.30-git14.orig/drivers/scsi/scsi_transport_fc.c
+++ linux-2.6.30-git14/drivers/scsi/scsi_transport_fc.c
@@ -3584,6 +3584,7 @@ enum fc_dispatch_result {
 
 /**
  * fc_bsg_host_dispatch - process fc host bsg requests and dispatch to LLDD
+ * @q:		fc host request queue
  * @shost:	scsi host rport attached to
  * @job:	bsg job to be processed
  */
@@ -3690,6 +3691,7 @@ fc_bsg_goose_queue(struct fc_rport *rpor
 
 /**
  * fc_bsg_rport_dispatch - process rport bsg requests and dispatch to LLDD
+ * @q:		rport request queue
  * @shost:	scsi host rport attached to
  * @rport:	rport request destined to
  * @job:	bsg job to be processed




---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
