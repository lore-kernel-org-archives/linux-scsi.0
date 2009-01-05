From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH] missing include in cxgb3i
Date: Mon, 5 Jan 2009 17:21:11 +0000
Message-ID: <20090105172111.GP28946@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:36617 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbZAERVN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jan 2009 12:21:13 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

it needs scatterlist.h - indirect chain of includes doesn't work on
a lot of targets.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/cxgb3i/cxgb3i_ddp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/cxgb3i/cxgb3i_ddp.c b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
index 1a41f04..08f3a09 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_ddp.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_ddp.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/skbuff.h>
+#include <linux/scatterlist.h>
 
 /* from cxgb3 LLD */
 #include "common.h"
-- 
1.5.6.5


