From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove abort,reset methods from host templates
Date: Tue, 14 Sep 2004 20:25:21 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040914182521.GC16223@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:50824 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S269497AbUINSZY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 14:25:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

Due to the prototype changes they'd been giving warnings since before
2.6.0 was release, it's time to finally kill them.


--- 1.19/include/scsi/scsi_host.h	2004-06-27 00:40:26 +02:00
+++ edited/include/scsi/scsi_host.h	2004-08-29 00:23:48 +02:00
@@ -146,15 +146,6 @@
 	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
 
 	/*
-	 * Old EH handlers, no longer used. Make them warn the user of old
-	 * drivers by using a wrong type
-	 *
-	 * Status: MORE THAN OBSOLETE
-	 */
-	int (* abort)(int);
-	int (* reset)(int, int);
-
-	/*
 	 * Before the mid layer attempts to scan for a new device where none
 	 * currently exists, it will call this entry in your driver.  Should
 	 * your driver need to allocate any structs or perform any other init
