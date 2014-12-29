From: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] scsi: fix scsi_error.c kernel-doc warning
Date: Mon, 29 Dec 2014 09:40:56 -0800
Message-ID: <54A19228.4030308@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:41433 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaL2RlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Dec 2014 12:41:02 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warning in scsi_error.c:

Warning(..//drivers/scsi/scsi_error.c:887): No description found for parameter 'hostt'

Fixes: 883a030f989a17b81167f3a181cf93d741fa98b4
	(scsi: document scsi_try_to_abort_cmd)

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c |    1 +
 1 file changed, 1 insertion(+)

--- lnx-319-rc2.orig/drivers/scsi/scsi_error.c
+++ lnx-319-rc2/drivers/scsi/scsi_error.c
@@ -868,6 +868,7 @@ static int scsi_try_bus_device_reset(str
 
 /**
  * scsi_try_to_abort_cmd - Ask host to abort a SCSI command
+ * @hostt:	SCSI driver host template
  * @scmd:	SCSI cmd used to send a target reset
  *
  * Return value:
