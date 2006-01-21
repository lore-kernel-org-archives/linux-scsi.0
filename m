From: Adrian Bunk <bunk@stusta.de>
Subject: drivers/scsi/megaraid.c: add a dummy mega_create_proc_entry() for PROC_FS=y
Date: Sat, 21 Jan 2006 20:44:16 +0100
Message-ID: <20060121194416.GV31803@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:57609 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S932302AbWAUToR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jan 2006 14:44:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: sju@lsil.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch adds a dummy mega_create_proc_entry() for CONFIG_PROC_FS=n.


Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

This patch was already sent on:
- 8 Jan 2006

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
 

