From: "majianpeng" <majianpeng@gmail.com>
Subject: [PATCH] mvsas:Fix compile warning.
Date: Fri, 27 Apr 2012 13:31:16 +0800
Message-ID: <201204271331071715586@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65464 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab2D0Fat (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Apr 2012 01:30:49 -0400
Received: by mail-pb0-f46.google.com with SMTP id rp8so122417pbb.19
        for <linux-scsi@vger.kernel.org>; Thu, 26 Apr 2012 22:30:49 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley <JBottomley@parallels.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 drivers/scsi/mvsas/mv_sas.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

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
1.7.5.4

 				
--------------
majianpeng
2012-04-27

