From: "Randy.Dunlap" <rdunlap@xenotime.net>
Subject: [PATCH] scsi: 2 drivers need MODULE_LICENSE()
Date: Tue, 13 Sep 2005 21:43:56 -0700
Message-ID: <20050913214356.2e87a579.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:35242 "HELO xenotime.net")
	by vger.kernel.org with SMTP id S932600AbVINEn5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Sep 2005 00:43:57 -0400
Received: from midway ([71.111.157.99]) by xenotime.net for <linux-scsi@vger.kernel.org>; Tue, 13 Sep 2005 21:43:57 -0700
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb <james.bottomley@steeleye.com>
Cc: scsi <linux-scsi@vger.kernel.org>, akpm <akpm@osdl.org>


(this got dropped/lost somewhere)

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
@@ -460,6 +460,8 @@ MODULE_PARM(adisplay, "1i");
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
@@ -1360,3 +1360,5 @@ static Scsi_Host_Template driver_templat
 	.use_clustering 		= DISABLE_CLUSTERING,
 };
 #include "scsi_module.c"
+
+MODULE_LICENSE("GPL");

---
