From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH 4/4] bfa:Update driver version to 3.2.25.0
Date: Thu, 26 Nov 2015 02:43:35 -0500
Message-ID: <1448523815-24562-5-git-send-email-anil.gurumurthy@qlogic.com>
References: <1448523815-24562-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:18065 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752825AbbKZIXr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Nov 2015 03:23:47 -0500
In-Reply-To: <1448523815-24562-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

From: Anil Gurumurthy <anil.gurumurthy@qlogic.com>

Signed-off-by: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Signed-off-by: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
---
 drivers/scsi/bfa/bfad_drv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_drv.h b/drivers/scsi/bfa/bfad_drv.h
index 8001459..f9e8620 100644
--- a/drivers/scsi/bfa/bfad_drv.h
+++ b/drivers/scsi/bfa/bfad_drv.h
@@ -58,7 +58,7 @@
 #ifdef BFA_DRIVER_VERSION
 #define BFAD_DRIVER_VERSION    BFA_DRIVER_VERSION
 #else
-#define BFAD_DRIVER_VERSION    "3.2.23.0"
+#define BFAD_DRIVER_VERSION    "3.2.25.0"
 #endif
 
 #define BFAD_PROTO_NAME FCPI_NAME
-- 
1.7.1

