From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 13/13] mpt3sas: Update mpt3sas driver version.
Date: Tue, 31 Oct 2017 18:02:39 +0530
Message-ID: <1509453159-7028-14-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1509453159-7028-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:50105 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932742AbdJaMeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 Oct 2017 08:34:03 -0400
Received: by mail-qt0-f194.google.com with SMTP id k31so20439758qta.6
        for <linux-scsi@vger.kernel.org>; Tue, 31 Oct 2017 05:34:02 -0700 (PDT)
In-Reply-To: <1509453159-7028-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sathya.Prakash@broadcom.com, linux-kernel@vger.kernel.org, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org, Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>

Updated mpt3sas driver version to 17.100.00.00

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 2d005af..ef7d001 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -74,8 +74,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"16.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		16
+#define MPT3SAS_DRIVER_VERSION		"17.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		17
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
2.5.5
