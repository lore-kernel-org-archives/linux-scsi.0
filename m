From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH v2 9/9] aacraid: Update driver version
Date: Thu, 10 Dec 2015 10:45:59 -0800
Message-ID: <1449773159-25058-10-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:32813 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752093AbbLKBka (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Dec 2015 20:40:30 -0500
In-Reply-To: <1449773159-25058-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Santosh.Akula@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

Updated diver version to 41052

Changes from V2:
None

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index a440840..22130b3 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -62,7 +62,7 @@ enum {
 #define	PMC_GLOBAL_INT_BIT0		0x00000001
 
 #ifndef AAC_DRIVER_BUILD
-# define AAC_DRIVER_BUILD 41010
+# define AAC_DRIVER_BUILD 41052
 # define AAC_DRIVER_BRANCH "-ms"
 #endif
 #define MAXIMUM_NUM_CONTAINERS	32
-- 
1.9.1

