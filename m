From: Marcelo Tosatti <marcelo.tosatti@cyclades.com>
Subject: Re: two sym53c8xx.o modules
Date: Thu, 9 Oct 2003 10:00:16 -0300 (BRT)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310090959550.3040-100000@logos.cnet>
References: <20031009122428.GF11525@bitwizard.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <20031009122428.GF11525@bitwizard.nl>
To: Erik Mouw <erik@harddisk-recovery.com>
Cc: Marcelo Tosatti <marcelo.tosatti@cyclades.com>, Xose Vazquez Perez <xose@wanadoo.es>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org



On Thu, 9 Oct 2003, Erik Mouw wrote:

> On Thu, Oct 09, 2003 at 08:41:49AM -0300, Marcelo Tosatti wrote:
> > On Thu, 9 Oct 2003, Xose Vazquez Perez wrote:
> > > kernel 2.4 has two modules with *same name*:
> > > /lib/modules/2.4.XX/kernel/drivers/scsi/sym53c8xx_2/sym53c8xx.o
> > > /lib/modules/2.4.XX/kernel/drivers/scsi/sym53c8xx.o
> > > 
> > > "# modprobe sym53c8xx" tries to load sym53c8xx.o first and then sym53c8xx_2/sym53c8xx.o
> > > bug or feature?
> > > 
> > > should be sym53c8xx_2/sym53c8xx.o renamed to sym53c8xx_2/sym53c8xx_2.o ?
> > 
> > One should not have both drivers loaded at the same time, so I think this
> > is alright.
> 
> No, it's not allright. Modprobe can't distinguish between
> sym53c8xx_2/sym53c8xx.o and sym53c8xx.o, you have to figure out the
> full path and insmod one of them manually. Xose is right in that
> sym53c8xx_2/sym53c8xx.o should be renamed in sym53c8xx_2/sym53c8xx_2.o.
> Compare with aic7xxx and aic7xxx_old.

True. Mind sending me a patch? 
