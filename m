From: akpm@osdl.org
Subject: [patch 05/20] drivers/scsi/megaraid.c: add a dummy mega_create_proc_entry() for PROC_FS=y
Date: Thu, 27 Apr 2006 02:32:59 -0700
Message-ID: <200604270934.k3R9YRP4025442@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:6097 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965036AbWD0Jhn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Apr 2006 05:37:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, bunk@stusta.de, Neela.Kolli@engenio.com


From: Adrian Bunk <bunk@stusta.de>

Add a dummy mega_create_proc_entry() for CONFIG_PROC_FS=n.

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Cc: Neela Syam Kolli <Neela.Kolli@engenio.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/megaraid.c |    4 ++++
 1 files changed, 4 insertions(+)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y drivers/scsi/megaraid.c
--- devel/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y	2006-04-05 21:27:56.000000000 -0700
+++ devel-akpm/drivers/scsi/megaraid.c	2006-04-05 21:27:56.000000000 -0700
@@ -3180,6 +3180,10 @@ proc_rdrv(adapter_t *adapter, char *page
 
 	return len;
 }
+#else  /*  CONFIG_PROC_FS  */
+
+static inline void
+mega_create_proc_entry(int index, struct proc_dir_entry *parent) {}
 
 #endif
 
_
