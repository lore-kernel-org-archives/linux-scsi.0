From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH 3/4] scsi: hpsa: Delete an unnecessary initialisation in
 hpsa_big_passthru_ioctl()
Date: Mon, 5 Mar 2018 09:33:36 +0100
Message-ID: <c8183b17-d228-5bac-938f-16e751726d81@users.sourceforge.net>
References: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f013341a-e3b2-69a7-4918-8bb3d109f0cc@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com, Don Brace <don.brace@microsemi.com>, "James E. J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 4 Mar 2018 22:02:10 +0100

The variable "status" will be set to an appropriate value a bit later.
Thus omit the explicit initialisation at the beginning.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/hpsa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 45177ead811f..86d371ab39e7 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -6381,7 +6381,7 @@ static int hpsa_big_passthru_ioctl(struct ctlr_info *h, void __user *argp)
 	int *buff_size;
 	u64 temp64;
 	BYTE sg_used = 0;
-	int status = 0;
+	int status;
 	u32 left;
 	u32 sz;
 	BYTE __user *data_ptr;
-- 
2.16.2
