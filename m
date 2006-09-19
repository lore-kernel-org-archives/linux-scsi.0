From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] 3w-xxxx: fix "ATA UDMA upgrade" message number
Date: Tue, 19 Sep 2006 05:04:23 +0400
Message-ID: <20060919010423.GA5273@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:13794 "EHLO
	ug-out-1314.google.com") by vger.kernel.org with ESMTP
	id S1751278AbWISBE0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 21:04:26 -0400
Received: by ug-out-1314.google.com with SMTP id o38so418395ugd
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 18:04:25 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, Adam Radford <linuxraid@amcc.com>

sparse "defined twice" warning

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/scsi/3w-xxxx.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/3w-xxxx.h
+++ b/drivers/scsi/3w-xxxx.h
@@ -74,7 +74,7 @@ static char *tw_aen_string[] = {
 	[0x00D] = "ERROR: Logical unit deleted: Unit #",
 	[0x00F] = "WARNING: SMART threshold exceeded: Port #",
 	[0x021] = "WARNING: ATA UDMA downgrade: Port #",
-	[0x021] = "WARNING: ATA UDMA upgrade: Port #",
+	[0x022] = "WARNING: ATA UDMA upgrade: Port #",
 	[0x023] = "WARNING: Sector repair occurred: Port #",
 	[0x024] = "ERROR: SBUF integrity check failure",
 	[0x025] = "ERROR: Lost cached write: Port #",

