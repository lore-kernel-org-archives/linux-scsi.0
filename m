From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH RESUBMIT 07/23] qla2xxx: Enable the Flash Access Control (FAC) mailbox command.
Date: Wed, 26 Feb 2014 04:15:02 -0500
Message-ID: <1393406118-6586-8-git-send-email-saurav.kashyap@qlogic.com>
References: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:4498 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbaBZJvF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Feb 2014 04:51:05 -0500
In-Reply-To: <1393406118-6586-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@qlogic.com>

Signed-off-by: Joe Carnuccio <joe.carnuccio@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index e7e5f4f..9b271cc 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1718,9 +1718,6 @@ enable_82xx_npiv:
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 	}
 
-	if (IS_QLA83XX(ha))
-		goto skip_fac_check;
-
 	if (rval == QLA_SUCCESS && IS_FAC_REQUIRED(ha)) {
 		uint32_t size;
 
@@ -1733,7 +1730,7 @@ enable_82xx_npiv:
 			    "Unsupported FAC firmware (%d.%02d.%02d).\n",
 			    ha->fw_major_version, ha->fw_minor_version,
 			    ha->fw_subminor_version);
-skip_fac_check:
+
 			if (IS_QLA83XX(ha)) {
 				ha->flags.fac_supported = 0;
 				rval = QLA_SUCCESS;
-- 
1.7.7

