From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: [PATCH] scsi: remove LINUX_VERSION_CODE macro usage from dpt
Date: Sat, 14 Jan 2006 18:57:14 +0200
Message-ID: <1137257835.9318.21.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1]:23719 "EHLO
	mail.cs.helsinki.fi") by vger.kernel.org with ESMTP
	id S1750737AbWANQ5R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 14 Jan 2006 11:57:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: linux-scsi@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

This patch removes LINUX_VERSION_CODE macro usage from the dpt driver in
drivers/scsi/.

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---

 drivers/scsi/dpt/dpti_i2o.h |   10 ----------
 1 file changed, 10 deletions(-)

Index: 2.6/drivers/scsi/dpt/dpti_i2o.h
===================================================================
--- 2.6.orig/drivers/scsi/dpt/dpti_i2o.h
+++ 2.6/drivers/scsi/dpt/dpti_i2o.h
@@ -48,21 +48,11 @@
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


