From: akpm@osdl.org
Subject: [patch 21/24] drivers/scsi/dpt/dpti_i2o.h: removal of old scsi code
Date: Mon, 14 Aug 2006 23:09:37 -0700
Message-ID: <200608150609.k7F69bXM013270@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:16534 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S965193AbWHOGK3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Aug 2006 02:10:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, michal.k.k.piotrowski@gmail.com

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/dpt/dpti_i2o.h |   10 ----------
 1 file changed, 10 deletions(-)

diff -puN drivers/scsi/dpt/dpti_i2o.h~drivers-scsi-dpt-dpti_i2oh-removal-of-old drivers/scsi/dpt/dpti_i2o.h
--- a/drivers/scsi/dpt/dpti_i2o.h~drivers-scsi-dpt-dpti_i2oh-removal-of-old
+++ a/drivers/scsi/dpt/dpti_i2o.h
@@ -47,21 +47,11 @@
  *	I2O Interface Objects
  */
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,4,0)
-
-#define DECLARE_MUTEX(name) struct semaphore name=MUTEX
-
-typedef struct wait_queue *adpt_wait_queue_head_t;
-#define ADPT_DECLARE_WAIT_QUEUE_HEAD(wait) adpt_wait_queue_head_t wait = NULL
-typedef struct wait_queue adpt_wait_queue_t;
-#else
-
 #include <linux/wait.h>
 typedef wait_queue_head_t adpt_wait_queue_head_t;
 #define ADPT_DECLARE_WAIT_QUEUE_HEAD(wait) DECLARE_WAIT_QUEUE_HEAD(wait)
 typedef wait_queue_t adpt_wait_queue_t;
 
-#endif
 /*
  * message structures
  */
_
