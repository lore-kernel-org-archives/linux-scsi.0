From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 4/5] bnx2fc: Do not use HBA_DBG macro when lport is not
 available
Date: Mon, 25 Apr 2011 12:30:09 -0700
Message-ID: <1303759810-22570-4-git-send-email-bprakash@broadcom.com>
References: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2591 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752515Ab1DYTaX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Apr 2011 15:30:23 -0400
In-Reply-To: <1303759810-22570-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, devel@open-fcoe.org
Cc: Nithin Nayak Sujir <nsujir@broadcom.com>, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

From: Nithin Nayak Sujir <nsujir@broadcom.com>

Use MISC_DBG instead.

Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 734d8c1..8075d65 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -1131,7 +1131,7 @@ static void bnx2fc_interface_release(struct kref *kref)
 	struct net_device *phys_dev;
 
 	hba = container_of(kref, struct bnx2fc_hba, kref);
-	BNX2FC_HBA_DBG(hba->ctlr.lp, "Interface is being released\n");
+	BNX2FC_MISC_DBG("Interface is being released\n");
 
 	netdev = hba->netdev;
 	phys_dev = hba->phys_dev;
-- 
1.7.0.6


