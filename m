From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 06/19] qla2xxx: Fix coccinelle warnings in qla2x00_relogin.
Date: Wed, 21 Nov 2012 02:40:31 -0500
Message-ID: <1353483644-17262-7-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:61214 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753230Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Reported-by: Fengguang Wu <Fengguang.wu@intel.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 0cdc6e2..132556b 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -3720,10 +3720,9 @@ void qla2x00_relogin(struct scsi_qla_host *vha)
 						if (fcport->flags &
 						    FCF_FCP2_DEVICE)
 							opts |= BIT_1;
-							status2 =
-							    qla2x00_get_port_database(
-								vha, fcport,
-								opts);
+						status2 =
+						    qla2x00_get_port_database(
+							vha, fcport, opts);
 						if (status2 != QLA_SUCCESS)
 							status = 1;
 					}
-- 
1.7.7

