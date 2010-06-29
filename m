From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 06/12] be2iscsi: including patch from Dan Carpenter
Date: Wed, 30 Jun 2010 05:29:59 +0530
Message-ID: <20100629235948.GA20254@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:34347 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753598Ab0F2X7t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 19:59:49 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

	This patch fixes a  negative value being returned when
the return is declared as unsigned char.

Signed-off-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_mgmt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 7d4ac5c..3eba889 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -81,7 +81,7 @@ unsigned char mgmt_check_supported_fw(struct be_ctrl_info *ctrl,
 		SE_DEBUG(DBG_LVL_1,
 			 "Failed to allocate memory for mgmt_check_supported_fw"
 			 "\n");
-		return -1;
+		return 1;
 	}
 	nonemb_cmd.size = sizeof(struct be_mgmt_controller_attributes);
 	req = nonemb_cmd.va;
-- 
1.6.5.2

