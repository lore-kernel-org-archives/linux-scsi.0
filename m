From: Yi Zou <yi.zou@intel.com>
Subject: [PATCH 6/6] fcoe: setup default initial value for DDP threshold
Date: Tue, 27 Sep 2011 21:38:18 -0700
Message-ID: <20110928043818.13004.60518.stgit@localhost6.localdomain6>
References: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21373 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752333Ab1I1Era (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 00:47:30 -0400
In-Reply-To: <20110928043601.13004.92207.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Vasu Dev <vasu.dev@intel.com>, Yi Zou <yi.zou@intel.com>

From: Vasu Dev <vasu.dev@intel.com>

Currently fcoe_ddp_min doesn't have default value
so by default not used, so setting up default value
as 4k as this works better by avoiding overhead
of programing DDP for small IOs.

Signed-off-by: Vasu Dev <vasu.dev@intel.com>
Tested-by: Ross Brattain <ross.b.brattain@intel.com>
Signed-off-by: Yi Zou <yi.zou@intel.com>
---

 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index cd203d7..430b2cd 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -52,7 +52,7 @@ MODULE_DESCRIPTION("FCoE");
 MODULE_LICENSE("GPL v2");
 
 /* Performance tuning parameters for fcoe */
-static unsigned int fcoe_ddp_min;
+static unsigned int fcoe_ddp_min = 4096;
 module_param_named(ddp_min, fcoe_ddp_min, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(ddp_min, "Minimum I/O size in bytes for "	\
 		 "Direct Data Placement (DDP).");

