From: Wei Yongjun <weiyj.lk@gmail.com>
Subject: [PATCH -next] target: remove unused including <linux/version.h>
Date: Thu, 29 Aug 2013 08:00:48 +0800
Message-ID: <CAPgLHd99FTjnSBbeRnVMxEYKPisJ5qdzm0=a8ZKeyF7m-=XkSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:53249 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008Ab3H2AAu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Aug 2013 20:00:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: yongjun_wei@trendmicro.com.cn, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/target/target_core_xcopy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 7e12286..fb4b0c5 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -21,7 +21,6 @@
  *
  ******************************************************************************/
 
-#include <linux/version.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/list.h>

