From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] drivers/scsi/arcmsr/arcmsr.c: remove unneeded #include <linux/devfs_fs_kernel.h>
Date: Sat, 11 Jun 2005 22:19:38 +0200
Message-ID: <20050611201938.GN3770@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:56838 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261818AbVFKUTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 11 Jun 2005 16:19:40 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Erich Chen <erich@areca.com.tw>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

This patch removes an unneeded #include.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.12-rc6-mm1-full/drivers/scsi/arcmsr/arcmsr.c.old	2005-06-11 20:58:49.000000000 +0200
+++ linux-2.6.12-rc6-mm1-full/drivers/scsi/arcmsr/arcmsr.c	2005-06-11 20:58:56.000000000 +0200
@@ -101,7 +101,6 @@
 #include <linux/moduleparam.h>
 #include <linux/blkdev.h>
 #include <linux/timer.h>
-#include <linux/devfs_fs_kernel.h>
 #include <linux/mc146818rtc.h>
 #include <linux/reboot.h>
 #include <linux/sched.h>

