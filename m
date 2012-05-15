From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: [PATCH] scsi/mvsas: Fix the memleak of struct sas_ha_struct:lldd_ha.
Date: Tue, 15 May 2012 19:25:53 +0800
Message-ID: <201205151925496711834@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60465 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757095Ab2EOLZG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 07:25:06 -0400
Received: by dady13 with SMTP id y13so7197528dad.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 04:25:06 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley <JBottomley@parallels.com>, yuxiangl <yuxiangl@marvell.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/scsi/mvsas/mv_init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cc59dff..cd9fc36 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -671,6 +671,7 @@ static void __devexit mvs_pci_remove(struct pci_dev *pdev)
 	}
 	kfree(sha->sas_phy);
 	kfree(sha->sas_port);
+	kfree(sha->lldd_ha);
 	kfree(sha);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-- 
1.7.5.4

 				
--------------
kedacomkernel
2012-05-15

