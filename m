From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 10/19] qla2xxx: Fix typo in qla83xx_fw_dump function.
Date: Wed, 21 Nov 2012 02:40:35 -0500
Message-ID: <1353483644-17262-11-git-send-email-saurav.kashyap@qlogic.com>
References: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mvnat01.qlogic.com ([198.186.3.73]:2022 "HELO linux-zupk.site"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753512Ab2KUH6y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Nov 2012 02:58:54 -0500
In-Reply-To: <1353483644-17262-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_dbg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 04b2823..9b9c632 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -2268,7 +2268,7 @@ qla83xx_fw_dump(scsi_qla_host_t *vha, int hardware_locked)
 
 		if (!cnt) {
 			nxt = fw->code_ram;
-			nxt += sizeof(fw->code_ram),
+			nxt += sizeof(fw->code_ram);
 			nxt += (ha->fw_memory_size - 0x100000 + 1);
 			goto copy_queue;
 		} else
-- 
1.7.7

