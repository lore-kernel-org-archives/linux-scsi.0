From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH] bnx2fc: Set no_async_abort to 1 in SCSI host template.
Date: Tue, 5 Aug 2014 15:45:53 -0400
Message-ID: <1407267953-26618-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:45168 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629AbaHEUSA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2014 16:18:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@lst.de
Cc: giridhar.malavali@qlogic.com

Set this to 1 for now as we've observed crashes when this is set to the default
value of 0.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index 785d0d7..4882ad6 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2789,6 +2789,7 @@ static struct scsi_host_template bnx2fc_shost_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 	.sg_tablesize		= BNX2FC_MAX_BDS_PER_CMD,
 	.max_sectors		= 1024,
+	.no_async_abort         = 1,
 };
 
 static struct libfc_function_template bnx2fc_libfc_fcn_templ = {
-- 
1.7.1

