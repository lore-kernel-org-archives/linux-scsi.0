From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove an unused function from NC53c406a
Date: Sat, 22 May 2004 18:45:10 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522164510.GA31646@infradead.org>
References: <20040519203430.GB10507@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:33921 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261638AbUEVQpP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 12:45:15 -0400
Content-Disposition: inline
In-Reply-To: <20040519203430.GB10507@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: jejb@steeleye.com
Cc: linux-scsi@vger.kernel.org

and here's a variant using #if 0


===== drivers/scsi/NCR53c406a.c 1.25 vs edited =====
--- 1.25/drivers/scsi/NCR53c406a.c	2003-07-31 16:32:16 +02:00
+++ edited/drivers/scsi/NCR53c406a.c	2004-05-22 18:44:31 +02:00
@@ -170,7 +170,6 @@
 /* Static function prototypes */
 static void NCR53c406a_intr(int, void *, struct pt_regs *);
 static irqreturn_t do_NCR53c406a_intr(int, void *, struct pt_regs *);
-static void wait_intr(void);
 static void chip_init(void);
 static void calc_port_addr(void);
 #ifndef IRQ_LEV
@@ -665,6 +664,7 @@
 	return (info_msg);
 }
 
+#if 0
 static void wait_intr(void)
 {
 	unsigned long i = jiffies + WATCHDOG;
@@ -684,6 +684,7 @@
 
 	NCR53c406a_intr(0, NULL, NULL);
 }
+#endif
 
 static int NCR53c406a_queue(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 {
