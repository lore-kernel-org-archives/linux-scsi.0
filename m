From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 07 Aug 2007 09:31:46 -0500
Message-ID: <1186497106.3414.24.camel@localhost.localdomain>
References: <1186248703.3439.20.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	 <1186458941.6637.44.camel@localhost.localdomain>
	 <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:58090 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754195AbXHGObr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 10:31:47 -0400
In-Reply-To: <alpine.LFD.0.999.0708062059030.5037@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2007-08-06 at 21:01 -0700, Linus Torvalds wrote:
> 
> On Mon, 6 Aug 2007, James Bottomley wrote:
> >
> > Confused ... you did get the first pull request in the first week.
> 
> Here's the problem. Let me repeat it again:
> 
> > > And after -rc1, I don't want to see crap like this:
> > > 
> > > 	 46 files changed, 2837 insertions(+), 2050 deletions(-)
> 
> It DOES NOT MATTER if I get a first pull request in the first week, if 
> that pull request is purely cosmetic, and is followed by stuff that 
> *should* have been in the merge window four weeks afterwards.
> 
> > OK ... that's arguable.
> 
> There's nothing arguable at all about it.
> 
> If you have 5000 lines of changes, that's not a "bugfix" any more. That's 
> a big damn change, and it should have happened in the merge window. Or if 
> it doesn't make it in time, in the *next* merge window.

I'm not arguing that the bug fix piece wasn't too big (although
realistically, line counts are only a guide not a rule.  If we discover
something like a calling convention bug in SCSI [reversed kmalloc
arguments, say], I could see a huge patch to fix all of the call
sites) ... I've said I'll take responsibility for that and fix it.

I'm arguing that a too strict an interpretation of bugfix only post -rc1
will damage feature stabilisation.  Please think carefully about this.
If we go out in a released kernel with a problematic user space ABI, we
end up being committed to it forever.

James


