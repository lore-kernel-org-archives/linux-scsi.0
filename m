From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH v3 11/17] be2iscsi: Fix return value for MCC completion
Date: Wed, 23 Dec 2015 14:04:30 +0530
Message-ID: <1450859676-22025-12-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:55541 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S964814AbbLWIfD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Dec 2015 03:35:03 -0500
In-Reply-To: <1450859676-22025-1-git-send-email-jitendra.bhivare@avagotech.com>
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
index d69fb0a..1e6a1b6 100644
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
1.9.1

