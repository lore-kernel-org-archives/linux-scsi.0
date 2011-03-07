From: "Michael Chan" <mchan@broadcom.com>
Subject: [PATCH 6/6] [SCSI] bnx2fc: Bump version to 1.0.1
Date: Mon, 7 Mar 2011 15:42:29 -0800
Message-ID: <1299541349-2438-6-git-send-email-mchan@broadcom.com>
References: <1299541349-2438-1-git-send-email-mchan@broadcom.com>
 <1299541349-2438-2-git-send-email-mchan@broadcom.com>
 <1299541349-2438-3-git-send-email-mchan@broadcom.com>
 <1299541349-2438-4-git-send-email-mchan@broadcom.com>
 <1299541349-2438-5-git-send-email-mchan@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4223 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab1CHAgm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Mar 2011 19:36:42 -0500
In-Reply-To: <1299541349-2438-5-git-send-email-mchan@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: linux-scsi@vger.kernel.org, devel@open-fcoe.org, michaelc@cs.wisc.edu, bprakash@broadcom.com, nsujir@broadcom.com, Michael Chan <mchan@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Michael Chan <mchan@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h      |    2 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 52057fa..2fba24c 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -62,7 +62,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"1.0.0"
+#define BNX2FC_VERSION		"1.0.1"
 
 #define PFX			"bnx2fc: "
 
diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index b3afaf2..c1f8932 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -21,7 +21,7 @@ DEFINE_PER_CPU(struct bnx2fc_percpu_s, bnx2fc_percpu);
 
 #define DRV_MODULE_NAME		"bnx2fc"
 #define DRV_MODULE_VERSION	BNX2FC_VERSION
-#define DRV_MODULE_RELDATE	"Jan 25, 2011"
+#define DRV_MODULE_RELDATE	"Mar 05, 2011"
 
 
 static char version[] __devinitdata =
-- 
1.6.4.GIT


