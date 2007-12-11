From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6 patch] scsi/megaraid.c: __devexit annotation
Date: Tue, 11 Dec 2007 23:23:31 +0100
Message-ID: <20071211222331.GW14204@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:38538 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756033AbXLKWXa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Dec 2007 17:23:30 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: megaraidlinux@lsi.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

megaraid_remove_one() can become __devexit.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b7d71f38d1c1aa66311e862b58f36aa34c888f98 
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 66c6520..765c24d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4889,7 +4889,7 @@ __megaraid_shutdown(adapter_t *adapter)
 		mdelay(1000);
 }
 
-static void
+static void __devexit
 megaraid_remove_one(struct pci_dev *pdev)
 {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);

