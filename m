From: Sam Ravnborg <sam@ravnborg.org>
Subject: Move scsi.h, hosts.h to include/linux/scsi ?
Date: Sun, 16 Feb 2003 22:14:22 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030216211422.GD8572@mars.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mars.ravnborg.org (0x83a4d0fe.hrnxx2.adsl-dhcp.tele.dk [131.164.208.254])
	by pasmtp.tele.dk (Postfix) with ESMTP id CC4FEB4CD
	for <linux-scsi@vger.kernel.org>; Sun, 16 Feb 2003 22:14:22 +0100 (CET)
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

The usual rule within the kernel is that all header files useby more than
one file, or at least by files spread all over the kernel,
should be located in include/linux.

Has this been considered for scsi.h, and if not so - why not?
The same for hosts.h.

Background for my question is that I'm doing some kbuild changes,
and it is rather annoying to support include of scsi.h from all over.
See the following snippet from: arch/i386/kernel/edd.c

/* FIXME - this really belongs in include/scsi/scsi.h */
#include <../drivers/scsi/scsi.h>
#include <../drivers/scsi/hosts.h>
 
I'm willing to do the footwork if the general answer is 'go for it',
but do not want to invest the time needed before general acceptance.

By the way - more candidates in drivers/scsi?

	Sam
