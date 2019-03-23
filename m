From: Yue Haibing <yuehaibing@huawei.com>
Subject: [PATCH -next] scsi: qla2xxx: Remove useless set memory to zero use memset()
Date: Sat, 23 Mar 2019 21:27:53 +0800
Message-ID: <20190323132753.22508-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: qla2xxx-upstream@qlogic.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

The memory return by kzalloc() has already be set to zero, so
remove useless memset(0).

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/scsi/qla2xxx/qla_init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 3b81a2a..90da4b9 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -8852,7 +8852,6 @@ struct qla_qpair *qla2xxx_create_qpair(struct scsi_qla_host *vha, int qos,
 			    "Failed to allocate memory for queue pair.\n");
 			return NULL;
 		}
-		memset(qpair, 0, sizeof(struct qla_qpair));
 
 		qpair->hw = vha->hw;
 		qpair->vha = vha;
-- 
2.7.0
