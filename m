From: Adrian Bunk <bunk@fs.tum.de>
Subject: Re: [TRIVIAL] [2.5 patch] remove an unused function from NCR53c406a.c
Date: Thu, 10 Jul 2003 23:37:30 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030710213730.GL6848@fs.tum.de>
References: <1057586204.1812.2.camel@mulgrave> <20030708034706.C1ABF2C244@lists.samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:48330 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S269587AbTGJVW7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2003 17:22:59 -0400
Content-Disposition: inline
In-Reply-To: <20030708034706.C1ABF2C244@lists.samba.org>
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>

On Tue, Jul 08, 2003 at 11:27:45AM +1000, Rusty Russell wrote:
> In message <1057586204.1812.2.camel@mulgrave> you write:
> > On Mon, 2003-07-07 at 02:46, Rusty Trivial Russell wrote:
> > > From:  Adrian Bunk <bunk@fs.tum.de>
> > > 
> > >   The patch below removes an unused function from 
> > >   drivers/scsi/NCR53c406a.c .
> > >    
> > >   I've tested the compilation with 2.5.72-mm2.
> > 
> > Rusty, I'm not going to remove this immediately.
> > 
> > It's the old polling interface for the chip.  It was unplumbed when the
> > ->command() API was removed, but these chips were strangely connected to
> > soundblaster cards and may need to operate in no-interrupt mode (in
> > which case we'll need to ressurect it).  I'm just waiting to see if
> > anyone complains that their sound card attached CDROM no-longer works.
> 
> Thanks for taking the time to explain, James.  From the other patches
> Adrian sent, I think he was on a warning hunt.

Yup, that's correct.

> I'll turn off re-transmit on this patch, so if it gets applied later
> Adrian will get a closure mail, otherwise I'll dredge it up again late
> in the 2.6-pre stuff.

That's OK for me.

> Thanks!
> Rusty.

Thanks
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

