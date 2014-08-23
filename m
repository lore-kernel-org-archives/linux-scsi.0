From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH v1 8/8][SCSI] mpt3sas: Bump mpt3sas driver version to 04.100.00.00
Date: Sat, 23 Aug 2014 17:41:42 +0530
Message-ID: <1408795902-10523-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1408795902-10523-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:58731 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaHWMMu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 23 Aug 2014 08:12:50 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so17261705pde.10
        for <linux-scsi@vger.kernel.org>; Sat, 23 Aug 2014 05:12:49 -0700 (PDT)
In-Reply-To: <1408795902-10523-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Bump mpt3sas driver version to 04.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index ca4a7cc..40926aa 100644
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
2.0.2

