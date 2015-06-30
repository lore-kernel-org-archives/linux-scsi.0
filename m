From: Rudhresh Kumar J <rudhresh.jk@gmail.com>
Subject: [PATCH] SCSI: DTC: Adding KERN_ facility level
Date: Tue, 30 Jun 2015 21:59:16 +0530
Message-ID: <1435681756-5508-1-git-send-email-rudhreshj@cdac.in>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:36448 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbbF3Q3q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2015 12:29:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: fthain@telegraphics.com.au
Cc: schmitzmic@gmail.com, JBottomley@odin.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Rudhresh Kumar J <rudhreshj@cdac.in>, Rudhresh Kumar J <rudhresh.jk@gmail.com>

Fixed coding style issue by adding KERN_ facility level to some of
the printk functions.

Signed-off-by: Rudhresh Kumar J <rudhresh.jk@gmail.com>
---
 drivers/scsi/dtc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index 4c74c7b..a3a2a71 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -156,7 +156,7 @@ static int __init dtc_setup(char *str)
 
 	get_options(str, ARRAY_SIZE(ints), ints);
 	if (ints[0] != 2)
-		printk("dtc_setup: usage dtc=address,irq\n");
+		printk(KERN_DEBUG "dtc_setup: usage dtc=address,irq\n");
 	else if (commandline_current < NO_OVERRIDES) {
 		overrides[commandline_current].address = ints[1];
 		overrides[commandline_current].irq = ints[2];
@@ -272,7 +272,7 @@ found:
 		instance->irq = NO_IRQ;
 #endif
 #if defined(DTCDEBUG) && (DTCDEBUG & DTCDEBUG_INIT)
-		printk("scsi%d : irq = %d\n", instance->host_no, instance->irq);
+		printk(KERN_DEBUG "scsi%d : irq = %d\n", instance->host_no, instance->irq);
 #endif
 
 		++current_override;
-- 
1.8.4

