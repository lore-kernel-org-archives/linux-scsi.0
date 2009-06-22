From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: New IDE maintainer (was Re: cmd64x: irq 14: nobody cared -
	system is dreadfully slow)
Date: Sun, 21 Jun 2009 18:53:26 -0600
Message-ID: <20090622005326.GQ19977@parisc-linux.org>
References: <20090621.141950.160759111.davem@davemloft.net> <20090621.155756.100422570.davem@davemloft.net> <20090621.161343.181101055.davem@davemloft.net> <200906220145.03923.bzolnier@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200906220145.03923.bzolnier@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: David Miller <davem@davemloft.net>, elendil@planet.nl, sparclinux@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 22, 2009 at 01:45:03AM +0200, Bartlomiej Zolnierkiewicz wrote:
> On Monday 22 June 2009 01:13:43 David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Sun, 21 Jun 2009 15:57:56 -0700 (PDT)
> > 
> > > From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> > > Date: Mon, 22 Jun 2009 00:34:22 +0200
> > > 
> > >> Lets get over this quickly, since you seem to have such a great
> > >> insight into running IDE layer here is a little proposition..
> > >> 
> > >> ACK?  [ If not than can we please get back with the program? ]
> > > 
> > > Acked-by: David S. Miller <davem@davemloft.net>
> > 
> > I'm going to treat IDE as pure legacy, rather than as competition
> > with the PATA drivers which is what people whould be moving over to.
> > 
> > And more importantly I refuse to apply any driver patch that isn't
> > actually tested on said hardware.
> > 
> > ide: Take over as maintainer.
> 
> Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> You have my full support (don't hesitate to ping me if you need some
> help) and I hope that the last few years of my of work would make your
> job relatively easy and painless.
> 
> I would also like to use this occasion and thank all the people who
> have been contributing to the project during my reign.  Thanks!!

Thanks, Bart.

It isn't easy to be maintainer of a subsystem that is being obsoleted
by another.  It's even less easy to gracefully hand over maintenance,
as you have done.  Personally, I'd love it if you could contribute to
the ATA drivers in the future.  I think there are a number of ways they
could stand to be improved.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
