From: mike.miller@hp.com
Subject: patch so cciss stats are collected in /proc/stat
Date: Wed, 29 Sep 2004 11:13:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929161345.GB22308@beardog.cca.cpqcorp.net>
Reply-To: mike.miller@hp.com, mikem@beardog.cca.cpqcorp.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palrel12.hp.com ([156.153.255.237]:49382 "EHLO palrel12.hp.com")
	by vger.kernel.org with ESMTP id S268501AbUI2QOM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 12:14:12 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: marcelo.tosatti@cyclades.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, brian.b@hp.com

Currently cciss statistics are not collected in /proc/stat. This patch
bumps DK_MAX_MAJOR to 111 to fix that. This has been a common complaint
by customers wishing to gather info about cciss devices.
Please consider this for inclusion. Applies to 2.4.28-pre3.

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
