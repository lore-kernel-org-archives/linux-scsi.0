From: Mark Knibbs <markk@clara.co.uk>
Subject: [PATCH] Fix trivial typos in scsi_scan.c comment
Date: Thu, 9 Oct 2014 12:39:40 +0100
Message-ID: <20141009123940.5b385e69e14564dc1c42194a@clara.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [195.8.89.42] ([195.8.89.42]:59904 "EHLO
	claranet-outbound-smtp09.uk.clara.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750858AbaJILlI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Oct 2014 07:41:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

Not much to say really...

Signed-off-by: Mark Knibbs <markk@clara.co.uk>

---
diff -upN linux-3.17/drivers/scsi/scsi_scan.c.orig linux-3.17/drivers/scsi/scsi_scan.c
--- linux-3.17/drivers/scsi/scsi_scan.c.orig	2014-10-05 20:23:04.000000000 +0100
+++ linux-3.17/drivers/scsi/scsi_scan.c	2014-10-09 12:32:53.000000000 +0100
@@ -1191,9 +1191,9 @@ static void scsi_sequential_lun_scan(str
 		sparse_lun = 0;
 
 	/*
-	 * If less than SCSI_1_CSS, and no special lun scaning, stop
+	 * If less than SCSI_1_CCS, and no special lun scanning, stop
 	 * scanning; this matches 2.4 behaviour, but could just be a bug
-	 * (to continue scanning a SCSI_1_CSS device).
+	 * (to continue scanning a SCSI_1_CCS device).
 	 *
 	 * This test is broken.  We might not have any device on lun0 for
 	 * a sparselun device, and if that's the case then how would we
