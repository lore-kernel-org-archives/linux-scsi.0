From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: qla2x00_sp_compl can be static.
Date: Thu, 25 Apr 2013 01:29:19 -0400
Message-ID: <1366867759-3562-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1366867759-3562-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.32.180.16] ([216.32.180.16]:30664 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750982Ab3DYFzJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 01:55:09 -0400
Received: from mail192-va3 (localhost [127.0.0.1])	by
 mail192-va3-R.bigfish.com (Postfix) with ESMTP id D3B1F1401DC	for
 <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2013 05:53:17 +0000 (UTC)
In-Reply-To: <1366867759-3562-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a083715..7b621c2 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -644,7 +644,7 @@ qla2x00_sp_free_dma(void *vha, void *ptr)
 	qla2x00_rel_sp(sp->fcport->vha, sp);
 }
 
-void
+static void
 qla2x00_sp_compl(void *data, void *ptr, int res)
 {
 	struct qla_hw_data *ha = (struct qla_hw_data *)data;
-- 
1.7.7


