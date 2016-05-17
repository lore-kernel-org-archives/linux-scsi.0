From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 5/7] pm8001: fix typo
Date: Tue, 17 May 2016 16:38:44 +0200
Message-ID: <1463495926-13728-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:25945 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755723AbcEQOya (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2016 10:54:30 -0400
In-Reply-To: <1463495926-13728-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jack Wang <jinpu.wang@profitbricks.com>
Cc: kernel-janitors@vger.kernel.org, lindar_liu@usish.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, pmchba@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

firmare -> firmware

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/pm8001/pm8001_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_init.c b/drivers/scsi/pm8001/pm8001_init.c
index 6bd7bf4..fdbee8b4 100644
--- a/drivers/scsi/pm8001/pm8001_init.c
+++ b/drivers/scsi/pm8001/pm8001_init.c
@@ -1249,7 +1249,7 @@ static int pm8001_pci_resume(struct pci_dev *pdev)
 
 	/* Chip documentation for the 8070 and 8072 SPCv    */
 	/* states that a 500ms minimum delay is required    */
-	/* before issuing commands.  Otherwise, the firmare */
+	/* before issuing commands. Otherwise, the firmware */
 	/* will enter an unrecoverable state.               */
 
 	if (pm8001_ha->chip_id == chip_8070 ||

