From: Chris Gamache <cgg007@yahoo.com>
Subject: Assistance with an upgraded scsi driver
Date: Thu, 1 Jul 2004 09:24:31 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040701162431.40296.qmail@web13810.mail.yahoo.com>
Reply-To: cgg007@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web13810.mail.yahoo.com ([216.136.175.218]:55195 "HELO
	web13810.mail.yahoo.com") by vger.kernel.org with SMTP
	id S266009AbUGAQYc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2004 12:24:32 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Linux 2.6.5 (Obtained via Gentoo's portage tree)

I'm sure that the SCSI Driver developers know the answer to this without even
thinking. I'm sincerely hoping that you all will be kind and give me a point in
the right direction. :)

The megaraid driver the compiles with the rest of the kernel modules in the
source tree doesn't (seem to) function for me... I can't get the controller
up-and-running. It is an ooold version of the driver. I want to compile the
shiny new megaraid driver to see if I have some better luck. I'm a bit lost,
though... The files in the new driver tarball are different than the ones in
the source tree. 

Link to new tarball:
ftp://ftp.lsil.com/pub/linux-megaraid/drivers/version-2.20.1.0/

Source tree: 

megaraid.c megaraid.h

New tarball:
Makefile     mega_common.h  megaraid_mbox.c  megaraid_mm.c
Kconfig.megaraid    mbox_defs.h  megaraid_ioctl.h     
megaraid_mbox.h  megaraid_mm.h

...

I've created a megaraid directory under /usr/src/linux/drivers/scsi

I modified the Makefile and Kconfig in /usr/src/linux/drivers/scsi

I cleaned out the old files

I re-configured to include the new options for compiling the MEGARAID_NEWGEN as
a module

I ran make all

... ... ...

No new module code was generated. :(

Where have I gone wrong?


		
__________________________________
Do you Yahoo!?
Yahoo! Mail - 50x more storage than other providers!
http://promotions.yahoo.com/new_mail
