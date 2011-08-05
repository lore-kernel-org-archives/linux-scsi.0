From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH v2 18/18] bnx2fc: Bump version to 1.0.5
Date: Thu, 4 Aug 2011 17:38:52 -0700
Message-ID: <1312504732-4572-19-git-send-email-bprakash@broadcom.com>
References: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4920 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756086Ab1HEAjV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Aug 2011 20:39:21 -0400
In-Reply-To: <1312504732-4572-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, mchan@broadcom.com, robert.w.love@intel.com, devel@open-fcoe.org, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 42228ca..903e8f6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -62,7 +62,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.4"
+#define BNX2FC_VERSION		"1.0.5"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 351ca4c..e6c9879 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Jun 23, 2011"
+#define DRV_MODULE_RELDATE	"Aug 03, 2011"
 
 
 static char version[] __devinitdata =
-- 
1.7.0.6


