From: Brian King <brking@us.ibm.com>
Subject: [PATCH 06/10] ipr: Remove debug trace points from dump code
Date: Tue, 21 Nov 2006 10:28:29 -0600
Message-ID: <200611211628.kALGSTtO007039@d03av04.boulder.ibm.com>
References: <11641264771784-patch-mail.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:48101 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S1031057AbWKUQ2c
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Nov 2006 11:28:32 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kALGSUZa011059
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 11:28:30 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kALGSUwx514464
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:30 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kALGSUAR007072
	for <linux-scsi@vger.kernel.org>; Tue, 21 Nov 2006 09:28:30 -0700
In-Reply-To: <11641264771784-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Remove some debug trace points that clutter up the log
when ipr debugging is turned on.

---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    2 --
 1 files changed, 2 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_dump_trace drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_dump_trace	2006-11-15 15:43:12.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-11-15 15:43:12.000000000 -0600
@@ -2969,7 +2969,6 @@ static int ipr_alloc_dump(struct ipr_ioa
 	struct ipr_dump *dump;
 	unsigned long lock_flags = 0;
 
-	ENTER;
 	dump = kzalloc(sizeof(struct ipr_dump), GFP_KERNEL);
 
 	if (!dump) {
@@ -2996,7 +2995,6 @@ static int ipr_alloc_dump(struct ipr_ioa
 	}
 	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
-	LEAVE;
 	return 0;
 }
 
_
