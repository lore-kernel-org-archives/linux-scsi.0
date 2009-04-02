From: Huang Weiyi <weiyi.huang@gmail.com>
Subject: [PATCH 8/9] [SCSI] fcoe: remove unused #include <version.h>
Date: Thu,  2 Apr 2009 23:34:17 +0800
Message-ID: <1238686457-1116-1-git-send-email-weiyi.huang@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:42522 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759519AbZDBPeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 11:34:24 -0400
Received: by ti-out-0910.google.com with SMTP id i7so569717tid.23
        for <linux-scsi@vger.kernel.org>; Thu, 02 Apr 2009 08:34:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, Huang Weiyi <weiyi.huang@gmail.com>

Remove unused #include <version.h> in drivers/scsi/fcoe/libfcoe.c.

Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
---
 drivers/scsi/fcoe/libfcoe.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/fcoe/libfcoe.c b/drivers/scsi/fcoe/libfcoe.c
index 0d6f5be..1eb4f73 100644
--- a/drivers/scsi/fcoe/libfcoe.c
+++ b/drivers/scsi/fcoe/libfcoe.c
@@ -18,7 +18,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/version.h>
 #include <linux/kernel.h>
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
-- 
1.6.0.4

