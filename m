From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: manual merge of the scsi tree with the staging tree
Date: Mon, 28 Aug 2017 18:51:59 +0100
Message-ID: <1503942719.2744.3.camel@HansenPartnership.com>
References: <20170828164127.15902025@canb.auug.org.au>
         <20170828064921.GA24696@kroah.com> <1503934884.2841.22.camel@wdc.com>
         <20170828160545.GA11231@kroah.com> <1503938165.2841.30.camel@wdc.com>
         <20170828164420.GB16802@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20170828164420.GB16802@kroah.com>
Sender: linux-next-owner@vger.kernel.org
To: "greg@kroah.com" <greg@kroah.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "hare@suse.de" <hare@suse.de>, "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "sameer.wadgaonkar@unisys.com" <sameer.wadgaonkar@unisys.com>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2017-08-28 at 18:44 +0200, greg@kroah.com wrote:
> On Mon, Aug 28, 2017 at 04:36:06PM +0000, Bart Van Assche wrote:
> > 
> > On Mon, 2017-08-28 at 18:05 +0200, greg@kroah.com wrote:
> > > 
> > > On Mon, Aug 28, 2017 at 03:41:28PM +0000, Bart Van Assche wrote:
> > > > 
> > > > * Most SCSI drivers exist under drivers/scsi, including the
> > > > virtio-scsi and   xen-scsifront drivers. So why has the
> > > > visorhba driver been added under unisys/visorhba?
> > > 
> > > That's because right now it's still a staging driver.  Also,
> > > there are other scsi drivers in other portions of the kernel tree
> > > (like the USB driver), so there's no hard rule that all scsi
> > > drivers have to be under drivers/scsi/
> > > 
> > > <snip>
> > > 
> > > Please provide this review to them, on the properly mailing list,
> > > I'm sure they would be glad to get it.
> > 
> > OK, I will do that. BTW, is there a written down version of the
> > rules for adding a driver under drivers/staging available
> > somewhere? 
> 
> The only 2 rules for adding a new drivers/staging driver is:
> 	- has to compile
> 	- correct license
> and sometimes we let code in if the first one isn't true :)
> 
> > 
> > As far as I can see the visorhba driver went in without the linux-
> > scsi mailing list having been CC-ed. See also Benjamin Romer,
> > [PATCH] staging: unisys: Add s-Par visorhba, linux-driver-devel
> > mailing list, July 2015
> > (https://urldefense.proofpoint.com/v2/url?u=https-3A__marc.info_-
> > 3Fl-3Dlinux-2Ddriver-2Ddevel-26m-
> > 3D143681271902628&d=DwIBAg&c=jf_iaSHvJObTbx-
> > siA1ZOg&r=lxuMXTRCffN3cvb-
> > aRKL97jBhWZUIH_7zc3AgXUz9Mw&m=muMI5n73yuzpaRBjZnIrYLfhcO8lIP0JZSjBG
> > D1LC5I&s=76_tO8QEuhUmhJPijDkweBOfh6DLPRILWj9Rhphb8j0&e= ).
> 
> That's totally normal, why would the scsi developers care about a
> staging driver in such a rough state.  Only when it looks "good
> enough" would we ask for a scsi developer review to move it out of
> staging.

I think I've said before, we'd really rather a SCSI driver went via the
SCSI tree because most of what's wrong with it will be the mechanics of
the driver and its interaction with the SCSI and block subsystems which
simply don't get looked at in the staging tree.  The aesthetics and the
formatting issues are mostly fixed by a quick trip through lindent or a
brief education of the submitters on Linux style.

James
