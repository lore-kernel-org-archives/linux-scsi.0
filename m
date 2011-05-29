From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] scsi: fix scsi_proc new kernel-doc warning
Date: Sat, 28 May 2011 17:26:40 -0700
Message-ID: <20110528172640.29a4caea.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:26194 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1E2A0y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 28 May 2011 20:26:54 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: torvalds <torvalds@linux-foundation.org>
Cc: scsi <linux-scsi@vger.kernel.org>, jejbscsi <jbottomley@parallels.com>

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warnings in scsi_proc.c:

Warning(drivers/scsi/scsi_proc.c:390): No description found for parameter 'dev'
Warning(drivers/scsi/scsi_proc.c:390): No description found for parameter 'data'
Warning(drivers/scsi/scsi_proc.c:390): Excess function parameter 's' description in 'always_match'
Warning(drivers/scsi/scsi_proc.c:390): Excess function parameter 'p' description in 'always_match'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/scsi/scsi_proc.c |    5 -----
 1 file changed, 5 deletions(-)

--- linux-2.6.39-git10.orig/drivers/scsi/scsi_proc.c
+++ linux-2.6.39-git10/drivers/scsi/scsi_proc.c
@@ -381,11 +381,6 @@ static ssize_t proc_scsi_write(struct fi
 	return err;
 }
 
-/**
- * proc_scsi_show - show contents of /proc/scsi/scsi (attached devices)
- * @s: output goes here
- * @p: not used
- */
 static int always_match(struct device *dev, void *data)
 {
 	return 1;
