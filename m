From: Anders Roxell <anders.roxell@linaro.org>
Subject: [PATCH v2] drivers: ufs: Add missing MODULE_* information
Date: Thu, 21 Mar 2019 14:24:44 +0100
Message-ID: <20190321132444.28659-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: jejb@linux.ibm.com, martin.petersen@oracle.com, matthias.bgg@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, Anders Roxell <anders.roxell@linaro.org>, linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
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
index c3b78fc83d3f..5e3bda42ac3b 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -364,4 +364,9 @@ static struct platform_driver ufs_mtk_pltform = {
 	},
 };
 
+MODULE_AUTHOR("Stanley Chu <stanley.chu@mediatek.com>");
+MODULE_AUTHOR("Peter Wang <peter.wang@mediatek.com>");
+MODULE_DESCRIPTION("MediaTek UFS Host Driver");
+MODULE_LICENSE("GPL v2");
+
 module_platform_driver(ufs_mtk_pltform);
-- 
2.20.1
