From: Richard Knutsson <ricknu-0@student.ltu.se>
Subject: [PATCH  1/33][SCSI] 3w-xxxx: Convert 'Scsi_Cmnd' to 'struct scsi_cmnd'
Date: Sun, 6 Jan 2008 04:02:55 +0100 (MET)
Message-ID: <20080106030255.30002.6527.sendpatchset@thinktank.campus.ltu.se>
References: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gepetto.dc.ltu.se ([130.240.42.40]:53845 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbYAFDDH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Jan 2008 22:03:07 -0500
In-Reply-To: <20080106030250.30002.96493.sendpatchset@thinktank.campus.ltu.se>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: trivial@kernel.org, kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, Richard Knutsson <ricknu-0@student.ltu.se>

Convert the typedef'ed 'Scsi_Cmnd' to 'struct scsi_cmnd'.

Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
---
Last item before 'drivers/scsi/scsi_typedefs.h' can be removed.


diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index 59716eb..54374e3 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1955,7 +1955,7 @@ static int tw_scsi_queue(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd
 	if (test_bit(TW_IN_RESET, &tw_dev->flags))
 		return SCSI_MLQUEUE_HOST_BUSY;
 
-	/* Save done function into Scsi_Cmnd struct */
+	/* Save done function into scsi_cmnd struct */
 	SCpnt->scsi_done = done;
 		 
 	/* Queue the command and get a request id */
