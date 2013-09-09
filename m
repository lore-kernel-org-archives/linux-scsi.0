From: Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] [SCSI] ufs: Remove casting the return value which is a
 void pointer
Date: Mon, 09 Sep 2013 14:47:07 +0900
Message-ID: <005a01cead20$05401e90$0fc05bb0$%han@samsung.com>
References: <005901cead1f$ab029e30$0107da90$%han@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:50894 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab3IIFrU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Sep 2013 01:47:20 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MSU00DQNG2JUP30@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 09 Sep 2013 14:47:08 +0900 (KST)
In-reply-to: <005901cead1f$ab029e30$0107da90$%han@samsung.com>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'James Bottomley' <JBottomley@Parallels.com>
Cc: linux-scsi@vger.kernel.org, 'James Bottomley' <jejb@kernel.org>, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, 'Jingoo Han' <jg1.han@samsung.com>

Casting the return value which is a void pointer is redundant.
The conversion from void pointer to any other pointer type is
guaranteed by the C programming language.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/scsi/ufs/ufshcd-pci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index a823cf4..26ea19c 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -117,7 +117,7 @@ static int ufshcd_pci_runtime_idle(struct device *dev)
  */
 static void ufshcd_pci_shutdown(struct pci_dev *pdev)
 {
-	ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev));
+	ufshcd_hba_stop(pci_get_drvdata(pdev));
 }
 
 /**
-- 
1.7.10.4


