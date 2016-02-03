From: Joao Pinto <Joao.Pinto@synopsys.com>
Subject: [PATCH 1/3] fixed typo in ufshcd-pltfrm
Date: Wed,  3 Feb 2016 11:28:24 +0000
Message-ID: <1eef4f4cd43d7363d54c6571d47da62da464a836.1454498292.git.jpinto@synopsys.com>
References: <cover.1454498292.git.jpinto@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1454498292.git.jpinto@synopsys.com>
In-Reply-To: <cover.1454498292.git.jpinto@synopsys.com>
References: <cover.1454498292.git.jpinto@synopsys.com>
Sender: linux-kernel-owner@vger.kernel.org
To: santosh.sy@samsung.com, h.vinayak@samsung.com, julian.calaby@gmail.com, akinobu.mita@gmail.com, hch@infradead.org
Cc: gbroner@codeaurora.org, subhashj@codeaurora.org, CARLOS.PALMINHA@synopsys.com, ijc+devicetree@hellion.org.uk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, devicetree@vger.kernel.org, Joao Pinto <Joao.Pinto@synopsys.com>
List-Id: linux-scsi@vger.kernel.org


Signed-off-by: Joao Pinto <jpinto@synopsys.com>
---
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
