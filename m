From: John Garry <john.garry@huawei.com>
Subject: [PATCH] hisi_sas: add dependency for HAS_IOMEM
Date: Tue, 26 Jan 2016 19:59:12 +0800
Message-ID: <1453809552-240944-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net, richard@nod.at, geert@linux-m68k.org, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

Not every arch has io, so fix build by adding
necessary dependency.

Signed-off-by: John Garry <john.garry@huawei.com>
Suggested-by: Richard Weinberger <richard@nod.at>

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index b676618..d1dd161 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -1,6 +1,6 @@
 config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
-	depends on HAS_DMA
+	depends on HAS_DMA && HAS_IOMEM
 	depends on ARM64 || COMPILE_TEST
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
-- 
1.9.1
