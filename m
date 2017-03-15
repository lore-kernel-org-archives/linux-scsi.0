From: Sebastian Herbszt <herbszt@gmx.de>
Subject: [PATCH] efct: add missing include file
Date: Wed, 15 Mar 2017 21:26:48 +0100
Message-ID: <20170315212648.00006c3f@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55592 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751236AbdCOU3G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Mar 2017 16:29:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Sebastian Herbszt <herbszt@gmx.de>

After the split of linux/sched.h, linux/sched/signal.h is required.

Signed-off-by: Sebastian Herbszt <herbszt@gmx.de>
---
 efct/efct_os.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/efct/efct_os.h b/efct/efct_os.h
index 16f7dc3..5ae269e 100644
--- a/efct/efct_os.h
+++ b/efct/efct_os.h
@@ -56,6 +56,7 @@
 #include <linux/seq_file.h>
 #include <linux/random.h>
 #include <linux/sched.h>
+#include <linux/sched/signal.h>
 #include <linux/jiffies.h>
 #include <linux/ctype.h>
 #include <linux/debugfs.h>
-- 
2.7.3
