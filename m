From: "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 9/9][SCSI]mpt3sas: Bump mpt3sas driver version to
 v04.100.00.00
Date: Fri, 14 Mar 2014 21:44:43 +0530
Message-ID: <20140314161443.GA8421@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, sreekanth.reddy@lsi.com, linux-kernel@vger.kernel.org, sreekanthreddy0547@gmail.com
List-Id: linux-scsi@vger.kernel.org

Bump mpt3sas driver version to 04.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 8fb2a38..09545fc 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -70,8 +70,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"03.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		3
+#define MPT3SAS_DRIVER_VERSION		"04.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		4
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
1.7.1
