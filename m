From: mathieu.poirier@linaro.org
Subject: [PATCH 4/7] scsi/advansys: do not build on ARM
Date: Fri, 11 May 2012 16:09:25 -0600
Message-ID: <1336774168-26577-5-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The advansys driver uses the dma_cache_sync interface
which is impossible to support on ARM.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 651f905..2f49a00 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -584,6 +584,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI && VIRT_TO_BUS
 	depends on ISA || EISA || PCI
+	depends on !ARM # no support for DMA_CACHE_SYNC
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
-- 
1.7.5.4
