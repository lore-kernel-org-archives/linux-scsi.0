From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] missing forward declarations in scsi_eh.h
Date: Fri, 4 Jun 2004 14:07:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040604120705.GA32155@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:21918 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265760AbUFDMH3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Jun 2004 08:07:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.1/include/scsi/scsi_eh.h	2003-06-09 00:03:00 +02:00
+++ edited/include/scsi/scsi_eh.h	2004-06-04 13:45:01 +02:00
@@ -1,6 +1,10 @@
 #ifndef _SCSI_SCSI_EH_H
 #define _SCSI_SCSI_EH_H
 
+struct scsi_cmnd;
+struct scsi_device;
+struct Scsi_Host;
+
 extern void scsi_add_timer(struct scsi_cmnd *, int,
 			   void (*)(struct scsi_cmnd *));
 extern int scsi_delete_timer(struct scsi_cmnd *);
