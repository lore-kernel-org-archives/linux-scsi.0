From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] deprecate the old NCR53C9x driver
Date: Sun, 13 May 2007 22:48:31 +0200
Message-ID: <20070513204831.GA23196@lst.de>
References: <20070429220548.GA22666@lst.de> <Pine.LNX.4.64.0704301516190.27246@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:52896 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754890AbXEMUsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 16:48:41 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704301516190.27246@anakin>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@osdl.org, torvalds@osdl.org, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Mon, Apr 30, 2007 at 03:16:39PM +0200, Geert Uytterhoeven wrote:
> > +What:	old NCR53C9x driver
> > +When:	October 2007
> > +Why:	Replaced by the much better esp_scsi driver.  Actual low-level
> > +	driver can ported over almost trivially.
>                   ^
> 		  be

current linus' tree still has my spelling mistake.  Here's a patch to
update it:


Index: linux-2.6/Documentation/feature-removal-schedule.txt
===================================================================
--- linux-2.6.orig/Documentation/feature-removal-schedule.txt	2007-05-13 21:46:38.000000000 +0200
+++ linux-2.6/Documentation/feature-removal-schedule.txt	2007-05-13 21:46:44.000000000 +0200
@@ -62,7 +62,7 @@ Who:	Dan Dennedy <dan@dennedy.org>, Stef
 What:	old NCR53C9x driver
 When:	October 2007
 Why:	Replaced by the much better esp_scsi driver.  Actual low-level
-	driver can ported over almost trivially.
+	driver can be ported over almost trivially.
 Who:	David Miller <davem@davemloft.net>
 	Christoph Hellwig <hch@lst.de>
 
