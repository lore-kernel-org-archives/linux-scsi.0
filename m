From: "Bhanu Prakash Gollapudi" <bprakash@broadcom.com>
Subject: [PATCH 7/8] bnx2fc: Support max IO size to 512KB
Date: Fri, 21 Dec 2012 19:40:33 -0800
Message-ID: <1356147634-17252-8-git-send-email-bprakash@broadcom.com>
References: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2973 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2LVDkn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Dec 2012 22:40:43 -0500
In-Reply-To: <1356147634-17252-1-git-send-email-bprakash@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, Bhanu Prakash Gollapudi <bprakash@broadcom.com>

Increase max_sectors from 512 to 1024 in order to support max IO size of 512KB.

Signed-off-by: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index e021e43..3701eab 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2667,7 +2667,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.can_queue		= BNX2FC_CAN_QUEUE,
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
-	.max_sectors		= 512,
+	.max_sectors		= 1024,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
-- 
1.7.0.6


