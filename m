From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] mmc_block: use generic helper to print capacities
Date: Fri, 05 Sep 2008 16:03:54 -0500
Message-ID: <1220648634.3331.57.camel@localhost.localdomain>
References: <48B9546B.4010004@simon.arlott.org.uk>
	 <1220117091.3615.3.camel@localhost.localdomain>
	 <20080830174516.GD1239@parisc-linux.org>
	 <48B9B552.8060406@simon.arlott.org.uk>
	 <48B9B588.7060709@simon.arlott.org.uk>
	 <1220147947.3615.18.camel@localhost.localdomain>
	 <20080831025412.GJ1239@parisc-linux.org>
	 <1220195310.4021.4.camel@localhost.localdomain>
	 <1220195634.4021.9.camel@localhost.localdomain>
	 <20080831205448.5b23507d@mjolnir.drzeus.cx>
	 <1220645340.3331.55.camel@localhost.localdomain>
	 <20080905225209.29aace1b@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:33777 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754671AbYIEVD4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2008 17:03:56 -0400
In-Reply-To: <20080905225209.29aace1b@mjolnir.drzeus.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2008-09-05 at 22:52 +0200, Pierre Ossman wrote:
> On Fri, 05 Sep 2008 15:09:00 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > On Sun, 2008-08-31 at 20:54 +0200, Pierre Ossman wrote:
> > > From: Pierre Ossman <drzeus@drzeus.cx>
> > > 
> > > Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>
> > 
> > Did you want me to take this?
> 
> That was the idea since it needed your helper.
> 
> > It seems to depend on pieces of your mmc
> > tree, so I'd have to carry it in my post-merge tree.
> > 
> 
> Oh? There shouldn't be any changes around those chunks. What kind of
> problems are you seeing?

Oh ... your inline attached patch is actually whitespace broken (it has
spaces for tabs), which is why it doesn't apply.  Sorry, that's the
first thing I usually check, I just skipped it in your case.  Could you
resend it as an attachment?

Thanks,

James


