From: mathieu.poirier@linaro.org
Subject: [PATCH RESEND 1/7] scsi: mark SCSI_SRP as experimental
Date: Fri,  8 Jun 2012 15:53:30 -0600
Message-ID: <1339192416-27026-2-git-send-email-mathieu.poirier@linaro.org>
References: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339192416-27026-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org
List-Id: linux-scsi@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

SCSI_SRP selects SCSI_TGT which is experimental and therefore
must be marked experimental.  Otherwise Kconfig warns about
symbols selecting other symbols that have unsatisfied
dependencies.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 drivers/scsi/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index e955978..ec8cc9a 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1803,8 +1803,9 @@ config SCSI_PM8001
 	  based host adapters.
 
 config SCSI_SRP
-	tristate "SCSI RDMA Protocol helper library"
+	tristate "SCSI RDMA Protocol helper library (EXPERIMENTAL)"
 	depends on SCSI && PCI
+	depends on EXPERIMENTAL
 	select SCSI_TGT
 	help
 	  If you wish to use SRP target drivers, say Y.
-- 
1.7.5.4
