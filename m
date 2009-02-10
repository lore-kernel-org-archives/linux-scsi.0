From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 4/5 2.6.29-rc] cxgb3i - added missing include in cxgb3i_ddp.h
Date: Mon, 9 Feb 2009 18:10:26 -0800
Message-ID: <200902100210.n1A2AQcY019828@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:8631 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbZBJCJD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2009 21:09:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 4/5 2.6.29-rc] cxgb3i - added missing include in cxgb3i_ddp.h

From: Karen Xie <kxie@chelsio.com>

Added missing include file in cxgb3i_ddp.h.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/cxgb3i/cxgb3i_ddp.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.h b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
index 5c7c4d9..99e0b50 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.h
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.h
@@ -13,6 +13,7 @@
 #ifndef __CXGB3I_ULP2_DDP_H__
 #define __CXGB3I_ULP2_DDP_H__
 
+#include <linux/vmalloc.h>
 /**
  * struct cxgb3i_tag_format - cxgb3i ulp tag format for an iscsi entity
  *
