From: Robert Love <robert.w.love@intel.com>
Subject: [PATCH 5/8] libfcoe: Move FCOE_MTU definition from fcoe.h to libfcoe.h
Date: Fri, 25 Feb 2011 15:03:12 -0800
Message-ID: <20110225230312.9310.49017.stgit@localhost6.localdomain6>
References: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12531 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750Ab1BYXDh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 25 Feb 2011 18:03:37 -0500
In-Reply-To: <20110225230245.9310.81462.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

both fcoe and bnx2fc drivers can access the common definition of
FCOE_MTU.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Robert Love <robert.w.love@intel.com>
---
 drivers/scsi/fcoe/fcoe.h |    6 ------
 include/scsi/libfcoe.h   |    6 ++++++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.h b/drivers/scsi/fcoe/fcoe.h
index d775128..408a6fd 100644
--- a/drivers/scsi/fcoe/fcoe.h
+++ b/drivers/scsi/fcoe/fcoe.h
@@ -40,12 +40,6 @@
 #define FCOE_MIN_XID		0x0000	/* the min xid supported by fcoe_sw */
 #define FCOE_MAX_XID		0x0FFF	/* the max xid supported by fcoe_sw */
 
-/*
- * Max MTU for FCoE: 14 (FCoE header) + 24 (FC header) + 2112 (max FC payload)
- * + 4 (FC CRC) + 4 (FCoE trailer) =  2158 bytes
- */
-#define FCOE_MTU	2158
-
 unsigned int fcoe_debug_logging;
 module_param_named(debug_logging, fcoe_debug_logging, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(debug_logging, "a bit mask of logging levels");
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index e502463..8c1638b 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -33,6 +33,12 @@
 #define FCOE_MAX_CMD_LEN	16	/* Supported CDB length */
 
 /*
+ * Max MTU for FCoE: 14 (FCoE header) + 24 (FC header) + 2112 (max FC payload)
+ * + 4 (FC CRC) + 4 (FCoE trailer) =  2158 bytes
+ */
+#define FCOE_MTU	2158
+
+/*
  * FIP tunable parameters.
  */
 #define FCOE_CTLR_START_DELAY	2000	/* mS after first adv. to choose FCF */

