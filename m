From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] remove an unused variable from scsi.c
Date: Mon, 9 Jun 2003 19:51:59 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030609175159.GA2960@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:49039 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S264593AbTFIRiY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jun 2003 13:38:24 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


diff -Nru a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c	Sun Jun  8 22:02:45 2003
+++ b/drivers/scsi/scsi.c	Sun Jun  8 22:02:45 2003
@@ -83,7 +83,6 @@
  * Data declarations.
  */
 unsigned long scsi_pid;
-struct scsi_cmnd *last_cmnd;
 static unsigned long serial_number;
 
 /*
