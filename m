From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: libata driver update posted
Date: Fri, 18 Jul 2003 11:43:22 -0400
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20030718154322.GB27152@gtf.org>
References: <3F1711C8.6040207@pobox.com> <Pine.LNX.4.53.0307180924020.19703@hosting.rdsbv.ro> <3F17F28C.9050105@pobox.com> <1058542771.13515.1599.camel@workshop.saharacpt.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1058542771.13515.1599.camel@workshop.saharacpt.lan>
To: Martin Schlemmer <azarah@gentoo.org>
Cc: Catalin BOIE <util@deuroconsult.ro>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Vojtech Pavlik <vojtech@suse.cz>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jul 18, 2003 at 05:39:32PM +0200, Martin Schlemmer wrote:
> On Fri, 2003-07-18 at 15:13, Jeff Garzik wrote:
> > Catalin BOIE wrote:
> > >>Next update will add several host drivers, now that the libata API is
> > >>settling down.
> > > 
> > > 
> > > Sii3112A is/will be supported?
> > 
> > 
> > Yes, will be.
> > 
> > Silicon Image and Promise support are most likely next.
> > 
> 
> How is performance compared to the default driver for the ICH5 SATA ?

I haven't done any comparisons because the "default driver" just flat
out doesn't work for me.

However, if performance is lower, then I consider that a bug.

	Jeff
