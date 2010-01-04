From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 12/12] be2iscsi: Enable TEXT req resp
Date: Tue, 5 Jan 2010 05:12:43 +0530
Message-ID: <20100104234232.GA16908@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:15388 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753780Ab0ADXmV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2010 18:42:21 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	 This patch enables TEXT Request / Response for the driver

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b1c8975..9fc4446 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3917,7 +3917,7 @@ disable_pci:
 struct iscsi_transport beiscsi_iscsi_transport = {
 	.owner = THIS_MODULE,
 	.name = DRV_NAME,
-	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST |
+	.caps = CAP_RECOVERY_L0 | CAP_HDRDGST | CAP_TEXT_NEGO |
 		CAP_MULTI_R2T | CAP_DATADGST | CAP_DATA_PATH_OFFLOAD,
 	.param_mask = ISCSI_MAX_RECV_DLENGTH |
 		ISCSI_MAX_XMIT_DLENGTH |
-- 
1.6.4

