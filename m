From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 10/22] [SCSI] mpt2sas: Bump driver version to 20.100.00.00
Date: Mon, 12 Jan 2015 11:39:04 +0530
Message-ID: <1421042944-14988-11-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1421042944-14988-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Bump mpt2sas driver version to 20.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 46e8d51..caff8d1 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -70,8 +70,8 @@
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT2SAS_DRIVER_VERSION		"19.100.00.00"
-#define MPT2SAS_MAJOR_VERSION		19
+#define MPT2SAS_DRIVER_VERSION		"20.100.00.00"
+#define MPT2SAS_MAJOR_VERSION		20
 #define MPT2SAS_MINOR_VERSION		100
 #define MPT2SAS_BUILD_VERSION		00
 #define MPT2SAS_RELEASE_VERSION		00
-- 
2.0.2
