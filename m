From: liujian <liujian56@huawei.com>
Subject: [PATCH 2/2] driver: scsi: qla2xxx: fix returnvar.cocci warning
Date: Sat, 1 Dec 2018 02:07:44 +0800
Message-ID: <1543601264-12610-2-git-send-email-liujian56@huawei.com>
References: <1543601264-12610-1-git-send-email-liujian56@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1543601264-12610-1-git-send-email-liujian56@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, vinholikatti@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Remove unneeded variable used to store return value,
detected by the semantic patch returnvar.cocci.

Signed-off-by: liujian <liujian56@huawei.com>
---
 drivers/scsi/qla2xxx/qla_mr.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 60f964c..bb66ea4 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -1712,7 +1712,6 @@ qlafx00_tgt_detach(struct scsi_qla_host *vha, int tgt_id)
 int
 qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 {
-	int rval = 0;
 	uint32_t aen_code, aen_data;
 
 	aen_code = FCH_EVT_VENDOR_UNIQUE;
@@ -1764,7 +1763,7 @@ qlafx00_process_aen(struct scsi_qla_host *vha, struct qla_work_evt *evt)
 	fc_host_post_event(vha->host, fc_get_event_number(),
 	    aen_code, aen_data);
 
-	return rval;
+	return 0;
 }
 
 static void
-- 
2.7.4
