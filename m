From: "Patro, Sumant" <Sumant.Patro@lsi.com>
Subject: RE: [2.6 patch] scsi/megaraid.c: __devexit annotation
Date: Fri, 28 Dec 2007 13:20:32 -0700
Message-ID: <0631C836DBF79F42B5A60C8C8D4E8229E022DA@NAMAIL2.ad.lsil.com>
References: <20071211222331.GW14204@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:63998 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751997AbXL1UU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Dec 2007 15:20:59 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20071211222331.GW14204@stusta.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>, DL-MegaRAID Linux <megaraidlinux@lsi.com>, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Ack.

Regards,

Sumant 

-----Original Message-----
From: Adrian Bunk [mailto:bunk@kernel.org] 
Sent: Tuesday, December 11, 2007 2:24 PM
To: DL-MegaRAID Linux; James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [2.6 patch] scsi/megaraid.c: __devexit annotation

megaraid_remove_one() can become __devexit.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b7d71f38d1c1aa66311e862b58f36aa34c888f98
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c index
66c6520..765c24d 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4889,7 +4889,7 @@ __megaraid_shutdown(adapter_t *adapter)
 		mdelay(1000);
 }
 
-static void
+static void __devexit
 megaraid_remove_one(struct pci_dev *pdev)  {
 	struct Scsi_Host *host = pci_get_drvdata(pdev);

