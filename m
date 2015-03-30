From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 07/20] [SCSI] mpt3sas: Bump mpt3sas Driver version to v5.100.00.00
Date: Mon, 30 Mar 2015 19:25:10 +0530
Message-ID: <1427723723-12676-8-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34784 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbbC3N4P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Mar 2015 09:56:15 -0400
Received: by pdbni2 with SMTP id ni2so176554291pdb.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Mar 2015 06:56:15 -0700 (PDT)
In-Reply-To: <1427723723-12676-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Bump mpt3sas Driver version to v5.100.00.00

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index a182d26..29ecfd1 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -71,8 +71,8 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR "Avago Technologies <MPT-FusionLinux.pdl@avagotech.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"04.100.00.00"
-#define MPT3SAS_MAJOR_VERSION		4
+#define MPT3SAS_DRIVER_VERSION		"05.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		5
 #define MPT3SAS_MINOR_VERSION		100
 #define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
-- 
2.0.2

