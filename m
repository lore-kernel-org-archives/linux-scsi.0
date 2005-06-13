From: randy_dunlap <rdunlap@xenotime.net>
Subject: [PATCH] scsi: 2 drivers need license
Date: Mon, 13 Jun 2005 12:33:05 -0700
Message-ID: <20050613123305.3e0c56be.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from titan.genwebhost.com ([209.9.226.66]:14272 "EHLO
	titan.genwebhost.com") by vger.kernel.org with ESMTP
	id S261245AbVFMTlB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 15:41:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi <linux-scsi@vger.kernel.org>
Cc: jejb <james.bottomley@steeleye.com>


From: Randy Dunlap <rdunlap@xenotime.net>

Modules need a license to prevent kernel tainting.

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>

diffstat:=
 drivers/scsi/fd_mcs.c |    2 ++
 drivers/scsi/ibmmca.c |    2 ++
 2 files changed, 4 insertions(+)

diff -Naurp ./drivers/scsi/ibmmca.c~taint_scsi ./drivers/scsi/ibmmca.c
--- ./drivers/scsi/ibmmca.c~taint_scsi	2005-03-01 23:37:48.000000000 -0800
+++ ./drivers/scsi/ibmmca.c	2005-06-13 10:44:09.000000000 -0700
@@ -461,6 +461,8 @@ MODULE_PARM(adisplay, "1i");
 MODULE_PARM(normal, "1i");
 MODULE_PARM(ansi, "1i");
 #endif
+
+MODULE_LICENSE("GPL");
 #endif
 /*counter of concurrent disk read/writes, to turn on/off disk led */
 static int disk_rw_in_progress = 0;
diff -Naurp ./drivers/scsi/fd_mcs.c~taint_scsi ./drivers/scsi/fd_mcs.c
--- ./drivers/scsi/fd_mcs.c~taint_scsi	2005-06-13 10:46:57.000000000 -0700
+++ ./drivers/scsi/fd_mcs.c	2005-06-13 10:47:11.000000000 -0700
@@ -1367,3 +1367,5 @@ static Scsi_Host_Template driver_templat
 	.use_clustering 		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
+
+MODULE_LICENSE("GPL");

---
