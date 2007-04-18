From: David Miller <davem@davemloft.net>
Subject: Re: Major qla2xxx regression on sparc64
Date: Wed, 18 Apr 2007 13:13:41 -0700 (PDT)
Message-ID: <20070418.131341.129061984.davem@davemloft.net>
References: <20070416200857.GH10822@andrew-vasquezs-computer.local>
	<20070418171346.GA16471@infradead.org>
	<20070418172802.GD12708@andrew-vasquezs-computer.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56639
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S2992490AbXDRUNi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2007 16:13:38 -0400
In-Reply-To: <20070418172802.GD12708@andrew-vasquezs-computer.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com
Cc: hch@infradead.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Date: Wed, 18 Apr 2007 10:28:02 -0700

> On Wed, 18 Apr 2007, Christoph Hellwig wrote:
> 
> > I don't think a module option is a good idea at this point.  The problem
> > is you broke some so far perfectly working setups, which is not okay.
> > The only first step can be printing a really big warning.  After this
> > has been in for a while (at lest half a year) we can make it a non-default
> > option or turn if off completely in case the warning never triggered in
> > practice.
> > 
> > The only resonable thing for 2.6.21 is to put in David's patch, possible
> > with an even more drastic warning when the rom is invalid and there's
> > no prom-fallback available.
> > 
> > Note that I expect Sun put in the invalid ROM intentionally, as we have
> > similar cases with other cards that have totally messed up ROMs in
> > Sun-branded versions.  Personally I think that's an utterly bad decision
> > from Sun's side, but we'll have to live with this.
> 
> Fine.  I'll rework an alternate patch for the 2.6.22 timeframe...

We need to fix things now for 2.6.21 and the 2.6.x -stable branches
because users have unusable systems currently.

If it's just a time issue I can work on and push the patch, especially
since I have the means to test things here.

