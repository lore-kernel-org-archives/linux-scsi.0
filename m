From: Andries.Brouwer@cwi.nl
Subject: [PATCH] Re: compile warning g_NCR5380 2.6.0-test6
Date: Tue, 30 Sep 2003 02:28:23 +0200 (MEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <UTC200309300028.h8U0SN116647.aeb@smtp.cwi.nl>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.cwi.nl ([192.16.191.8]:19612 "EHLO hera.cwi.nl")
	by vger.kernel.org with ESMTP id S263058AbTI3Agc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Sep 2003 20:36:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, kevin@zerodivide.de, linux-scsi@vger.kernel.org, torvalds@osdl.org

> `generic_NCR5380_biosparam' declared `static' but never defined

diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
--- a/drivers/scsi/g_NCR5380.c	Sun Sep 28 12:42:14 2003
+++ b/drivers/scsi/g_NCR5380.c	Tue Sep 30 02:13:22 2003
@@ -527,8 +527,9 @@
  *	Locks: none
  */
 
-int generic_NCR5380_biosparam(struct scsi_device *sdev,
-		struct block_device *bdev, sector_t capacity, int *ip)
+static int
+generic_NCR5380_biosparam(struct scsi_device *sdev, struct block_device *bdev,
+			  sector_t capacity, int *ip)
 {
 	ip[0] = 64;
 	ip[1] = 32;
diff -u --recursive --new-file -X /linux/dontdiff a/drivers/scsi/g_NCR5380.h b/drivers/scsi/g_NCR5380.h
--- a/drivers/scsi/g_NCR5380.h	Sun Jun 15 01:41:02 2003
+++ b/drivers/scsi/g_NCR5380.h	Tue Sep 30 02:12:10 2003
@@ -52,7 +52,6 @@
 static int generic_NCR5380_host_reset(Scsi_Cmnd *);
 static int generic_NCR5380_device_reset(Scsi_Cmnd *);
 static const char* generic_NCR5380_info(struct Scsi_Host *);
-static int generic_NCR5380_biosparam(struct scsi_device *, struct block_device *, sector_t, int *);
 
 #ifndef CMD_PER_LUN
 #define CMD_PER_LUN 2
