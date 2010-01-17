From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] lpfc: two branches the same in lpfc_decode_firmware_rev()
Date: Sun, 17 Jan 2010 16:15:57 +0100
Message-ID: <4B5329AD.9010100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:61355 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0AQPLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Jan 2010 10:11:14 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>

Regardless of the flag state, the branches execute the same code

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 0ebcd9b..bf7bf62 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -1843,12 +1843,7 @@ lpfc_decode_firmware_rev(struct lpfc_hba *phba, char *fwrevision, int flag)
 		c  = (rev & 0x0000ff00) >> 8;
 		b4 = (rev & 0x000000ff);
 
-		if (flag)
-			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
-				b2, b3, c, b4);
-		else
-			sprintf(fwrevision, "%d.%d%d%c%d ", b1,
-				b2, b3, c, b4);
+		sprintf(fwrevision, "%d.%d%d%c%d", b1, b2, b3, c, b4);
 	}
 	return;
 }
