From: akpm@linux-foundation.org
Subject: [patch 18/28] scsi/lpfc/lpfc_init.c: remove unused variable
Date: Thu, 10 May 2007 23:01:02 -0700
Message-ID: <200705110601.l4B612QA008169@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:39419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758697AbXEKGJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 11 May 2007 02:09:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, bunk@stusta.de

From: Adrian Bunk <bunk@stusta.de>

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/lpfc/lpfc_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-lpfc_initc-remove-unused-variable drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c~scsi-lpfc-lpfc_initc-remove-unused-variable
+++ a/drivers/scsi/lpfc/lpfc_init.c
@@ -1512,7 +1512,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
 	struct lpfc_sli  *psli;
 	struct lpfc_iocbq *iocbq_entry = NULL, *iocbq_next = NULL;
 	unsigned long bar0map_len, bar2map_len;
-	int error = -ENODEV, retval;
+	int error = -ENODEV;
 	int i;
 	uint16_t iotag;
 
_
