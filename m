From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH V8 9/9] aacraid: Update driver version
Date: Tue, 29 Sep 2015 09:50:24 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AEC60A27F@BBYEXM02.pmc-sierra.internal>
References: <1440758321-2996-1-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <1440758321-2996-10-git-send-email-Mahesh.Rajashekhara@pmcs.com>
 <B539A9786201A44A91E34268415A2B1AEC603C55@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:45404 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933616AbbI2JuZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Sep 2015 05:50:25 -0400
In-Reply-To: <B539A9786201A44A91E34268415A2B1AEC603C55@BBYEXM02.pmc-sierra.internal>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "JBottomley@Parallels.com" <JBottomley@Parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "thenzl@redhat.com" <thenzl@redhat.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>, "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>

Hi James,

Can you please let me know the status of V8 patch set.

Thanks,
Mahesh


-----Original Message-----
From: Mahesh Rajashekhara 
Sent: Wednesday, September 09, 2015 6:51 PM
To: Mahesh Rajashekhara; JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com; Murthy Bhat; Karthikeya Sunkesula; aacraid@pmc-sierra.com; Harry Yang; Rich Bono
Subject: RE: [PATCH V8 9/9] aacraid: Update driver version

Hi James,

Please let me know the status of V8 patchset.

Thanks,
Mahesh

-----Original Message-----
From: Mahesh Rajashekhara [mailto:Mahesh.Rajashekhara@pmcs.com] 
Sent: Friday, August 28, 2015 4:09 PM
To: JBottomley@Parallels.com; linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com; Murthy Bhat; Karthikeya Sunkesula; aacraid@pmc-sierra.com; Harry Yang; Rich Bono
Subject: [PATCH V8 9/9] aacraid: Update driver version

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Murthy Bhat <Murthy.Bhat@pmcs.com>
Reviewed-by: Karthikeya Sunkesula <Karthikeya.Sunkesula@pmcs.com>
Signed-off-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index 2de5ebc..074878b 100644
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
--
1.9.3

