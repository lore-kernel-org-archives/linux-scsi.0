From: Tobias Klauser <tklauser@nuerscht.ch>
Subject: Re: [PATCH] scsi/a100u2w: Remove custom msecs_to_jiffies and jiffies_to_msecs macros
Date: Wed, 13 Apr 2005 17:01:02 +0200
Message-ID: <20050413150102.GA1921@neon>
References: <20050413121104.GA9419@argon.tklauser.home> <20050413144308.GA9616@infradead.org> <20050413145100.GA9958@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from server3.hostpoint.ch ([217.26.52.13]:11271 "EHLO
	server3.hostpoint.ch") by vger.kernel.org with ESMTP
	id S261364AbVDMPBr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2005 11:01:47 -0400
Content-Disposition: inline
In-Reply-To: <20050413145100.GA9958@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Alexey Dobriyan <adobriyan@mail.ru>
Cc: kernel-janitors@lists.osdl.org, linux-scsi@vger.kernel.org

On Wed, Apr 13, 2005 at 03:51:00PM +0100, Christoph Hellwig wrote:
> On Wed, Apr 13, 2005 at 03:43:08PM +0100, Christoph Hellwig wrote:
> > >  static void waitForPause(unsigned amount)
> > >  {
> > > -	ULONG the_time = jiffies + MS_TO_JIFFIES(amount);
> > > +	ULONG the_time = jiffies + msecs_to_jiffies(amount);
> > >  	while (time_before_eq(jiffies, the_time))
> > >  		cpu_relax();
> > 
> > You should probably replace this function with msleep completely.
> 
> I actually meant mdelay, but as mentioned in the other followup that might
> need some more research.

OK, I'll have a look at it. Thanks for your help.
