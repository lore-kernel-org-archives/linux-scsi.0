From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Major qla2xxx regression on sparc64
Date: Wed, 18 Apr 2007 10:28:02 -0700
Message-ID: <20070418172802.GD12708@andrew-vasquezs-computer.local>
References: <20070416.010218.130850966.davem@davemloft.net> <20070416163712.GA10822@andrew-vasquezs-computer.local> <20070416.123743.07452378.davem@davemloft.net> <20070416200857.GH10822@andrew-vasquezs-computer.local> <20070418171346.GA16471@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:22321 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992916AbXDRR2H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Apr 2007 13:28:07 -0400
Content-Disposition: inline
In-Reply-To: <20070418171346.GA16471@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@SteelEye.com, ema@debian.org

On Wed, 18 Apr 2007, Christoph Hellwig wrote:

> I don't think a module option is a good idea at this point.  The problem
> is you broke some so far perfectly working setups, which is not okay.
> The only first step can be printing a really big warning.  After this
> has been in for a while (at lest half a year) we can make it a non-default
> option or turn if off completely in case the warning never triggered in
> practice.
> 
> The only resonable thing for 2.6.21 is to put in David's patch, possible
> with an even more drastic warning when the rom is invalid and there's
> no prom-fallback available.
> 
> Note that I expect Sun put in the invalid ROM intentionally, as we have
> similar cases with other cards that have totally messed up ROMs in
> Sun-branded versions.  Personally I think that's an utterly bad decision
> from Sun's side, but we'll have to live with this.

Fine.  I'll rework an alternate patch for the 2.6.22 timeframe...

