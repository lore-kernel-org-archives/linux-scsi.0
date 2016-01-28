From: Suganath prabu Subaramani <suganath-prabu.subramani@avagotech.com>
Subject: [mpt3sas driver 10/10] mpt3sas: Updating mpt3sas driver version to 12.100.00.00
Date: Thu, 28 Jan 2016 12:07:07 +0530
Message-ID: <1453963027-19770-11-git-send-email-suganath-prabu.subramani@avagotech.com>
References: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1453963027-19770-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@avagotech.com, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com
List-Id: linux-scsi@vger.kernel.org

From: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>

Bump mpt3sas driver version from 09.102.00.00 to 12.100.00.00

Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 24bd19a..32580b5 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -73,9 +73,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"09.102.00.00"
-#define MPT3SAS_MAJOR_VERSION		9
-#define MPT3SAS_MINOR_VERSION		102
+#define MPT3SAS_DRIVER_VERSION		"12.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		12
+#define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
-- 
1.8.3.1
