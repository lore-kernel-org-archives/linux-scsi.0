From: John Levon <levon@movementarian.org>
Subject: [PATCH] IPS driver typo
Date: Wed, 26 Feb 2003 18:50:53 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226185053.GA56031@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: ipslinux@adaptec.com


Not tested, against 2.5.63

regards
john


--- linux-linus/drivers/scsi/ips.c	2003-02-25 13:53:55.000000000 +0000
+++ linux/drivers/scsi/ips.c	2003-02-26 18:54:14.000000000 +0000
@@ -2737,7 +2737,7 @@
 
       scb->dcdb.cmd_attribute = ips_command_direction[scb->scsi_cmd->cmnd[0]];
 
-      if (!scb->dcdb.cmd_attribute & 0x3)
+      if (!(scb->dcdb.cmd_attribute & 0x3))
          scb->dcdb.transfer_length = 0;
 
       if (scb->data_len >= IPS_MAX_XFER) {
@@ -3315,7 +3315,7 @@
          scb->dcdb.transfer_length = scb->data_len;
          scb->dcdb.cmd_attribute |= ips_command_direction[scb->scsi_cmd->cmnd[0]];
 
-         if (!scb->dcdb.cmd_attribute & 0x3)
+         if (!(scb->dcdb.cmd_attribute & 0x3))
             scb->dcdb.transfer_length = 0;
 
          if (scb->data_len >= IPS_MAX_XFER) {
