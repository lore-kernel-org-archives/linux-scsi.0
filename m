From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 2/2] hisi_sas: Restrict SCSI_HISI_SAS to arm64
Date: Fri, 15 Jan 2016 14:39:09 +0100
Message-ID: <1452865149-32064-2-git-send-email-geert@linux-m68k.org>
References: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1452865149-32064-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-scsi@vger.kernel.org

The HiSilicon SAS HBA is available in HiSilicon arm64 SoCs only.
Restrict it to arm64, unless compile-testing.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/scsi/hisi_sas/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/hisi_sas/Kconfig b/drivers/scsi/hisi_sas/Kconfig
index 2c05021636a5fea6..b67661836c9fa26f 100644
--- a/drivers/scsi/hisi_sas/Kconfig
+++ b/drivers/scsi/hisi_sas/Kconfig
@@ -1,6 +1,7 @@
 config SCSI_HISI_SAS
 	tristate "HiSilicon SAS"
 	depends on HAS_DMA
+	depends on ARM64 || COMPILE_TEST
 	select SCSI_SAS_LIBSAS
 	select BLK_DEV_INTEGRITY
 	help
-- 
1.9.1
