From: Martin Drab <drab@kepler.fjfi.cvut.cz>
Subject: Re: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Fri, 8 Jul 2005 20:17:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0507082014210.14785@kepler.fjfi.cvut.cz>
References: <1120844190.19677.46.camel@markh1.pdx.osdl.net>
 <1120844507.19828.70.camel@ryan2.internal.autoweb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kepler.fjfi.cvut.cz ([147.32.6.11]:31629 "EHLO
	kepler.fjfi.cvut.cz") by vger.kernel.org with ESMTP id S262761AbVGHSRx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2005 14:17:53 -0400
In-Reply-To: <1120844507.19828.70.camel@ryan2.internal.autoweb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>



On Fri, 8 Jul 2005, Ryan Anderson wrote:

> On Fri, 2005-07-08 at 10:36 -0700, Mark Haverkamp wrote:
> > Martin Drab found that he could get aacraid timeouts with high load on
> > his controller / disk drive combinations.  After some experimentation
> > Mark Salyzyn has come up with a patch to reduce the default max_sectors
> > to something that will keep the controller from being overloaded and
> > will eliminate the timeout issues.
> 
> Would hitting this timeout issue cause the container to go offline?

Yes. See my previous report to LKML.
(http://lkml.org/lkml/2005/7/5/194)
 
> If so, I think this may fix the issues I was having 6 months ago.  (We
> ended up taking the aacraid controller out of our production
> environment, in frustration.)
>
> I'll try to get some testing time in on this next week, though, the
> problems I've run into were very hard to reproduce on demand.

Yes, just try to do some heavy copying of large files.

Martin

