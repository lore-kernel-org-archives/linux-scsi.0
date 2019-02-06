From: John Garry <john.garry@huawei.com>
Subject: [PATCH 3/6] scsi: hisi_sas: change queue depth from 512 to 4096
Date: Wed, 6 Feb 2019 18:52:53 +0800
Message-ID: <1549450376-114929-4-git-send-email-john.garry@huawei.com>
References: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1549450376-114929-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

If sending IOs to many disks from single queue, it is possible that the
queue may be full. To avoid the situation, change queue depth from 512
to 4096 which is the max number of IOs for v3 hw.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index df2a92a0e7a1..ff844d4ba0d3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -30,7 +30,7 @@
 
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
-#define HISI_SAS_QUEUE_SLOTS 512
+#define HISI_SAS_QUEUE_SLOTS	4096
 #define HISI_SAS_MAX_ITCT_ENTRIES 1024
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
 #define HISI_SAS_RESET_BIT	0
-- 
2.17.1
