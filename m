From: "Bagalkote, Sreenivas" <sreenib@lsil.com>
Subject: RE: Why are MegaRAID drivers mutually exclusive?
Date: Wed, 10 Nov 2004 14:24:06 -0500
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570562C128@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:44996 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S262093AbUKJTYW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Nov 2004 14:24:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Chris Adams' <cmadams@hiwaay.net>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

The new and old drivers are mutually exclusive to the extent that
both cannot be loaded simultaneously as they both work on same
hardware. It only seems logical that this exclusivity is represented
in Kconfig as well.

Thanks,
Sreenivas 
LSI Logic

>-----Original Message-----
>From: Chris Adams [mailto:cmadams@hiwaay.net] 
>Sent: Wednesday, November 10, 2004 12:05 PM
>To: linux-scsi@vger.kernel.org
>Subject: Why are MegaRAID drivers mutually exclusive?
>
>I've got some systems that need the old megaraid driver with 
>Fedora Core 3, however it isn't being built.  Looking at 
>Kconfig.megaraid, I see that the new and old drivers are 
>mutually exclusive?  Is there a reason for that?  It means 
>that packagers can't build both as modules.
>
>Is there a good reason not to do:
>
>diff -urN 
>linux-2.6.9-dist/drivers/scsi/megaraid/Kconfig.megaraid 
>linux-2.6.9/drivers/scsi/megaraid/Kconfig.megaraid
>--- linux-2.6.9-dist/drivers/scsi/megaraid/Kconfig.megaraid	
>2004-10-18 16:53:22.000000000 -0500
>+++ linux-2.6.9/drivers/scsi/megaraid/Kconfig.megaraid	
>2004-11-10 10:33:26.748570929 -0600
>@@ -63,7 +63,6 @@
> 	To compile this driver as a module, choose M here: the
> 	module will be called megaraid_mbox
> 
>-if MEGARAID_NEWGEN=n
> config MEGARAID_LEGACY
> 	tristate "LSI Logic Legacy MegaRAID Driver"
> 	depends on PCI && SCSI
>@@ -74,4 +73,3 @@
> 
> 	To compile this driver as a module, choose M here: the
> 	module will be called megaraid
>-endif
>
>
>I looked in MAINTAINERS, CREDITS, megaraid.txt, and 
>ChangeLog.megaraid, but I didn't see that there was any more 
>specific list to use for the megaraid driver (other than three 
>author addresses listed in megaraid_mbox.c).
>
>--
>Chris Adams <cmadams@hiwaay.net>
>Systems and Network Administrator - HiWAAY Internet Services I 
>don't speak for anybody but myself - that's enough trouble.
>-
>To unsubscribe from this list: send the line "unsubscribe 
>linux-scsi" in the body of a message to 
>majordomo@vger.kernel.org More majordomo info at  
>http://vger.kernel.org/majordomo-info.html
>
