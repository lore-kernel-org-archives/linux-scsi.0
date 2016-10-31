From: Ondrej Zary <linux@rainbow-software.org>
Subject: [PATCH 5/6] g_NCR5380: Autoprobe IRQ by default
Date: Mon, 31 Oct 2016 21:18:31 +0100
Message-ID: <1477945112-25659-6-git-send-email-linux@rainbow-software.org>
References: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1477945112-25659-1-git-send-email-linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Finn Thain <fthain@telegraphics.com.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

IRQ probing seems to work fine now. Default to autoprobe for IRQ instead
of disabling it.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/scsi/g_NCR5380.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 27fc499..6a08d3e 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -52,9 +52,9 @@
 module_param(dtc_3181e, int, 0);
 module_param(hp_c2502, int, 0);
 
-static int irq[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
+static int irq[] = { IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO, IRQ_AUTO };
 module_param_array(irq, int, NULL, 0);
-MODULE_PARM_DESC(irq, "IRQ number(s)");
+MODULE_PARM_DESC(irq, "IRQ number(s) (0=disable, 254=auto [default])");
 
 static int base[] = { 0, 0, 0, 0, 0, 0, 0, 0 };
 module_param_array(base, int, NULL, 0);
-- 
Ondrej Zary
