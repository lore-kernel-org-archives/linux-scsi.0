From: Al Viro <viro@ftp.linux.org.uk>
Subject: [PATCH] missing include in megaraid_sas
Date: Tue, 4 Oct 2005 17:36:04 +0100
Message-ID: <20051004163604.GE7992@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964846AbVJDQgI@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

	megaraid_sas depends on arch-specific indirect includes pulling
fs.h in; on alpha they do not.
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
----
diff -urN RC14-rc3-git4-base/drivers/scsi/megaraid/megaraid_sas.c current/drivers/scsi/megaraid/megaraid_sas.c
--- RC14-rc3-git4-base/drivers/scsi/megaraid/megaraid_sas.c	2005-10-04 00:41:36.000000000 -0400
+++ current/drivers/scsi/megaraid/megaraid_sas.c	2005-10-04 02:43:31.000000000 -0400
@@ -34,6 +34,7 @@
 #include <linux/delay.h>
 #include <linux/uio.h>
 #include <asm/uaccess.h>
+#include <linux/fs.h>
 #include <linux/compat.h>
 
 #include <scsi/scsi.h>
