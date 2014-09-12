From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v2 12/18][SCSI] mpt3sas: Bump mpt3sas driver version to 03.100.00.00
Date: Fri, 12 Sep 2014 15:35:27 +0530
Message-ID: <1410516333-3678-13-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410516333-3678-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

Bump mpt3sas driver version to 03.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 184826c..575f1bc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -70,8 +70,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"02.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		2
+#define MPT3SAS_DRIVER_VERSION		"03.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		3
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
2.0.2
