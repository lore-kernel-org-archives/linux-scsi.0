From: akpm@linux-foundation.org
Subject: [patch 06/30] Remove dead references to MODULE_PARM macro
Date: Fri, 10 Aug 2007 14:50:35 -0700
Message-ID: <200708102150.l7ALoZgI011332@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38441 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751792AbXHJVvY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:51:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, rpjday@mindspring.com

From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove the useless references to the obsolete MODULE_PARM macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/ibmmca.c |    7 -------
 1 files changed, 7 deletions(-)

diff -puN drivers/scsi/ibmmca.c~remove-dead-references-to-module_parm-macro drivers/scsi/ibmmca.c
--- a/drivers/scsi/ibmmca.c~remove-dead-references-to-module_parm-macro
+++ a/drivers/scsi/ibmmca.c
@@ -460,13 +460,6 @@ module_param(boot_options, charp, 0);
 module_param_array(io_port, int, NULL, 0);
 module_param_array(scsi_id, int, NULL, 0);
 
-#if 0 /* FIXME: No longer exist? --RR */
-MODULE_PARM(display, "1i");
-MODULE_PARM(adisplay, "1i");
-MODULE_PARM(normal, "1i");
-MODULE_PARM(ansi, "1i");
-#endif
-
 MODULE_LICENSE("GPL");
 #endif
 /*counter of concurrent disk read/writes, to turn on/off disk led */
_
