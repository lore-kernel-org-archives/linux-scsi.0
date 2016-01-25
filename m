From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 03/22] scsi: Fix dependencies for !HAS_IOMEM and
	!HAS_DMA archs
Date: Mon, 25 Jan 2016 23:24:02 +0100
Message-ID: <1453760661-1444-4-git-send-email-richard@nod.at>
References: <1453760661-1444-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <user-mode-linux-devel-bounces@lists.sourceforge.net>
In-Reply-To: <1453760661-1444-1-git-send-email-richard@nod.at>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel>,
	<mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=user-mode-linux-devel>
List-Post: <mailto:user-mode-linux-devel@lists.sourceforge.net>
List-Help: <mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel>,
	<mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: user-mode-linux-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: John Garry <john.garry@huawei.com>, user-mode-linux-devel@lists.sourceforge.net, "Martin K. Petersen" <martin.petersen@oracle.com>, Richard Weinberger <richard@nod.at>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Not every arch has io or DMA memory.
So, unbreak the build by fixing the dependencies.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/scsi/hisi_sas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 37a0c71..f9157f4 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -2,5 +2,6 @@ config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
+	depends on HAS_IOMEM && HAS_DMA
 	help
 		This driver supports HiSilicon's SAS HBA
-- 
1.8.4.5


------------------------------------------------------------------------------
Site24x7 APM Insight: Get Deep Visibility into Application Performance
APM + Mobile APM + RUM: Monitor 3 App instances at just $35/Month
Monitor end-to-end web transactions and take corrective actions now
Troubleshoot faster and improve end-user experience. Signup Now!
http://pubads.g.doubleclick.net/gampad/clk?id=267308311&iu=/4140
