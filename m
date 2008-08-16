From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: [PATCH] Fixup KERN_INFO in tmscsim.c
Date: Sun, 17 Aug 2008 00:00:44 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808162351560.6275@axis700.grange>
References: <20080815121045.48ca37e4@sauron.linicks.net>
 <Pine.LNX.4.64.0808152202440.7852@axis700.grange> <20080816090654.4a5188e2@sauron.linicks.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:54541 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751411AbYHPV7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 16 Aug 2008 17:59:40 -0400
In-Reply-To: <20080816090654.4a5188e2@sauron.linicks.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nick Warne <nick@ukfsn.org>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

From: Nick Warne <nick@ukfsn.org>

Multiline kernel messages should contain a priority in every line, 
besides, some log daemons represent a tabulator as "^I", fix both these 
issues.

Signed-off-by: Nick Warne <nick@ukfsn.org>
Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

---

On Sat, 16 Aug 2008, Nick Warne wrote:

> On Fri, 15 Aug 2008 22:17:57 +0200 (CEST)
> Guennadi Liakhovetski <g.liakhovetski@gmx.de> wrote:
> 
> > So, please, redo as above, create with "-p1" format, fix your Sob line
> 
> New patch attached.

Nick, I took the liberty to reformat your Sob and to replace the tab in 
your patch with spaces - as was in my previous reply to you. Hope, you 
don't mind:-)

diff -u linux-2.6.26.y/drivers/scsi/tmscsim.cORIG linux-2.6.26.y/drivers/scsi/tmscsim.c
--- linux-2.6.26.y/drivers/scsi/tmscsim.cORIG	2008-08-15 10:30:47.000000000 +0100
+++ linux-2.6.26.y/drivers/scsi/tmscsim.c	2008-08-16 08:45:43.000000000 +0100
@@ -2573,8 +2573,8 @@
 static int __init dc390_module_init(void)
 {
 	if (!disable_clustering)
-		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n"
-		       "\twith \"disable_clustering=1\" and report to maintainers\n");
+		printk(KERN_INFO "DC390: clustering now enabled by default. If you get problems load\n");
+		printk(KERN_INFO "       with \"disable_clustering=1\" and report to maintainers\n");
 
 	if (tmscsim[0] == -1 || tmscsim[0] > 15) {
 		tmscsim[0] = 7;

