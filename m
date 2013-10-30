From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 19/22] qla2xxx: Reset nic_core_reset_owner on moving from COLD to READY for ISP8044
Date: Wed, 30 Oct 2013 03:38:26 -0400
Message-ID: <1383118709-5569-20-git-send-email-saurav.kashyap@qlogic.com>
References: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:13728 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752168Ab3J3IJx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Oct 2013 04:09:53 -0400
In-Reply-To: <1383118709-5569-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Sawan Chandak <sawan.chandak@qlogic.com>

Signed-off-by: Sawan Chandak <sawan.chandak@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx2.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx2.c b/drivers/scsi/qla2xxx/qla_nx2.c
index 6f509f8..cc3522f 100644
--- a/drivers/scsi/qla2xxx/qla_nx2.c
+++ b/drivers/scsi/qla2xxx/qla_nx2.c
@@ -1860,7 +1860,7 @@ qla8044_device_state_handler(struct scsi_qla_host *vha)
 			goto exit;
 		case QLA8XXX_DEV_COLD:
 			rval = qla8044_device_bootstrap(vha);
-			goto exit;
+			break;
 		case QLA8XXX_DEV_INITIALIZING:
 			qla8044_idc_unlock(ha);
 			msleep(1000);
-- 
1.7.7

