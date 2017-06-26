From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH 7/7] bnx2fc: Update version number to 2.11.8.
Date: Mon, 26 Jun 2017 08:59:38 -0700
Message-ID: <20170626155938.2091-8-chad.dupuis@cavium.com>
References: <20170626155938.2091-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0068.outbound.protection.outlook.com ([104.47.34.68]:56480
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752020AbdFZP77 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jun 2017 11:59:59 -0400
In-Reply-To: <20170626155938.2091-1-chad.dupuis@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Signed-off-by: Chad Dupuis <chad.dupuis@cavium.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index c192840..7e007e1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -66,7 +66,7 @@
 #include "bnx2fc_constants.h"
 
 #define BNX2FC_NAME		"bnx2fc"
-#define BNX2FC_VERSION		"2.10.3"
+#define BNX2FC_VERSION		"2.11.8"
 
 #define PFX			"bnx2fc: "
 
-- 
1.8.5.6
