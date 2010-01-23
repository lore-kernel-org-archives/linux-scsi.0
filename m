From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 5/8] be2iscsi: correcting the return
Date: Sat, 23 Jan 2010 05:37:40 +0530
Message-ID: <20100123000722.GA12638@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:40002 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754308Ab0AWAHg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Jan 2010 19:07:36 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

       This patch fixes an issue where return was not called properly.
Thanks to Mike Christie for spotting this

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 2f0027c..6b700ad 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3873,7 +3873,7 @@ static int __init beiscsi_module_init(void)
 		SE_DEBUG(DBG_LVL_1,
 			 "beiscsi_module_init - Unable to  register beiscsi"
 			 "transport.\n");
-		ret = -ENOMEM;
+		return -ENOMEM;
 	}
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_module_init, tt=%p \n",
 		 &beiscsi_iscsi_transport);
-- 
1.6.4

