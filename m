From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Vanilla 2.4.27 fails to compile on amd64
Date: 12 Sep 2004 14:23:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1095013408.1714.14.camel@mulgrave>
References: <1095009093.30166.632.camel@lh2.linush.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:51159 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268767AbUILSXk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 12 Sep 2004 14:23:40 -0400
In-Reply-To: <1095009093.30166.632.camel@lh2.linush.net>
List-Id: linux-scsi@vger.kernel.org
To: "C. Linus Hicks" <lhicks@nc.rr.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-09-12 at 13:11, C. Linus Hicks wrote:
> Is there a patch for this problem, and can the fix be included
> permanently in 2.4?

That's a known annoyance of the aic7xxx driver on non-x86 platforms. 
The attached patch should make it at least compile.

James

===== drivers/scsi/aic7xxx/Makefile 1.16 vs edited =====
--- 1.16/drivers/scsi/aic7xxx/Makefile	2003-05-30 16:56:17 -04:00
+++ edited/drivers/scsi/aic7xxx/Makefile	2004-09-12 14:21:38 -04:00
@@ -13,7 +13,7 @@
 obj-$(CONFIG_SCSI_AIC79XX)	+= aic79xx.o
 endif
 
-EXTRA_CFLAGS += -I$(TOPDIR)/drivers/scsi -Werror
+EXTRA_CFLAGS += -I$(TOPDIR)/drivers/scsi
 #EXTRA_CFLAGS += -g
 
 # Platform Specific Files

