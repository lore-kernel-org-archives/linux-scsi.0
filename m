From: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>
Subject: RE: [PATCH 9/9] [SCSI] aacraid: Update driver version
Date: Fri, 15 May 2015 02:58:07 +0000
Message-ID: <B539A9786201A44A91E34268415A2B1AB7F6AD2C@BBYEXM01.pmc-sierra.internal>
References: <1431562378-8514-1-git-send-email-rajinikanth.pandurangan@pmcs.com>
 <1431562378-8514-10-git-send-email-rajinikanth.pandurangan@pmcs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:38785 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423341AbbEOC6I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 May 2015 22:58:08 -0400
In-Reply-To: <1431562378-8514-10-git-send-email-rajinikanth.pandurangan@pmcs.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "aacraid@pmc-sierra.com" <aacraid@pmc-sierra.com>, Harry Yang <Harry.Yang@pmcs.com>, Rich Bono <Rich.Bono@pmcs.com>, Achim Leubner <Achim.Leubner@pmcs.com>, Murthy Bhat <Murthy.Bhat@pmcs.com>, Rajinikanth Pandurangan <Rajinikanth.Pandurangan@pmcs.com>

Reviewed-by: Mahesh Rajashekhara <Mahesh.Rajashekhara@pmcs.com>

-----Original Message-----
From: rajinikanth.pandurangan@pmcs.com [mailto:rajinikanth.pandurangan@pmcs.com] 
Sent: Thursday, May 14, 2015 5:43 AM
To: jbottomley@parallels.com; linux-scsi@vger.kernel.org
Cc: aacraid@pmc-sierra.com; Harry Yang; Rich Bono; Achim Leubner; Murthy Bhat; Rajinikanth Pandurangan
Subject: [PATCH 9/9] [SCSI] aacraid: Update driver version

From: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>

Signed-off-by: Rajinikanth Pandurangan <rajinikanth.pandurangan@pmcs.com>
---
 drivers/scsi/aacraid/aacraid.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h index ec32a2bdd..7a73eca 100644
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

