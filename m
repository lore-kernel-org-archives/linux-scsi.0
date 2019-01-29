From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 4/4] mpt3sas: Update driver version to 27.102.00.00
Date: Tue, 29 Jan 2019 07:14:43 -0500
Message-ID: <1548764083-5781-5-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548764083-5781-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

Updated driver version to 27.102.00.00 from 27.101.00.00.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index db12c1b..19158cb 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -75,9 +75,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"27.101.00.00"
+#define MPT3SAS_DRIVER_VERSION		"27.102.00.00"
 #define MPT3SAS_MAJOR_VERSION		27
-#define MPT3SAS_MINOR_VERSION		101
+#define MPT3SAS_MINOR_VERSION		102
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
-- 
1.8.3.1
