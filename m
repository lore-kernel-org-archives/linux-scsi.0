From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: [PATCH] IB/srp: Fix typo in source code comment
Date: Fri, 4 Dec 2009 20:20:47 +0100
Message-ID: <200912042020.47763.bart.vanassche@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:47706 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817AbZLDTvS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2009 14:51:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

Fixes a typo in the source-code comments in libsrp.c.

Signed-off-by: Bart Van Assche <bart.vanassche@gmail.com>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

diff --git a/drivers/scsi/libsrp.c b/drivers/scsi/libsrp.c
index 9ad38e8..0fc0aaf 100644
--- a/drivers/scsi/libsrp.c
+++ b/drivers/scsi/libsrp.c
@@ -1,5 +1,5 @@
 /*
- * SCSI RDAM Protocol lib functions
+ * SCSI RDMA Protocol lib functions
  *
  * Copyright (C) 2006 FUJITA Tomonori <tomof@acm.org>
  *
