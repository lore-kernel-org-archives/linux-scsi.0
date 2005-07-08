From: Mark Haverkamp <markh@osdl.org>
Subject: Re: [PATCH] 2.6 aacraid: Fix for controller load based timeouts
Date: Fri, 08 Jul 2005 10:59:45 -0700
Message-ID: <1120845585.19677.48.camel@markh1.pdx.osdl.net>
References: <1120844190.19677.46.camel@markh1.pdx.osdl.net>
	 <1120844507.19828.70.camel@ryan2.internal.autoweb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:42204 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S262737AbVGHR7y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2005 13:59:54 -0400
In-Reply-To: <1120844507.19828.70.camel@ryan2.internal.autoweb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ryan@autoweb.net
Cc: James Bottomley <James.Bottomley@steeleye.com>, Mark Salyzyn <mark_salyzyn@adaptec.com>, linux-scsi <linux-scsi@vger.kernel.org>, Martin Drab <drab@kepler.fjfi.cvut.cz>

On Fri, 2005-07-08 at 13:41 -0400, Ryan Anderson wrote:
> On Fri, 2005-07-08 at 10:36 -0700, Mark Haverkamp wrote:
> > Martin Drab found that he could get aacraid timeouts with high load on
> > his controller / disk drive combinations.  After some experimentation
> > Mark Salyzyn has come up with a patch to reduce the default max_sectors
> > to something that will keep the controller from being overloaded and
> > will eliminate the timeout issues.
> 
> Would hitting this timeout issue cause the container to go offline?

Yes, the usual results of the overload timeouts are that the container
goes offline.

> 
> If so, I think this may fix the issues I was having 6 months ago.  (We
> ended up taking the aacraid controller out of our production
> environment, in frustration.)
> 
> I'll try to get some testing time in on this next week, though, the
> problems I've run into were very hard to reproduce on demand.
> 
-- 
Mark Haverkamp <markh@osdl.org>

