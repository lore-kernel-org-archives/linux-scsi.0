From: Parag Warudkar <parag.lkml@gmail.com>
Subject: Re: [PATCH] SCSI IOCTL: Check for device deletion [was Re:
 __elv_add_request OOPS]
Date: Wed, 25 May 2011 16:22:50 -0400 (EDT)
Message-ID: <alpine.DEB.2.02.1105251622040.8972@ubuntu-natty>
References: <alpine.DEB.2.02.1105232329040.1910@natty-nar> <4DDB8BF6.2000304@fusionio.com> <alpine.DEB.2.02.1105242127340.3472@ubuntu-natty> <4DDCB1C8.7040708@fusionio.com> <alpine.DEB.2.02.1105251416340.3472@ubuntu-natty> <BANLkTimZi6rPSA-1OX+ZAh3135SMpDcHKg@mail.gmail.com>
 <4DDD5240.2060308@fusionio.com> <BANLkTikSXMZ3a6-e4-k5dV5vHtegxuUL-w@mail.gmail.com> <4DDD55D6.1080909@fusionio.com> <alpine.DEB.2.02.1105251548420.2742@ubuntu-natty> <BANLkTimWPWc4k2_q0KZpmWo9G93UmVWoxA@mail.gmail.com>
 <1306354818.1641.55.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1306354818.1641.55.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Parag Warudkar <parag.lkml@gmail.com>, Jens Axboe <jaxboe@fusionio.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Wed, 25 May 2011, James Bottomley wrote:

> On Wed, 2011-05-25 at 13:03 -0700, Linus Torvalds wrote:
> > On Wed, May 25, 2011 at 12:52 PM, Parag Warudkar <parag.lkml@gmail.com> wrote:
> > >
> > > +static inline int sdev_early_check(struct scsi_device *sdev)
> > > +{
> > > +       if (!sdev || sdev->sdev_state == SDEV_DEL
> > > +               || sdev->sdev_state > SDEV_QUIESCE)
> > > +               return -ENXIO;
> > > +       return 0;
> > > +}
> > 
> > Can somebody explain why it's those states, and nothing else?
> 
> The states are definitely wrong.  QUIESCE shouldn't cause an error.
> 
QUIESCE is not causing an error above - > QUIESCE is which per the 
documentation is correct.

Parag
