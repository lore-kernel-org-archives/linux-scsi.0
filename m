From: Mark Haverkamp <markh@linux-foundation.org>
Subject: compile error in NCR_D700
Date: Wed, 24 Jan 2007 09:31:30 -0800
Message-ID: <1169659890.26207.21.camel@markh3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46247 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbXAXRbd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Jan 2007 12:31:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Fix a typo in NCR_D700

Signed-off-by Mark Haverkamp <markh@linux-foundation.org>

---
--- scsi-misc-2.6.orig/drivers/scsi/NCR_D700.c	2007-01-15 09:18:58.000000000 -0800
+++ scsi-misc-2.6/drivers/scsi/NCR_D700.c	2007-01-24 09:27:02.000000000 -0800
@@ -200,7 +200,7 @@
 	hostdata->base = ioport_map(region, 64);
 	hostdata->differential = (((1<<siop) & differential) != 0);
 	hostdata->clock = NCR_D700_CLOCK_MHZ;
-	hostdata->busrt_length = 8;
+	hostdata->burst_length = 8;
 
 	/* and register the siop */
 	host = NCR_700_detect(&NCR_D700_driver_template, hostdata, p->dev);




-- 
Mark Haverkamp <markh@linux-foundation.org>

