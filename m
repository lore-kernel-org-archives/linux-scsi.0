From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: [PATCH] typo in 53c700.c
Date: Tue, 11 Feb 2003 13:36:03 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200302111336.03471@bilbo.math.uni-mannheim.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

--- linux-2.5.60/drivers/scsi/53c700.c	Mon Feb 10 19:38:00 2003
+++ linux-2.5.60-eike/drivers/scsi/53c700.c	Tue Feb 11 13:32:44 2003
@@ -1769,7 +1769,7 @@
 	NCR_700_set_depth(SCp->device, NCR_700_get_depth(SCp->device) + 1);
 
 	/* begin the command here */
-	/* no need to check for NULL, test for command_slot_cound above
+	/* no need to check for NULL, test for command_slot_count above
 	 * ensures a slot is free */
 	slot = find_empty_slot(hostdata);
 
