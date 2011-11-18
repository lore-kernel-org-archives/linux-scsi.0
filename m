From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 18/18] qla2xxx: Do not check for minidump when device state is QLA82XX_DEV_READY.
Date: Fri, 18 Nov 2011 09:03:22 -0800
Message-ID: <1321635802-16491-19-git-send-email-chad.dupuis@qlogic.com>
References: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:31250 "EHLO
	VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758221Ab1KRRQm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:16:42 -0500
In-Reply-To: <1321635802-16491-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index e3bd475..d98065d 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -3275,7 +3275,6 @@ qla82xx_device_state_handler(scsi_qla_host_t *vha)
 
 		switch (dev_state) {
 		case QLA82XX_DEV_READY:
-			qla82xx_check_md_needed(vha);
 			ha->flags.isp82xx_reset_owner = 0;
 			goto exit;
 		case QLA82XX_DEV_COLD:
-- 
1.6.0.2


