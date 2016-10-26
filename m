From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH v2 11/11] mpt3sas: Bump driver version as "14.101.00.00"
Date: Wed, 26 Oct 2016 13:34:42 +0530
Message-ID: <1477469082-32395-12-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38160 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760348AbcJZIGs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2016 04:06:48 -0400
Received: by mail-wm0-f47.google.com with SMTP id d128so71207465wmf.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2016 01:06:47 -0700 (PDT)
In-Reply-To: <1477469082-32395-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, Sathya Prakash <sathya.prakash@broadcom.com>

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 5d9ae15..8de0eda 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -73,9 +73,9 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"14.100.00.00"
+#define MPT3SAS_DRIVER_VERSION		"14.101.00.00"
 #define MPT3SAS_MAJOR_VERSION		14
-#define MPT3SAS_MINOR_VERSION		100
+#define MPT3SAS_MINOR_VERSION		101
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
-- 
2.4.3

