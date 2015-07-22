From: <rajinikanth.pandurangan@pmcs.com>
Subject: [PATCH V5 09/11] [SCSI] aacraid: Update driver version
Date: Wed, 22 Jul 2015 09:49:15 -0700
Message-ID: <1437583757-5449-10-git-send-email-rajinikanth.pandurangan@pmcs.com>
References: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:57072 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965440AbbGVQuP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jul 2015 12:50:15 -0400
In-Reply-To: <1437583757-5449-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com, harry.yang@pmcs.com, rich.bono@pmcs.com, mahesh.rajashekhara@pmcs.com, achim.leubner@pmcs.com, murthy.bhat@pmcs.com, rajinikanth.pandurangan@pmcs.com

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 drivers/scsi/aacraid/linit.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index 7b95227..73c3384 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -62,7 +62,7 @@ enum {
 #define	PMC_GLOBAL_INT_BIT0		0x00000001
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 40709
+# define AAC_DRIVER_BUILD 41010
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 35dd849..3fabfa1 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -56,7 +56,7 @@
 
 #include "aacraid.h"
 
-#define AAC_DRIVER_VERSION		"1.2-1"
+#define AAC_DRIVER_VERSION		"1.2-2"
 #ifndef AAC_DRIVER_BRANCH
 #define AAC_DRIVER_BRANCH		""
 #endif
-- 
1.9.3

