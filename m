From: Henne <henne@nachtwindheim.de>
Subject: [PATCH] fix legacy megaraid-driver to compile without CONFIG_PROC_FS
Date: Thu, 06 Jul 2006 21:54:02 +0200
Message-ID: <44AD6A5A.5060403@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server6.greatnet.de ([83.133.96.26]:11400 "EHLO
	server6.greatnet.de") by vger.kernel.org with ESMTP
	id S1750787AbWGFTwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:52:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Neela.Kolli@engenio.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@lists.osdl.org

From: Henrik Kretzschmar <henne@nachtwindheim.de>

Create an empty inline function to make the legacy megaraid-driver compile
without PROC_FS.
Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
---

--- linux-2.6.18-rc1/drivers/scsi/megaraid.h    2006-06-18 03:49:35.000000000 +0200
+++ linux/drivers/scsi/megaraid.h       2006-07-06 21:39:59.000000000 +0200
@@ -1039,6 +1039,9 @@
 static int proc_rdrv_30(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv_40(char *, char **, off_t, int, int *, void *);
 static int proc_rdrv(adapter_t *, char *, int, int);
+#else
+static inline void
+mega_create_proc_entry(int index, struct proc_dir_entry *parent) {}
 #endif

 static int mega_adapinq(adapter_t *, dma_addr_t);
