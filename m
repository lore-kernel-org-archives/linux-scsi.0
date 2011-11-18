From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 03/14] qla2xxx: Don't call alloc_fw_dump for ISP82XX.
Date: Fri, 18 Nov 2011 09:02:11 -0800
Message-ID: <1321635742-16426-4-git-send-email-chad.dupuis@qlogic.com>
References: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-va3.bigfish.com ([216.32.180.10]:5941 "EHLO
	VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758196Ab1KRRPk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Nov 2011 12:15:40 -0500
In-Reply-To: <1321635742-16426-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_init.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index f03e915..54ea68c 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1509,7 +1509,8 @@ enable_82xx_npiv:
 				    &ha->fw_xcb_count, NULL, NULL,
 				    &ha->max_npiv_vports, NULL);
 
-				if (!fw_major_version && ql2xallocfwdump)
+				if (!fw_major_version && ql2xallocfwdump
+				    && !IS_QLA82XX(ha))
 					qla2x00_alloc_fw_dump(vha);
 			}
 		} else {
-- 
1.6.0.2


