From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 13/13] mpt3sas: Update mpt3sas driver version.
Date: Thu, 29 Jun 2017 19:49:14 +0530
Message-ID: <1498745954-7907-14-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:37084 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753432AbdF2OWF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jun 2017 10:22:05 -0400
Received: by mail-wm0-f44.google.com with SMTP id i127so16528682wma.0
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jun 2017 07:22:04 -0700 (PDT)
In-Reply-To: <1498745954-7907-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com

Updated mpt3sas driver version to 15.101.00.00

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index ea6e607..835d6da 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -74,11 +74,11 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"15.100.00.00"
+#define MPT3SAS_DRIVER_VERSION		"15.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		15
-#define MPT3SAS_MINOR_VERSION		100
+#define MPT3SAS_MINOR_VERSION		101
 #define MPT3SAS_BUILD_VERSION		0
-#define MPT3SAS_RELEASE_VERSION	00
+#define MPT3SAS_RELEASE_VERSION		0
 
 #define MPT2SAS_DRIVER_NAME		"mpt2sas"
 #define MPT2SAS_DESCRIPTION	"LSI MPT Fusion SAS 2.0 Device Driver"
-- 
1.7.1
