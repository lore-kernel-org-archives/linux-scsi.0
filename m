From: Martin Hicks <mort@wildopensource.com>
Subject: [mort@wildopensource.com: Re: [PATCH] remove __exit from mptscsih_exit()]
Date: Thu, 5 Feb 2004 18:31:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040205233109.GE28976@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from galileo.bork.org ([66.11.174.156]:31172 "HELO galileo.bork.org")
	by vger.kernel.org with SMTP id S266895AbUBEXbK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Feb 2004 18:31:10 -0500
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Here's a fix for the discarded symbol in mptscsih.c

I forgot to CC linux-scsi.

mh

----- Forwarded message from Martin Hicks <mort@wildopensource.com> -----

From: Martin Hicks <mort@wildopensource.com>
Subject: Re: [PATCH] remove __exit from mptscsih_exit()
Date: Thu, 5 Feb 2004 18:18:32 -0500
To: Martin Hicks <mort@wildopensource.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>,
	Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org



On Thu, Feb 05, 2004 at 06:17:19PM -0500, Martin Hicks wrote:
> 
> Hi James and Andrew
> 
> I needed to apply this patch to get my kernel to link on ia64.  The
> patch is against 2.6.2-mm1

and the patch this time...

-- 
Martin Hicks                Wild Open Source Inc.
mort@wildopensource.com     613-266-2296

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1552  -> 1.1553 
#	drivers/message/fusion/mptscsih.c	1.32    -> 1.33   
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 04/02/05	mort@green.i.bork.org	1.1553
# Get rid of __exit from mptscsih_exit() to get the
# kernel to link.
# --------------------------------------------
#
diff -Nru a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
--- a/drivers/message/fusion/mptscsih.c	Thu Feb  5 18:13:39 2004
+++ b/drivers/message/fusion/mptscsih.c	Thu Feb  5 18:13:39 2004
@@ -198,7 +198,7 @@
 
 /* module entry point */
 static int  __init    mptscsih_init  (void);
-static void __exit    mptscsih_exit  (void);
+static void    mptscsih_exit  (void);
 
 static int  __devinit mptscsih_probe (struct pci_dev *, const struct pci_device_id *);
 static void __devexit mptscsih_remove(struct pci_dev *);
@@ -1985,7 +1985,7 @@
  *
  */
 static void
-__exit mptscsih_exit(void)
+mptscsih_exit(void)
 {
 	MPT_ADAPTER	*ioc;
 


----- End forwarded message -----

-- 
Martin Hicks || mort@bork.org || PGP/GnuPG: 0x4C7F2BEE
