From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] update scsi_eh_get_sense commentary
Date: Tue, 24 Aug 2004 23:38:27 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824213827.GA27904@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:26024 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S268354AbUHXVic (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 17:38:32 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.79/drivers/scsi/scsi_error.c	2004-06-19 16:47:16 +02:00
+++ edited/drivers/scsi/scsi_error.c	2004-08-24 13:38:13 +02:00
@@ -643,15 +643,13 @@
  * Notes:
  *    This has the unfortunate side effect that if a shost adapter does
  *    not automatically request sense information, that we end up shutting
- *    it down before we request it.  All shosts should be doing this
- *    anyways, so for now all I have to say is tough noogies if you end up
- *    in here.  On second thought, this is probably a good idea.  We
- *    *really* want to give authors an incentive to automatically request
- *    this.
+ *    it down before we request it.
  *
- *    In 2.5 this capability will be going away.
+ *    All drivers should request sense information internally these days,
+ *    so for now all I have to say is tough noogies if you end up in here.
  *
- *    Really?  --hch
+ *    XXX: Long term this code should go away, but that needs an audit of
+ *         all LLDDs first.
  **/
 static int scsi_eh_get_sense(struct list_head *work_q,
 			     struct list_head *done_q)
