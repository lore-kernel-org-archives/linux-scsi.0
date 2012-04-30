From: joseph daniel <josephdanielwalter@gmail.com>
Subject: [PATCH] scsi/mvsas: Remove an unused variable
Date: Mon, 30 Apr 2012 16:52:42 +0600
Message-ID: <1335783162-3185-1-git-send-email-josephdanielwalter@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:39111 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2D3Kww (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Apr 2012 06:52:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>, Dan Williams <dan.j.williams@intel.com>, joseph daniel <josephdanielwalter@gmail.com>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

the pointer of type struct domain_device is not used anywhere in the code.

Signed-off-by: joseph daniel <josephdanielwalter@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index fd3b283..3006ec9 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -885,7 +885,6 @@ static int mvs_task_exec(struct sas_task *task, const int num, gfp_t gfp_flags,
 				struct completion *completion, int is_tmf,
 				struct mvs_tmf_task *tmf)
 {
-	struct domain_device *dev = task->dev;
 	struct mvs_info *mvi = NULL;
 	u32 rc = 0;
 	u32 pass = 0;
-- 
1.7.9.5

