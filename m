From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: FWD: [BK PATCH] SCSI host num allocation improvement
Date: Fri, 27 Feb 2004 13:26:34 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040227212634.GB1441@beaverton.ibm.com>
References: <1077842444.2662.123.camel@mulgrave> <20040227124811.A32109@infradead.org> <20040227130414.GH4019@phunnypharm.org> <20040227164925.GC1424@beaverton.ibm.com> <20040227170005.GQ4019@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:8683 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S263140AbUB0V1F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 16:27:05 -0500
Content-Disposition: inline
In-Reply-To: <20040227170005.GQ4019@phunnypharm.org>
List-Id: linux-scsi@vger.kernel.org
To: Ben Collins <bcollins@debian.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Ben Collins [bcollins@debian.org] wrote:
> On Fri, Feb 27, 2004 at 08:49:25AM -0800, Mike Anderson wrote:
> > Ben Collins [bcollins@debian.org] wrote:
> > > On Fri, Feb 27, 2004 at 12:48:11PM +0000, Christoph Hellwig wrote:
> > > > On Thu, Feb 26, 2004 at 06:40:43PM -0600, James Bottomley wrote:
> > > > > I'm forwarding this to linux-scsi, which is the appropriate list to
> > > > > scrutinise it.
> > > > 
> > > > Well, the last patch looks sane if we want to do that.  But didn't we
> > > > declare the mononically increasing host numbers a feature?
> > > 
> > > I can't see how things like the device naming can work the "right" way,
> > > but making the host numbers work in an increasing fashion would be a
> > > feature or even a benefit.
> > > 
> > 
> > I thought the direction was that default kernels names where headed in
> > the direction of being depreciated. Are you using udev or something else
> > for you naming policy. Is your naming policy based on position? Are the
> > devices you are attaching unable to return a unique ID. Device naming
> > based on immutable values are better.
> 
> Not sure if you are directing this at me(firewire), but the ieee1394
> devices are immutable naming that comes from the device. I don't have
> any control over how the scsi layer sets up the scsi host numbers and
> device names though.
> 

I guess I was directing it at you trying to understand the issue of
device naming working the "right" way and default kernel names picked
for hosts / devices. I can see the possible legacy issues of host /
device numbers reaching beyond the bounds the applications expects.
There is also the theoretical issue of scsi host numbers wrapping which
I believe has been mentioned in a old thread. I do not see the issue if
someone is using udev naming along with a increasing scsi host number.

-andmike
--
Michael Anderson
andmike@us.ibm.com

