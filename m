From: zhong jiang <zhongjiang@huawei.com>
Subject: [PATCH 1/2] scsi:qla1280: remove unnessary same condition check
Date: Thu, 2 Aug 2018 10:45:00 +0800
Message-ID: <1533177901-19514-2-git-send-email-zhongjiang@huawei.com>
References: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1533177901-19514-1-git-send-email-zhongjiang@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: andy.shevchenko@gmail.com, john.garry@huawei.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, aacraid@microsemi.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

doulbe test in a expression is redundant. so just remove one of
them.

Signed-off-by: zhong jiang <zhongjiang@huawei.com>
---
 drivers/scsi/qla1280.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 390775d..8e6f156 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -1504,7 +1504,6 @@ static void qla1280_mailbox_timeout(struct timer_list *t)
 	/* Issue SCSI reset, if we can't reset twice then bus is dead */
 	for (bus = 0; bus < ha->ports; bus++) {
 		if (!ha->bus_settings[bus].disable_scsi_reset &&
-		    qla1280_bus_reset(ha, bus) &&
 		    qla1280_bus_reset(ha, bus))
 			ha->bus_settings[bus].scsi_bus_dead = 1;
 	}
-- 
1.7.12.4
