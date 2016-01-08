From: John Garry <john.garry@huawei.com>
Subject: [PATCH 04/23] hisi_sas: reduce max itct entries
Date: Fri, 8 Jan 2016 22:15:23 +0800
Message-ID: <1452262542-64589-5-git-send-email-john.garry@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Since v2 hw only supports 2048 itct entries,
as opposed to 4096 for v1 hw, set the max itct
entries to the lower of the two.

It is not anticipated that any device with v1
will ever require to connect > 2048 devices.

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas.h b/drivers/scsi/hisi_sas/hisi_sas.h
index 5ed5cf1..7c05eb3 100644
--- a/drivers/scsi/hisi_sas/hisi_sas.h
+++ b/drivers/scsi/hisi_sas/hisi_sas.h
@@ -25,7 +25,7 @@
 #define HISI_SAS_MAX_PHYS	9
 #define HISI_SAS_MAX_QUEUES	32
 #define HISI_SAS_QUEUE_SLOTS 512
-#define HISI_SAS_MAX_ITCT_ENTRIES 4096
+#define HISI_SAS_MAX_ITCT_ENTRIES 2048
 #define HISI_SAS_MAX_DEVICES HISI_SAS_MAX_ITCT_ENTRIES
 
 #define HISI_SAS_STATUS_BUF_SZ \
-- 
1.9.1
