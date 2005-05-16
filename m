From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] aic7xxx: remove some DV leftovers
Date: Mon, 16 May 2005 20:51:13 +0200
Message-ID: <20050516185113.GA16811@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:45196 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261806AbVEPSvT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2005 14:51:19 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org


Index: linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h
===================================================================
--- linux-2.6.orig/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 19:25:37.000000000 +0200
+++ linux-2.6/drivers/scsi/aic7xxx/aic7xxx_osm.h	2005-05-16 19:26:55.000000000 +0200
@@ -488,15 +488,9 @@
 
 	spinlock_t		 spin_lock;
 	u_int			 qfrozen;
-	pid_t			 dv_pid;
 	struct timer_list	 completeq_timer;
 	struct timer_list	 reset_timer;
 	struct semaphore	 eh_sem;
-	struct semaphore	 dv_sem;
-	struct semaphore	 dv_cmd_sem;	/* XXX This needs to be in
-						 * the target struct
-						 */
-	struct scsi_device	*dv_scsi_dev;
 	struct Scsi_Host        *host;		/* pointer to scsi host */
 #define AHC_LINUX_NOIRQ	((uint32_t)~0)
 	uint32_t		 irq;		/* IRQ for this adapter */
