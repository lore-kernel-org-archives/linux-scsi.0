From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATHC 2.5.62] typo in 53c700.c
Date: Tue, 18 Feb 2003 13:32:43 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302181332.43808@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

diff -Naur linux-2.5.62/drivers/scsi/53c700.c linux-2.5.62-eike/drivers/scsi/53c700.c
--- linux-2.5.62/drivers/scsi/53c700.c	Mon Feb 17 23:55:57 2003
+++ linux-2.5.62-eike/drivers/scsi/53c700.c	Tue Feb 18 12:49:11 2003
@@ -1769,7 +1769,7 @@
 	NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);
 
 	/* begin the command here */
-	/* no need to check for NULL, test for command_slot_cound above
+	/* no need to check for NULL, test for command_slot_count above
 	 * ensures a slot is free */
 	slot = find_empty_slot(hostdata);
 
