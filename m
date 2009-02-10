From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 5/5 2.6.29-rc] cxgb3i -- update the driver version to 1.0.1
Date: Mon, 9 Feb 2009 18:10:31 -0800
Message-ID: <200902100210.n1A2AVbG019835@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:8616 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZBJCJV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2009 21:09:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 5/5 2.6.29-rc] cxgb3i -- update the driver version to 1.0.1

From: Karen Xie <kxie@chelsio.com>

Bump the driver version up to 1.0.1.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_init.c b/drivers/scsi/cxgb3i/cxgb3i_init.c
index 091ecb4..fcbf5af 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_init.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_init.c
@@ -12,7 +12,7 @@
 #include "cxgb3i.h"
 
 #define DRV_MODULE_NAME         "cxgb3i"
-#define DRV_MODULE_VERSION	"1.0.0"
+#define DRV_MODULE_VERSION	"1.0.1"
 #define DRV_MODULE_RELDATE	"Jun. 1, 2008"
 
 static char version[] =
