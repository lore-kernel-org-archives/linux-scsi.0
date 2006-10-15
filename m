From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 0/2] aic94xx: Supermicro motherboards support
Date: Sun, 15 Oct 2006 12:31:14 -0700 (PDT)
Message-ID: <20061015193114.69853.qmail@web31811.mail.mud.yahoo.com>
References: <1160930840.2917.387.camel@fc6.xsintricity.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31811.mail.mud.yahoo.com ([68.142.207.74]:11401 "HELO
	web31811.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1422829AbWJOTbP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Oct 2006 15:31:15 -0400
In-Reply-To: <1160930840.2917.387.camel@fc6.xsintricity.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Sergey Kononenko <sergk@sergk.org.ua>, linux-scsi@vger.kernel.org

--- Doug Ledford <dledford@redhat.com> wrote:
> On Sat, 2006-10-14 at 18:21 -0700, Luben Tuikov wrote:
> > > As i found this code was commented out in original driver by Luben
> > > Tuikov with following comment:
> > > 
> > > /*     Early (current?) SuperMicro mainboards, X6DHR-3G2 and X6DH3-G2
> > >        have a bug whereby RS104 is missing (not installed) and RS103
> > >        is installed, causing FLASHEX to be 0. */
> > > /*     if (!(reg & FLASHEX)) { */
> > > /*             ASD_DPRINTK("flash doesn't exist\n"); */
> > > /*             return -ENOENT; */
> > > /*     } */
> > > 
> > > May be it is possible to write separate code for checking
> > > availability of flash chip especially for supermicro
> > > motherboards, but i don't know hot it possible and don't know what is
> > > RS104, RS103 and difference between it.
> > 
> > RSxyz stands for "resistor xyz" in the schematic diagrams.
> > This is a hardware bug in the (early?) SuperMicro mainboards.
> > It dates from last year, 20 October 2005.
> 
> This wouldn't be the first (or last I'm sure) time a hardware
> manufacturer didn't properly set up the external resistors that signal
> to the chip whether or not certain options are installed.  In the past
> I've done searches of the PCI device space looking for specific
> northbridge/southbridge pairs so I would know when to ignore certain
> hardware indicators based upon buggy motherboard setups.

That's a very neat trick! (to identifying mainboards)

    Luben

P.S. For aic94xx, all boards shipped out (to customers) do have
a flash chip installed (to store things like SAS phy parameters,
SAS addresses, etc), so it would be safe to ignore FLASHEX bit.


