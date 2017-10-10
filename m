From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: [PATCH 10/10] mpt3sas: Bump mpt3sas driver version to v16.100.00.00
Date: Tue, 10 Oct 2017 18:41:23 +0530
Message-ID: <1507641083-20207-11-git-send-email-Sreekanth.Reddy@broadcom.com>
References: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f172.google.com ([209.85.216.172]:47309 "EHLO
        mail-qt0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932210AbdJJNMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 09:12:40 -0400
Received: by mail-qt0-f172.google.com with SMTP id z50so45910849qtj.4
        for <linux-scsi@vger.kernel.org>; Tue, 10 Oct 2017 06:12:39 -0700 (PDT)
In-Reply-To: <1507641083-20207-1-git-send-email-Sreekanth.Reddy@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, JBottomley@Parallels.com, Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>

Bump mpt3sas driver version to v16.100.00.00

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 75d90f2..0fe3969 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -73,8 +73,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"15.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		15
+#define MPT3SAS_DRIVER_VERSION		"16.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		16
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
2.4.3
