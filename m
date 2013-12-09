From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH][RESEND] [SCSI] wd7000: remove deprecated IRQF_DISABLED
Date: Mon,  9 Dec 2013 11:13:21 +0100
Message-ID: <1386584001-5341-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1381040337-12620-1-git-send-email-michael.opdenacker@free-electrons.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1381040337-12620-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: zaga@fly.cc.fer.hr, JBottomley@parallels.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Michael Opdenacker <michael.opdenacker@free-electrons.com>
List-Id: linux-scsi@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/scsi/wd7000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index f9a6e4b0affe..32674236fec7 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1252,7 +1252,7 @@ static int wd7000_init(Adapter * host)
 		return 0;
 
 
-	if (request_irq(host->irq, wd7000_intr, IRQF_DISABLED, "wd7000", host)) {
+	if (request_irq(host->irq, wd7000_intr, 0, "wd7000", host)) {
 		printk("wd7000_init: can't get IRQ %d.\n", host->irq);
 		return (0);
 	}
-- 
1.8.3.2
