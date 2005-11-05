From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] Documentation: typo in scsi/scsi_eh.txt
Date: Sat, 5 Nov 2005 01:35:05 +0100 (CET)
Message-ID: <200511050035.jA50Zs2t017983@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:62130 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1751373AbVKEAgC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Nov 2005 19:36:02 -0500
Received: from s5r6.in-berlin.de ([62.180.98.151])
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jA50Zs2t017983
	for <linux-scsi@vger.kernel.org>; Sat, 5 Nov 2005 01:35:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

undefined symbol in Documentation/scsi/scsi_eh.txt

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>

--- linux-2.6.14-git3/Documentation/scsi/scsi_eh.txt.orig	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.14-git3/Documentation/scsi/scsi_eh.txt	2005-11-05 01:28:56.000000000 +0100
@@ -83,11 +83,11 @@
  The timeout handler is scsi_times_out().  When a timeout occurs, this
 function
 
- 1. invokes optional hostt->eh_timedout() callback.  Return value can
+ 1. invokes optional hostt->eh_timed_out() callback.  Return value can
     be one of
 
     - EH_HANDLED
-	This indicates that eh_timedout() dealt with the timeout.  The
+	This indicates that eh_timed_out() dealt with the timeout.  The
 	scmd is passed to __scsi_done() and thus linked into per-cpu
 	scsi_done_q.  Normal command completion described in [1-2-1]
 	follows.
@@ -105,7 +105,7 @@
 	command will time out again.
 
     - EH_NOT_HANDLED
-	This is the same as when eh_timedout() callback doesn't exist.
+	This is the same as when eh_timed_out() callback doesn't exist.
 	Step #2 is taken.
 
  2. scsi_eh_scmd_add(scmd, SCSI_EH_CANCEL_CMD) is invoked for the
@@ -142,7 +142,7 @@
  Note that this does not mean lower layers are quiescent.  If a LLDD
 completed a scmd with error status, the LLDD and lower layers are
 assumed to forget about the scmd at that point.  However, if a scmd
-has timed out, unless hostt->eh_timedout() made lower layers forget
+has timed out, unless hostt->eh_timed_out() made lower layers forget
 about the scmd, which currently no LLDD does, the command is still
 active as long as lower layers are concerned and completion could
 occur at any time.  Of course, all such completions are ignored as the

