From: mikem <mikem@beardog.cca.cpqcorp.net>
Subject: patch for kernel_stats.h, bump DK_MAJOR_MAX for cciss devices
Date: Mon, 23 Aug 2004 16:25:17 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040823212517.GA8811@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S267796AbUHWV1z@vger.kernel.org>
Content-Disposition: inline
To: marcelo.tossati@cyclades.com, axboe.suse.de@beardog.cca.cpqcorp.net
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch bumps DK_MAX_MAJOR to 111 so various cciss statistics can be
collected just they are with SCSI, IDE, etc.
Applies to 2.4.28-pre1. Please consider this for inclusion.

Thanks,
mikem
-------------------------------------------------------------------------------
diff -burNp lx2428-pre1.orig/include/linux/kernel_stat.h lx2428-pre1/include/linux/kernel_stat.h
--- lx2428-pre1.orig/include/linux/kernel_stat.h	2004-08-23 15:41:43.640300000 -0500
+++ lx2428-pre1/include/linux/kernel_stat.h	2004-08-23 15:43:07.097613064 -0500
@@ -12,7 +12,7 @@
  * used by rstatd/perfmeter
  */
 
-#define DK_MAX_MAJOR 16
+#define DK_MAX_MAJOR 111
 #define DK_MAX_DISK 16
 
 struct kernel_stat {
