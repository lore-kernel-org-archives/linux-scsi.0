From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH] drivers: ufs: Add missing MODULE_* information
Date: Thu, 21 Mar 2019 13:50:34 +0100
Message-ID: <20190321125034.22697-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, matthias.bgg@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org, Anders Roxell <anders.roxell@linaro.org>
List-Id: linux-scsi@vger.kernel.org

When building the ufs-mediatek module the following warning shows up:

WARNING: modpost: missing MODULE_LICENSE() in
  drivers/scsi/ufs/ufs-mediatek.o

Rework to add MODULE_LICENSE,MODULE_AUTHOR and MODULE_DESCRIPTION.

Fixes: ddd90623ce26 ("scsi: ufs-mediatek: Add UFS support for Mediatek SoC chips")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index c3b78fc83d3f..ce4767784937 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -364,4 +364,9 @@ static struct platform_driver ufs_mtk_pltform = {
 	},
 };
 
+MODULE_AUTHOR("Stanley Chu <stanley.chu@mediatek.com>");
+MODULE_AUTHOR("Peter Wang <peter.wang@mediatek.com>");
+MODULE_DESCRIPTION("Mediatek UFS Driver");
+MODULE_LICENSE("GPL v2");
+
 module_platform_driver(ufs_mtk_pltform);
-- 
2.20.1
