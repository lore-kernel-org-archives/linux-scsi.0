From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 5/5] bnx2fc: increase cleanup wait time
Date: Mon, 25 Apr 2011 12:30:10 -0700
Message-ID: <1303759810-22570-5-git-send-email-bprakash@broadcom.com>
References: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3659 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758651Ab1DYTac (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2011 15:30:32 -0400
In-Reply-To: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

FW may take more time cleaning up IOs issued to multiple targets.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc.h b/drivers/scsi/bnx2fc/bnx2fc.h
index 24102e8..e3caa50 100644
--- a/drivers/scsi/bnx2fc/bnx2fc.h
+++ b/drivers/scsi/bnx2fc/bnx2fc.h
@@ -130,7 +130,7 @@
 #define BNX2FC_TM_TIMEOUT		60	/* secs */
 #define BNX2FC_IO_TIMEOUT		20000UL	/* msecs */
 
-#define BNX2FC_WAIT_CNT			120
+#define BNX2FC_WAIT_CNT			1200
 #define BNX2FC_FW_TIMEOUT		(3 * HZ)
 #define PORT_MAX			2
 
-- 
1.7.0.6


