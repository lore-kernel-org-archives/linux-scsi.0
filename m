From: akpm@osdl.org
Subject: [patch 25/28] 3w-xxxx: fix "ATA UDMA upgrade" message number
Date: Mon, 25 Sep 2006 16:59:11 -0700
Message-ID: <200609252359.k8PNxBCx003538@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:45755 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751764AbWIYX7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Sep 2006 19:59:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, adobriyan@gmail.com

From: Alexey Dobriyan <adobriyan@gmail.com>

sparse "defined twice" warning

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/3w-xxxx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/3w-xxxx.h~3w-xxxx-fix-ata-udma-upgrade-message-number drivers/scsi/3w-xxxx.h
--- a/drivers/scsi/3w-xxxx.h~3w-xxxx-fix-ata-udma-upgrade-message-number
+++ a/drivers/scsi/3w-xxxx.h
@@ -74,7 +74,7 @@ static char *tw_aen_string[] = {
 	[0x00D] = "ERROR: Logical unit deleted: Unit #",
 	[0x00F] = "WARNING: SMART threshold exceeded: Port #",
 	[0x021] = "WARNING: ATA UDMA downgrade: Port #",
-	[0x021] = "WARNING: ATA UDMA upgrade: Port #",
+	[0x022] = "WARNING: ATA UDMA upgrade: Port #",
 	[0x023] = "WARNING: Sector repair occurred: Port #",
 	[0x024] = "ERROR: SBUF integrity check failure",
 	[0x025] = "ERROR: Lost cached write: Port #",
_
