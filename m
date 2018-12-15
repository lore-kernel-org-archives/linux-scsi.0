From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: 3w-xxx: fix indentation issue, add missing tab
Date: Sat, 15 Dec 2018 14:17:08 +0000
Message-ID: <20181215141708.30883-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Adam Radford <aradford@gmail.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a tab missing on a return statement, add the missing tab.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/3w-xxxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a58257645e94..04164d2f03dd 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1174,7 +1174,7 @@ static int tw_setfeature(TW_Device_Extension *tw_dev, int parm, int param_size,
   	command_que_value = tw_dev->command_packet_physical_address[request_id];
 	if (command_que_value == 0) {
 		printk(KERN_WARNING "3w-xxxx: tw_setfeature(): Bad command packet physical address.\n");
-	return 1;
+		return 1;
 	}
 
 	/* Send command packet to the board */
-- 
2.19.1
