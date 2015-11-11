From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 23/25] mpt2sas: Removed mpt2sas entries from SCSI's Kconfig and Makefile
Date: Wed, 11 Nov 2015 17:30:39 +0530
Message-ID: <1447243241-10912-24-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Removed mpt2sas entries from SCSI's Kconfig and Makefile files.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/Kconfig  | 1 -
 drivers/scsi/Makefile | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 95f7a76..8aed855 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -541,7 +541,6 @@ config SCSI_ARCMSR
 
 source "drivers/scsi/esas2r/Kconfig"
 source "drivers/scsi/megaraid/Kconfig.megaraid"
-source "drivers/scsi/mpt2sas/Kconfig"
 source "drivers/scsi/mpt3sas/Kconfig"
 source "drivers/scsi/ufs/Kconfig"
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index 1a8c9b5..c14bca4 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -106,7 +106,6 @@ obj-$(CONFIG_CXLFLASH)		+= cxlflash/
 obj-$(CONFIG_MEGARAID_LEGACY)	+= megaraid.o
 obj-$(CONFIG_MEGARAID_NEWGEN)	+= megaraid/
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid/
-obj-$(CONFIG_SCSI_MPT2SAS)	+= mpt2sas/
 obj-$(CONFIG_SCSI_MPT3SAS)	+= mpt3sas/
 obj-$(CONFIG_SCSI_UFSHCD)	+= ufs/
 obj-$(CONFIG_SCSI_ACARD)	+= atp870u.o
-- 
2.0.2
