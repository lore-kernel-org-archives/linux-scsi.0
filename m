From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 4/4] Bumped version to 1.0.11
Date: Wed, 11 Apr 2012 15:54:52 -0700
Message-ID: <1334184892-18419-5-git-send-email-bprakash@broadcom.com>
References: <1334184892-18419-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3498 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761368Ab2DKWzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Apr 2012 18:55:04 -0400
In-Reply-To: <1334184892-18419-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index a4953ef..f2b8875 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -62,7 +62,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.10"
+#define BNX2FC_VERSION		"1.0.11"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 1c34a44..9783b0a 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -22,7 +22,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Jan 22, 2011"
+#define DRV_MODULE_RELDATE	"Apr 11, 2012"
 
 
 static char version[] __devinitdata =
-- 
1.7.0.6


