From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 5/8] qla2xxx: Fix warning for code intentation in __qla24xx_handle_gpdb_event()
Date: Mon, 15 Jan 2018 20:46:50 -0800
Message-ID: <20180116044653.20696-6-himanshu.madhani@cavium.com>
References: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0050.outbound.protection.outlook.com ([104.47.40.50]:10400
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751336AbeAPErH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:47:07 -0500
In-Reply-To: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

This patch fixes following smatch warning

drivers/scsi/qla2xxx/qla_init.c:1054 __qla24xx_handle_gpdb_event() warn: inconsistent indenting

Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 08ad1a60cb0d..e030ee38fa6f 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1055,7 +1055,7 @@ void __qla24xx_handle_gpdb_event(scsi_qla_host_t *vha, struct event_arg *ea)
 		ql_dbg(ql_dbg_disc, vha, 0x20d6,
 		    "%s %d %8phC session revalidate success\n",
 		    __func__, __LINE__, ea->fcport->port_name);
-		 ea->fcport->disc_state = DSC_LOGIN_COMPLETE;
+		ea->fcport->disc_state = DSC_LOGIN_COMPLETE;
 	}
 	spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
 }
-- 
2.12.0
