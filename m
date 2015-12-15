From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 11/15] be2iscsi: Fix return value for MCC completion
Date: Tue, 15 Dec 2015 21:25:02 +0530
Message-ID: <1450194906-12925-12-git-send-email-jitendra.bhivare@avagotech.com>
References: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:63989 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754133AbbLOPze (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2015 10:55:34 -0500
In-Reply-To: <1450194906-12925-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra <jitendra.bhivare@avagotech.com>

From: Jitendra <jitendra.bhivare@avagotech.com>

Change return value of completed MCC EBUSY to EINVAL.

Signed-off-by: Jitendra <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_cmds.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
index 9bb5905..eced82b 100644
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
1.7.1

