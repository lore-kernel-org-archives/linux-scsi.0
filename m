From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 3/4] cxgbi: update driver versions
Date: Fri, 10 Apr 2015 13:57:18 -0700
Message-ID: <201504102057.t3AKvIsx028769@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([67.207.112.58]:3292 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756484AbbDJVAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Apr 2015 17:00:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: kxie@chelsio.com, hch@infradead.org, James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu

Change driver version to follow the same format as other Chelsio drivers.
Added missing release date back to cxgb4i and version string back to libcxgbi.

Signed-off-by: Karen Xie <kxie@chelsio.com>
---
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c |    4 ++--
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c |    5 +++--
 drivers/scsi/cxgbi/libcxgbi.c      |   10 ++++++++--
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
index a9ddddd..5bc15a4 100644
--- a/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
+++ b/drivers/scsi/cxgbi/cxgb3i/cxgb3i.c
@@ -32,8 +32,8 @@ static unsigned int dbg_level;
 
 #define DRV_MODULE_NAME         "cxgb3i"
 #define DRV_MODULE_DESC         "Chelsio T3 iSCSI Driver"
-#define DRV_MODULE_VERSION	"2.0.0"
-#define DRV_MODULE_RELDATE	"Jun. 2010"
+#define DRV_MODULE_VERSION	"2.0.1-ko"
+#define DRV_MODULE_RELDATE	"Apr. 2015"
 
 static char version[] =
 	DRV_MODULE_DESC " " DRV_MODULE_NAME
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index fabd365..dc495a4 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -36,11 +36,12 @@ static unsigned int dbg_level;
 
 #define	DRV_MODULE_NAME		"cxgb4i"
 #define DRV_MODULE_DESC		"Chelsio T4/T5 iSCSI Driver"
-#define	DRV_MODULE_VERSION	"0.9.4"
+#define	DRV_MODULE_VERSION	"0.9.5-ko"
+#define DRV_MODULE_RELDATE	"Apr. 2015"
 
 static char version[] =
 	DRV_MODULE_DESC " " DRV_MODULE_NAME
-	" v" DRV_MODULE_VERSION "\n";
+	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 MODULE_AUTHOR("Chelsio Communications, Inc.");
 MODULE_DESCRIPTION(DRV_MODULE_DESC);
diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index f4cfa1e..241ef19 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -38,8 +38,12 @@ static unsigned int dbg_level;
 
 #define DRV_MODULE_NAME		"libcxgbi"
 #define DRV_MODULE_DESC		"Chelsio iSCSI driver library"
-#define DRV_MODULE_VERSION	"0.9.0"
-#define DRV_MODULE_RELDATE	"Jun. 2010"
+#define DRV_MODULE_VERSION	"0.9.1-ko"
+#define DRV_MODULE_RELDATE	"Apr. 2015"
+
+static char version[] =
+	DRV_MODULE_DESC " " DRV_MODULE_NAME
+	" v" DRV_MODULE_VERSION " (" DRV_MODULE_RELDATE ")\n";
 
 MODULE_AUTHOR("Chelsio Communications, Inc.");
 MODULE_DESCRIPTION(DRV_MODULE_DESC);
@@ -2913,6 +2917,8 @@ static int __init libcxgbi_init_module(void)
 	sw_tag_idx_bits = (__ilog2_u32(ISCSI_ITT_MASK)) + 1;
 	sw_tag_age_bits = (__ilog2_u32(ISCSI_AGE_MASK)) + 1;
 
+	pr_info("%s", version);
+
 	pr_info("tag itt 0x%x, %u bits, age 0x%x, %u bits.\n",
 		ISCSI_ITT_MASK, sw_tag_idx_bits,
 		ISCSI_AGE_MASK, sw_tag_age_bits);
