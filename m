From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v4 11/17] be2iscsi: Fix return value for MCC completion
Date: Wed, 20 Jan 2016 14:10:55 +0530
Message-ID: <1453279261-659-12-git-send-email-jitendra.bhivare@avagotech.com>
References: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55634 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S933631AbcATIlx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Jan 2016 03:41:53 -0500
In-Reply-To: <1453279261-659-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Change return value of completed MCC EBUSY to EINVAL.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/be2iscsi/be_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 533060e..dbe62c0 100644
--- a/drivers/scsi/be2iscsi/be_cmds.c
+++ b/drivers/scsi/be2iscsi/be_cmds.c
@@ -323,7 +323,7 @@ static int be_mcc_compl_process(struct be_ctrl_info *ctrl,
 			if (resp_hdr->response_length)
 				return 0;
 		}
-		return -EBUSY;
+		return -EINVAL;
 	}
 	return 0;
 }
-- 
2.5.0

