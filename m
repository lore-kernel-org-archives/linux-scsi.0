From: Paul Wagland <paul@kungfoocoder.org>
Subject: RE: megaraid: ABORTING problem
Date: Tue, 13 Apr 2004 17:15:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1081869323.2113.16.camel@morsel.kungfoocoder.org>
References: <0E3FA95632D6D047BA649F95DAB60E57033BC51F@exa-atlanta.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out4.xs4all.nl ([194.109.24.5]:62728 "EHLO
	smtp-out4.xs4all.nl") by vger.kernel.org with ESMTP id S263609AbUDMPPn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Apr 2004 11:15:43 -0400
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57033BC51F@exa-atlanta.se.lsil.com>
List-Id: linux-scsi@vger.kernel.org
To: Atul Mukker <atulm@lsil.com>
Cc: Linux SCSI mailing list <linux-scsi@vger.kernel.org>

On Tue, 2004-04-13 at 17:09, Mukker, Atul wrote:
>  > In trying to do some performance analysis on my LSI Login 
> > SATA-150-6, I
> > 
> > megaraid: ABORTING-188cf36 cmd=2a <c=0 t=5 l=0>
> > megaraid: ABORTING-188cf36[52], fw owner.
> >
> You seem to be running a older version of the driver. Can you upgrade to the
> latest 2.10.3 or 2.20.x.x and re-test. Also, what is the firmware version on
> this controller.
> 
> -Atul Mukker

Ah. Guess I had better get to work adding in sysfs support to the new
unified driver then ;-)

This was the 2.6.4 kernel driver, and from /proc/hba0/config I get:

Version =712T:G116, DRAM = 64Mb

I was running these tests as part of a baseline to see what, if any,
performance differences there would be with the new unified driver.
Should this be fixed in that new driver?

Thanks in advance,
Paul

