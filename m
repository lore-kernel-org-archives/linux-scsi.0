From: Matthew Whitehead <tedheadster@gmail.com>
Subject: [PATCH] scsi: scsi_scan.c fix formatting
Date: Fri,  4 Oct 2013 14:30:18 -0400
Message-ID: <1380911418-3700-1-git-send-email-tedheadster@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f170.google.com ([209.85.216.170]:44237 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab3JDSab (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Oct 2013 14:30:31 -0400
Received: by mail-qc0-f170.google.com with SMTP id m20so3109744qcx.1
        for <linux-scsi@vger.kernel.org>; Fri, 04 Oct 2013 11:30:30 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Whitehead <tedheadster@gmail.com>

Change output of the form "Sequential scan oftarget7:0:5"
to the more readable "Sequential scan of target7:0:5".

Signed-off-by: Matthew Whitehead <tedheadster@gmail.com>
---
 drivers/scsi/scsi_scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 307a811..3cf21db 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1162,7 +1162,7 @@ static void scsi_sequential_lun_scan(struct scsi_target *starget,
 	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
 
 	SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO "scsi scan: Sequential scan of"
-				    "%s\n", dev_name(&starget->dev)));
+				    " %s\n", dev_name(&starget->dev)));
 
 	max_dev_lun = min(max_scsi_luns, shost->max_lun);
 	/*
-- 
1.7.2.5

