From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 18/25] mpt2sas, mpt3sas: Update the driver versions
Date: Wed, 11 Nov 2015 17:30:34 +0530
Message-ID: <1447243241-10912-19-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Bump the mpt2sas driver version to 20.102.00.00 and
Bump the mpt3sas driver version to 9.101.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 6d64fa8..213d7f8 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -71,17 +71,22 @@
 
 /* driver versioning info */
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
-#define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"09.100.00.00"
-#define MPT2SAS_DRIVER_VERSION		"20.101.00.00"
+#define MPT3SAS_DRIVER_VERSION		"09.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		9
-#define MPT3SAS_MINOR_VERSION		100
+#define MPT3SAS_MINOR_VERSION		101
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
+#define MPT2SAS_DRIVER_NAME		"mpt2sas"
+#define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
+#define MPT2SAS_DRIVER_VERSION		"20.102.00.00"
+#define MPT2SAS_MAJOR_VERSION		20
+#define MPT2SAS_MINOR_VERSION		102
+#define MPT2SAS_BUILD_VERSION		0
+#define MPT2SAS_RELEASE_VERSION	00
+
 /*
  * Set MPT3SAS_SG_DEPTH value based on user input.
  */
-- 
2.0.2
