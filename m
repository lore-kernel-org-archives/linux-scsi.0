From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 10 Sep 2003 15:07:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063228028.6151.1.camel@patehci2>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:24209 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265726AbTIJV1b
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Sep 2003 17:27:31 -0400
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

I see Google didn't thread my first try properly, sorry.  Here I am
again with an edited subject line.

-----Forwarded Message-----

From: Pat LaVarre <p.lavarre@ieee.org>
To: stern@rowland.harvard.edu
Cc: mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org
Subject: Re: [usb-storage] Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 10 Sep 2003 12:16:31 -0600


> What do the SCSI folk have to say about it?

Anyone?

> > for 2.6.0 ... drivers/scsi/sd.c ...
> > sd_read_cache_type ...
> > Get rid of (or #ifdef out) most ...
>
> Is there any feeling about how to handle these
> ongoing problems with the mode-sense cache
> page?

Yes, much.

Maybe more feeling if you remind/teach me what breaks if we don't fetch
page 8 re Cache.  First I imagine automounters mount read-only disks rw,
and then the write cache gets errors while flushing.  I wonder what else
breaks.  Maybe thruput varies for devices that do or do not bother to
claim they have write cache.

Maybe more feeling if you can say how in/accurate page 8 re Cache
commonly is.  For example, I know of no clear & broadly adopted standard
that requires a device to declare write-behind or background defect map
updates as a form of write cache.

> There doesn't seem to be any general solution
> that can work with all USB storage devices.

I understand you to be saying we can settle for an sd solution, we don't
mind if the sd heuristic we discover then doesn't apply to pdt x05
dvd/cd.

> some hang when asked to read just the page
> header.
> ...
> some hang when asked to read just part of the
> page;
> ...
> Some hang when asked to read the entire page;

Device folk ship bugs, aye, same as host folk.

Are not two of these three failures disproportionately common?

Me, I would expect asking anything but what Windows asks would fail most
often.  Is that not so?  Do we know what Windows asks?  Do we know
if/how Win ME/ 2K/ XP differ here?  Have we matched CBWCB and
dCBWDataTransferLength in every bit?

Pat LaVarre



