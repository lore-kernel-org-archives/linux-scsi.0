From: Christoph Hellwig <hch@lst.de>
Subject: fix jiffies compare warning in aha152x
Date: Tue, 11 Mar 2003 20:13:26 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030311201326.C986@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org


--- 1.24/drivers/scsi/aha152x.c	Thu Feb 27 04:02:59 2003
+++ edited/drivers/scsi/aha152x.c	Mon Mar 10 14:36:18 2003
@@ -2651,7 +2651,7 @@
 
 static void datai_run(struct Scsi_Host *shpnt)
 {
-	unsigned int the_time;
+	unsigned long the_time;
 	int fifodata, data_count;
 
 	/*
@@ -2793,7 +2793,7 @@
 
 static void datao_run(struct Scsi_Host *shpnt)
 {
-	unsigned int the_time;
+	unsigned long the_time;
 	int data_count;
 
 	/* until phase changes or all data sent */
