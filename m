From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] kill an unused variable in sym2
Date: Mon, 25 Aug 2003 14:45:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030825124505.GA16134@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:33436 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261801AbTHYMpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2003 08:45:08 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: linux-scsi@vger.kernel.org


--- 1.31/drivers/scsi/sym53c8xx_2/sym_glue.c	Wed Aug 13 01:33:45 2003
+++ edited/drivers/scsi/sym53c8xx_2/sym_glue.c	Mon Aug 25 14:33:44 2003
@@ -192,12 +192,6 @@
 }
 #endif
 
-/*
- *  Used to retrieve the host structure when the 
- *  driver is called from the proc FS.
- */
-static struct Scsi_Host	*first_host = NULL;
-
 #define scsi_data_direction(cmd)	(cmd->sc_data_direction)
 
 /*
@@ -1985,12 +1979,6 @@
 	np->s.timer.function = sym53c8xx_timer;
 	np->s.lasttime=0;
 	sym_timer (np);
-
-	/*
-	 *  Done.
-	 */
-        if (!first_host)
-        	first_host = instance;
 
 	/*
 	 *  Fill Linux host instance structure
