From: akpm@osdl.org
Subject: [patch 1/1] mptctl.c build fix
Date: Sat, 19 Jun 2004 00:23:24 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200406190724.i5J7OGr20720@mail.osdl.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:44470 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261582AbUFSHYU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jun 2004 03:24:20 -0400
List-Id: linux-scsi@vger.kernel.org
To: torvalds@osdl.org
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org



drivers/message/fusion/mptctl.c:89:24: asm/compat.h: No such file or directory

Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 25-akpm/drivers/message/fusion/mptctl.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/message/fusion/mptctl.c~mptctl-build-fix drivers/message/fusion/mptctl.c
--- 25/drivers/message/fusion/mptctl.c~mptctl-build-fix	2004-06-19 00:22:35.220514888 -0700
+++ 25-akpm/drivers/message/fusion/mptctl.c	2004-06-19 00:22:46.612783000 -0700
@@ -83,10 +83,10 @@
 #include <linux/pci.h>
 #include <linux/miscdevice.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <asm/io.h>
 #include <asm/uaccess.h>
-#include <asm/compat.h>
 
 #include <linux/kdev_t.h>	/* needed for access to Scsi_Host struct */
 #include <linux/blkdev.h>
_
