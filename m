From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [RFC] [PATCH 1/9] drivers/scsi/dpt/dpti_i2o.h Removal of old
 scsi code
Date: Sat, 12 Aug 2006 23:01:55 +0200
Message-ID: <44DE41C3.2050308@gmail.com>
References: <44DE3E5E.3020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:17043 "EHLO
	nf-out-0910.google.com") by vger.kernel.org with ESMTP
	id S1422688AbWHLVBU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Aug 2006 17:01:20 -0400
Received: by nf-out-0910.google.com with SMTP id a4so1295187nfc
        for <linux-scsi@vger.kernel.org>; Sat, 12 Aug 2006 14:01:20 -0700 (PDT)
In-Reply-To: <44DE3E5E.3020605@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

diff -uprN -X linux-work/Documentation/dontdiff linux-work-clean/drivers/scsi/dpt/dpti_i2o.h linux-work/drivers/scsi/dpt/dpti_i2o.h
--- linux-work-clean/drivers/scsi/dpt/dpti_i2o.h	2006-08-12 01:51:16.000000000 +0200
+++ linux-work/drivers/scsi/dpt/dpti_i2o.h	2006-08-12 20:54:40.000000000 +0200
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


