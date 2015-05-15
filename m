From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6
 controller
Date: Fri, 15 May 2015 02:56:46 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F6AC87@BBYEXM01.pmc-sierra.internal>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1431562378-8514-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60422 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423291AbbEOC4r convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2015 22:56:47 -0400
In-Reply-To: <1431562378-8514-4-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

-----Original Message-----
From: rajinikanth.pandurangan@pmcs.com [mailto:rajinikanth.pandurangan@pmcs.com] 
Sent: Thursday, May 14, 2015 5:43 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [PATCH 3/9] [SCSI] aacraid: Enable MSI interrupt for series-6 controller

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Description:
	Enable MSI interrupt mode for series-6 controller.

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/src.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/src.c b/drivers/scsi/aacraid/src.c index b0204d0..ae494c5 100644
--- a/drivers/scsi/aacraid/src.c
+++ b/drivers/scsi/aacraid/src.c
@@ -742,7 +742,7 @@ int aac_src_init(struct aac_dev *dev)
 	if (dev->comm_interface != AAC_COMM_MESSAGE_TYPE1)
 		goto error_iounmap;
 
-	dev->msi = aac_msi && !pci_enable_msi(dev->pdev);
+	dev->msi = !pci_enable_msi(dev->pdev);
 
 	dev->aac_msix[0].vector_no = 0;
 	dev->aac_msix[0].dev = dev;
--
1.9.3

