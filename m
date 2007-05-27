From: "Robert P. J. Day" <rpjday@mindspring.com>
Subject: [PATCH] Remove dead references to MODULE_PARM macro.
Date: Sun, 27 May 2007 14:22:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705271419460.10276@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nic.NetDirect.CA ([216.16.235.2]:40370 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbXE0SYB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 May 2007 14:24:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@SteelEye.com, langa2@kph.uni-mainz.de


Remove the useless references to the obsolete MODULE_PARM macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  just spending a few minutes cleaning the tree of the few remaining
references to MODULE_PARM.


diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 0e57fb6..095a939 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -447,13 +447,6 @@ module_param(boot_options, charp, 0);
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
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
