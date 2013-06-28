From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH 7/7][SCSI] mpt3sas: Bump driver version to v02.100.00.00
Date: Sat, 29 Jun 2013 03:55:45 +0530
Message-ID: <20130628222545.GA5070@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:43333
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753840Ab3F1LaX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Jun 2013 07:30:23 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, Sathya.Prakash@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com


Bump driver version to v02.100.00.00.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3610647..0ebf5d9 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -70,10 +70,10 @@
 #define MPT3SAS_DRIVER_NAME		"mpt3sas"
 #define MPT3SAS_AUTHOR	"LSI Corporation <DL-MPTFusionLinux@lsi.com>"
 #define MPT3SAS_DESCRIPTION	"LSI MPT Fusion SAS 3.0 Device Driver"
-#define MPT3SAS_DRIVER_VERSION		"01.100.01.00"
-#define MPT3SAS_MAJOR_VERSION		1
+#define MPT3SAS_DRIVER_VERSION		"02.100.00.00"
+#define MPT3SAS_MAJOR_VERSION		2
 #define MPT3SAS_MINOR_VERSION		100
-#define MPT3SAS_BUILD_VERSION		1
+#define MPT3SAS_BUILD_VERSION		0
 #define MPT3SAS_RELEASE_VERSION	00
 
 /*
-- 
1.7.3


