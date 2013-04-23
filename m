From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: qla2x00_sp_compl can be static.
Date: Tue, 23 Apr 2013 14:10:12 -0400
Message-ID: <1366740612-3561-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1366740612-3561-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:46501
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758536Ab3DXWOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 18:14:19 -0400
Received: from mail56-am1 (localhost [127.0.0.1])	by mail56-am1-R.bigfish.com
 (Postfix) with ESMTP id 71110602BB	for <linux-scsi@vger.kernel.org>; Wed, 24
 Apr 2013 22:14:18 +0000 (UTC)
In-Reply-To: <1366740612-3561-1-git-send-email-saurav.kashyap@qlogic.com>
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


