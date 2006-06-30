From: akpm@osdl.org
Subject: [patch 03/22] drivers/scsi/megaraid.c: add a dummy mega_create_proc_entry() for PROC_FS=y
Date: Fri, 30 Jun 2006 02:33:04 -0700
Message-ID: <200606300933.k5U9X4O5001683@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:29075 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932168AbWF3JgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Jun 2006 05:36:22 -0400
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
 1 file changed, 4 insertions(+)

diff -puN drivers/scsi/megaraid.c~drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y drivers/scsi/megaraid.c
--- a/drivers/scsi/megaraid.c~drivers-scsi-megaraidc-add-a-dummy-mega_create_proc_entry-for-proc_fs=y
+++ a/drivers/scsi/megaraid.c
@@ -3180,6 +3180,10 @@ proc_rdrv(adapter_t *adapter, char *page
 
 	return len;
 }
+#else  /*  CONFIG_PROC_FS  */
+
+static inline void
+mega_create_proc_entry(int index, struct proc_dir_entry *parent) {}
 
 #endif
 
_
