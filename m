From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 07/25] qla2xxx: Allow fwdump template T262 to specify same start/end.
Date: Fri, 19 May 2017 14:53:26 -0700
Message-ID: <20170519215344.2168-8-himanshu.madhani@cavium.com>
References: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0049.outbound.protection.outlook.com ([104.47.32.49]:60647
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756792AbdESVyD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 17:54:03 -0400
In-Reply-To: <20170519215344.2168-1-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

From: Joe Carnuccio <joe.carnuccio@cavium.com>

Cc: <stable@vger.kernel.org>
Signed-off-by: Joe Carnuccio <joe.carnuccio@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
---
 drivers/scsi/qla2xxx/qla_tmpl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_tmpl.c b/drivers/scsi/qla2xxx/qla_tmpl.c
index 2f2633a8c4ad..33142610882f 100644
--- a/drivers/scsi/qla2xxx/qla_tmpl.c
+++ b/drivers/scsi/qla2xxx/qla_tmpl.c
@@ -369,7 +369,7 @@ qla27xx_fwdt_entry_t262(struct scsi_qla_host *vha,
 		goto done;
 	}
 
-	if (end <= start || start == 0 || end == 0) {
+	if (end < start || start == 0 || end == 0) {
 		ql_dbg(ql_dbg_misc, vha, 0xd023,
 		    "%s: unusable range (start=%x end=%x)\n", __func__,
 		    ent->t262.end_addr, ent->t262.start_addr);
-- 
2.12.0
