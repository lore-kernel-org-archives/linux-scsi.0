From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH] scsi: Fix "choir" and "beeing" malaprops
Date: Fri, 3 Oct 2014 11:42:17 +1000 (AEST)
Message-ID: <alpine.LNX.2.00.1410011653440.25690@nippy.intranet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:38955 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752682AbaJCBnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Oct 2014 21:43:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, "Juergen E. Fischer" <fischer@norbit.de>, linux-scsi@vger.kernel.org, trivial@kernel.org


Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

---
 Documentation/scsi/scsi_eh.txt |    4 ++--
 drivers/scsi/aha152x.c         |    2 +-
 drivers/scsi/mac_scsi.c        |    2 +-
 include/scsi/scsi_host.h       |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

Index: linux/Documentation/scsi/scsi_eh.txt
===================================================================
--- linux.orig/Documentation/scsi/scsi_eh.txt	2014-09-29 10:55:44.000000000 +1000
+++ linux/Documentation/scsi/scsi_eh.txt	2014-10-01 16:33:24.000000000 +1000
@@ -172,7 +172,7 @@ ways.
 
  - eh_strategy_handler() callback
 	This is one big callback which should perform whole error
-	handling.  As such, it should do all choirs SCSI midlayer
+	handling.  As such, it should do all chores the SCSI midlayer
 	performs during recovery.  This will be discussed in [2-2].
 
  Once recovery is complete, SCSI EH resumes normal operation by
@@ -428,7 +428,7 @@ scmd->allowed.
 scsi_unjam_host() and it is responsible for whole recovery process.
 On completion, the handler should have made lower layers forget about
 all failed scmds and either ready for new commands or offline.  Also,
-it should perform SCSI EH maintenance choirs to maintain integrity of
+it should perform SCSI EH maintenance chores to maintain integrity of
 SCSI midlayer.  IOW, of the steps described in [2-1-2], all steps
 except for #1 must be implemented by eh_strategy_handler().
 
Index: linux/drivers/scsi/aha152x.c
===================================================================
--- linux.orig/drivers/scsi/aha152x.c	2014-09-29 10:55:44.000000000 +1000
+++ linux/drivers/scsi/aha152x.c	2014-10-01 16:33:24.000000000 +1000
@@ -345,7 +345,7 @@ CMD_INC_RESID(struct scsi_cmnd *cmd, int
 
 enum {
 	not_issued	= 0x0001,	/* command not yet issued */
-	selecting	= 0x0002, 	/* target is beeing selected */
+	selecting	= 0x0002,	/* target is being selected */
 	identified	= 0x0004,	/* IDENTIFY was sent */
 	disconnected	= 0x0008,	/* target disconnected */
 	completed	= 0x0010,	/* target sent COMMAND COMPLETE */ 
Index: linux/drivers/scsi/mac_scsi.c
===================================================================
--- linux.orig/drivers/scsi/mac_scsi.c	2014-10-01 16:32:58.000000000 +1000
+++ linux/drivers/scsi/mac_scsi.c	2014-10-01 16:33:24.000000000 +1000
@@ -360,7 +360,7 @@ const char * macscsi_info (struct Scsi_H
    XXX: Since bus errors in the PDMA routines never happen on my 
    computer, the bus error code is untested. 
    If the code works as intended, a bus error results in Pseudo-DMA 
-   beeing disabled, meaning that the driver switches to slow handshake. 
+   being disabled, meaning that the driver switches to slow handshake.
    If bus errors are NOT extremely rare, this has to be changed. 
 */
 
Index: linux/include/scsi/scsi_host.h
===================================================================
--- linux.orig/include/scsi/scsi_host.h	2014-09-29 10:55:44.000000000 +1000
+++ linux/include/scsi/scsi_host.h	2014-10-01 16:33:24.000000000 +1000
@@ -572,7 +572,7 @@ struct Scsi_Host {
 	 * __devices is protected by the host_lock, but you should
 	 * usually use scsi_device_lookup / shost_for_each_device
 	 * to access it and don't care about locking yourself.
-	 * In the rare case of beeing in irq context you can use
+	 * In the rare case of being in irq context you can use
 	 * their __ prefixed variants with the lock held. NEVER
 	 * access this list directly from a driver.
 	 */
