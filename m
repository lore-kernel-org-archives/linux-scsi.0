From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] st.c : fix up log messages format
Date: Fri, 3 Nov 2006 01:25:12 -0800 (PST)
Message-ID: <20061103092512.88130.qmail@web31807.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:18784 "HELO
	web31807.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1752367AbWKCJZN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Nov 2006 04:25:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/st.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

That's a very old patch.

    Luben

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 7f96f33..29d7319 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -4072,10 +4072,11 @@ static int st_probe(struct device *dev)
 	disk->number = devfs_register_tape(SDp->devfs_name);
 
 	sdev_printk(KERN_WARNING, SDp,
-		    "Attached scsi tape %s", tape_name(tpnt));
-	printk(KERN_WARNING "%s: try direct i/o: %s (alignment %d B)\n",
-	       tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
-	       queue_dma_alignment(SDp->request_queue) + 1);
+		    "Attached scsi tape %s\n", tape_name(tpnt));
+	sdev_printk(KERN_WARNING, SDp,
+		    "%s: try direct i/o: %s (alignment %d bytes)\n",
+		    tape_name(tpnt), tpnt->try_dio ? "yes" : "no",
+		    queue_dma_alignment(SDp->request_queue) + 1);
 
 	return 0;
 
-- 
1.4.3.3.g6cec


