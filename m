From: mathieu.poirier@linaro.org
Subject: [PATCH 1/7] scsi: mark SCSI_SRP as experimental
Date: Fri, 11 May 2012 16:09:22 -0600
Message-ID: <1336774168-26577-2-git-send-email-mathieu.poirier@linaro.org>
References: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58842 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030224Ab2EKWJg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2012 18:09:36 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so3813332pbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 11 May 2012 15:09:35 -0700 (PDT)
In-Reply-To: <1336774168-26577-1-git-send-email-mathieu.poirier@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, mathieu.poirier@linaro.org

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
index 29684c8..651f905 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1885,8 +1885,9 @@ config SCSI_PM8001
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

