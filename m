From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from NCR53c406a.c
Date: Tue, 08 Jul 2003 11:27:45 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708034706.C1ABF2C244@lists.samba.org>
References: <1057586204.1812.2.camel@mulgrave>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dp.samba.org ([66.70.73.150]:27327 "EHLO lists.samba.org")
	by vger.kernel.org with ESMTP id S266881AbTGHDcb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jul 2003 23:32:31 -0400
In-reply-to: Your message of "07 Jul 2003 08:56:42 EST."
             <1057586204.1812.2.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, Adrian Bunk <bunk@fs.tum.de>

In message <1057586204.1812.2.camel@mulgrave> you write:
> On Mon, 2003-07-07 at 02:46, Rusty Trivial Russell wrote:
> > From:  Adrian Bunk <bunk@fs.tum.de>
> > 
> >   The patch below removes an unused function from 
> >   drivers/scsi/NCR53c406a.c .
> >    
> >   I've tested the compilation with 2.5.72-mm2.
> 
> Rusty, I'm not going to remove this immediately.
> 
> It's the old polling interface for the chip.  It was unplumbed when the
> ->command() API was removed, but these chips were strangely connected to
> soundblaster cards and may need to operate in no-interrupt mode (in
> which case we'll need to ressurect it).  I'm just waiting to see if
> anyone complains that their sound card attached CDROM no-longer works.

Thanks for taking the time to explain, James.  From the other patches
Adrian sent, I think he was on a warning hunt.

I'll turn off re-transmit on this patch, so if it gets applied later
Adrian will get a closure mail, otherwise I'll dredge it up again late
in the 2.6-pre stuff.

Thanks!
Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
