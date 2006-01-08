From: Adrian Bunk <bunk@stusta.de>
Subject: drivers/scsi/megaraid.c: add a dummy mega_create_proc_entry() for PROC_FS=y
Date: Sun, 8 Jan 2006 15:14:34 +0100
Message-ID: <20060108141434.GK3774@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752628AbWAHOOg@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: sju@lsil.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch adds a dummy mega_create_proc_entry() for CONFIG_PROC_FS=n.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.15-mm2-full/drivers/scsi/megaraid.c.old	2006-01-08 11:31:28.000000000 +0100
+++ linux-2.6.15-mm2-full/drivers/scsi/megaraid.c	2006-01-08 11:33:43.000000000 +0100
@@ -3179,6 +3179,10 @@
 
 	return len;
 }
+#else  /*  CONFIG_PROC_FS  */
+
+static inline void
+mega_create_proc_entry(int index, struct proc_dir_entry *parent) {}
 
 #endif
 
