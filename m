From: akpm@linux-foundation.org
Subject: [patch 22/30] drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion to kcalloc
Date: Fri, 10 Aug 2007 14:50:47 -0700
Message-ID: <200708102150.l7ALomZa011384@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60620 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757055AbXHJWBX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 18:01:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, m.kozlowski@tuxland.pl, James.Smart@Emulex.Com

From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/scsi/lpfc/lpfc_init.c | 65932 -> 65881 (-51 bytes)
 drivers/scsi/lpfc/lpfc_init.o | 219760 -> 219616 (-144 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Acked-by: James Smart <James.Smart@Emulex.Com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    3 +--
 1 files changed, 1 insertion(+), 2 deletions(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~drivers-scsi-lpfc-lpfc_initc-kmalloc-memset-conversion-to-kcalloc
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1265,11 +1265,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
 	uint32_t *HashWorking;
 	uint32_t *pwwnn = (uint32_t *) phba->wwnn;
 
-	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
+	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
 	if (!HashWorking)
 		return;
 
-	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
 	HashWorking[0] = HashWorking[78] = *pwwnn++;
 	HashWorking[1] = HashWorking[79] = *pwwnn;
 
_
