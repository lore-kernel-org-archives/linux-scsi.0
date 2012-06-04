From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 6/6] bnx2fc: Bumped version to 1.0.12
Date: Mon, 4 Jun 2012 16:15:47 -0700
Message-ID: <1338851747-7240-7-git-send-email-bprakash@broadcom.com>
References: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3589 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761183Ab2FDXQD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jun 2012 19:16:03 -0400
In-Reply-To: <1338851747-7240-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>


Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index baac6e9..5147475 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -63,7 +63,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.11"
+#define BNX2FC_VERSION		"1.0.12"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 2fd7c26..6edd8f6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Apr 24, 2012"
+#define DRV_MODULE_RELDATE	"Jun 04, 2012"
 
 
 static char version[] __devinitdata =
-- 
1.7.0.6


