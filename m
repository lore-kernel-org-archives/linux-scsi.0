From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] NCR5380 unbalanced curly brace
Date: Thu, 06 Feb 2003 14:00:52 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206053821.9AA732C32E@lists.samba.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Marcelo Tosatti <marcelo@conectiva.com.br>

(Included in 2.5)
From:  Geert Uytterhoeven <geert@linux-m68k.org>

  Fix inbalance of curly braces if AUTOSENSE is not defined.
  

--- trivial-2.4.21-pre4/drivers/scsi/NCR5380.c.orig	2003-02-06 13:53:42.000000000 +1100
+++ trivial-2.4.21-pre4/drivers/scsi/NCR5380.c	2003-02-06 13:53:42.000000000 +1100
@@ -2460,8 +2460,9 @@
 						    hostdata->issue_queue;
 						hostdata->issue_queue = (Scsi_Cmnd *) cmd;
 						dprintk(NDEBUG_QUEUES, ("scsi%d : REQUEST SENSE added to head of issue queue\n", instance->host_no));
-					} else {
+					} else
 #endif				/* def AUTOSENSE */
+					{
 						collect_stats(hostdata, cmd);
 						cmd->scsi_done(cmd);
 					}
-- 
  Don't blame me: the Monkey is driving
  File: Geert Uytterhoeven <geert@linux-m68k.org>: [PATCH] NCR5380 unbalanced curly brace
