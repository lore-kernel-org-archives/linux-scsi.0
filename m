From: Joe Perches <joe@perches.com>
Subject: [PATCH 29/35] drivers/scsi: Convert remaining use of pr_warning to pr_warn
Date: Thu, 16 Feb 2017 23:11:42 -0800
Message-ID: <2969e366299bfc17f89ec9ba10614b01bdc2dd01.1487314667.git.joe@perches.com>
References: <cover.1487314666.git.joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1487314666.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

To enable eventual removal of pr_warning

This makes pr_warn use consistent for drivers/scsi

Prior to this patch, there was 1 use of pr_warning and
96 uses of pr_warn in drivers/scsi

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/a3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/a3000.c b/drivers/scsi/a3000.c
index e6375b4de79e..2be0f577abbf 100644
--- a/drivers/scsi/a3000.c
+++ b/drivers/scsi/a3000.c
@@ -38,7 +38,7 @@ static irqreturn_t a3000_intr(int irq, void *data)
 		spin_unlock_irqrestore(instance->host_lock, flags);
 		return IRQ_HANDLED;
 	}
-	pr_warning("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
+	pr_warn("Non-serviced A3000 SCSI-interrupt? ISTR = %02x\n", status);
 	return IRQ_NONE;
 }
 
-- 
2.10.0.rc2.1.g053435c
