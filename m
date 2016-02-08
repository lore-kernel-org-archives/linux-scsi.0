From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH v4 1/2] fixed typo in ufshcd-pltfrm
Date: Mon,  8 Feb 2016 19:07:50 +0000
Message-ID: <f0f2b1704255651c0d465093df1965fdf912098a.1454957580.git.jpinto@synopsys.com>
References: <cover.1454957580.git.jpinto@synopsys.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtprelay.synopsys.com ([198.182.47.9]:59216 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbcBHTIE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2016 14:08:04 -0500
In-Reply-To: <cover.1454957580.git.jpinto@synopsys.com>
In-Reply-To: <cover.1454957580.git.jpinto@synopsys.com>
References: <cover.1454957580.git.jpinto@synopsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org, mark.rutland@arm.com
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>

Fixed typo in ufshcd-pltfrm.

Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
Changes v0->v4:
- Nothing changed (just to keep up with patch set version).

 drivers/scsi/ufs/ufshcd-pltfrm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index d2a7b12..0522891 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -353,6 +353,6 @@ EXPORT_SYMBOL_GPL(ufshcd_pltfrm_init);
 
 MODULE_AUTHOR("Santosh Yaragnavi <santosh.sy@samsung.com>");
 MODULE_AUTHOR("Vinayak Holikatti <h.vinayak@samsung.com>");
-MODULE_DESCRIPTION("UFS host controller Pltform bus based glue driver");
+MODULE_DESCRIPTION("UFS host controller Platform bus based glue driver");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(UFSHCD_DRIVER_VERSION);
-- 
1.8.1.5

