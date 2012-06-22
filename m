From: Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/1] [SCSI] tcm_qla2xxx: Remove duplicate header file inclusion
Date: Fri, 22 Jun 2012 17:23:58 +0530
Message-ID: <1340366038-12722-1-git-send-email-sachin.kamat@linaro.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36569 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab2FVMGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jun 2012 08:06:00 -0400
Received: by pbbrp8 with SMTP id rp8so3473322pbb.19
        for <linux-scsi@vger.kernel.org>; Fri, 22 Jun 2012 05:06:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: JBottomley@parallels.com, nab@linux-iscsi.org, sachin.kamat@linaro.org, patches@linaro.org

ctype.h and string.h header files were included more than once.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index 6e64314..dd0a0df 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -38,8 +38,6 @@
 #include <linux/string.h>
 #include <linux/configfs.h>
 #include <linux/ctype.h>
-#include <linux/string.h>
-#include <linux/ctype.h>
 #include <asm/unaligned.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_host.h>
-- 
1.7.4.1

