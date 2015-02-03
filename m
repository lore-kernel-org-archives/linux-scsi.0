From: <anil.gurumurthy@qlogic.com>
Subject: [PATCH RESEND 4/4] bfa:Update driver version to 3.2.25.0
Date: Tue, 3 Feb 2015 03:45:03 -0500
Message-ID: <1422953103-5470-5-git-send-email-anil.gurumurthy@qlogic.com>
References: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:32850 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751563AbbBCJYk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Feb 2015 04:24:40 -0500
In-Reply-To: <1422953103-5470-1-git-send-email-anil.gurumurthy@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, Anil Gurumurthy <anil.gurumurthy@qlogic.com>

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

