From: Jesse Barnes <jbarnes@engr.sgi.com>
Subject: Re: SCSI QLA not working on latest *-mm SN2
Date: Tue, 21 Sep 2004 19:17:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200409211917.31817.jbarnes@engr.sgi.com>
References: <B179AE41C1147041AA1121F44614F0B0012AD911@AVEXCH02.qlogic.org> <200409211843.49312.jbarnes@engr.sgi.com> <20040921225405.GC147518@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:60380 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S267494AbUIUXTi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 19:19:38 -0400
In-Reply-To: <20040921225405.GC147518@sgi.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@steeleye.com>, Grant Grundler <grundler@parisc-linux.org>, pj@sgi.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdr@cthulhu.engr.sgi.com, jeremy@cthulhu.engr.sgi.com, djh@cthulhu.engr.sgi.com, Andrew Morton <akpm@osdl.org>

On Tuesday, September 21, 2004 6:54 pm, Jeremy Higdon wrote:
> On Tue, Sep 21, 2004 at 06:43:49PM -0400, Jesse Barnes wrote:
> > On Tuesday, September 21, 2004 6:39 pm, Jeremy Higdon wrote:
> > > On Tue, Sep 21, 2004 at 06:36:36PM -0400, Jesse Barnes wrote:
> > > > Shouldn't we do a config space read and *then* start the delay, which
> > > > will only delay for as long as it takes to reset the card on a 33 MHz
> > > > bus?
> > >
> > > The config space read has the same problem that the mmio space read
> > > does. The chip does not respond.
> >
> > Right, but config space reads are supposed to soft fail no matter what. 
> > So we'll get back all ones, but we'll also know that the write has been
> > received by the device.  We can start the delay regardless of the value
> > the read returns.
>
> I thought you said that config space read failures generate an MCA.
> Or are you going to fix that?

That's the plan.  I'll come up with a patch.

Jesse
