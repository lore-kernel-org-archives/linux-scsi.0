From: Erez Zilber <erezz@voltaire.com>
Subject: [PATCH] IB/iSER: add logical unit reset support
Date: Tue, 22 Jan 2008 12:06:25 +0200
Message-ID: <4795C021.6030707@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fwil.voltaire.com ([193.47.165.2]:20253 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762097AbYAVKG2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Jan 2008 05:06:28 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org

eh_device_reset_handler was already added to scsi_host_template
in iscsi_tcp, and is now added also for iscsi_iser.

Signed-off-by: Erez Zilber <erezz@voltaire.com>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index fd69fb3..4cd0705 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -552,6 +552,7 @@ static struct scsi_host_template iscsi_iser_sht = {
 	.max_sectors		= 1024,
 	.cmd_per_lun            = ISCSI_MAX_CMD_PER_LUN,
 	.eh_abort_handler       = iscsi_eh_abort,
+	.eh_device_reset_handler= iscsi_eh_device_reset,
 	.eh_host_reset_handler	= iscsi_eh_host_reset,
 	.use_clustering         = DISABLE_CLUSTERING,
 	.proc_name              = "iscsi_iser",
-- 
1.5.3.7



