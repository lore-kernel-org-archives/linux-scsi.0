From: Pat LaVarre <p_lavarre@yahoo.com>
Subject: RE: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Wed, 9 Apr 2003 08:15:35 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409151535.59490.qmail@web21110.mail.yahoo.com>
Reply-To: p.lavarre@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web21110.mail.yahoo.com ([216.136.227.112]:393 "HELO
	web21110.mail.yahoo.com") by vger.kernel.org with SMTP
	id S263471AbTDIPD4 (for <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Apr 2003 11:03:56 -0400
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: p.lavarre@ieee.org, linux-usb-devel@lists.sourceforge.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

> > Fibre Channel, Parallel SCSI, SSA, IEEE 1394,
> > RDMA (infiniband), Internet SCSI, SAS, ...
> > ATAPI ... USB ...
>...
> SCSI thru the legacy PC printer port ...

I hear Windows contains separate binary-code-only for
each of these that it supports.

Rumour tells me, for example, that the first CDB's
seen by the device can vary between FireWire and USB,
because they don't come from a shared analogoue of
sd.c, but instead they come from code built for just
one particular bus, charged with beginning life by
distinguishing HDD from CD from DVD etc.

For example, I've heard that some FireWire HDD's
worked in Windows without supporting op x12 Inquiry.

Might be smart for Linux to give in sooner, rather
than later.  So long as we are engaged in publishing a
model of what the de facto Windows SCSI-over-whatever
standards are, we may as well include a copy the basic
structure of the original.

Pat LaVarre

P.S. Please ignore Yahoo spam that follows, if any.



__________________________________________________
Do you Yahoo!?
Yahoo! Tax Center - File online, calculators, forms, and more
http://tax.yahoo.com
