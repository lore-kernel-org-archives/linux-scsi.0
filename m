From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH] SCSI/libsrp: fix typo -- replace RDAM by RDMA
Date: Fri, 4 Dec 2009 20:38:49 +0100
Message-ID: <200912042038.49266.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:46343 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbZLDTit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2009 14:38:49 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Fixed a typo in libsrp.c: replaced two occurrences of 'RDAM' by 'RDMA'.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 9ad38e8..f5bfbc5 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -1,5 +1,5 @@
 /*
- * SCSI RDAM Protocol lib functions
+ * SCSI RDMA Protocol lib functions
  *
  * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
  *
@@ -439,6 +439,6 @@ int srp_cmd_queue(struct Scsi_Host *shost, struct srp_cmd *cmd, void *info,
 }
 EXPORT_SYMBOL_GPL(srp_cmd_queue);
 
-MODULE_DESCRIPTION("SCSI RDAM Protocol lib functions");
+MODULE_DESCRIPTION("SCSI RDMA Protocol lib functions");
 MODULE_AUTHOR("FUJITA Tomonori");
 MODULE_LICENSE("GPL");
