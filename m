From: John Levon <levon@movementarian.org>
Subject: [PATCH] aix7xxx_old typo
Date: Wed, 26 Feb 2003 19:20:29 +0000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030226192029.GA58846@compsoc.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dledford@redhat.com


Untested, against 2.5.63

regards
john


--- linux-linus/drivers/scsi/aic7xxx_old.c	2003-02-25 13:53:55.000000000 +0000
+++ linux/drivers/scsi/aic7xxx_old.c	2003-02-26 19:24:45.000000000 +0000
@@ -10392,7 +10392,7 @@
   aic7xxx_done_cmds_complete(p);
   /* If the command was already complete or just completed, then we didn't
    * do a reset, return FAILED */
-  if(!scb->flags & SCB_ACTIVE)
+  if(!(scb->flags & SCB_ACTIVE))
     return FAILED;
 
   pause_sequencer(p);
@@ -10615,7 +10615,7 @@
   aic7xxx_done_cmds_complete(p);
   /* If the command was already complete or just completed, then we didn't
    * do a reset, return FAILED */
-  if(!scb->flags & SCB_ACTIVE)
+  if(!(scb->flags & SCB_ACTIVE))
     return FAILED;
 
   pause_sequencer(p);
