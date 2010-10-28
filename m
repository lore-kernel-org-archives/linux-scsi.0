From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: Full hostlock pushdown available
Date: Thu, 28 Oct 2010 15:22:45 -0500
Message-ID: <1288297365.10498.4.camel@mulgrave.site>
References: <20101028150508.GA2385@basil.fritz.box>
	 <1288294123.3043.164.camel@mulgrave.site>
	 <20101028201036.GA2797@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:37471 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757217Ab0J1UWt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Oct 2010 16:22:49 -0400
In-Reply-To: <20101028201036.GA2797@basil.fritz.box>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: nab@linux-iscsi.org, linux-scsi@vger.kernel.org

On Thu, 2010-10-28 at 22:10 +0200, Andi Kleen wrote:
On Thu, Oct 28, 2010 at 02:28:43PM -0500, James Bottomley wrote:
> > On Thu, 2010-10-28 at 17:05 +0200, Andi Kleen wrote:
> > > Here's the promised attempt to do a full host_lock pushdown. This
> > > was done using coccinelle and some manual adjustments.
> > > 
> > > This is just a dumb pushdown of host lock and serial number into
> > > the driver, no attempt to remove any locks yet.
> > > 
> > > Currently lightly tested, but compiles with allmodconfig on 32bit x86.
> > > 
> > > I made no attempt to automatically add maintainers to Cc.
> > > 
> > > I'm not posting the patches because they are numerous and boring,
> > > but it's available in git.
> > > 
> > > This will likely bitrot quickly so if it's decided to do it this
> > > way I would prefer if this was merged quickly.
> > 
> > OK, so can you post an actual diff?  It obviously has to be done in one
> > commit rather than the 87 you have.
> 
> Why? I'm not sure a single commit is manageable. The multiple commits
> are not atomic, but at least they should all compile and boot
> and they minimze breakage.

To put this upstream, I need the single commit (with changelog and
signoff).  Otherwise the series won't bisect.  Murphys law says that if
I apply an unbisectable series like this, all the kernel bisections in
the next few months will end up in here, and I'll take a huge amount of
flack ...

> Anyways full diff appended.

Thanks,

James

