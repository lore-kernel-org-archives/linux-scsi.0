From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@pmcs.com>
Subject: [PATCH V2 9/9] aacraid: Update driver version
Date: Wed, 6 Jan 2016 23:22:24 -0800
Message-ID: <1452151344-417-10-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
References: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:44864 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752547AbcAFXMj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2016 18:12:39 -0500
In-Reply-To: <1452151344-417-1-git-send-email-RaghavaAditya.Renukunta@pmcs.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, linux-scsi@vger.kernel.org
Cc: Mahesh.Rajashekhara@pmcs.com, Murthy.Bhat@pmcs.com, Gana.Sridaran@pmcs.com, aacraid@pmc-sierra.com, Scott.Benesh@pmcs.com, jthumshirn@suse.de, thenzl@redhat.com, David.Carroll@pmcs.com, RaghavaAditya.Renukunta@pmcs.com

From: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>

Updated diver version to 41052

Changes in V2:
None

Signed-off-by: Raghava Aditya Renukunta <raghavaaditya.renukunta@pmcs.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
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

