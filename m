From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] scsi/mvsas: Fix the memleak of struct sas_ha_struct:lldd_ha.
Date: Wed, 16 May 2012 09:05:55 +0800
Message-ID: <201205160905484539991@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53595 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965036Ab2EPBFM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 May 2012 21:05:12 -0400
Received: by dady13 with SMTP id y13so246574dad.19
        for <linux-scsi@vger.kernel.org>; Tue, 15 May 2012 18:05:12 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scsi maintainers <JBottomley@Parallels.com>
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
majianpeng
2012-05-16

