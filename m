From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: INQUIRY always only untagged
Date: Fri, 1 Oct 2004 23:31:51 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041001233151.A8853@infradead.org>
References: <Pine.LNX.4.60.0409040033310.5266@poirot.grange> <20040904140102.A15247@infradead.org> <Pine.LNX.4.60.0409050022570.3092@poirot.grange> <20040904233835.A18659@infradead.org> <Pine.LNX.4.60.0409051654460.3039@poirot.grange> <1094398979.10977.9.camel@mulgrave> <20040905173134.A31521@infradead.org> <1094422949.10977.15.camel@mulgrave> <Pine.LNX.4.60.0409061042240.6252@poirot.grange> <Pine.LNX.4.60.0410012255410.3951@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:19206 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S266352AbUJAWb4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2004 18:31:56 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0410012255410.3951@poirot.grange>; from g.liakhovetski@gmx.de on Fri, Oct 01, 2004 at 11:00:23PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, Oct 01, 2004 at 11:00:23PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 6 Sep 2004, Guennadi Liakhovetski wrote:
> 
> > On Mon, 5 Sep 2004, James Bottomley wrote:
> >
> >> I think perhaps the correct palliative fix is simply to list this device
> >> (whatever it is, it's not listed in the bug report) as BLIST_NOTQ, then
> >> the problem won't arise (and of course, tmscsim would have actually to
> >> use the mid-layer black list rather than its own much shorter internal
> >> list).
> >
> > I don't know what device the original reporter had, but the one I have here, 
> > which exibits the same behaviour, is a Seagate disk (see attached patch). So, 
> > if you still think, this device should not be allowed any tags (which is a 
> > pity, I would then again have no device with tags supported for tests 
> > here:-(), then, please, apply the attached patch. A patch to use the 
> > blacklist will follow shortly.
> 
> Looks like this patch didn't get applied until now. Have you changed your 
> opinion about the proper handling of this disk, James, or it just somehow 
> got lost? Attaching again below. Next patch to tmscsim will switch the 
> driver to use the device information from the mid-layer, so, this patch is 
> required.

I get rejects in every single hunk when trying to apply your patches.  It
looks like some kind of whitespace messup, but I don't see in what way.

Did you recently switch mailers?

